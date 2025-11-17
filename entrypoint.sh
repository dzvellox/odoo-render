#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo avec Supabase..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}"
echo "🔒 Mode SSL: ${PGSSLMODE:-require}"

# Attendre que le réseau soit stable
sleep 5

# Lancer Odoo - database manager activé
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --workers=0 \
  --max-cron-threads=0