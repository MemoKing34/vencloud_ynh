#!/bin/bash

#=================================================
# COMMON VARIABLES AND CUSTOM HELPERS
#=================================================

# Build the Vencloud binary from the sources deployed in $install_dir/source
_vencloud_build() {
    pushd "$install_dir/source"
        ynh_hide_warnings ynh_exec_as_app env \
            GOPATH="$install_dir/.go" \
            GOCACHE="$install_dir/.cache/go-build" \
            GOMODCACHE="$install_dir/.go/pkg/mod" \
            GOTOOLCHAIN=local \
            GOFLAGS=-modcacherw \
            CGO_ENABLED=0 \
            go build -trimpath -ldflags="-s -w" -o "$install_dir/vencloud"
    popd

    # Build caches are no longer needed once the binary exists
    ynh_safe_rm "$install_dir/.go"
    ynh_safe_rm "$install_dir/.cache"
}

# Add the env file, Redis config and systemd units
_vencloud_add_config() {
    ynh_config_add --template="vencloud.env" --destination="$install_dir/.env"
    chmod 400 "$install_dir/.env"
    chown "$app:$app" "$install_dir/.env"

    ynh_config_add --template="redis.conf" --destination="$install_dir/redis.conf"
    chmod 400 "$install_dir/redis.conf"
    chown "$app:$app" "$install_dir/redis.conf"
}

_vencloud_add_services() {
    ynh_config_add_systemd --service="$app-redis" --template="redis.service"
    ynh_config_add_systemd

    yunohost service add "$app-redis" --description="Redis instance for Vencloud" --log="/var/log/$app/redis.log"
    yunohost service add "$app" --description="Vencord cloud settings sync API" --log="/var/log/$app/$app.log"
}
