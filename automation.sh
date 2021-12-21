#!/bin/bash



bucket="uprgad-sagar"
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

#Task 3: Scheduling a cron job
inventory="/var/www/html/inventory.html"
cron_file="/etc/cron.d/automation"
if [ ! -f "$inventory_file" ]
then
touch "$inventory"
echo "Log Type&emsp;&emsp;&emsp;&emsp;Time Created&emsp;&emsp;&emsp;&emsp;Type&emsp;&emsp;&emsp;&emsp;Size&emsp;&emsp;&emsp;&emsp;<br>" >> "$inventory"
fi
echo -e "<br><br>" >> $inventory

echo "http-d&emsp;&emsp;&emsp;&emsp;&nbsp;"$time_stamp"&emsp;&emsp;&nbsp;&nbsp;tar&emsp;&emsp;&emsp;&emsp;&emsp;"$file_size"&emsp;&emsp;&emsp;<br>" >> "$inventory"

if [ ! -f "$cron_file" ]
then
touch "$cron_file"
echo "00 00 * * * root /root/Automation_Project/automation.sh" > "$cron_file"
fi
