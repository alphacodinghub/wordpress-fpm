    #!/bin/bash

    set -e

    # note: the end of line sequence should use LF instead of CRLF
    # terminate on errors...

    # $1: the wordpress name, e.g. myblog

    if [ ! "$1" -o ! "$2" ]; then
        echo 'Usage:'
        echo '    bash ./wp-deploy.sh  app_root  appName'
        echo eg:
        echo '    bash ./wp-deploy.sh /app/ myblog'
    else

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
        sed "s/achanchor/$app_name/g" docker-compose-template.yml > docker-compose.yml

        echo "... generating .env file ..."
        sed "s/achanchor/$app_name/g" .env-template > .env

        echo "... generating Nginx configure file - default.conf ..."
        sed "s/achanchor/$app_name/g" nginx-template.conf > config/nginx/default.conf

        docker-compose up -d

        db_name=$(awk 'BEGIN{FS="="}/^DB_NAME=/{print $2}' .env)
        db_user=$(awk 'BEGIN{FS="="}/^DB_USER=/{print $2}' .env)
        db_password=$(awk 'BEGIN{FS="="}/^DB_PASSWORD=/{print $2}' .env)
        app_domain=$(awk 'BEGIN{FS="="}/^APP_DOMAIN=/{print $2}' .env)

        echo " "
        echo "Congratulations!"
        echo "  The DB name is $db_name"
        echo "      Its constant is DB_NAME"
        echo "  The DB user is $db_user"
        echo "      Its constant is DB_USER"
        echo "  The DB password is $db_password"
        echo "      Its constant is DB_PASSWORD"
        echo " "
        echo "  Your web app url is: https://$app_name.$app_domain"
        echo " "

    fi