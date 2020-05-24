#!/bin/bash

set -e

# note: the end of line sequence should use LF instead of CRLF
# terminate on errors...

# $1: the wordpress name, e.g. myblog
usage () {
  echo hello in usage!
  exit
}


echo '$#=' $#
echo '$0=' $0
echo '$1=' $1
echo '$2=' $2
echo '$3=' $3

appdir=/app/myapp
#echo please copy files to ${appdir}/run/html
#exit 

if [ $# -ne 3 ]; then
  usage
fi

if [ $# = 3 -a $3 = "wp" -o $3 = "app" ]; then
  echo '$# = 3 -- right'
else
  echo '$# = no'
  usage
fi

if [ ! "$1" -o ! "$2" ]; then
    echo 'Usage:'
    echo '    bash ./wp-deploy.sh  app_root  appName'
    echo eg:
    echo '    bash ./wp-deploy.sh /app/ myblog'
else

    echo '......'
    app_root=$1
    app_name=$2
fi

