# Лабораторная работа 3: Веб-сервер Nginx

## 📋 Задание
Установить и настроить веб-сервер Nginx, разместить статический веб-сайт и настроить виртуальные хосты.

## 🛠️ Инструкция

### Часть 1: Установка и запуск Nginx

#### Установка Nginx
```bash
# 1. Обновляем список пакетов
sudo apt update

# 2. Устанавливаем Nginx
sudo apt install nginx -y

# 3. Проверяем установку
nginx -v

Запуск и управление службой
bash
# 1. Запускаем Nginx
sudo systemctl start nginx

# 2. Включаем автозапуск при загрузке
sudo systemctl enable nginx

# 3. Проверяем статус
sudo systemctl status nginx

# 4. Проверяем в браузере
# Откройте: http://ваш-ip-адрес

Часть 2: Базовая настройка
Изучение структуры Nginx
bash
# 1. Основная конфигурация
sudo nano /etc/nginx/nginx.conf

# 2. Папка с настройками сайтов
ls -la /etc/nginx/sites-available/

# 3. Папка с включенными сайтами
ls -la /etc/nginx/sites-enabled/

# 4. Папка с файлами сайта по умолчанию
ls -la /var/www/html/
Проверка работы
bash
# 1. Проверяем синтаксис конфигурации
sudo nginx -t

# 2. Перезагружаем конфигурацию
sudo systemctl reload nginx

# 3. Смотрим логи в реальном времени
sudo tail -f /var/log/nginx/access.log
Часть 3: Создание своего сайта

Подготовка структуры папок
bash
# 1. Создаем папку для нашего сайта
sudo mkdir -p /var/www/college-site/html

# 2. Устанавливаем правильные права
sudo chown -R www-data:www-data /var/www/college-site
sudo chmod -R 755 /var/www/college-site

# 3. Создаем тестовую страницу
sudo nano /var/www/college-site/html/index.html

Содержимое index.html:
html
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Колледж - IT Отдел</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background-color: #f5f5f5;
        }
        .header {
            background: #2c3e50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .content {
            background: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .server-info {
            background: #e8f4fd;
            padding: 15px;
            border-left: 4px solid #3498db;
            margin: 15px 0;
        }
    </style>
</head>
<body>
    <div class="header">
        <h1>🐧 Сайт учебного сервера</h1>
        <p>Колледж | Курс администрирования Linux</p>
    </div>
    
    <div class="content">
        <h2>Добро пожаловать!</h2>
        <p>Это тестовый сайт, размещенный на нашем сервере Ubuntu с Nginx.</p>
        
        <div class="server-info">
            <h3>📊 Информация о сервере:</h3>
            <p><strong>Студент:</strong> [Ваше ФИО]</p>
            <p><strong>Группа:</strong> [Ваша группа]</p>
            <p><strong>Дата:</strong> <span id="currentDate"></span></p>
            <p><strong>Сервер:</strong> Ubuntu Server + Nginx</p>
        </div>

        <h3>🎯 Выполненные задачи:</h3>
        <ul>
            <li>✅ Установлен и настроен Nginx</li>
            <li>✅ Создан виртуальный хост</li>
            <li>✅ Размещен статический сайт</li>
            <li>✅ Настроены права доступа</li>
        </ul>
    </div>

    <script>
        // Добавляем текущую дату
        document.getElementById('currentDate').textContent = new Date().toLocaleDateString('ru-RU');
        
        // Добавляем информацию о браузере
        const browserInfo = document.createElement('div');
        browserInfo.className = 'server-info';
        browserInfo.innerHTML = `<h3>🌐 Информация о клиенте:</h3>
                                <p><strong>Браузер:</strong> ${navigator.userAgent}</p>
                                <p><strong>Язык:</strong> ${navigator.language}</p>`;
        document.querySelector('.content').appendChild(browserInfo);
    </script>
</body>
</html>

Часть 4: Настройка виртуального хоста
Создание конфигурации сайта
bash
# 1. Создаем конфигурационный файл
sudo nano /etc/nginx/sites-available/college-site
Содержимое конфигурации:
nginx
server {
    listen 80;
    listen [::]:80;

    # Имя сервера (можно использовать IP или домен)
    server_name _;

    # Корневая директория сайта
    root /var/www/college-site/html;
    index index.html index.htm;

    # Настройки логирования
    access_log /var/log/nginx/college-site_access.log;
    error_log /var/log/nginx/college-site_error.log;

    # Основная конфигурация location
    location / {
        # Пробуем найти файл, директорию или отдать 404
        try_files $uri $uri/ =404;
    }

    # Запрещаем доступ к скрытым файлам
    location ~ /\. {
        deny all;
        access_log off;
        log_not_found off;
    }

    # Настройки для статических файлов
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}

Активация сайта

bash
# 1. Активируем сайт (создаем символическую ссылку)
sudo ln -s /etc/nginx/sites-available/college-site /etc/nginx/sites-enabled/

# 2. Отключаем дефолтный сайт (опционально)
sudo rm /etc/nginx/sites-enabled/default

# 3. Проверяем синтаксис конфигурации
sudo nginx -t

# 4. Перезагружаем Nginx
sudo systemctl reload nginx

Часть 5: Проверка работы

Тестирование сайта

bash
# 1. Проверяем, что Nginx слушает порт 80
sudo netstat -tulpn | grep :80

# 2. Проверяем через curl
curl http://localhost

# 3. Проверяем логи
sudo tail -f /var/log/nginx/college-site_access.log
Проверка в браузере
Откройте браузер на вашем основном компьютере

Перейдите по адресу: http://ваш-ip-адрес-сервера

Должна открыться ваша созданная страница