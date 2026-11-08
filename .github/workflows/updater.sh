#!/bin/bash
#
# Check upstream Vencloud for a new version and update manifest.toml.
#
# Vencloud is not tagged on every change, so we follow the latest commit of
# the upstream default branch:
#   - if that commit is tagged (e.g. v0.0.3), we package the tag:
#       version = "0.0.3~ynh1", source = archive/refs/tags/v0.0.3.tar.gz
#   - otherwise we package the commit itself:
#       version = "<latest tag>.<YYYYMMDD>~ynh1", source = archive/<sha>.tar.gz
#     (e.g. "0.0.2.20261108~ynh1", which sorts after 0.0.2 and before 0.0.3)
#
# Outputs (in $GITHUB_OUTPUT when run in GitHub Actions):
#   PROCEED=true|false, VERSION, REF, COMMIT_URL

set -euo pipefail

REPO="Vencord/Vencloud"
MANIFEST="${1:-manifest.toml}"
API="https://api.github.com/repos/$REPO"

output() {
    echo "$1=$2"
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "$1=$2" >> "$GITHUB_OUTPUT"
    fi
}

gh_api() {
    curl --silent --show-error --fail --location \
        ${GITHUB_TOKEN:+--header "Authorization: Bearer $GITHUB_TOKEN"} \
        --header "Accept: application/vnd.github+json" \
        "$API${1:+/$1}"
}

#=================================================
# FETCH UPSTREAM STATE
#=================================================

branch=$(gh_api "" | jq -r '.default_branch')
head_json=$(gh_api "commits/$branch")
head_sha=$(jq -r '.sha' <<< "$head_json")
head_date=$(jq -r '.commit.committer.date' <<< "$head_json" | cut -c1-10 | tr -d '-')

tags_json=$(gh_api "tags?per_page=100")
latest_tag=$(jq -r '.[].name' <<< "$tags_json" | grep -E '^v?[0-9]+(\.[0-9]+)*$' | sort -V | tail -n1)
latest_tag_sha=$(jq -r --arg t "$latest_tag" '.[] | select(.name == $t) | .commit.sha' <<< "$tags_json")
base_version="${latest_tag#v}"

if [ "$head_sha" == "$latest_tag_sha" ]; then
    version="$base_version"
    ref="$latest_tag"
    url="https://github.com/$REPO/archive/refs/tags/$latest_tag.tar.gz"
else
    version="$base_version.$head_date"
    ref="$head_sha"
    url="https://github.com/$REPO/archive/$head_sha.tar.gz"
fi

echo "Upstream $branch is at $head_sha ($head_date), latest tag $latest_tag ($latest_tag_sha)"

#=================================================
# COMPARE WITH THE PACKAGED VERSION
#=================================================

current_url=$(sed -n '/^\s*\[resources\.sources\.main\]/,/^\s*\[/ s/^\s*url\s*=\s*"\(.*\)"/\1/p' "$MANIFEST")
current_version=$(sed -n 's/^version\s*=\s*"\(.*\)~ynh[0-9]*"/\1/p' "$MANIFEST")

echo "Packaged: $current_version ($current_url)"
echo "Upstream: $version ($url)"

if [ "$current_url" == "$url" ]; then
    echo "Already up to date."
    output PROCEED false
    exit 0
fi

# Never go backwards (e.g. if upstream force-pushed or a tag was deleted)
if [ "$(printf '%s\n%s\n' "$current_version" "$version" | sort -V | tail -n1)" != "$version" ] \
    || [ "$current_version" == "$version" ]; then
    echo "Upstream version $version is not newer than $current_version, skipping."
    output PROCEED false
    exit 0
fi

#=================================================
# UPDATE THE MANIFEST
#=================================================

tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT

curl --silent --show-error --fail --location "$url" --output "$tmpdir/source.tar.gz"
sha256=$(sha256sum "$tmpdir/source.tar.gz" | cut -d' ' -f1)

# Follow the Go version required by upstream's go.mod (major.minor only)
go_version=$(tar --extract --to-stdout --wildcards --file="$tmpdir/source.tar.gz" '*/go.mod' \
    2>/dev/null | sed -n 's/^go \([0-9]*\.[0-9]*\).*/\1/p' | head -n1 || true)

sed -i "s/^version\s*=.*/version = \"$version~ynh1\"/" "$MANIFEST"
sed -i "/^\s*\[resources\.sources\.main\]/,/^\s*\[/ {
    s#^\(\s*\)url\s*=.*#\1url = \"$url\"#
    s#^\(\s*\)sha256\s*=.*#\1sha256 = \"$sha256\"#
}" "$MANIFEST"
if [ -n "$go_version" ]; then
    sed -i "/^\s*\[resources\.go\]/,/^\s*\[/ s#^\(\s*\)version\s*=.*#\1version = \"$go_version\"#" "$MANIFEST"
fi

echo "Manifest updated to $version (sha256 $sha256, go $go_version)"

output PROCEED true
output VERSION "$version"
output REF "$ref"
output COMMIT_URL "https://github.com/$REPO/commit/$head_sha"
