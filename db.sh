#!/bin/bash
yum install mariadb-server -y
systemctl restart mariadb.service
