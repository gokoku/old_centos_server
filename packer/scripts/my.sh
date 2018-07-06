echo ">>> php install"
yum -y install php php-mysql php-xml php-pear php-pdo php-cli php-mbstring php-gd php-mcrypt php-common php-devel php-bcmath

echo ">>> apache install"
yum -y install httpd httpd-devel
# overwrite

echo ">>> mysql install"
yum install mysql mysql-server mysql-devel -y

service mysqld start
mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO root@localhost IDENTIFIED BY 'root' WITH GRANT OPTION;"

echo ">>> emacs install"
yum -y install ncurses-devel
yum -y install emacs-nox

sed -i -e "s/AllowOverride None/AllowOverride All/g" /etc/httpd/conf/httpd.conf
echo "<?php phpinfo(); ?>" >/var/www/html/info.php
chkconfig httpd on
chkconfig mysqld on
