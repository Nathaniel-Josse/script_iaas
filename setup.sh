#!/bin/bash

# === Variables ===
APP_DIR="/var/www/myapp"
DB_NAME="mydatabase"
DB_USER="myuser"
DB_PASS="mypassword"

echo "🚀 Déploiement du serveur web en cours..."

# === Mise à jour du système ===
sudo apt update -y && sudo apt upgrade -y

# === Installation des paquets ===
echo "📦 Installation de Nginx, MySQL et PHP..."
sudo apt install -y nginx mysql-server php-fpm php-mysql unzip

# === Configuration du pare-feu ===
echo "🛡️ Configuration du pare-feu..."
sudo ufw allow OpenSSH
sudo ufw allow 'Nginx HTTP'
sudo ufw enable

# === Configuration de MySQL ===
echo "🗄️ Configuration de MySQL..."
sudo mysql -e "CREATE DATABASE ${DB_NAME};"
sudo mysql -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';"
sudo mysql -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# === Déploiement de l'application ===
echo "📂 Déploiement de l'application..."
sudo mkdir -p ${APP_DIR}
sudo chown -R $USER:$USER ${APP_DIR}
sudo chmod -R 755 ${APP_DIR}

# === Création d'un fichier index.php de test ===
echo "<?php phpinfo(); ?>" > ${APP_DIR}/index.php

# === Configuration de Nginx ===
echo "📝 Configuration de Nginx..."
sudo tee /etc/nginx/sites-available/myapp > /dev/null <<EOL
server {
    listen 80;
    server_name _;
    root ${APP_DIR};
    index index.php index.html index.htm;
    
    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOL

# === Activation de la configuration et redémarrage des services ===
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/
sudo systemctl restart nginx php-fpm

# === Vérification du statut des services ===
echo "📡 Vérification du statut des services..."
sudo systemctl status nginx --no-pager
sudo systemctl status php-fpm --no-pager
sudo systemctl status mysql --no-pager

echo "✅ Déploiement terminé ! Votre application est accessible via http://<IP_DU_SERVEUR>"

