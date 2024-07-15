# Usa la imagen base de PHP 8.2 con Apache
FROM php:8.2-apache

# Instala las dependencias necesarias
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libaio1 \
    unzip \
    libzip-dev \
    libssl-dev \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    wget \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd zip

# Instala y configura Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Configuración de Xdebug
RUN echo "zend_extension=$(find /usr/local/lib/php/extensions/ -name xdebug.so)" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/php.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/php.ini

# Instala las extensiones de PostgreSQL
RUN docker-php-ext-install pdo_pgsql pgsql

# Descarga e instala el driver de Oracle Instant Client
RUN mkdir -p /opt/oracle \
    && cd /opt/oracle \
    && wget https://download.oracle.com/otn_software/linux/instantclient/217000/instantclient-basic-linux.x64-21.7.0.0.0dbru.zip \
    && wget https://download.oracle.com/otn_software/linux/instantclient/217000/instantclient-sdk-linux.x64-21.7.0.0.0dbru.zip \
    && unzip instantclient-basic-linux.x64-21.7.0.0.0dbru.zip \
    && unzip instantclient-sdk-linux.x64-21.7.0.0.0dbru.zip \
    && rm instantclient-basic-linux.x64-21.7.0.0.0dbru.zip \
    && rm instantclient-sdk-linux.x64-21.7.0.0.0dbru.zip \
    && echo /opt/oracle/instantclient_21_7 > /etc/ld.so.conf.d/oracle-instantclient.conf \
    && ldconfig

# Establece variables de entorno para Oracle
ENV LD_LIBRARY_PATH /opt/oracle/instantclient_21_7

# Instala las extensiones de Oracle
RUN docker-php-ext-configure oci8 --with-oci8=instantclient,/opt/oracle/instantclient_21_7 \
    && docker-php-ext-install oci8 \
    && docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/opt/oracle/instantclient_21_7 \
    && docker-php-ext-install pdo_oci

# Habilita mod_rewrite para Apache
RUN a2enmod rewrite

# Copia el archivo de configuración de Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf

# Configura el directorio de trabajo
WORKDIR /var/www/html

# Exponer el puerto
EXPOSE 80

# Comando para ejecutar Apache en primer plano
CMD ["apache2-foreground"]
