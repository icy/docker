#!/bin/bash

########################################################################
# phpfpm hook
########################################################################

_nginx_config_default() {
  cat \
<<-EOF
  server {
    listen       80;
    server_name  ${PHPFPM_DOMAIN} ${PHPFPM_OTHER_DOMAINS:-};
    root         /phpfpm/www/;

    index index.php index.html;

    error_log   /var/log/nginx/${PHPFPM_DOMAIN}.error.log;
    access_log  /var/log/nginx/${PHPFPM_DOMAIN}.acces.log main;

    include /etc/nginx/misc/security.conf;

    location / {
      try_files \$uri \$uri/ /index.php?q=\$uri&\$args;
    }

    location ~ \.php$ {
      fastcgi_pass     unix:/phpfpm/var/phpfpm.sock;
      fastcgi_index    index.php;
      fastcgi_param    SCRIPT_FILENAME  /phpfpm/www/\$fastcgi_script_name;
      include          /etc/nginx/fastcgi_params;
    }
  }
EOF
}

if [[ "${1:-}" == "phpfpm_hook" ]]; then
  _nginx_config_default > /etc/nginx/sites/phpfpm.conf
  exit 0
fi

########################################################################
# Generating wp-config.php
########################################################################

_random_64_chars() {
  < /dev/urandom \
  tr -dc '_A-Z-a-z-0-9!@#$%' \
  | head -c64; echo ""
}

_wordpress_config_generate() {
  export WP_DB_NAME="${WP_DB_NAME:-wordpress}"
  export WP_DB_USER="${WP_DB_USER:-wordpress}"
  export WP_DB_PASSWD="${WP_DB_PASSWD:-wordpress}"
  export WP_DB_HOST="${WP_DB_HOST:-db}"

  cat \
<<-EOF
<?php

define('DB_NAME',     '${WP_DB_NAME}');
define('DB_USER',     '${WP_DB_USER}');
define('DB_PASSWORD', '${WP_DB_PASSWD}');
define('DB_HOST',     '${WP_DB_HOST}');

define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');

define('AUTH_KEY',         '$(_random_64_chars)');
define('SECURE_AUTH_KEY',  '$(_random_64_chars)');
define('LOGGED_IN_KEY',    '$(_random_64_chars)');
define('NONCE_KEY',        '$(_random_64_chars)');
define('AUTH_SALT',        '$(_random_64_chars)');
define('SECURE_AUTH_SALT', '$(_random_64_chars)');
define('LOGGED_IN_SALT',   '$(_random_64_chars)');
define('NONCE_SALT',       '$(_random_64_chars)');

\$table_prefix  = 'wp_';

define('WP_DEBUG', false);

if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

require_once(ABSPATH . 'wp-settings.php');
EOF

}

_F_CONFIG="/phpfpm/www/wp-config.php"

if [[ ! -f "$_F_CONFIG" ]]; then
  echo >&2 ":: Generating a new Wordpress configuration '$_F_CONFIG'..."
  _wordpress_config_generate > $_F_CONFIG
fi

########################################################################
# Downloading wordpress from its homepage
########################################################################

export WP_VERSION="${WP_VERSION:-4.2.2}"
export WP_URL="${WP_URL:-https://wordpress.org/wordpress-4.2.2.tar.gz}"

if [[ ! -f "/phpfpm/www/wp-includes/version.php" ]]; then
  echo >&2 ":: Downloading wordpress from ${WP_URL}..."
  curl -Lso- "${WP_URL}" \
  | tar -xzf - --strip-components=1 -C /phpfpm/www/
fi
