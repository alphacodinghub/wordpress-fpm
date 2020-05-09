#!/bin/bash

# note: the end of line sequence should use LF instead of CRLF
# terminate on errors...
set -e

# Check if the src volume is empty
if [ ! "$(ls -A "/var/www/html" 2>/dev/null)" ]; then
    echo 'Setting up  wordpress volume'
    # Copy wwordpress from Wordpress src to volume
    cp -r /usr/src/wordpress/* /var/www/html/
    chown -R www-data.www-data /var/www
    #chmod -R 777 /var/www

    # Generate secrets
    curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-secrets.php
fi
exec "$@"
