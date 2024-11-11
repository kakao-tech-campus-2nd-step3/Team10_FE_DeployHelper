#!/bin/bash 

generate_nginx_config() {
    local SUBDOMAIN=$1
    local DOMAIN=$2
    local WEB_ROOT=$3

    if [ -z "$SUBDOMAIN" ]; then
        echo "Subdomain Name Not Found"
        exit 1
    fi

    if [ -z "$DOMAIN" ]; then
        echo "Domain Not Found"
        exit 1
    fi

    if [ -z "$WEB_ROOT" ]; then
        echo "Web Root Not Found"
        exit 1
    fi

    if [ "$SUBDOMAIN" == "master" ]; then
        SERVERNAME="${DOMAIN} www.${DOMAIN}"
    else
        SERVERNAME="${SUBDOMAIN}.${DOMAIN}"
    fi

    cat << EOF
server {
    listen 80;
    listen [::]:80;
    server_name ${SERVERNAME};

    root  ${WEB_ROOT};
    index index.html;

    # Cloudflare의 실제 IP 주소를 얻기 위한 설정
    set_real_ip_from 173.245.48.0/20;
    set_real_ip_from 103.21.244.0/22;
    set_real_ip_from 103.22.200.0/22;
    set_real_ip_from 103.31.4.0/22;
    set_real_ip_from 141.101.64.0/18;
    set_real_ip_from 108.162.192.0/18;
    set_real_ip_from 190.93.240.0/20;
    set_real_ip_from 188.114.96.0/20;
    set_real_ip_from 197.234.240.0/22;
    set_real_ip_from 198.41.128.0/17;
    set_real_ip_from 162.158.0.0/15;
    set_real_ip_from 104.16.0.0/13;
    set_real_ip_from 104.24.0.0/14;
    set_real_ip_from 172.64.0.0/13;
    set_real_ip_from 131.0.72.0/22;
    set_real_ip_from 2400:cb00::/32;
    set_real_ip_from 2606:4700::/32;
    set_real_ip_from 2803:f800::/32;
    set_real_ip_from 2405:b500::/32;
    set_real_ip_from 2405:8100::/32;
    set_real_ip_from 2a06:98c0::/29;
    set_real_ip_from 2c0f:f248::/32;
    
    real_ip_header CF-Connecting-IP;

    # 기본 location 블록
    location / {
        try_files \$uri \$uri/ /index.html;
    }

    # 로그 설정
    access_log /var/log/nginx/${SUBDOMAIN}.access.log;
    error_log /var/log/nginx/${SUBDOMAIN}.error.log;
}
EOF
}