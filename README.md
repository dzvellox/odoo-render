# Odoo sur Render

Déploiement d'Odoo 17.0 sur Render avec PostgreSQL.

## 📋 Prérequis

- Un compte Render (gratuit)
- Git installé localement

## 🚀 Déploiement

### Méthode 1 : Via le Dashboard Render

1. **Connectez votre dépôt GitHub** à Render
2. **Créez un nouveau Blueprint** :
   - Allez sur le Dashboard Render
   - Cliquez sur "New +" → "Blueprint"
   - Sélectionnez votre dépôt
   - Render détectera automatiquement le fichier `render.yaml`
3. **Attendez le déploiement** (5-10 minutes)
4. **Accédez à votre instance Odoo** via l'URL fournie par Render

### Méthode 2 : Via le fichier render.yaml

Le fichier `render.yaml` configure automatiquement :
- Une base de données PostgreSQL
- L'application Odoo
- Les variables d'environnement nécessaires
- Les disques persistants pour les données

## 📁 Structure des fichiers

```
.
├── Dockerfile              # Image Odoo
├── Dockerfile.postgres     # Image PostgreSQL
├── entrypoint.sh          # Script de démarrage
├── render.yaml            # Configuration Render
├── .dockerignore          # Fichiers à ignorer
└── requirements.txt       # Dépendances Python (si nécessaire)
```

## 🔧 Configuration

### Variables d'environnement automatiques

Render génère automatiquement :
- `ADMIN_PASSWD` : Mot de passe administrateur Odoo
- `POSTGRES_PASSWORD` : Mot de passe PostgreSQL

### Variables d'environnement manuelles

Si besoin, vous pouvez ajouter :
- `ODOO_ADDONS_PATH` : Chemin vers les modules personnalisés
- `WORKERS` : Nombre de workers (recommandé: 2 pour le plan gratuit)

## 📝 Première connexion

1. Accédez à votre URL Render (ex: `https://odoo-app.onrender.com`)
2. Créez votre première base de données :
   - Master Password : Utilisez la valeur de `ADMIN_PASSWD` (visible dans les variables d'environnement)
   - Database Name : `odoo` (ou autre nom)
   - Email : votre email
   - Password : votre mot de passe admin
   - Language : Français
   - Country : France

## ⚠️ Limitations du plan gratuit

- **Inactivité** : Les services s'arrêtent après 15 minutes d'inactivité
- **Redémarrage** : Premier démarrage lent (30-60 secondes)
- **Stockage** : 1GB par disque
- **RAM** : 512MB pour chaque service

## 🔄 Mise à jour

Pour mettre à jour votre instance :
```bash
git add .
git commit -m "Update configuration"
git push
```

Render redéploiera automatiquement.

## 🐛 Dépannage

### L'application ne démarre pas
- Vérifiez les logs dans le Dashboard Render
- Assurez-vous que PostgreSQL est démarré avant Odoo

### Erreur de connexion à la base de données
- Vérifiez que les variables d'environnement `DB_HOST`, `DB_USER`, `DB_PASSWORD` sont correctes
- Attendez que PostgreSQL soit complètement démarré

### Données perdues après redémarrage
- Vérifiez que les disques persistants sont bien configurés dans `render.yaml`

## 📚 Ressources

- [Documentation Odoo](https://www.odoo.com/documentation/17.0/)
- [Documentation Render](https://render.com/docs)
- [Image Docker Odoo](https://hub.docker.com/_/odoo)

## 🎯 Prochaines étapes

- [ ] Configurer un nom de domaine personnalisé
- [ ] Ajouter des modules Odoo personnalisés
- [ ] Configurer les sauvegardes automatiques
- [ ] Passer à un plan payant pour de meilleures performances