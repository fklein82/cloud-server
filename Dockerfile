# Container image that runs your code
FROM php:apache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /_site/ /var/www/html/

# Configure Apache port 8080
RUN sed -i "s/80/8080/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
RUN sed -i "s/443/8080/g" /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf

