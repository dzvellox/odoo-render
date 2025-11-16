FROM odoo:17.0

USER root

# Installer psql pour vérifier l'état de la base
RUN apt-get update && apt-get install -y postgresql-client && rm -rf /var/lib/apt/lists/*

# Créer le répertoire pour les données Odoo
RUN mkdir -p /var/lib/odoo && \
    chown -R odoo:odoo /var/lib/odoo

USER odoo

# Copier le script de démarrage
COPY --chown=odoo:odoo entrypoint.sh /entrypoint.sh

# Rendre le script exécutable
USER root
RUN chmod +x /entrypoint.sh
USER odoo

# Exposer le port
EXPOSE 8069

# Point d'entrée personnalisé
ENTRYPOINT ["/entrypoint.sh"]
CMD ["odoo"]