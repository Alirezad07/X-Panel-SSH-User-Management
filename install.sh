#!/bin/bash
sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")
adminuser=$(mysql -N -e "use XPanel; select adminuser from setting where id='1';")
adminpass=$(mysql -N -e "use XPanel; select adminpassword from setting where id='1';")
clear
if test -f "/var/www/xpanelport"; then
    echo "File exists xpanelport"
else
touch /var/www/xpanelport
fi
chmod 777 /var/www/xpanelport
domainp=$(cat /var/www/xpanelport | grep "^DomainPanel")
sslp=$(cat /var/www/xpanelport | grep "^SSLPanel")
xpo=$(cat /var/www/xpanelport | grep "^Xpanelport")
xport=$(echo "$xpo" | sed "s/Xpanelport //g")
dmp=$(echo "$domainp" | sed "s/DomainPanel //g")
dmssl=$(echo "$sslp" | sed "s/SSLPanel //g")

if [ "$dmp" != "" ]; then
defdomain=$dmp
else
defdomain=$(curl -sm8 ipv4.icanhazip.com)
fi

if [ "$dmssl" == "True" ]; then
protcohttp=https

else
protcohttp=http
fi

if [ "$adminuser" != "" ]; then
adminusername=$adminuser
adminpassword=$adminpass
else
adminusername=admin
echo -e "\nPlease input Panel admin user."
printf "Default user name is \e[33m${adminusername}\e[0m, let it blank to use this user name: "
read usernametmp
if [[ -n "${usernametmp}" ]]; then
    adminusername=${usernametmp}
fi
adminpassword=123456
echo -e "\nPlease input Panel admin password."
printf "Default password is \e[33m${adminpassword}\e[0m, let it blank to use this password : "
read passwordtmp
if [[ -n "${passwordtmp}" ]]; then
    adminpassword=${passwordtmp}
fi
fi

ipv4=$(curl -sm8 ipv4.icanhazip.com)
sudo sed -i '/www-data/d' /etc/sudoers &
wait
sudo sed -i '/apache/d' /etc/sudoers & 
wait

if command -v apt-get >/dev/null; then
apt update -y
apt remove php8* -y
sudo apt -y install software-properties-common

sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get install postfix
apt install apache2 php7.4 zip unzip net-tools curl mariadb-server -y
apt install php7.4-mysql php7.4-xml php7.4-curl -y

if test -f "/var/www/xpanelport"; then
    echo "File exists xpanelport"
else
touch /var/www/xpanelport
fi
chmod 777 /var/www/xpanelport

