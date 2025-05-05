FROM php:8.2-apache

# Copy app files into the Apache root directory
COPY . /var/www/html/

# Optional: Enable Apache mods (if needed)
RUN docker-php-ext-install mysqli && docker-php-ext-enable mysqli

EXPOSE 80

CMD ["apache2-foreground"]
