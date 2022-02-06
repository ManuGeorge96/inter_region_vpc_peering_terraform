#!/bin/bash
yum update -y
yum install mariadb-server -y
systemctl restart mariadb.service; systemctl enable mariadb.service
