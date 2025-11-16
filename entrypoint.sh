#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}"

# Attendre un peu pour laisser le temps à la DB de répondre
sleep 5

# Lancer Odoo SANS spécifier de base de données
# Cela permettra de créer une nouvelle base via l'interface web
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=info \
  --db-filter=^%d$