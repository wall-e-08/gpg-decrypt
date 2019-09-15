#!/usr/bin/env bash

DIR="$(pwd)/gpg-decrypt"

yum install -y python-setuptools python-dev build-essential gnupg python-pip
pip install --upgrade pip
pip install virtualenv

mkdir $HOME/dcm
cd $HOME/dcm
yes | cp -rf $DIR/* $HOME/dcm/


virtualenv -p python3 venv

source $HOME/dcm/venv/bin/activate
pip install wheel gunicorn
pip install -r $HOME/dcm/requirements.txt

ufw allow 5000

gunicorn --bind 0.0.0.0:5000 wsgi:app
