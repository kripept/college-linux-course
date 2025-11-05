#!/bin/bash

# Скрипт автоматического развертывания сайта
# Урок 3: Веб-сервер Nginx

SITE_NAME="college-site"
SITE_DIR="/var/www/$SITE_NAME"
BACKUP_DIR="/home/admin/backups"
NGINX_AVAILABLE="/etc/nginx/sites-available"
NGINX_ENABLED="/etc/nginx/sites-enabled"

echo "🚀 Начало развертывания сайта $SITE_NAME"
echo "========================================"

# Проверка прав доступа
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Этот скрипт должен запускаться с правами root (sudo)"
    exit 1
fi

# Создание бэкапа
echo "📦 Создание бэкапа текущего сайта..."
if [ -d "$SITE_DIR" ]; then
    BACKUP_FILE="$BACKUP_DIR/$SITE_NAME-$(date +%Y%m%d-%H%M%S).tar.gz"
    mkdir -p "$BACKUP_DIR"
    tar -czf "$BACKUP_FILE" -C "/var/www/" "$SITE_NAME"
    echo "✅ Бэкап создан: $BACKUP_FILE"
else
    echo "ℹ️  Папка сайта не найдена, создаем новую"
fi

# Создание структуры папок
echo "📁 Создание структуры папок..."
mkdir -p "$SITE_DIR"/{html,logs,backups}
mkdir -p "$SITE_DIR"/html/{css,js,images}

# Копирование файлов сайта (если есть в текущей директории)
if [ -d "./www" ]; then
    echo "📄 Копирование файлов сайта..."
    cp -r ./www/* "$SITE_DIR/html/"
else
    # Создание тестовой страницы
    echo "📝 Создание тестовой страницы..."
    cat > "$SITE_DIR/html/index.html" << EOF
<!DOCTYPE html>
<html>
<head>
    <title>Сайт $SITE_NAME</title>
    <meta charset="utf-8">
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background: #2c3e50; color: white; padding: 20px; }
    </style>
</head>
<body>
    <div class="header">
        <h1>Сайт успешно развернут!</h1>
        <p>Сервер: $(hostname)</p>
        <p>Дата: $(date)</p>
    </div>
    <p>Это автоматически развернутый сайт через скрипт deploy-site.sh</p>
</body>
</html>
EOF
fi

# Настройка прав доступа
echo "🔐 Настройка прав доступа..."
chown -R www-data:www-data "$SITE_DIR"
chmod -R 755 "$SITE_DIR"
chmod 644 "$SITE_DIR/html/index.html"

# Создание конфигурации Nginx
echo "⚙️  Создание конфигурации Nginx..."
cat > "$NGINX_AVAILABLE/$SITE_NAME" << EOF
server {
    listen 80;
    server_name _;
    root $SITE_DIR/html;
    index index.html;

    access_log $SITE_DIR/logs/access.log;
    error_log $SITE_DIR/logs/error.log;

    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOF

# Активация сайта
echo "🔗 Активация сайта..."
if [ -f "$NGINX_ENABLED/$SITE_NAME" ]; then
    rm "$NGINX_ENABLED/$SITE_NAME"
fi
ln -s "$NGINX_AVAILABLE/$SITE_NAME" "$NGINX_ENABLED/$SITE_NAME"

# Проверка конфигурации и перезагрузка
echo "🔍 Проверка конфигурации Nginx..."
if nginx -t; then
    echo "✅ Конфигурация верна, перезагружаем Nginx..."
    systemctl reload nginx
    echo "🎉 Сайт $SITE_NAME успешно развернут!"
    echo "🌐 Доступен по адресу: http://$(hostname -I | awk '{print $1}')"
else
    echo "❌ Ошибка в конфигурации Nginx!"
    exit 1
fi

echo "📊 Статус Nginx:"
systemctl status nginx --no-pager -l