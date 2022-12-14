#!/bin/bash
Ostania(){
    apt-get update
    iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE -s 192.183.0.0/16

}

Wise() {
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install bind9 -y
echo 'zone "wise.c08.com" {
type master;
file "/etc/bind/wise/wise.c08.com";
};'
# nomor 2
echo 'zone "wise.c08.com" {
        type master;
        file "/etc/bind/wise/wise.c08.com";
};' > /etc/bind/named.conf.local
mkdir /etc/bind/wise
echo "
\$TTL    604800
@       IN      SOA     wise.c08.com. root.wise.c08.com. (
                                2       ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@               IN      NS      wise.c08.com.
@               IN      A       192.183.3.2 ; IP Wise
www             IN      CNAME   wise.c08.com.
" > /etc/bind/wise/wise.c08.com
service bind9 restart

# nomor 3
echo "
\$TTL    604800
@       IN      SOA     wise.c08.com. root.wise.c08.com. (
                                2       ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@               IN      NS      wise.c08.com.
@               IN      A       192.183.3.2 ; IP Wise
www             IN      CNAME   wise.c08.com.
eden            IN      A       192.183.2.3 ; IP Eden
www.eden        IN      CNAME   eden.wise.c08.com.
" > /etc/bind/wise/wise.c08.com
service bind9 restart

# nomor 4

echo '
zone "wise.c08.com" {
        type master;
        file "/etc/bind/wise/wise.c08.com";
};

zone "2.183.192.in-addr.arpa" {
        type master;
        file "/etc/bind/wise/2.183.192.in-addr.arpa";
};' > /etc/bind/named.conf.local

echo "
\$TTL    604800
@       IN      SOA     wise.c08.com. root.wise.c08.com. (
                                2       ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
2.183.192.in-addr.arpa.   IN      NS      wise.c08.com.
2                         IN      PTR     wise.c08.com.
"> /etc/bind/wise/2.183.192.in-addr.arpa
service bind9 restart


# nomor 5

echo '
zone "wise.c08.com" {
        type master;
        notify yes;
        also-notify {192.183.2.2;};  //Masukan IP Berlint tanpa tanda petik
        allow-transfer {192.183.2.2;}; // Masukan IP Berlint tanpa tanda petik
        file "/etc/bind/wise/wise.c08.com";
};

zone "2.183.192.in-addr.arpa" {
        type master;
        file "/etc/bind/wise/2.183.192.in-addr.arpa";
};' > /etc/bind/named.conf.local
service bind9 restart

# nomor 6
echo "
\$TTL    604800
@       IN      SOA     wise.c08.com. root.wise.c08.com. (
                                2       ; Serial
                        604800          ; Refresh
                        86400           ; Retry
                        2419200         ; Expire
                        604800 )        ; Negative Cache TTL
;
@               IN      NS      wise.c08.com.
@               IN      A       192.183.2.3 ; IP Eden
www             IN      CNAME   wise.c08.com.
eden            IN      A       192.183.2.3 ; IP Eden
www.eden        IN      CNAME   eden.wise.c08.com.
ns1             IN      A       192.183.2.2; IP Berlint
operation       IN      NS      ns1
"> /etc/bind/wise/wise.c08.com

echo "
options {
        directory \"/var/cache/bind\";

        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options

echo '
zone "wise.c08.com" {
        type master;
        //notify yes;
        //also-notify {192.183.2.2;};  Masukan IP Berlint tanpa tanda petik
        file "/etc/bind/wise/wise.c08.com";
        allow-transfer {192.183.2.2;}; // Masukan IP Berlint tanpa tanda petik
};

zone "2.183.192.in-addr.arpa" {
        type master;
        file "/etc/bind/wise/2.183.192.in-addr.arpa";
};
' >  /etc/bind/named.conf.local

service bind9 restart
}

Berlint(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update

# nomor 5
apt-get update
apt-get install bind9 -y
echo '
zone "wise.c08.com" {
        type slave;
        masters { 192.183.3.2; }; // Masukan IP Wise tanpa tanda petik
        file "/var/lib/bind/wise.c08.com";
};
' > /etc/bind/named.conf.local
service bind9 restart

# nomor 6

echo "
options {
        directory \"/var/cache/bind\";
        allow-query{any;};
        auth-nxdomain no;    # conform to RFC1035
        listen-on-v6 { any; };
};
" > /etc/bind/named.conf.options
echo '
zone "wise.c08.com" {
        type slave;
        masters { 192.183.3.2; }; // Masukan IP Wise tanpa tanda petik
        file "/var/lib/bind/wise.c08.com";
};

zone "operation.wise.c08.com"{
        type master;
        file "/etc/bind/operation/operation.wise.c08.com";
};
'> /etc/bind/named.conf.local
mkdir /etc/bind/operation
echo "
\$TTL    604800
@       IN      SOA     operation.wise.c08.com. root.operation.wise.c08.com. (
                                2      ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
@               IN      NS      operation.wise.c08.com.
@               IN      A       192.183.2.3       ;ip Eden
www             IN      CNAME   operation.wise.c08.com.
" > /etc/bind/operation/operation.wise.c08.com
service bind9 restart


# Nomor 7
echo "
\$TTL    604800
@       IN      SOA     operation.wise.c08.com. root.operation.wise.c08.com. (
                                2      ; Serial
                        604800         ; Refresh
                        86400         ; Retry
                        2419200         ; Expire
                        604800 )       ; Negative Cache TTL
;
@               IN      NS      operation.wise.c08.com.
@               IN      A       192.183.2.3       ;ip Eden
www             IN      CNAME   operation.wise.c08.com.
strix           IN      A       192.183.2.3       ;IP Eden
www.strix       IN      CNAME   strix.operation.wise.c08.com.
" > /etc/bind/operation/operation.wise.c08.com
service bind9 restart

}

SSS(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install dnsutils -y
apt-get install lynx -y

# nomor 5
echo "
nameserver 192.183.1.2
nameserver 192.183.3.2
nameserver 192.183.3.3

" > /etc/resolv.conf
}

Garden(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update
apt-get install dnsutils -y
apt-get install lynx -y

# nomor 5
echo "
nameserver 192.183.3.2
nameserver 192.183.2.2
nameserver 192.183.2.3

" > /etc/resolv.conf
}

Eden(){
echo "nameserver 192.168.122.1" > /etc/resolv.conf
apt-get update

# nomor 8
apt-get install apache2 -y
service apache2 start
apt-get install php -y
apt-get install libapache2-mod-php7.0 -y
service apache2 
apt-get install ca-certificates openssl -y
apt-get install unzip -y
apt-get install git -y
git clone https://github.com/Trelel129/Praktikum-Modul-2-Jarkom.git 
unzip -o /root/Praktikum-Modul-2-Jarkom/\*.zip -d /root/Praktikum-Modul-2-Jarkom
echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.c08.com
        ServerName wise.c08.com
        ServerAlias www.wise.c08.com

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/wise.c08.com.conf
a2ensite wise.c08.com
mkdir /var/www/wise.c08.com
cp -r /root/Praktikum-Modul-2-Jarkom/wise/. /var/www/wise.c08.com
service apache2 restart

# nomor 9
a2enmod rewrite
service apache2 restart
echo "
RewriteEngine On
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule (.*) /index.php/\$1 [L]
" >/var/www/wise.c08.com/.htaccess
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/wise.c08.com
        ServerName wise.c08.com
        ServerAlias www.wise.c08.com

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/wise.c08.com.conf
service apache2 restart

# nomor 10
echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.c08.com
        ServerName eden.wise.c08.com
        ServerAlias www.eden.wise.c08.com

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.c08.com.conf
a2ensite eden.wise.c08.com
mkdir /var/www/eden.wise.c08.com
cp -r /root/Praktikum-Modul-2-Jarkom/eden.wise/. /var/www/eden.wise.c08.com
service apache2 restart
echo "<?php echo 'yes nomor 10' ?>" > /var/www/eden.wise.c08.com/index.php

# nomor 11
echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.c08.com
        ServerName eden.wise.c08.com
        ServerAlias www.eden.wise.c08.com

        <Directory /var/www/eden.wise.c08.com/public>
                Options +Indexes
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.c08.com.conf
service apache2 restart

# nomor 12
echo "
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.c08.com
        ServerName eden.wise.c08.com
        ServerAlias www.eden.wise.c08.com

        ErrorDocument 404 /error/404.html
        ErrorDocument 500 /error/404.html
        ErrorDocument 502 /error/404.html
        ErrorDocument 503 /error/404.html
        ErrorDocument 504 /error/404.html

        <Directory /var/www/eden.wise.c08.com/public>
                Options +Indexes
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.c08.com.conf
service apache2 restart

# nomor 13
echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.c08.com
        ServerName eden.wise.c08.com
        ServerAlias www.eden.wise.c08.com

        ErrorDocument 404 /error/404.html
        ErrorDocument 500 /error/404.html
        ErrorDocument 502 /error/404.html
        ErrorDocument 503 /error/404.html
        ErrorDocument 504 /error/404.html

        <Directory /var/www/eden.wise.c08.com/public>
                Options +Indexes
        </Directory>

        Alias \"/js\" \"/var/www/eden.wise.c08.com/public/js\"


        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.c08.com.conf
service apache2 restart

# nomor 14

echo "
<VirtualHost *:15000>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.c08.com
        ServerName strix.operation.wise.c08.com
        ServerAlias www.strix.operation.wise.c08.com


        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<VirtualHost *:15500>        
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.c08.com
        ServerName strix.operation.wise.c08.com
        ServerAlias www.strix.operation.wise.c08.com
        

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/strix.operation.wise.c08.com.conf
a2ensite strix.operation.wise.c08.com
service apache2 restart
mkdir /var/www/strix.operation.wise.c08.com
cp -r /root/Praktikum-Modul-2-Jarkom/strix.operation.wise/ ./var/www/strix.operation.wise.c08.com/
echo "
<?php
        echo 'selamat 14';
?>
" > /var/www/strix.operation.wise.c08.com/index.php
echo "
# If you just change the port or add more ports here, you will likely also
# have to change the VirtualHost statement in
# /etc/apache2/sites-enabled/000-default.conf

Listen 80
Listen 15000
Listen 15500
<IfModule ssl_module>
        Listen 443
</IfModule>

<IfModule mod_gnutls.c>
        Listen 443
</IfModule>
" > /etc/apache2/ports.conf

service apache2 restart

# nomor 15
htpasswd -c -b /etc/apache2/.htpasswd Twilight opStrix

echo "
<VirtualHost *:15000>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.c08.com
        ServerName strix.operation.wise.c08.com
        ServerAlias www.strix.operation.wise.c08.com

        <Directory \"/var/www/strix.operation.wise.c08.com\">
                AuthType Basic
                AuthName \"Restricted Content\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
<VirtualHost *:15500>        
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/strix.operation.wise.c08.com
        ServerName strix.operation.wise.c08.com
        ServerAlias www.strix.operation.wise.c08.com
        
        <Directory \"/var/www/strix.operation.wise.c08.com\">
                AuthType Basic
                AuthName \"Restricted Content\"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
        </Directory>
        
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
" > /etc/apache2/sites-available/strix.operation.wise.c08.com.conf
service apache2 restart

# nomor 16

echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        RewriteEngine On
        RewriteCond %{HTTP_HOST} !^wise.c08.com$
        RewriteRule /.* http://wise.c08.com/ [R]

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

</VirtualHost>
" > /etc/apache2/sites-available/000-default.conf
service apache2 restart

# nomor 17
echo "
RewriteEngine On
RewriteCond %{REQUEST_URI} ^/public/images/(.*)eden(.*)
RewriteCond %{REQUEST_URI} !/public/images/eden.png
RewriteRule /.* http://eden.wise.c08.com/public/images/eden.png [L]
" > /var/www/eden.wise.c08.com/.htaccess

echo "
<VirtualHost *:80>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/eden.wise.c08.com
        ServerName eden.wise.c08.com
        ServerAlias www.eden.wise.c08.com

        ErrorDocument 404 /error/404.html
        ErrorDocument 500 /error/404.html
        ErrorDocument 502 /error/404.html
        ErrorDocument 503 /error/404.html
        ErrorDocument 504 /error/404.html

        <Directory /var/www/eden.wise.c08.com/public>
                Options +Indexes
        </Directory>

        Alias \"/js\" \"/var/www/eden.wise.c08.com/public/js\"

        <Directory /var/www/eden.wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/wise.c08.com>
                Options +FollowSymLinks -Multiviews
                AllowOverride All
        </Directory>
</VirtualHost>
" > /etc/apache2/sites-available/eden.wise.c08.com.conf
service apache2 restart

}

if [ $HOSTNAME == "Ostania" ]
then
    Ostania
elif [ $HOSTNAME == "WISE" ]
then
    Wise
elif [ $HOSTNAME == "Berlint" ]
then
    Berlint
elif [ $HOSTNAME == "SSS" ]
then
    SSS
elif [ $HOSTNAME == "Garden" ]
then
    Garden
elif [ $HOSTNAME == "Eden" ]
then
    Eden
fi