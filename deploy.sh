    #!/bin/bash

    set -e

    # note: the end of line sequence should use LF instead of CRLF
    # terminate on errors...

    # $1: the wordpress name, e.g. myblog
usages () {
    echo 'Usage:'
    echo '  bash ./deploy.sh  app_root  appName  TYPE'
    echo '    app_root: the root directory of the installation, e.g. /app or /app/'
    echo '    appName: the app name, e.g. myblog'
    echo '    TYPE: the type of the app, one of the two values: wp or app'
    echo '          wp  - Wordpress'
    echo '          app - a general wep application with php and DB support'
    echo ' '
    echo examples:
    echo ' '
    echo to install a Wordpress app called myblog in the root folder /app:
    echo '    bash ./deploy.sh /app/ myblog wp'
    echo ' '
    echo to install a general web app called myapp in the root folder /app:
    echo '    bash ./deploy.sh /app/ myapp app'
    exit
}

if [ $# -ne 3 ]; then
    usages
fi

if [ $3 = "wp" -o $3 = "app" ]; then
    echo '......'
    app_root=$1
    app_name=$2

    if [ ${app_root:(-1)} != "/" ]; then
        app_root+="/"
    fi

    app_dir=$app_root$app_name

    echo app path is $app_dir

    mkdir -p $app_dir

    cp -r config $app_dir/
    cp docker-compose-template.yml $app_dir/
    cp nginx-template.conf $app_dir/
    cp .env-template $app_dir/
    cd $app_dir

    echo "... generating docker-compose.yml ..."

    if [ $3 = "wp" ]; then
        sed "s/achanchor/$app_name/g" docker-compose-template.yml | sed "s/##wp-image/image/g" - > docker-compose.yml
    else
        sed "s/achanchor/$app_name/g" docker-compose-template.yml | sed "s/##app-image/image/g" - > docker-compose.yml
    fi

    echo "... generating .env file ..."
    sed "s/achanchor/$app_name/g" .env-template > .env

    echo "... generating Nginx configure file - default.conf ..."
    sed "s/achanchor/$app_name/g" nginx-template.conf > config/nginx/default.conf

    docker-compose up -d

    db_name=$(awk 'BEGIN{FS="="}/^DB_NAME=/{print $2}' .env)
    db_user=$(awk 'BEGIN{FS="="}/^DB_USER=/{print $2}' .env)
    db_password=$(awk 'BEGIN{FS="="}/^DB_PASSWORD=/{print $2}' .env)
    app_domain=$(awk 'BEGIN{FS="="}/^APP_DOMAIN=/{print $2}' .env)

    if [ $3 = "app" ]; then
        echo " "
        echo "Congratulations!"
        echo "  The DB name is $db_name"
        echo "  The DB user is $db_user"
        echo "  The DB password is $db_password"
        echo " "
        echo please copy your web source files to ${app_dir}/run/html
    fi
    echo " "
    echo "  Your web app url is: https://$app_name.$app_domain"
    echo " "

else
    usages
fi
