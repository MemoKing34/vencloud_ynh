<!--
Nota bene : ce README est automatiquement généré par <https://github.com/YunoHost/apps_tools/tree/main/readme_generator>
Il NE doit PAS être modifié à la main.
-->

> [!WARNING]
> **Ce package a été généré par IA** ([Claude Code](https://claude.com/claude-code)), puis testé par son mainteneur sur YunoHost 13. Merci de signaler tout problème rencontré.

# Vencloud pour YunoHost

[![Niveau d’intégration](https://apps.yunohost.org/badge/integration/vencloud)](https://ci-apps.yunohost.org/ci/apps/vencloud/)
![Statut du fonctionnement](https://apps.yunohost.org/badge/state/vencloud)
![Statut de maintenance](https://apps.yunohost.org/badge/maintained/vencloud)

[![Installer Vencloud avec YunoHost](https://apps.yunohost.org/install-with-yunohost.svg)](https://apps.yunohost.org/app/vencloud)

*[Read this README in English.](./README.md)*

> *Ce package vous permet d’installer Vencloud rapidement et simplement sur un serveur YunoHost.*
> *Si vous n’avez pas YunoHost, consultez [ce guide](https://doc.yunohost.org/admin/get_started/install_on/) pour savoir comment l’installer et en profiter.*

## Vue d’ensemble

Vencloud est le backend officiel utilisé par [Vencord](https://vencord.dev), le client mod pour Discord, pour synchroniser vos paramètres entre vos appareils. En l'auto-hébergeant, vos paramètres Vencord ne quittent jamais votre propre serveur.

### Fonctionnalités

- Sauvegarde et synchronisation des paramètres Vencord entre tous vos clients Discord
- Authentification via Discord OAuth2 — aucun compte supplémentaire nécessaire
- Liste blanche optionnelle des utilisateurs Discord autorisés à utiliser l'instance
- Léger : un seul binaire Go et une instance Redis dédiée

**Version incluse :** 0.0.2~ynh1

## Documentations et ressources

- Site officiel de l’app : <https://vencord.dev>
- Dépôt de code officiel de l’app : <https://github.com/Vencord/Vencloud>
- YunoHost Store : <https://apps.yunohost.org/app/vencloud>
- Signaler un bug : <https://github.com/YunoHost-Apps/vencloud_ynh/issues>

## Informations pour les développeurs

Merci de faire vos pull request sur la [branche `testing`](https://github.com/YunoHost-Apps/vencloud_ynh/tree/testing).

Pour essayer la branche `testing`, procédez comme suit :

```bash
sudo yunohost app install https://github.com/YunoHost-Apps/vencloud_ynh/tree/testing --debug
ou
sudo yunohost app upgrade vencloud -u https://github.com/YunoHost-Apps/vencloud_ynh/tree/testing --debug
```

**Plus d’infos sur le packaging d’applications :** <https://doc.yunohost.org/dev/packaging/>
