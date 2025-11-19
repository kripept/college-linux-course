# Проверка конфигурации
sudo nginx -t

# Тестирование сайта через curl
curl -I http://localhost

# Проверка заголовков ответа
curl -I http://your-server-ip

# Просмотр статистики Nginx (если включено)
sudo systemctl status nginx -l