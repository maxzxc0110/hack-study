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



 wfuzz -w /usr/share/wfuzz/wordlist/general/common.txt -w /usr/share/wordlists/SecLists/Discovery/Web-Content/web-extensions.txt  --hc 404,403 https://10.10.10.60/FUZZFUZ2Z