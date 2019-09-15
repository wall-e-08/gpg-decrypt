#!/usr/bin/env bash

DIR="$(pwd)"

yum install -y python-setuptools python-dev build-essential gnupg python-pip epel-release ufw
pip install --upgrade pip
pip install virtualenv

mkdir /usr/share/decrypt_message
cd /usr/share/decrypt_message
yes | cp -rf $DIR/* /usr/share/decrypt_message/


virtualenv -p python3 venv

source /usr/share/decrypt_message/venv/bin/activate
pip install wheel gunicorn
pip install -r /usr/share/decrypt_message/requirements.txt

ufw allow 5000

# gunicorn --bind 0.0.0.0:5000 wsgi:app
deactivate


# deployment
touch /etc/systemd/system/decrypt_message.service
"[Unit]
Description=Gunicorn instance to serve decrypt_message
After=network.target

[Service]
User=ec2-user
Group=www-data

WorkingDirectory=/user/share/decrypt_message
Environment="PATH=/user/share/decrypt_message/venv/bin"
ExecStart=/user/share/decrypt_message/venv/bin/gunicorn --workers 3 --bind unix:decrypt_message.sock -m 007 wsgi:app


[Install]
WantedBy=multi-user.target" >> /etc/systemd/system/decrypt_message.service

systemctl start decrypt_message
systemctl enable decrypt_message

# nginx 
yum install -y nginx
systemctl start nginx
systemctl enable nginx

touch /etc/nginx/default.d/decrypt_message.conf
"server {
    listen 80;
    server_name _;

    location / {
        include proxy_params;
        proxy_pass http://unix:/user/share/decrypt_message/decrypt_message.sock;
    }
}" >> /etc/nginx/default.d/decrypt_message.conf

systemctl restart nginx
