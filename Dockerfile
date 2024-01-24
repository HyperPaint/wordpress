FROM hyperpaint/centos:7-base

# Репозитории
RUN rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
RUN rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
RUN yum-config-manager --enable remi-php82

# PHP https://make.wordpress.org/hosting/handbook/server-environment/
# WordPress
# Веб-сервер
# Прочее
RUN yum -y install php php-common php-mysql php-mysqlnd php-dom php-exif php-fileinfo php-pecl-igbinary php-imagick php-intl php-mbstring php-pcre php-xml php-zip \
	php-apcu php-memcached php-opcache php-redis \
	php-bcmath php-gd \
	php-ssh2 php-ftp php-sockets \
	curl ghostscript imagemagick openssl \
	httpd \
	tar unzip

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

# Установка wordpress
# https://ru.wordpress.org/download/releases/
RUN curl -vo /tmp/wordpress.tar.gz https://ru.wordpress.org/wordpress-6.4.2-ru_RU.tar.gz
RUN tar -xzvf /tmp/wordpress.tar.gz -C /tmp/
RUN mv -v /tmp/wordpress/* /var/www/html/

# Удаление предустановленных плагинов
RUN mv -v /var/www/html/wp-content/plugins/index.php /tmp/index.php
RUN rm -vrf /var/www/html/wp-content/plugins/*
RUN mv -v /tmp/index.php /var/www/html/wp-content/plugins/index.php

# Удалить ненужные файлы
RUN rm -rf /tmp/*

# Файлы
COPY --chown=root:root --chmod=755 ./files/ /

# Выдать права
RUN chown -v apache:apache -R /var/www/html/

# Проверить
RUN httpd -S

EXPOSE 80

# Запуск
ENTRYPOINT ["/root/scripts/start.sh"]

# Готовность
HEALTHCHECK CMD ["/root/scripts/healthcheck.sh"]
