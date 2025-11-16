#!/bin/bash
# Script pour nettoyer et recréer la base de données Odoo

set -e

echo "🧹 Nettoyage de la base de données Odoo sur Neon.tech"
echo ""

# Variables de connexion
DB_HOST="ep-divine-lab-a45nny5y-pooler.us-east-1.aws.neon.tech"
DB_USER="neondb_owner"
DB_PASSWORD="npg_wQPuv6cRdg7W"
DB_NAME="yas"

# Connexion à la base par défaut
CONNECT_STRING="postgresql://${DB_USER}:${DB_PASSWORD}@${DB_HOST}/neondb?sslmode=require"

echo "📊 Suppression de la base '$DB_NAME'..."
psql "$CONNECT_STRING" -c "DROP DATABASE IF EXISTS $DB_NAME;" 2>/dev/null || echo "⚠️  Base n'existe pas encore"

echo "📦 Création d'une nouvelle base '$DB_NAME'..."
psql "$CONNECT_STRING" -c "CREATE DATABASE $DB_NAME TEMPLATE template0 ENCODING 'UTF8';"

echo "✅ Base de données nettoyée avec succès !"
echo ""
echo "🚀 Vous pouvez maintenant déployer sur Render avec:"
echo "   git push"