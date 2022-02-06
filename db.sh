#!/bin/bash
yum install mariadb-server -y
systemctl restart mariadb.service; systemctl enable mariadb.service
