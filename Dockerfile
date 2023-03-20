FROM php:7.4-apache-bullseye
LABEL maintainer="Péter Király <pkiraly@gwdg.de>"
LABEL description="A metadata quality assessment tool for Deutsche Digitale Bibliothek."

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Berlin
ENV RUN_USER nobody
ENV RUN_GROUP 0

ARG SMARTY_VERSION=3.1.33

RUN apt-get update \
 && apt-get install -y unzip curl \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/www/html/* \
 && docker-php-ext-install pdo_mysql

COPY --chown=${RUN_USER}:${RUN_GROUP} . /var/www/html/
WORKDIR /var/www/html/
 
 #
 # set configuration
 #
RUN mv configuration.cnf.docker configuration.cnf \
 #
 # set smarty
 #
 && cd libs/ \
 && curl -s -L https://github.com/smarty-php/smarty/archive/v${SMARTY_VERSION}.zip --output v$SMARTY_VERSION.zip \
 && unzip -q v${SMARTY_VERSION}.zip \
 && rm v${SMARTY_VERSION}.zip \
 && mkdir -p _smarty/templates_c \
 && chmod a+w -R _smarty/templates_c/ \
 #
 # Configure Apache
 #
 && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
 && { \
	echo "<VirtualHost *:8080>"; \
	echo "	ServerAdmin webmaster@localhost"; \
	echo "	DocumentRoot /var/www/html"; \
	echo "	ErrorLog /dev/stderr"; \
	echo "	CustomLog /dev/stdout combined"; \
        echo "	<Directory /var/www/html>"; \
        echo "		Options Indexes FollowSymLinks MultiViews"; \
        echo "		AllowOverride All"; \
        echo "		Order allow,deny"; \
        echo "		allow from all"; \
        echo "		DirectoryIndex index.php index.html"; \
        echo "	</Directory>"; \
	echo "</VirtualHost>"; \
    } > /etc/apache2/sites-available/000-default.conf
 
CMD ["apache2-foreground"]
EXPOSE 8080
