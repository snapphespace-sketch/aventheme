#!/bin/bash

clear

PANEL="/var/www/pterodactyl"

USERCSS="https://raw.githubusercontent.com/YOURUSERNAME/aven-theme/main/user.css"
ADMINCSS="https://raw.githubusercontent.com/YOURUSERNAME/aven-theme/main/admin.css"

echo "================================="
echo "       AVEN THEME INSTALLER"
echo "================================="

if [ ! -d "$PANEL" ]; then
echo "Pterodactyl not found!"
exit 1
fi

cd $PANEL || exit

echo "Downloading theme..."

curl -L $USERCSS -o public/user.css
curl -L $ADMINCSS -o public/admin.css

echo "Injecting theme..."

grep -q 'user.css' resources/views/layouts/base.blade.php || 
sed -i '/</head>/i <link rel="stylesheet" href="\/user.css">' resources/views/layouts/base.blade.php

grep -q 'admin.css' resources/views/layouts/admin.blade.php || 
sed -i '/</head>/i <link rel="stylesheet" href="\/admin.css">' resources/views/layouts/admin.blade.php

echo "Clearing cache..."

php artisan optimize:clear

echo "Restarting services..."

systemctl restart nginx

systemctl restart php8.3-fpm 2>/dev/null
systemctl restart php8.2-fpm 2>/dev/null
systemctl restart php8.1-fpm 2>/dev/null

echo ""
echo "================================="
echo "    AVEN THEME INSTALLED!"
echo "================================="
