#!/bin/sh
# Startskript für Container
FOLDER="/var/www/frontend"

# Nur initial einrichten, wenn Ordner leer ist
if [ -z "$(ls -A "$FOLDER")" ]; then
    # Templatefiles kopieren
    cp -r /var/templatefiles/. "$FOLDER"

    cd "$FOLDER"
    # Laravel Projekt initialisieren
    composer install --no-interaction --prefer-dist
    composer require dcblogdev/laravel-microsoft-graph laravel/socialite socialiteproviders/microsoft-azure

    # App-Key und Caches
    php artisan key:generate
    php artisan optimize:clear
    php artisan config:clear
    php artisan view:clear
    php artisan route:clear

    # Node-Module
    npm install

    # Rechte setzen
    mkdir -p /var/www/frontend/storage/framework/sessions
    mkdir -p /var/www/frontend/storage/framework/views
    mkdir -p /var/www/frontend/storage/framework/cache
    chmod -R 777 storage bootstrap/cache
    chown -R www-data:www-data storage bootstrap/cache

    npm init -y

fi

if [ ! -d node_modules ]; then
  npm install
fi

# Services starten
echo "Starting services..."
npm install
service php8.2-fpm start
nginx -g "daemon off;" &

echo "Ready."

# Optional: Vite Dev Server
npm run dev || exit 1
# php artisan serve

# Nginx Logs streamen
tail -s 1 -f /var/log/nginx/*.log