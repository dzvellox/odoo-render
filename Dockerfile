# 1. Image de base officielle Odoo
FROM odoo:17.0

# 2. Installer les dépendances système de base
# Nous réintégrons les commandes sur une seule couche pour la stabilité:
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libpq-dev \
    # Ajoutez d'autres dépendances ici si vous en avez
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER odoo

# Le reste de votre Dockerfile (si vous avez requirements.txt, custom_addons, etc.)
# ...
