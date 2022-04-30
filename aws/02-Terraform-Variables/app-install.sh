#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd
INTERFACE=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/)
SUBNETID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/${INTERFACE}/subnet-id/)
sudo echo "<center><h1> This instance is in the subnet with ID: ${SUBNETID} </h1></center>" > /var/www/html/index.txt
sudo sed "s/SUBNETID/${SUBNETID}/" /var/www/html/index.txt > /var/www/html/index.html