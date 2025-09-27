# Use the official PHP 8.2 image with Apache
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies required by the application
# and the PHP extensions in a single layer to optimize build time.
RUN apt-get update && \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get install -y --no-install-recommends \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      zip \
      unzip \
      libzip-dev \
      libonig-dev && \
    # Enable the rewrite module for .htaccess to work
    a2enmod rewrite && \
    # Install all required PHP extensions
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip && \
    # Clean up apt cache
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the application source code
COPY . .

# Install application dependencies from the "application" directory
RUN composer install --working-dir=./application --no-interaction --optimize-autoloader --no-dev

# Set correct permissions for writable directories
RUN chmod -R 775 application/logs temp uploads
