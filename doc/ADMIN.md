### Using your instance

In Discord, open **Settings → Vencord → Backup & Restore → Cloud Integrations** and set the **Backend URL** to `https://__DOMAIN__`.

### Configuration

The Discord credentials, the list of allowed users, the maximum backup size and the root redirect URL can be changed from the app's config panel in the YunoHost webadmin. They are stored in `__INSTALL_DIR__/.env`.

If you modified the code, the root redirect URL **must** point to your modified source code to comply with the AGPL-3.0 license. If your instance is open to others, you should also provide a privacy policy.

### Data

All synced settings are stored in a dedicated Redis instance (service `__APP__-redis`), whose dump lives in `__DATA_DIR__`. Two random secrets ("peppers") generated at install time are used to derive the storage keys: if they are lost, the stored settings become unreachable. They are kept in the app settings and in `__INSTALL_DIR__/.env`, and are part of YunoHost backups.

### Changing the domain

If you move the app to another domain, update the redirect URI in your Discord application to `https://<new domain>/v1/oauth/callback`.
