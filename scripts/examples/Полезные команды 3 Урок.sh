# Просмотр запущенных процессов Nginx
ps aux | grep nginx

# Проверка, какие порты слушает Nginx
sudo netstat -tulpn | grep nginx

# Просмотр логов в реальном времени
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Поиск ошибок в логах
sudo grep error /var/log/nginx/error.log

# Проверка версии и модулей
nginx -V