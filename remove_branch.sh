#!/bin/bash 

# Check Arguments
# $1 = subdomain name
# $2 = domain
SUBDOMAIN=$1
DOMAIN=$2

if [ -z "$SUBDOMAIN" ]; then
    echo "Subdomain Name Not Found"
    exit 1
fi

if [ -z "$DOMAIN" ]; then
    echo "Domain Not Found"
    exit 1
fi

# Delete Old Build Files If Exists
OLD_BUILD_PATH="builds/${SUBDOMAIN}/old"
if [ -d "$OLD_BUILD_PATH" ]; then
    rm -rf "$OLD_BUILD_PATH"
fi

# Delete Current Build Files If Exists
CURRENT_BUILD_PATH="builds/${SUBDOMAIN}/current"
if [ -d "$CURRENT_BUILD_PATH" ]; then
    rm -rf "$CURRENT_BUILD_PATH"
fi

# Delete Subdomain Folder If Exists
SUBDOMAIN_PATH="builds/${SUBDOMAIN}"
if [ -d "$SUBDOMAIN_PATH" ]; then
    rm -rf "$SUBDOMAIN_PATH"
fi

# Delete Nginx Config Files If Exists
NGINX_CONF_FILE="nginx/sites-enabled/${SUBDOMAIN}.${DOMAIN}.conf"
if [ -f "$NGINX_CONF_FILE" ]; then
    rm -rf "$NGINX_CONF_FILE"
fi

# Restart Nginx Docker
docker restart poomasi-front