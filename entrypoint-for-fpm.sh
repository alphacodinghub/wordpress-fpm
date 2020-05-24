#!/bin/bash

# note: the end of line sequence should use LF instead of CRLF
# terminate on errors...
set -e

# Check if the src volume is empty
if [ ! "$(ls -A "/var/www/html" 2>/dev/null)" ]; then
    echo 'Setting up  APP volume'
    
    echo "<?php" > /var/www/html/index.php
    echo "phpinfo();" >> /var/www/html/index.php

    # Copy wwordpress from Wordpress src to volume
    #cp -r /usr/src/wordpress/* /var/www/html/
    chown -R www-data.www-data /var/www

    # during the development, if there is any permission conflicts, try to add the below command
    #chmod -R 777 /var/www

    # Generate secrets if any
    #curl -f https://api.wordpress.org/secret-key/1.1/salt/ >> /var/www/html/wp-secrets.php
fi
exec "$@"
