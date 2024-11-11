# Check Arguments
# $1 = subdomain name
# $2 = domain
# $3 = commit hash
SUBDOMAIN=$1
DOMAIN=$2
COMMIT_HASH=$3

if [ -z "$SUBDOMAIN" ]; then
    echo "Subdomain Name Not Found"
    exit 1
fi

if [ -z "$DOMAIN" ]; then
    echo "Domain Not Found"
    exit 1
fi

if [ -z "$COMMIT_HASH" ]; then
    echo "Commit Hash Not Found"
    exit 1
fi

# Check Script File
# nginx_template.sh
NGINX_TEMPLATE="nginx_template.sh"
if [ ! -f "$NGINX_TEMPLATE" ]; then
    echo "Script File Not Found"
    exit 1
fi
source "$NGINX_TEMPLATE"

# Get Build From Temp
TEMP_PATH="temp/${SUBDOMAIN}"
if [ ! -d "$TEMP_PATH" ]; then
    echo "Temp Build Not Found"
    exit 1
fi

# Delete Old Build Files If Exists
OLD_BUILD_PATH="builds/${SUBDOMAIN}/old"
if [ -d "$OLD_BUILD_PATH" ]; then
    rm -rf "$OLD_BUILD_PATH"
fi
mkdir -p "$OLD_BUILD_PATH"

# Move Current Build Files To Old Build Files
CURRENT_BUILD_PATH="builds/${SUBDOMAIN}/current"
if [ -d "$CURRENT_BUILD_PATH" ]; then
    mv "$CURRENT_BUILD_PATH"/* "$OLD_BUILD_PATH"
fi
mkdir -p "$CURRENT_BUILD_PATH"

# Unzip Build Files
cat $TEMP_PATH/$COMMIT_HASH.tar.gz* | tar zxvf - -C $CURRENT_BUILD_PATH
rm -rf $TEMP_PATH

# Create Nginx Config Files If Not Exists
NGINX_CONF_FILE="nginx/sites-enabled/${SUBDOMAIN}.${DOMAIN}.conf"

WEB_ROOT="/var/www/${SUBDOMAIN}/current/build"
generate_nginx_config "$SUBDOMAIN" "$DOMAIN" "$WEB_ROOT" > "$NGINX_CONF_FILE"

# Restart Nginx Docker
docker restart poomasi-front