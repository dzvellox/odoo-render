#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Connexion DB: $DB_HOST:${DB_PORT:-5432}"
echo "🗄️  Base de données: ${DB_NAME:-odoo}"
echo "🔒 SSL: ${PGSSLMODE:-require}"

# Attendre que la connexion réseau soit stable
sleep 5

# Configuration spéciale pour Neon.tech (pooled connection)
# Utiliser un pool de connexions très limité pour éviter les conflits
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="${DB_NAME:-odoo}" \
  --db_maxconn="${DB_MAXCONN:-3}" \
  --db-template="${DB_TEMPLATE:-template0}" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=warn \
  --limit-time-cpu=600 \
  --limit-time-real=1200 \
  --workers=0 \
  --max-cron-threads=0