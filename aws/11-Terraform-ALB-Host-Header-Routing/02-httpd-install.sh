#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir /var/www/html/app2
AVAIL_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone/)
LOCALHOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/hostname/)
sudo echo "<center><h1> Availability Zone: ${AVAIL_ZONE} </h1></br><h3>Hostname: ${LOCALHOSTNAME}</h3></center>" > /var/www/html/index.html