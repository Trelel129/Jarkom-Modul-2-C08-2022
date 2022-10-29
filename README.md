# Jarkom-Modul-2-C08-2022

## Anggota Kelompok
|No|NRP|Nama|
|-|-|-|
|1|5025201043|Fahmi Muhazir|
|2|5025201204|Moh Akmal Ali Dzikri|
|3|5025201214|Ferry Nur Alfian Eka Putra|

# Soal
> No 1

![image](https://user-images.githubusercontent.com/89815856/198034789-89c6c8cc-8abd-4529-af9c-e2b384c8fc3a.png)

Ostania Network Cofiguration
```
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
	address 192.183.1.1
	netmask 255.255.255.0

auto eth2
iface eth2 inet static
	address 192.183.2.1
	netmask 255.255.255.0

auto eth3
iface eth3 inet static
	address 192.183.3.1
	netmask 255.255.255.0
```

SSS Network Cofiguration
```
auto eth0
iface eth0 inet static
	address 192.183.1.2
	netmask 255.255.255.0
	gateway 192.183.1.1
```

Garden Network Cofiguration
```
auto eth0
iface eth0 inet static
	address 192.183.1.3
	netmask 255.255.255.0
	gateway 192.183.1.1
```

Berlint Network Cofiguration
```
auto eth0
iface eth0 inet static
	address 192.183.3.2
	netmask 255.255.255.0
	gateway 192.183.3.1
```

Eden Network Cofiguration
```
auto eth0
iface eth0 inet static
	address 192.183.2.2
	netmask 255.255.255.0
	gateway 192.183.2.1
```

Wise Network Cofiguration
```
auto eth0
iface eth0 inet static
	address 192.183.2.3
	netmask 255.255.255.0
	gateway 192.183.2.1
```

>No 2

```
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
```

>No3

![image](https://user-images.githubusercontent.com/89815856/198834513-a69789f0-2c20-4adb-ba3b-677820969895.png)

```
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
```

>No 4


