# Основная конфигурация
/etc/nginx/nginx.conf

# Дополнительные конфигурации
/etc/nginx/conf.d/

# Доступные сайты (виртуальные хосты)
/etc/nginx/sites-available/

# Включенные сайты
/etc/nginx/sites-enabled/

# Файлы логов
/var/log/nginx/
/var/log/nginx/access.log   # Лог доступа
/var/log/nginx/error.log    # Лог ошибок

# Стандартная папка для файлов сайта
/var/www/html/