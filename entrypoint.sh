#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Connexion DB: $DB_HOST:${DB_PORT:-5432}"
echo "🗄️  Base de données: ${DB_NAME:-odoo}"
echo "🔒 SSL: ${PGSSLMODE:-require}"

# Attendre que la connexion réseau soit stable
sleep 5

DB_NAME_VAR="${DB_NAME:-odoo}"

# Initialiser la base avec des timeouts étendus pour Neon.tech
echo "🔧 Initialisation/vérification de la base (cela peut prendre 3-5 minutes)..."

# Forcer les timeouts PostgreSQL via PGOPTIONS
export PGOPTIONS="-c statement_timeout=0 -c lock_timeout=60000 -c idle_in_transaction_session_timeout=0"

odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME_VAR" \
  --db-template="${DB_TEMPLATE:-template0}" \
  --init=base \
  --without-demo=all \
  --db_maxconn=1 \
  --stop-after-init

echo "✅ Base prête ! Démarrage du serveur..."

# Démarrer Odoo normalement (sans PGOPTIONS pour éviter les problèmes)
unset PGOPTIONS

exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME_VAR" \
  --db_maxconn=2 \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=info \
  --limit-time-cpu=600 \
  --limit-time-real=1200 \
  --workers=0 \
  --max-cron-threads=0