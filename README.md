# phpMyAdmin Installer Script for Nginx & MariaDB

This script automates the installation and configuration of phpMyAdmin, Nginx, and MariaDB on a Debian-based system.

## Prerequisites
- A Debian or Ubuntu-based server
- Root or sudo access
- A registered domain pointing to your server

## Installation

1. Clone this repository or download the script:
   ```sh
   git clone https://github.com/Zer0NC/phpmyadmin-installer
   ```

2. Make the script executable:
   ```sh
   chmod +x phpmyadmin.sh
   ```

3. Run the installation script:
   ```sh
   sudo ./phpmyadmin.sh
   ```

## Configuration

The script will:
- Install necessary packages (Nginx, MariaDB, PHP, phpMyAdmin)
- Secure MariaDB and set the root password
- Configure phpMyAdmin under `/usr/share/phpmyadmin`
- Set up an Nginx virtual host for phpMyAdmin
- Obtain and configure an SSL certificate using Let's Encrypt
- Create a MySQL user for phpMyAdmin access

### Changing Default Variables

Before running the script, you may want to customize some variables. Open `install.sh` and modify the following values:

- `ROOT_PASSWORD` – The MariaDB root password
- `DB_USER` – The MySQL user for phpMyAdmin
- `DB_PASSWORD` – The password for the phpMyAdmin user
- `PHPMYADMIN_DIR` – The directory where phpMyAdmin will be installed
- `DOMAIN` – The domain name where phpMyAdmin will be accessible

Example:
```sh
ROOT_PASSWORD="YourSecureRootPassword"
DB_USER="yourphpmyadminuser"
DB_PASSWORD="YourSecurePassword"
DOMAIN="yourdomain.com"
```

## Accessing phpMyAdmin

Once the installation is complete, you can access phpMyAdmin at:
```
https://yourdomain.com
```

Use the credentials set in the script to log in.

## Troubleshooting

- If Nginx does not start, check the configuration with:
  ```sh
  sudo nginx -t
  ```
- Restart services if needed:
  ```sh
  sudo systemctl restart nginx
  sudo systemctl restart mariadb
  ```
- Check firewall settings to allow traffic on ports 80 and 443:
  ```sh
  sudo ufw allow 'Nginx Full'
  sudo ufw enable
  ```

## Uninstallation

To remove phpMyAdmin and its configurations:
```sh
sudo rm -rf /usr/share/phpmyadmin
sudo rm /etc/nginx/sites-available/phpmyadmin.conf
sudo rm /etc/nginx/sites-enabled/phpmyadmin.conf
sudo systemctl restart nginx
sudo apt remove --purge mariadb-server nginx php certbot -y
```

## License
This script is open-source and available under the MIT License.

## Author
Created by [ByZer0](https://ByZer0.de). Feel free to contribute!

