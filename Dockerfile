FROM centos:7

# Репозитории
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN	rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php82

# PHP
# Веб-сервер
# Прочее
RUN yum -y install php php-zip php-dom php-xml php-mbstring php-gd php-mysql php-pgsql php-fileinfo php-bz2 php-intl php-ldap php-smbclient php-ftp php-imap php-bcmath php-gmp php-exif php-apcu php-memcached php-redis php-imagick php-pcntl php-phar php-pcre php-ssh2 php-sockets php-process php-opcache \
	httpd \
	curl tar unzip

# Настроить php
RUN sed -i 's/memory_limit = .*/memory_limit = 512M/g' /etc/php.ini && \
	sed -i 's/post_max_size = .*/post_max_size = 1G/g' /etc/php.ini && \
	sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/g' /etc/php.ini && \
	sed -i 's/output_buffering = .*/output_buffering = Off/g' /etc/php.ini && \
	echo "apc.enable_cli = 1" >> /etc/php.ini

# Очистить кэш
RUN yum clean all
# Удалить ненужные репозитории
RUN rm -vrf /etc/yum.repos.d/*

# Файлы
COPY --chown=root:root --chmod=754 ./files/ /

# Установка wordpress
# https://ru.wordpress.org/download/releases/
RUN curl -vo /tmp/wordpress.tar.gz https://ru.wordpress.org/wordpress-6.2-ru_RU.tar.gz
RUN tar -xzvf /tmp/wordpress.tar.gz -C /tmp/
RUN mv -v /tmp/wordpress/* /var/www/html/
# Удаление предустановленных плагинов / установка плагинов
RUN rm -vrf /var/www/html/wp-content/plugins/* && cp -v /var/www/html/wp-content/themes/index.php /var/www/html/wp-content/plugins/index.php
# APCu Manager
RUN curl -vo /tmp/apcu-manager.zip https://downloads.wordpress.org/plugin/apcu-manager.3.7.2.zip
RUN unzip /tmp/apcu-manager.zip -d /var/www/html/wp-content/plugins/
# Disable WP REST API
RUN curl -vo /tmp/disable-wp-rest-api.zip https://downloads.wordpress.org/plugin/disable-wp-rest-api.2.6.1.zip
RUN unzip /tmp/disable-wp-rest-api.zip -d /var/www/html/wp-content/plugins/
# Easy WP SMTP
RUN curl -vo /tmp/easy-wp-smtp.zip https://downloads.wordpress.org/plugin/easy-wp-smtp.2.2.0.zip
RUN unzip /tmp/easy-wp-smtp.zip -d /var/www/html/wp-content/plugins/
# WP Super Cache
RUN curl -vo /tmp/wp-super-cache.zip https://downloads.wordpress.org/plugin/wp-super-cache.1.11.0.zip
RUN unzip /tmp/wp-super-cache.zip -d /var/www/html/wp-content/plugins/
# Yoast SEO
RUN curl -vo /tmp/wordpress-seo.zip https://downloads.wordpress.org/plugin/wordpress-seo.21.7.zip
RUN unzip /tmp/wordpress-seo.zip -d /var/www/html/wp-content/plugins/
# Quiz Maker - localhost
RUN curl -vko /tmp/quiz-maker.zip https://192.168.1.100/quiz-maker-21.7.6.zip
RUN unzip /tmp/quiz-maker.zip -d /var/www/html/wp-content/plugins/
# Установка тем без удаления предустановленных
# Kadence
RUN curl -vo /tmp/kadence.zip https://downloads.wordpress.org/theme/kadence.1.1.50.zip
RUN unzip /tmp/kadence.zip -d /var/www/html/wp-content/themes/
# Удалить ненужные файлы
RUN rm -rf /tmp/*

# Выдать права
RUN chown -v apache:apache -R /var/www/html/

# Проверить
RUN httpd -S

EXPOSE 80

# Запуск
ENTRYPOINT ["/root/scripts/start.sh"]

# Готовность
HEALTHCHECK CMD ["/root/scripts/healthcheck.sh"]
