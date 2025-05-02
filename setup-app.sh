#!/bin/bash
sudo apt update && sudo apt upgrade -y
sudo apt install curl -y
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install nodejs -y
sudo apt install mysql-server -y

# MySQL root password setup
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Password1!'; FLUSH PRIVILEGES;"
mysql -u root -pPassword1! -e "CREATE DATABASE IF NOT EXISTS employees_db;"
mysql -u root -pPassword1! -e "CREATE USER IF NOT EXISTS 'archit'@'localhost' IDENTIFIED BY 'Password1!';"
mysql -u root -pPassword1! -e "GRANT ALL PRIVILEGES ON employees_db.* TO 'archit'@'localhost';"
mysql -u root -pPassword1! -e "FLUSH PRIVILEGES;"
mysql -u root -pPassword1! employees_db -e "CREATE TABLE IF NOT EXISTS EMPLOYEES (
   emp_id INT(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
   emp_name VARCHAR(225) NOT NULL,
   emp_contact VARCHAR(10),
   emp_add VARCHAR(225) DEFAULT NULL
   ) ENGINE=InnoDB DEFAULT CHARSET=utf8;"

# Clone and start backend and frontend
cd /home/ubuntu
git clone -b master https://github.com/git-hub-sachin/Project-App.git
cd Project-App/backend
npm install
nohup node app.js &

cd ../frontend
npm install
nohup node app.js &
