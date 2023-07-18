# Container image that runs your code
FROM php:apache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /_site/ /var/www/html/

# Configure Apache for port 80
ENV PORT 80
ENTRYPOINT []
CMD sed -i "s/80/$PORT/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf && docker-php-entrypoint apache2-foreground
