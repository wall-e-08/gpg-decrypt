#!/usr/bin/env bash

DIR="$(pwd)"

#install mod_wsgi
yum install -y libapache2-mod-wsgi python3-dev python-devel python3-setuptools python3-pip build-essential libssl-dev libffi-dev
pip install --upgrade pip
pip install virtualenv

mkdir $HOME/decryptMessage
cd $HOME/decryptMessage

virtualenv -p python3 venv

source $HOME/decryptMessage/venv/bin/activate
pip install wheel gunicorn
pip install -r requirements.txt

ufw allow 5000

gunicorn --bind 0.0.0.0:5000 wsgi:app
