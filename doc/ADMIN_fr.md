### Utiliser votre instance

Dans Discord, ouvrez **Paramètres → Vencord → Backup & Restore → Cloud Integrations** et définissez la **Backend URL** à `https://__DOMAIN__`.

### Configuration

Les identifiants Discord, la liste des utilisateurs autorisés, la taille maximale des sauvegardes et l'URL de redirection de la racine sont modifiables depuis le panneau de configuration de l'app dans la webadmin YunoHost. Ils sont stockés dans `__INSTALL_DIR__/.env`.

Si vous avez modifié le code, l'URL de redirection de la racine **doit** pointer vers votre code source modifié pour respecter la licence AGPL-3.0. Si votre instance est ouverte à d'autres personnes, vous devriez aussi fournir une politique de confidentialité.

### Données

Tous les paramètres synchronisés sont stockés dans une instance Redis dédiée (service `__APP__-redis`), dont le dump se trouve dans `__DATA_DIR__`. Deux secrets aléatoires (« peppers ») générés à l'installation servent à dériver les clés de stockage : s'ils sont perdus, les paramètres stockés deviennent inaccessibles. Ils sont conservés dans les paramètres de l'app et dans `__INSTALL_DIR__/.env`, et font partie des sauvegardes YunoHost.

### Changer de domaine

Si vous déplacez l'app vers un autre domaine, mettez à jour l'URI de redirection de votre application Discord : `https://<nouveau domaine>/v1/oauth/callback`.
