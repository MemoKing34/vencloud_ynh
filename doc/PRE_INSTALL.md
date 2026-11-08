Vencloud authenticates users through Discord, so you need a Discord application **before** installing:

1. Create an application at <https://discord.com/developers/applications>
2. Open the **OAuth2** tab
3. Copy the **Client ID**, and press **Reset Secret** to get the **Client Secret**
4. Under **Redirects**, add `https://<your domain>/v1/oauth/callback`

Vencloud must be installed **at the root of a dedicated (sub)domain** (e.g. `vencloud.example.com`), and that domain must have a valid HTTPS certificate: Discord refuses to talk to a plain HTTP backend.

The API is necessarily public (visitors), because Vencord calls it from inside Discord. Use the *allowed users* setting to restrict who can store settings on your instance.
