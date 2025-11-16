#!/bin/bash
set -e

# Attendre que PostgreSQL soit prêt
until PGPASSWORD=$DB_PASSWORD psql -h "$DB_HOST" -U "$DB_USER" -d postgres -c '\q' 2>/dev/null; do
  >&2 echo "PostgreSQL n'est pas encore prêt - attente..."
  sleep 2
done

>&2 echo "PostgreSQL est prêt - démarrage d'Odoo"

# Lancer Odoo avec les paramètres de configuration
exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --admin-passwd="${ADMIN_PASSWD}" \
  --without-demo=all \
  --proxy-mode \
  "$@"