link=$(sudo curl -Ls "https://api.github.com/repos/Alirezad07/X-Panel-SSH-User-Management/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget -O /var/www/html/update.zip $link
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/wget' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/unzip' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/htpasswd' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/reboot' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'www-data ALL=(ALL:ALL) NOPASSWD:/usr/sbin/iptables' | sudo EDITOR='tee -a' visudo &
wait
sudo a2enmod rewrite
wait
sudo service apache2 restart
wait
sudo systemctl restart apache2
wait
sudo service apache2 restart
wait
sudo sed -i "s/AllowOverride None/AllowOverride All/g" /etc/apache2/apache2.conf &
wait
sudo service apache2 restart
wait
echo -e "\nPlease input Panel admin Port."
printf "Default port 8081: "
read porttmp
if [[ -n "${porttmp}" ]]; then
#Get the server port number from my settings file
serverPort=${porttmp}
serverPortssl=$((serverPort+1))
echo $serverPort
else
serverPort=8081
serverPortssl=$((serverPort+1))
echo $serverPort
fi
if [ "$dmssl" == "True" ]; then
sshttp=$((serverPort+1))
else
sshttp=$serverPort
fi
##Get just the port number from the settings variable I just grabbed
serverPort=${serverPort##*=}
##Remove the "" marks from the variable as they will not be needed
serverPort=${serverPort//'"'}
echo "<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/example
        ErrorLog /error.log
        CustomLog /access.log combined
        <Directory '/var/www/html/example'>
        AllowOverride All
        </Directory>
</VirtualHost>

<VirtualHost *:$serverPort>
        # The ServerName directive sets the request scheme, hostname and port that
        # the server uses to identify itself. This is used when creating
        # redirection URLs. In the context of virtual hosts, the ServerName
        # specifies what hostname must appear in the request's Host: header to
        # match this virtual host. For the default virtual host (this file) this
        # value is not decisive as it is used as a last resort host regardless.
        # However, you must set it for any further virtual host explicitly.
        #ServerName www.example.com

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html/cp

        # Available loglevels: trace8, ..., trace1, debug, info, notice, warn,
        # error, crit, alert, emerg.
        # It is also possible to configure the loglevel for particular
        # modules, e.g.
        #LogLevel info ssl:warn

        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        # For most configuration files from conf-available/, which are
        # enabled or disabled at a global level, it is possible to
        # include a line for only one particular virtual host. For example the
        # following line enables the CGI configuration for this host only
        # after it has been globally disabled with "a2disconf".
        #Include conf-available/serve-cgi-bin.conf
<Directory '/var/www/html/cp'>
    AllowOverride All
</Directory>

</VirtualHost>

# vim: syntax=apache ts=4 sw=4 sts=4 sr noet" > /etc/apache2/sites-available/000-default.conf
wait
##Replace 'Virtual Hosts' and 'List' entries with the new port number
sudo  sed -i.bak 's/.*NameVirtualHost.*/NameVirtualHost *:'$serverPort'/' /etc/apache2/ports.conf 
echo "Listen 80
Listen $serverPort
<IfModule ssl_module>
Listen $serverPortssl
Listen 443
</IfModule>

<IfModule mod_gnutls.c>
Listen $serverPortssl
Listen 443
</IfModule>" > /etc/apache2/ports.conf
echo '#Xpanel' > /var/www/xpanelport
sudo sed -i -e '$a\'$'\n''Xpanelport '$serverPort /var/www/xpanelport
wait
##Restart the apache server to use new port
sudo /etc/init.d/apache2 reload
sudo service apache2 restart
chown www-data:www-data /var/www/html/cp/* &
wait
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
elif command -v yum >/dev/null; then
yum update -y
sudo yum -y install https://rpms.remirepo.net/enterprise/remi-release-7.rpm
sudo yum-config-manager --enable remi-php74 -y
sudo yum install php php-cli -y

yum install epel-release httpd zip unzip net-tools curl mariadb-server php-mysql php-mysqli php-xml mod_ssl php-curl -y
systemctl restart httpd
systemctl restart mariadb &
wait
systemctl enable mariadb &
wait
link=$(sudo curl -Ls "https://api.github.com/repos/Alirezad07/X-Panel-SSH-User-Management/releases/latest" | grep '"browser_download_url":' | sed -E 's/.*"([^"]+)".*/\1/')
sudo wget -O /var/www/html/update.zip $link
sudo unzip -o /var/www/html/update.zip -d /var/www/html/ &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/adduser' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/userdel' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/passwd' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/curl' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/wget' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/unzip' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/kill' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/killall' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/lsof' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/htpasswd' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/sed' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/rm' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/crontab' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysqldump' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/reboot' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/mysql' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/netstat' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/pgrep' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/local/sbin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/bin/nethogs' | sudo EDITOR='tee -a' visudo &
wait
echo 'apache ALL=(ALL:ALL) NOPASSWD:/usr/sbin/iptables' | sudo EDITOR='tee -a' visudo &
wait
po=$(cat /etc/ssh/sshd_config | grep "^Port")
port=$(echo "$po" | sed "s/Port //g")

systemctl restart httpd
systemctl enable httpd
chown apache:apache /var/www/html/cp/* &
wait
chmod 644 /etc/ssh/sshd_config &
wait
sudo phpenmod curl
PHP_INI=$(php -i | grep /.+/php.ini -oE)
sed -i 's/extension=intl/;extension=intl/' ${PHP_INI}
fi
bash <(curl -Ls https://raw.githubusercontent.com/Alirezad07/Nethogs-Json-main/master/install.sh --ipv4)
mysql -e "create database XPanel;" &
wait
mysql -e "CREATE USER '${adminusername}'@'localhost' IDENTIFIED BY '${adminpassword}';" &
wait
mysql -e "GRANT ALL ON *.* TO '${adminusername}'@'localhost';" &
wait
sudo sed -i "s/22/$port/g" /var/www/html/cp/Config/database.php &
wait
sudo sed -i "s/adminuser/$adminusername/g" /var/www/html/cp/Config/database.php &
wait 
sudo sed -i "s/adminpass/$adminpassword/g" /var/www/html/cp/Config/database.php &
wait 
sudo sed -i "s/SERVERUSER/$adminusername/g" /var/www/html/cp/Libs/sh/killusers.sh &
wait 
sudo sed -i "s/SERVERPASSWORD/$adminpassword/g" /var/www/html/cp/Libs/sh/killusers.sh &
wait 
curl -u "$adminusername:$adminpassword" "$protcohttp://${defdomain}:$sshttp/reinstall"
wait
crontab -r
wait
chmod 777 /var/www/html/cp/Libs/sh/kill.sh
wait
multiin=$(echo "$protcohttp://${defdomain}:$sshttp/fixer&jub=multi")
cat > /var/www/html/cp/Libs/sh/kill.sh << ENDOFFILE
#!/bin/bash
#By Alireza

i=0
while [ 1i -lt 20 ]; do 
cmd=(bbh '$multiin')
echo cmd &
  sleep 3
  i=(( i + 1 ))
done
ENDOFFILE
wait
sudo sed -i 's/(bbh/$(curl -v -H "A: B"/' /var/www/html/cp/Libs/sh/kill.sh
wait
sudo sed -i 's/cmd/$cmd/' /var/www/html/cp/Libs/sh/kill.sh
wait
sudo sed -i 's/1i/$i/' /var/www/html/cp/Libs/sh/kill.sh
wait
sudo sed -i 's/((/$((/' /var/www/html/cp/Libs/sh/kill.sh
wait
chmod 777 /var/www/html/cp/storage
wait
chmod 777 /var/www/html/cp/storage/log
wait
chmod 777 /var/www/html/cp/storage/backup
wait
chmod 777 /var/www/html/cp/Config/database.php
wait
chmod 777 /var/www/html/example/index.php
wait
chmod 777 /var/www/html/cp/Config/define.php 
wait
chmod 777 /var/www/html/cp/Libs
wait
chmod 777 /var/www/html/cp/Libs/sh
wait
if [ "$xport" != "" ]; then
pssl=$((xport+1))
sudo sed -i "s/$xport/$serverPort/g" /var/www/html/cp/Config/define.php &
wait 
sudo sed -i "s/$pssl/$serverPortssl/g" /var/www/html/cp/Config/define.php &
fi
(crontab -l | grep . ; echo -e "* * * * * /var/www/html/cp/Libs/sh/kill.sh") | crontab -
(crontab -l ; echo "* * * * * wget -q -O /dev/null '$protcohttp://${defdomain}:$sshttp/fixer&jub=exp' > /dev/null 2>&1") | crontab -
(crontab -l ; echo "* * * * * wget -q -O /dev/null '$protcohttp://${defdomain}:$sshttp/fixer&jub=synstraffic' > /dev/null 2>&1") | crontab -

clear
printf "\nXPanel Link : $protcohttp://${defdomain}:$sshttp/login"
printf "\nUsername : \e[31m${adminusername}\e[0m "
printf "\nPassword : \e[31m${adminpassword}\e[0m "
printf "\nPort : \e[31m${port}\e[0m \n"
