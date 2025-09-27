# Use a base image with PHP and Apache
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install system dependencies required by Laravel
RUN apt-get update && apt-get install -y \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      zip \
      unzip \
      libzip-dev \
      libonig-dev \
      && docker-php-ext-configure gd --with-freetype --with-jpeg \
      && docker-php-ext-install gd pdo pdo_mysql mbstring exif pcntl bcmath zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the rest of your application's code
COPY . .

# Install Laravel dependencies
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Set permissions for storage and bootstrap folders
RUN chown -R www-data:www-data storage bootstrap/cache
RUN chmod -R 775 storage bootstrap/cache

# Configure Apache by copying our custom virtual host file
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf

# Enable the rewrite module for pretty URLs (like /login instead of /index.php/login)
RUN a2enmod rewrite

# This tells Docker that the container will listen on port 80
EXPOSE 80
