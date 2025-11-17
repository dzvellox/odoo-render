#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo avec Supabase..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}/$DB_NAME"
echo "🔒 Mode SSL: ${PGSSLMODE:-require}"

# Attendre que le réseau soit stable
sleep 5

# IMPORTANT: Bypass la vérification de sécurité du user postgres
# On force l'option --no-database-list qui permet d'utiliser postgres
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --workers=0 \
  --max-cron-threads=0 \
  --no-database-list \
  -i base