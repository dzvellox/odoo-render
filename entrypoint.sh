#!/bin/bash
set -e

echo "🚀 Démarrage d'Odoo..."
echo "📊 Connexion DB: $DB_HOST:${DB_PORT:-5432}"
echo "🗄️  Base de données: ${DB_NAME:-odoo}"
echo "🔒 SSL: ${PGSSLMODE:-require}"

DB_NAME_VAR="${DB_NAME:-odoo}"

# Démarrer un serveur HTTP simple sur le port 8069 pour Render
# Ceci évite que Render kill le container pendant l'initialisation
python3 -c "
import http.server
import socketserver
import threading

PORT = ${PORT:-8069}

class HealthCheckHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header('Content-type', 'text/html')
        self.end_headers()
        self.wfile.write(b'Odoo is initializing... Please wait 5-10 minutes.')
    def log_message(self, format, *args):
        pass

def run_server():
    with socketserver.TCPServer(('0.0.0.0', PORT), HealthCheckHandler) as httpd:
        httpd.serve_forever()

server_thread = threading.Thread(target=run_server, daemon=True)
server_thread.start()
print(f'✅ Healthcheck server started on port {PORT}')

import time
while True:
    time.sleep(1)
" &

HEALTH_PID=$!
echo "✅ Serveur de healthcheck démarré (PID: $HEALTH_PID)"

sleep 3

# Fonction pour vérifier si la base est initialisée
check_db_initialized() {
    # Utiliser la connexion directe pour le check
    DB_HOST_DIRECT="${DB_HOST//-pooler/}"
    PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST_DIRECT" -p "${DB_PORT:-5432}" -U "$DB_USER" -d "$DB_NAME_VAR" \
        -c "SELECT 1 FROM ir_module_module LIMIT 1;" 2>/dev/null
    return $?
}

# Vérifier si la base doit être initialisée
echo "🔍 Vérification de l'état de la base..."

if ! check_db_initialized; then
    echo "📦 Base non initialisée, lancement de l'initialisation..."
    echo "⏳ Ceci peut prendre 5-10 minutes, merci de patienter..."
    
    # IMPORTANT: Utiliser la connexion DIRECTE (sans -pooler)
    # Le pooler Neon ne supporte pas PGOPTIONS
    DB_HOST_DIRECT="${DB_HOST//-pooler/}"
    
    echo "🔧 Utilisation de la connexion directe: $DB_HOST_DIRECT"
    
    # Tuer le healthcheck server avant init (libère des ressources)
    kill $HEALTH_PID 2>/dev/null || true
    
    # Initialiser avec la connexion DIRECTE + timeouts SQL intégrés
    odoo \
      --db_host="$DB_HOST_DIRECT" \
      --db_port="${DB_PORT:-5432}" \
      --db_user="$DB_USER" \
      --db_password="$DB_PASSWORD" \
      --database="$DB_NAME_VAR" \
      --db-template="${DB_TEMPLATE:-template0}" \
      --init=base \
      --without-demo=all \
      --db_maxconn=1 \
      --stop-after-init \
      --log-level=info
    
    INIT_STATUS=$?
    
    if [ $INIT_STATUS -eq 0 ]; then
        echo "✅ Base initialisée avec succès !"
    else
        echo "❌ Erreur lors de l'initialisation de la base (code: $INIT_STATUS)"
        exit 1
    fi
else
    echo "✅ Base déjà initialisée, démarrage direct"
    # Tuer le healthcheck server
    kill $HEALTH_PID 2>/dev/null || true
fi

# Démarrer Odoo normalement
# On peut utiliser le pooler maintenant (pas de PGOPTIONS en runtime)
echo "🎯 Démarrage du serveur Odoo..."

exec odoo \
  --db_host="$DB_HOST" \
  --db_port="${DB_PORT:-5432}" \
  --db_user="$DB_USER" \
  --db_password="$DB_PASSWORD" \
  --database="$DB_NAME_VAR" \
  --db_maxconn="${DB_MAXCONN:-2}" \
  --data-dir="/var/lib/odoo" \
  --http-port="${PORT:-8069}" \
  --proxy-mode \
  --log-level=info \
  --limit-time-cpu=600 \
  --limit-time-real=1200 \
  --workers=0 \
  --max-cron-threads=0