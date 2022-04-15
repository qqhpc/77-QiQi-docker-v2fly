#!/bin/bash

if ! [ -x "$(command -v docker-compose)" ]; then
  echo 'Error: docker-compose is not installed.' >&2
  exit 1
fi

source ./info.conf

rsa_key_size=4096
data_path="./data/certbot"

if [ -d "$data_path" ]; then
  read -p "Existing data found for $domains. Continue and replace existing certificate? (y/N) " decision
  if [ "$decision" != "Y" ] && [ "$decision" != "y" ]; then
    exit
  fi
fi


if [ ! -e "$data_path/conf/options-ssl-nginx.conf" ] || [ ! -e "$data_path/conf/ssl-dhparams.pem" ]; then
  echo "### Downloading recommended TLS parameters ..."
  mkdir -p "$data_path/conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot-nginx/certbot_nginx/_internal/tls_configs/options-ssl-nginx.conf > "$data_path/conf/options-ssl-nginx.conf"
  curl -s https://raw.githubusercontent.com/certbot/certbot/master/certbot/certbot/ssl-dhparams.pem > "$data_path/conf/ssl-dhparams.pem"
  echo
fi

echo "### Creating dummy certificate for $domains ..."

mv ./data/nginx/conf.d/v2ray.conf ./data/nginx/conf.d/v2ray.conf.bak

touch ./data/nginx/conf.d/v2ray.conf
echo "server{" >> ./data/nginx/conf.d/v2ray.conf
echo "   listen 80;" >> ./data/nginx/conf.d/v2ray.conf
echo "   server_name $domains;" >> ./data/nginx/conf.d/v2ray.conf
echo "   location /.well-known/acme-challenge/ {" >> ./data/nginx/conf.d/v2ray.conf
echo "     root /var/www/certbot;"  >> ./data/nginx/conf.d/v2ray.conf
echo "   }"  >> ./data/nginx/conf.d/v2ray.conf
echo "   location / { "  >> ./data/nginx/conf.d/v2ray.conf
echo "       return 301 https://\$host\$request_uri;"  >> ./data/nginx/conf.d/v2ray.conf
echo "   }"   >> ./data/nginx/conf.d/v2ray.conf
echo "}" >> ./data/nginx/conf.d/v2ray.conf

path="/etc/letsencrypt/live/$domains"
mkdir -p "$data_path/conf/live/$domains"
docker-compose run --rm --entrypoint "\
  openssl req -x509 -nodes -newkey rsa:1024 -days 1\
    -keyout '$path/privkey.pem' \
    -out '$path/fullchain.pem' \
    -subj '/CN=localhost'" certbot
echo


echo "### Starting nginx ..."
docker-compose up --force-recreate -d nginx
echo

echo "### Deleting dummy certificate for $domains ..."
docker-compose run --rm --entrypoint "\
  rm -Rf /etc/letsencrypt/live/$domains && \
  rm -Rf /etc/letsencrypt/archive/$domains && \
  rm -Rf /etc/letsencrypt/renewal/$domains.conf" certbot
echo


echo "### Requesting Let's Encrypt certificate for $domains ..."
#Join $domains to -d args
domain_args=""
for domain in "${domains[@]}"; do
  domain_args="$domain_args -d $domain"
done

# Select appropriate email arg
case "$email" in
  "") email_arg="--register-unsafely-without-email" ;;
  *) email_arg="--email $email" ;;
esac

# Enable staging mode if needed
if [ $staging != "0" ]; then staging_arg="--staging"; fi

docker-compose run --rm --entrypoint "\
  certbot certonly --webroot -w /var/www/certbot \
    $staging_arg \
    $email_arg \
    $domain_args \
    --rsa-key-size $rsa_key_size \
    --agree-tos \
    --force-renewal" certbot
echo

rm -f ./data/nginx/conf.d/v2ray.conf
mv ./data/nginx/conf.d/v2ray.conf.bak ./data/nginx/conf.d/v2ray.conf

echo "### Reloading nginx ..."
docker-compose exec nginx nginx -s reload

echo "### 后期更新TLS证书，请重新执行 ./install.sh 命令 ..."
