#!/bin/bash




name="Sagar_S"
mkdir temp
apt update -y
dpkg -s apache2

## if exit sttatus of last task not equal to zero ##

if [ $? -ne 0 ]
then
## install apache server ##

sudo apt install apache2
sudo systemctl start apache2
sudo service apache2 start
fi

status=$(sudo systemctl is-enabled apache2)

if [ "$status" != "enabled" ]

then
sudo systemctl enable apache2
fi

started_a2=$(sudo systemctl is-active apache2)

if [ "$started_a2" != "active" ]
then
service apache2 start
fi
time_stamp=$(date '+%d%m%Y-%H%M%S')
cd temp
filename="$name-httpd-logs-$time_stamp.tar"
echo "$filename"
tar -cvf "$filename" /var/log/apache2/*.log
aws s3 cp "$filename" s3://"$bucket_name"/"$filename"
file_size=$(du -h "$filename")

