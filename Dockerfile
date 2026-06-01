FROM php:7.4-apache-bullseye
LABEL maintainer="Péter Király <pkiraly@gwdg.de>"
LABEL description="A metadata quality assessment tool for Deutsche Digitale Bibliothek."

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
ENV RUN_GROUP 0

# OpenShift uses an arbitrary UID at runtime; keep directories group-writable for GID 0.
ENV APACHE_RUN_DIR=/tmp/apache2/run
ENV APACHE_LOCK_DIR=/tmp/apache2/lock
ENV APACHE_LOG_DIR=/tmp/apache2/log
ENV APACHE_PID_FILE=/tmp/apache2/apache2.pid

ARG SMARTY_VERSION=3.1.33

RUN apt-get update \
 && apt-get install -y --no-install-recommends unzip curl \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/www/html/* \
 && docker-php-ext-install pdo_mysql

COPY --chown=www-data:${RUN_GROUP} . /var/www/html/
WORKDIR /var/www/html/
 
 #
 # set configuration
 #
RUN mv configuration.cnf.docker configuration.cnf \
 && mkdir -p ${APACHE_RUN_DIR} ${APACHE_LOCK_DIR} ${APACHE_LOG_DIR} \
 #
 # set smarty
 #
 && cd libs/ \
 && curl -s -L https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip \
 && unzip -q v${SMARTY_VERSION}.zip \
 && rm v${SMARTY_VERSION}.zip \
 && mkdir -p _smarty/templates_c \
 && chmod g+rwX -R _smarty/templates_c/ \
 && chgrp -R ${RUN_GROUP} /var/www/html /tmp/apache2 /var/run/apache2 /var/lock/apache2 \
 && chmod -R g=u /var/www/html /tmp/apache2 /var/run/apache2 /var/lock/apache2 \
 #
 # Configure PHP logging for container environments
 #
 && { \
    echo 'log_errors = On'; \
    echo 'error_log = /proc/self/fd/2'; \
     echo 'error_reporting = E_ALL'; \
    echo 'display_errors = Off'; \
    echo 'display_startup_errors = Off'; \
    } > /usr/local/etc/php/conf.d/zz-logging.ini \
 #
 # Configure Apache
 #
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && a2disconf other-vhosts-access-log \
 && ln -sf /proc/self/fd/1 /var/log/apache2/access.log \
 && ln -sf /proc/self/fd/2 /var/log/apache2/error.log \
 && { \
     echo 'ServerTokens Prod'; \
     echo 'ServerSignature Off'; \
     echo 'TraceEnable Off'; \
     } > /etc/apache2/conf-available/zz-hardening.conf \
 && a2enconf zz-hardening \
 && { \
	echo "<VirtualHost *:8080>"; \
	echo "	ServerAdmin webmaster@localhost"; \
	echo "	DocumentRoot /var/www/html"; \
    echo "	ErrorLog /proc/self/fd/2"; \
    echo "	CustomLog /proc/self/fd/1 combined"; \
        echo "	<Directory /var/www/html>"; \
        echo "		Options Indexes FollowSymLinks MultiViews"; \
        echo "		AllowOverride All"; \
        echo "		Require all granted"; \
        echo "		DirectoryIndex index.php index.html"; \
        echo "	</Directory>"; \
	echo "</VirtualHost>"; \
    } > /etc/apache2/sites-available/000-default.conf
 
CMD ["apache2-foreground"]
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 CMD curl -fsS http://127.0.0.1:8080/ > /dev/null || exit 1
EXPOSE 8080
