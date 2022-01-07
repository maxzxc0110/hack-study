# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 服务探测
查看开启端口
```
┌──(root💀kali)-[~/htb]
└─# nmap -p- 10.10.10.193 --open
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-05 20:53 EST
Nmap scan report for 10.10.10.193
Host is up (0.35s latency).
Not shown: 65514 filtered ports
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
49666/tcp open  unknown
49667/tcp open  unknown
49675/tcp open  unknown
49676/tcp open  unknown
49678/tcp open  unknown
49701/tcp open  unknown
49702/tcp open  unknown

```

查看端口详细信息
```
─(root💀kali)-[~/htb]
└─# nmap -sV -T4 -A -O 10.10.10.193 -p 53,80,88,135,139,389,445,464,593,636,3268,3269,5985,9389,49666,49667,49675,49676,49678,49701,49702
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-05 21:08 EST
Nmap scan report for fuse.fabricorp.local (10.10.10.193)
Host is up (0.58s latency).

PORT      STATE SERVICE      VERSION
53/tcp    open  domain       Simple DNS Plus
80/tcp    open  http         Microsoft IIS httpd 10.0
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-server-header: Microsoft-IIS/10.0
|_http-title: Site doesn't have a title (text/html).
88/tcp    open  kerberos-sec Microsoft Windows Kerberos (server time: 2022-01-06 02:21:25Z)
135/tcp   open  msrpc        Microsoft Windows RPC
139/tcp   open  netbios-ssn  Microsoft Windows netbios-ssn
389/tcp   open  ldap         Microsoft Windows Active Directory LDAP (Domain: fabricorp.local, Site: Default-First-Site-Name)
445/tcp   open  microsoft-ds Windows Server 2016 Standard 14393 microsoft-ds (workgroup: FABRICORP)
464/tcp   open  kpasswd5?
593/tcp   open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
636/tcp   open  tcpwrapped
3268/tcp  open  ldap         Microsoft Windows Active Directory LDAP (Domain: fabricorp.local, Site: Default-First-Site-Name)
3269/tcp  open  tcpwrapped
5985/tcp  open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
9389/tcp  open  mc-nmf       .NET Message Framing
49666/tcp open  msrpc        Microsoft Windows RPC
49667/tcp open  msrpc        Microsoft Windows RPC
49675/tcp open  ncacn_http   Microsoft Windows RPC over HTTP 1.0
49676/tcp open  msrpc        Microsoft Windows RPC
49678/tcp open  msrpc        Microsoft Windows RPC
49701/tcp open  msrpc        Microsoft Windows RPC
49702/tcp open  msrpc        Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose
Running (JUST GUESSING): Microsoft Windows 2016 (90%)
OS CPE: cpe:/o:microsoft:windows_server_2016
Aggressive OS guesses: Microsoft Windows Server 2016 (90%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: FUSE; OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: 2h52m59s, deviation: 4h37m09s, median: 12m58s
| smb-os-discovery: 
|   OS: Windows Server 2016 Standard 14393 (Windows Server 2016 Standard 6.3)
|   Computer name: Fuse
|   NetBIOS computer name: FUSE\x00
|   Domain name: fabricorp.local
|   Forest name: fabricorp.local
|   FQDN: Fuse.fabricorp.local
|_  System time: 2022-01-05T18:22:46-08:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: required
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled and required
| smb2-time: 
|   date: 2022-01-06T02:22:47
|_  start_date: 2022-01-06T02:05:53

TRACEROUTE (using port 88/tcp)
HOP RTT       ADDRESS
1   490.15 ms 10.10.16.1
2   733.78 ms fuse.fabricorp.local (10.10.10.193)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 141.01 seconds

```

显然是一台DC，域名：```fabricorp.local```,smb爆出一个```guest```用户
一个个枚举

## web

80端口打开跳到一个域名，把域名添加到host文件：
```echo "10.10.10.193   fuse.fabricorp.local">>/etc/hosts```


80端口看起来像是一个打印机历史记录网站，收集到几个用户名,整理成一个名单
另外页面下载的打印记录里显示打印机的名称是HP-MFT01,应该是一台惠普打印机

5月份打印记录
```
PaperCut Print Logger - http://www.papercut.com/
Time,User,Pages,Copies,Printer,Document Name,Client,Paper Size,Language,Height,Width,Duplex,Grayscale,Size
2020-05-29 17:50:10,pmerton,1,1,HP-MFT01,"New Starter - bnielson - Notepad",JUMP01,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,19kb,
2020-05-29 17:53:55,tlavel,1,1,HP-MFT01,"IT Budget Meeting Minutes - Notepad",LONWK015,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,52kb,
2020-05-30 16:37:45,sthompson,1,1,HP-MFT01,"backup_tapes - Notepad",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,20kb,
2020-05-30 16:42:19,sthompson,1,1,HP-MFT01,"mega_mountain_tape_request.pdf",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,104kb,
2020-05-30 17:07:06,sthompson,1,1,HP-MFT01,"Fabricorp01.docx - Word",LONWK019,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,153kb,
```

