#!/bin/bash

    # Install Node.js

    sleep 30

    sudo yum update -y

    sudo yum install -y gcc-c++ make

    curl -sL https://rpm.nodesource.com/setup_16.x | sudo -E bash -
    sudo yum install -y nodejs

    # Install MySQL
    sudo amazon-linux-extras install epel -y 
    sudo yum install https://dev.mysql.com/get/mysql80-community-release-el7-5.noarch.rpm -y
    sudo yum install mysql-community-server -y
    sudo systemctl start mysqld.service
    password=$(sudo cat /var/log/mysqld.log | grep "A temporary password" | awk '{print $NF}')
    echo $password
    sudo mysql -u root -p$password --connect-expired-password -e "ALTER USER 'root'@'localhost' IDENTIFIED BY 'Leomessi@1!';CREATE DATABASE usersdb;USE usersdb;"

    sudo yum install unzip -y
    cd ~/ && unzip webapp.zip
    cd ~/webapp && npm i

    sudo mv /tmp/webapp.service /etc/systemd/system/webapp.service
    sudo systemctl enable webapp.service
    sudo systemctl start webapp.service