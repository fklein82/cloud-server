# Container image that runs your code
FROM php:apache

# Copies your code file from your action repository to the filesystem path `/` of the container
COPY /_site/ /var/www/html/
