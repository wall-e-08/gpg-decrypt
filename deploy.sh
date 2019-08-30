#!/usr/bin/env bash

DIR="$(pwd)"

#install mod_wsgi
apt-get install libapache2-mod-wsgi python-dev python-pip virtualenv

#enable mod_wsgi
a2enmod wsgi

cd /var/www
mkdir decryptMessage
cd decryptMessage
mkdir decryptMessage
cd decryptMessage

APP_DIR="/var/www/decryptMessage/decryptMessage"

cp -r $DIR/* $APP_DIR

cd $APP_DIR

virtualenv -p python3 env
source env/bin/activate

pip install -r requirements.txt
deactivate

cat $DIR/apache2_conf > /etc/apache2/sites-available/decryptMessage.conf
a2ensite decryptMessage

cat $DIR/wsgi_conf > /var/www/decryptMessage/decryptMessage.wsgi
service apache2 restart
