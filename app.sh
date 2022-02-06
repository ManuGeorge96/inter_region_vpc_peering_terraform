#!/bin/bash
hostnamectl set-hostname APP.server --static
yum install httpd php -y
systemctl restart httpd.service; systemctl enable httpd.service
cat <<EOF > /var/www/html/index.php
<?php
\$output = shell_exec('echo $HOSTNAME');
echo "<h1><center><pre>\$output</pre></center></h1>";
?>
EOF
service httpd restart
chkconfig httpd on
