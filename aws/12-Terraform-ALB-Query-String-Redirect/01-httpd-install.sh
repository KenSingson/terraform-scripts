#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
sudo mkdir /var/www/html/app1
INTERFACE=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNETID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id/)
LOCALHOSTNAME=$(curl -s http://169.254.169.254/latest/meta-data/hostname/)
sudo echo "<center><h1> This instance is in the subnet with ID: ${SUBNETID} </h1></br><h3>Hostname: ${LOCALHOSTNAME}</h3></center>" > /var/www/html/index.html