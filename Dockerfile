# Use PHP 7.4 with Apache
FROM php:7.4-apache

# Install dependencies (e.g., curl, git, etc.)
RUN apt-get update && apt-get install -y \
    curl \
    git \
    && rm -rf /var/lib/apt/lists/*

# Enable Apache mod_rewrite and other necessary mods
RUN a2enmod rewrite

# Copy your website files into the container
COPY . /var/www/html/

# Fix ownership and permissions for the Apache user
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Set the document root to the appropriate folder
ENV APACHE_DOCUMENT_ROOT /var/www/html

# Ensure that Apache's default virtual host is set up correctly
COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

# Configure Apache to allow .htaccess files (if you use them) and ensure permissions
RUN echo '<Directory /var/www/html>' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    Options Indexes FollowSymLinks' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    AllowOverride All' >> /etc/apache2/sites-available/000-default.conf \
    && echo '    Require all granted' >> /etc/apache2/sites-available/000-default.conf \
    && echo '</Directory>' >> /etc/apache2/sites-available/000-default.conf

# Expose port 80 for the web server
EXPOSE 80

# Restart Apache on container start
CMD ["apache2-foreground"]
