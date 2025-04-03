#!/bin/bash

# === Variables ===
APP_DIR="/var/www/myapp"
DB_NAME="mydatabase"
DB_USER="myuser"

echo "⚠️ Suppression du serveur web et de l'application..."

# === Arrêt des services ===
echo "🛑 Arrêt des services Nginx, PHP et MySQL..."
sudo systemctl stop nginx php-fpm mysql

# === Suppression du site web ===
echo "🗑️ Suppression des fichiers du site..."
sudo rm -rf ${APP_DIR}

# === Suppression de la configuration Nginx ===
echo "🗑️ Suppression de la configuration Nginx..."
sudo rm -f /etc/nginx/sites-available/myapp
sudo rm -f /etc/nginx/sites-enabled/myapp

# === Désinstallation des paquets ===
echo "📦 Suppression de Nginx, PHP et MySQL..."
sudo apt remove --purge -y nginx mysql-server php-fpm php-mysql unzip
sudo apt autoremove -y
sudo apt clean

# === Suppression de la base de données et de l’utilisateur MySQL ===
echo "🗄️ Suppression de la base de données et de l'utilisateur..."
sudo mysql -e "DROP DATABASE IF EXISTS ${DB_NAME};"
sudo mysql -e "DROP USER IF EXISTS '${DB_USER}'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# === Réinitialisation du pare-feu ===
echo "🛡️ Réinitialisation du pare-feu..."
sudo ufw disable
sudo ufw reset

# === Nettoyage final ===
echo "🧹 Nettoyage des fichiers temporaires..."
sudo rm -rf /var/lib/mysql /etc/mysql /var/log/mysql

echo "✅ Suppression terminée !"