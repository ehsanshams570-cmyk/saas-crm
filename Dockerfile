# Use a standard base image with PHP and Apache
FROM php:8.2-apache

# Set the working directory
WORKDIR /var/www/html

# Install only the most basic and necessary PHP extensions
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      libpng-dev \
      libjpeg-dev \
      libfreetype6-dev \
      zip \
      unzip \
      libzip-dev && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo pdo_mysql zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy the application code
COPY . .

# Install dependencies (this will now succeed because imap is removed)
RUN composer install --working-dir=./application --no-interaction --optimize-autoloader --no-dev

# Set permissions for the application
RUN chown -R www-data:www-data .

# Configure Apache
COPY .docker/vhost.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite

# Expose port 80
EXPOSE 80
