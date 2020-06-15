#!/bin/bash
docker build -t alphacodinghub/wordpress-fpm:latest .
docker build -t alphacodinghub/wordpress-fpm:5.4.2 .

docker build -f Dockerfile-for-fpm -t alphacodinghub/php-fpm:7.3-alpine .
docker build -f Dockerfile-for-fpm -t alphacodinghub/php-fpm:latest .