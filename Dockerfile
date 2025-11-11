# 1. Image de base officielle Odoo
FROM odoo:17.0

# 2. Installer les dépendances du système (si vous en avez besoin pour des fonctionnalités de base, ex: PDF)
# Ces dépendances sont souvent nécessaires même sans custom_addons.
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        libpq-dev \
        # Ajoutez ici d'autres dépendances système courantes si besoin (ex: wkhtmltopdf-related)
        && rm -rf /var/lib/apt/lists/*
USER odoo

# --- Les étapes suivantes deviennent inutiles : ---

# 3. Supprimer l'installation des dépendances Python supplémentaires (requirements.txt)
# (Si vous n'avez pas de modules custom, vous n'avez probablement pas de requirements.txt)
# COPY requirements.txt /tmp/requirements.txt
# RUN pip install -r /tmp/requirements.txt

# 4. Supprimer la création et la copie du dossier custom_addons
# RUN mkdir -p /mnt/extra-addons
# COPY ./custom_addons/ /mnt/extra-addons/

# L'image de base est prête à démarrer Odoo
