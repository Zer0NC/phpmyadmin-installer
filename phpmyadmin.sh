#!/bin/bash

# Variables
ROOT_PASSWORD="MariaDB-Root-Password"
DB_USER="phpmyadmin"
DB_PASSWORD="Y@urPasswo7d!"
PHPMYADMIN_DIR="/usr/share/phpmyadmin"
DOMAIN="database.yourdomain.net"

# Update system
apt-get update && apt-get upgrade -y

# Install essential packages
apt install -y ca-certificates apt-transport-https lsb-release gnupg curl unzip nano

# Add PHP repository
echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list
wget -qO- https://packages.sury.org/php/apt.gpg | apt-key add -
apt-get update

# Install Nginx, PHP & MariaDB
apt install -y nginx mariadb-server mariadb-client
apt install -y php php-cli php-curl php-gd php-intl php-json php-mbstring php-mysql php-opcache php-readline php-xml php-xsl php-zip php-bz2 php-fpm

# Secure MariaDB & set root password
mysql_secure_installation <<EOF
n
y
$ROOT_PASSWORD
$ROOT_PASSWORD
y
y
y
y
EOF

# Download and configure phpMyAdmin
cd /usr/share
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.zip -O phpmyadmin.zip
unzip phpmyadmin.zip
rm phpmyadmin.zip
mv phpMyAdmin-* phpmyadmin
chmod -R 0755 phpmyadmin
chown -R www-data:www-data $PHPMYADMIN_DIR

# Configure Nginx for phpMyAdmin
tee /etc/nginx/sites-available/phpmyadmin.conf > /dev/null <<EOF
server {
    listen 80;
    server_name $DOMAIN;

    root $PHPMYADMIN_DIR;
    index index.php;

    location / {
        try_files \$uri \$uri/ /index.php;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }

    location ~* ^/(doc|sql|setup)/ {
        deny all;
    }
}
EOF

ln -s /etc/nginx/sites-available/phpmyadmin.conf /etc/nginx/sites-enabled/
systemctl restart nginx

# Obtain SSL certificate with Let's Encrypt
apt install -y certbot python3-certbot-nginx
certbot --nginx -d $DOMAIN --non-interactive --agree-tos -m admin@$DOMAIN
systemctl restart nginx

# Create database user for phpMyAdmin
mysql -u root -p"$ROOT_PASSWORD" <<MYSQL_SCRIPT
CREATE USER '$DB_USER'@'localhost' IDENTIFIED BY '$DB_PASSWORD';
GRANT ALL PRIVILEGES ON *.* TO '$DB_USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
MYSQL_SCRIPT

echo "phpMyAdmin has been successfully installed and is available at https://$DOMAIN!"
