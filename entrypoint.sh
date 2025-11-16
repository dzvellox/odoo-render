#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}/$DB_NAME"
echo "🔒 SSL Mode: ${DB_SSLMODE:-prefer}"

# Attendre un peu pour laisser le temps à la DB de répondre
sleep 5

# Lancer Odoo avec initialisation forcée de la base
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --db_sslmode="${DB_SSLMODE:-require}" \
  --database="$DB_NAME" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=info \
  -i base