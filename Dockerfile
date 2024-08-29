FROM centos-stream-container-base-9-20240729.0.x86_64:latest

# Репозитории
RUN yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm
RUN /usr/bin/crb enable
RUN yum -y install https://rpms.remirepo.net/enterprise/remi-release-9.rpm
RUN yum -y module enable php:remi-8.3

RUN yum -y update && yum -y upgrade

# PHP https://make.wordpress.org/hosting/handbook/server-environment/
# PHP 8.3
# Required
RUN yum -y install php \
	php-json \
	php-pdo \
	php-mysqlnd

# Highly recommended
RUN yum -y install \
	php-curl \
	php-dom \
	php-exif \
	php-fileinfo \
	php-hash \
	php-igbinary \
	php-imagick \
	php-intl \
	php-mbstring \
	php-openssl \
	php-pcre \
	php-xml \
	php-zip

# Recommended
RUN yum -y install php-apcu php-memcached php-opcache php-redis

# Optional
# RUN yum -y install php-timezonedb

# Completeness
RUN yum -y install \
	php-bcmath \
	php-filter \
	php-gd \
	php-iconv \
	php-shmop \
	php-simplexml \
	php-sodium \
	php-xmlreader \
	php-zlib

# File changes
RUN yum -y install php-ssh2 php-ftp php-sockets

# System Packages
RUN yum -y install --allowerasing curl ghostscript ImageMagick openssl libwebp libavif

# PHP configure
RUN echo 'apc.enable_cli = 1' >> /etc/php.ini && \
    sed -i 's/max_execution_time = .*/max_execution_time = 3600/g' /etc/php.ini && \
    sed -i 's/memory_limit = .*/memory_limit = 512M/g' /etc/php.ini && \
	sed -i 's/post_max_size = .*/post_max_size = 1G/g' /etc/php.ini && \
	sed -i 's/upload_max_filesize = .*/upload_max_filesize = 1G/g' /etc/php.ini && \
    echo 'opcache.interned_strings_buffer = 10' >> /etc/php.ini

# Apache Httpd
RUN yum -y install httpd php-fpm
RUN mkdir -p /run/php-fpm/

# Other
RUN yum -y install sudo procps psmisc bc

# WordPress
RUN chown apache:apache /var/www/html/
COPY --chown=apache:apache --chmod=755 ./tmp/wordpress/ /var/www/html/

COPY --chmod=755 ./files/ /

# Уборка
RUN yum clean all
RUN rm -rf /tmp/*

# Проверить
RUN httpd -S

EXPOSE 80

WORKDIR "/root/"

ENTRYPOINT ["/root/scripts/entrypoint.sh"]

HEALTHCHECK CMD ["/root/scripts/healthcheck.sh"]
