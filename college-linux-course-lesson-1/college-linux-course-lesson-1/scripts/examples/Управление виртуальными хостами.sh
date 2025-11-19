# Создание нового сайта
sudo nano /etc/nginx/sites-available/my-site

# Активация сайта
sudo ln -s /etc/nginx/sites-available/my-site /etc/nginx/sites-enabled/

# Деактивация сайта
sudo rm /etc/nginx/sites-enabled/my-site

# Перезагрузка конфигурации
sudo nginx -t && sudo systemctl reload nginx