Vencloud authentifie les utilisateurs via Discord, vous devez donc créer une application Discord **avant** l'installation :

1. Créez une application sur <https://discord.com/developers/applications>
2. Ouvrez l'onglet **OAuth2**
3. Copiez le **Client ID**, puis cliquez sur **Reset Secret** pour obtenir le **Client Secret**
4. Dans **Redirects**, ajoutez `https://<votre domaine>/v1/oauth/callback`

Vencloud doit être installé **à la racine d'un (sous-)domaine dédié** (par ex. `vencloud.example.com`), et ce domaine doit disposer d'un certificat HTTPS valide : Discord refuse de communiquer avec un backend en HTTP.

L'API est forcément publique (visiteurs), car Vencord l'appelle depuis Discord. Utilisez le paramètre *utilisateurs autorisés* pour restreindre qui peut stocker des paramètres sur votre instance.
