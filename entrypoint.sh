#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Connexion DB: $DB_HOST:${DB_PORT:-5432}"
echo "🔒 SSL: ${PGSSLMODE:-require}"

# Attendre que la connexion réseau soit stable
sleep 5

# Lancer Odoo en mode multi-database
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --db_maxconn="${DB_MAXCONN:-10}" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=warn \
  --limit-time-cpu=600 \
  --limit-time-real=1200