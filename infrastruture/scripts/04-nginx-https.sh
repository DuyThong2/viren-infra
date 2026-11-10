#!/bin/bash
set -euxo pipefail

APP_DIR="/opt/viren"
TPL_DIR="${APP_DIR}/templates"

# load DOMAIN + EMAIL náº¿u cÃ³
set +u
source "${APP_DIR}/.env" || true
set -u

# Náº¿u chÆ°a cÃ³ DOMAIN/EMAIL -> dÃ¹ng HTTP template
if [ -z "${DOMAIN:-}" ] || [ -z "${EMAIL:-}" ]; then
  cp "${TPL_DIR}/nginx-http.conf.tmpl" /etc/nginx/sites-available/viren-api
  rm -f /etc/nginx/sites-enabled/default || true
  ln -sf /etc/nginx/sites-available/viren-api /etc/nginx/sites-enabled/viren-api
  nginx -t
  systemctl reload nginx
  echo "Nginx HTTP enabled (:80 -> 127.0.0.1:5297). Set DOMAIN+EMAIL in .env to enable HTTPS."
  exit 0
fi

apt-get update -y
apt-get install -y certbot python3-certbot-nginx

sed "s/\${DOMAIN}/${DOMAIN}/g" "${TPL_DIR}/nginx-https.conf.tmpl" > /etc/nginx/sites-available/viren-api

rm -f /etc/nginx/sites-enabled/default || true
ln -sf /etc/nginx/sites-available/viren-api /etc/nginx/sites-enabled/viren-api
nginx -t
systemctl reload nginx

certbot --nginx -n --agree-tos -m "${EMAIL}" -d "${DOMAIN}" --redirect

systemctl reload nginx
echo "HTTPS enabled for ${DOMAIN} (:443) -> proxy http://127.0.0.1:5297"
