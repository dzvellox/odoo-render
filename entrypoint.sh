#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}/$DB_NAME"

# Attendre un peu pour laisser le temps à la DB de répondre
sleep 3

# Lancer Odoo avec les paramètres de configuration
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --without-demo=all \
  --proxy-mode \
  -i base