6月份打印记录
```
PaperCut Print Logger - http://www.papercut.com/
Time,User,Pages,Copies,Printer,Document Name,Client,Paper Size,Language,Height,Width,Duplex,Grayscale,Size
2020-06-10 17:40:21,bhult,1,1,HP-MFT01,"offsite_dr_invocation - Notepad",LAPTOP07,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,19kb,
2020-06-10 19:18:17,administrator,1,1,HP-MFT01,"printing_issue_test - Notepad",FUSE,LETTER,PCL6,,,NOT DUPLEX,GRAYSCALE,16kb,

```


在[这个](https://www.papercut.com/kb/Main/CommonSecurityQuestions)关于PaperCut的页面里，我们知道网站用户身份验证是通过AD进行的
因此我们猜测打印机的账号可能是svc-print
```
pmerton
tlavel
sthompson
bhult
administrator
guest
Fuse
JUMP01
LONWK015
LONWK019
LAPTOP07
HP-MFT01
svc-print
```

## kerberos

验证上面名单用户是否是域用户
```
┌──(root💀kali)-[~/htb/Fuse]
└─# nmap -p 88 --script=krb5-enum-users --script-args krb5-enum-users.realm="fabricorp.local",userdb=/root/htb/Fuse/user 10.10.10.193
Starting Nmap 7.91 ( https://nmap.org ) at 2022-01-06 01:54 EST
Nmap scan report for fuse.fabricorp.local (10.10.10.193)
Host is up (0.27s latency).

PORT   STATE SERVICE
88/tcp open  kerberos-sec
| krb5-enum-users: 
| Discovered Kerberos principals
|     sthompson@fabricorp.local
|     administrator@fabricorp.local
|     pmerton@fabricorp.local
|     tlavel@fabricorp.local
|     Fuse@fabricorp.local
|     svc-print@fabricorp.local
|_    bhult@fabricorp.local

Nmap done: 1 IP address (1 host up) scanned in 3.60 seconds

```

有效的域用户名单为：
```
tlavel
bhult
```


查看是否有不需要预认证的用户
```
┌──(root💀kali)-[~/htb/Fuse]
└─# python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py fabricorp.local/ -usersfile /root/htb/Fuse/user  -outputfile hashes.asreproast -dc-ip 10.10.10.193
Impacket v0.9.24.dev1+20210906.175840.50c76958 - Copyright 2021 SecureAuth Corporation

[-] User pmerton doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User tlavel doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User sthompson doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User bhult doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] User administrator doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_CLIENT_REVOKED(Clients credentials have been revoked)
[-] User Fuse doesn't have UF_DONT_REQUIRE_PREAUTH set
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] Kerberos SessionError: KDC_ERR_C_PRINCIPAL_UNKNOWN(Client not found in Kerberos database)
[-] User svc-print doesn't have UF_DONT_REQUIRE_PREAUTH set

```

没有。

## smb
enum4linux 没有任何有用的东西

rpcclient 可以匿名登录，但是没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# rpcclient -U "" -N 10.10.10.193                                                                             130 ⨯
rpcclient $> enumdomusers
result was NT_STATUS_ACCESS_DENIED
rpcclient $> 

```

smbclient尝试匿名登录，但是没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# smbclient --no-pass -L 10.10.10.193                                                                         130 ⨯
Anonymous login successful

        Sharename       Type      Comment
        ---------       ----      -------
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.10.193 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

smbmap匿名也没有权限
```
┌──(root💀kali)-[~/htb/Fuse]
└─# smbmap -H 10.10.10.193 -u "" -p ""         
[+] IP: 10.10.10.193:445        Name: fuse.fabricorp.local                              
                                                               
┌──(root💀kali)-[~/htb/Fuse]
└─# smbmap -H 10.10.10.193 -u "svc-print" -p ""
[!] Authentication error on 10.10.10.193

```

## ldap
没有权限查不到任何东西
```
┌──(root💀kali)-[~/htb/Fuse]
└─# ldapsearch -x -h 10.10.10.193 -D 'fabricorp.local/svc-print' -w '' -b "DC=fabricorp,DC=local"
# extended LDIF
#
# LDAPv3
# base <DC=fabricorp,DC=local> with scope subtree
# filter: (objectclass=*)
# requesting: ALL
#

# search result
search: 2
result: 1 Operations error
text: 000004DC: LdapErr: DSID-0C090A6C, comment: In order to perform this opera
 tion a successful bind must be completed on the connection., data 0, v3839

# numResponses: 1

```

## Spray for Password

用cewl命令从web上收集信息作为密码字典，爆破上面的用户列表
```
┌──(root💀kali)-[~/htb/Fuse]
└─# cewl --with-numbers -w passwd.txt http://fuse.fabricorp.local/papercut/logs/html/index.htm
CeWL 5.4.8 (Inclusion) Robin Wood (robin@digi.ninja) (https://digi.ninja/)
WARNING: Nokogiri was built against libxml version 2.9.10, but has dynamically loaded 2.9.12

```

现在我们收集到了一个密码字典passwd.txt

crackmapexec smb 10.10.10.193 -u ./user -p ./passwd.txt


