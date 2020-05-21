#!/bin/bash
set -e

# Create certificate directories
mkdir -p /etc/grid-security/certificates
mkdir -p /etc/ssl/certs/
mkdir -p /etc/ssl/private

# enable modules
a2enmod \
  rewrite \
  ssl

# Enable the site
a2ensite \
  000-default-ssl.conf \
  000-default.conf \
  000-mantisbt.conf

rm -f /var/www/html/index.html ${0}
