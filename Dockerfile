# Stage 1: Get the IMAP source files from a matching PHP image
FROM php:8.2-cli as imap_source

# Create a directory for the source files, including parent directories
RUN mkdir -p /usr/src/php/ext/imap

# Download the PHP source code, which includes the imap extension
RUN curl -fsSL https://www.php.net/distributions/php-8.2.0.tar.gz -o php.tar.gz && \
    tar -xf php.tar.gz && \
    mv php-8.2.0/ext/imap/* /usr/src/php/ext/imap/ && \
    rm -rf php.tar.gz php-8.2.0


# Stage 2: The main build using the Apache image
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the IMAP source files from the first stage
COPY --from=imap_source /usr/src/php/ext/imap /usr/src/php/ext/imap

# Install system dependencies. We still need the runtime libraries, but not the -dev package.
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      zip \
      unzip \
      libzip-dev \
      libonig-dev \
      libkrb5-dev && \
    # Now configure and install imap from the source we copied
    docker-php-ext-configure imap --with-kerberos --with-imap-ssl && \
    docker-php-ext-install imap && \
    # Install the other extensions
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the rest of your application's code
COPY . .

# Install application dependencies from the "application" directory
RUN composer install --working-dir=./application --no-interaction --optimize-autoloader --no-dev

# Set permissions for CodeIgniter's writable directories
RUN chown -R www-data:www-data application/logs application/config
RUN chmod -R 775 application/logs application/config

# Configure Apache by copying our custom virtual host file
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable the rewrite module for pretty URLs
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
