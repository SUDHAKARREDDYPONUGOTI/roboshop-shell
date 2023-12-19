#!/bin/bash

ID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m]"

MONGODB_HOST=mongodb.devopslearnhub.online

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="tmp/$0-$TIMESTAMP.log"

VALIDATE() {

    if [$1 -ne 0]
    then
        echo -e "$2....$R FAILED $N"
        exit 1
    else
        echo -e "$2....$G SUCCESS $N"
    fi
} 


if [$ID -ne 0]
then
    echo -e "$R ERROR:: Please run this script with root access $N"
else
    echo "You are root user"
fi

dnf module disable mysql -y &>> $LOGFILE

$VALIDATE "disable mysql version"

cp /etc/yum.repos.d/s-mysql.repo
$VALIDATE "copy the mysql repo"

dnf install mysql-community-server -y
$VALIDATE "Install mysql software"

systemctl enable mysqld
$VALIDATE "enble the mysql server"

systemctl start mysqld
$VALIDATE "start mysql sserver"

mysql_secure_installation --set-root-pass RoboShop@1
VALIDATE $? "Setting  MySQL root password"


