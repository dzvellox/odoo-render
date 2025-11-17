#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo avec Supabase..."
echo "📊 Base de données: $DB_HOST:${DB_PORT:-5432}"
echo "🔒 Mode SSL: ${PGSSLMODE:-require}"

# Force IPv4 seulement
export PGHOST=$DB_HOST
export PGPORT=${DB_PORT:-5432}
export PGUSER=$DB_USER
export PGPASSWORD=$DB_PASSWORD
export PGSSLMODE=${PGSSLMODE:-require}

# Attendre que le réseau soit stable
sleep 5

# Test de connexion avant de lancer Odoo
echo "🔍 Test de connexion à la base..."
if psql -h "$DB_HOST" -p "${DB_PORT:-5432}" -U "$DB_USER" -d postgres -c '\q' 2>/dev/null; then
  echo "✅ Connexion OK"
else
  echo "⚠️ Avertissement: Impossible de tester la connexion, Odoo va essayer quand même..."
fi

# Lancer Odoo avec paramètres de connexion explicites
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --workers=0 \
  --max-cron-threads=0 \
  --db_maxconn=5