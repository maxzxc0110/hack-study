# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现

先快速看看哪些端口开着
```
┌──(root💀kali)-[~/htb/Bastion]
└─# nmap -p- 10.10.10.134 --open               
Nmap scan report for 10.10.10.134
Host is up (0.50s latency).
Not shown: 63143 closed ports, 2379 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
22/tcp    open  ssh
135/tcp   open  msrpc
139/tcp   open  netbios-ssn
445/tcp   open  microsoft-ds
5985/tcp  open  wsman
47001/tcp open  winrm
49664/tcp open  unknown
49665/tcp open  unknown
49666/tcp open  unknown
49667/tcp open  unknown
49668/tcp open  unknown
49669/tcp open  unknown
49670/tcp open  unknown

```

再详细查看指定端口信息
```
└─# nmap -Pn -sV 10.10.10.134 -A -O -p 22,135,139,445,5985,47001,49664,49665,49666,49667,49668,49669,49670
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-22 09:04 EST
Nmap scan report for 10.10.10.134
Host is up (0.58s latency).

PORT      STATE    SERVICE      VERSION
22/tcp    open     tcpwrapped
| ssh-hostkey: 
|   2048 3a:56:ae:75:3c:78:0e:c8:56:4d:cb:1c:22:bf:45:8a (RSA)
|_  256 93:5f:5d:aa:ca:9f:53:e7:f2:82:e6:64:a8:a3:a0:18 (ED25519)
135/tcp   open     msrpc        Microsoft Windows RPC
139/tcp   filtered netbios-ssn
445/tcp   open     microsoft-ds Windows Server 2016 Standard 14393 microsoft-ds
5985/tcp  open     http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
47001/tcp open  http         Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-server-header: Microsoft-HTTPAPI/2.0
|_http-title: Not Found
49664/tcp open     unknown
49665/tcp open     unknown
49666/tcp open     unknown
49667/tcp open     unknown
49668/tcp open     unknown
49669/tcp open     unknown
49670/tcp open     unknown
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Microsoft Windows Server 2016 build 10586 - 14393 (96%), Microsoft Windows Server 2016 (95%), Microsoft Windows 10 1507 (93%), Microsoft Windows 10 1507 - 1607 (93%), Microsoft Windows 10 1511 (93%), Microsoft Windows Server 2012 (93%), Microsoft Windows Server 2012 R2 (93%), Microsoft Windows Server 2012 R2 Update 1 (93%), Microsoft Windows 7, Windows Server 2012, or Windows 8.1 Update 1 (93%), Microsoft Windows Vista SP1 - SP2, Windows Server 2008 SP2, or Windows 7 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OSs: Windows, Windows Server 2008 R2 - 2012; CPE: cpe:/o:microsoft:windows

Host script results:
|_clock-skew: mean: -19m59s, deviation: 34m33s, median: -3s
| smb-os-discovery: 
|   OS: Windows Server 2016 Standard 14393 (Windows Server 2016 Standard 6.3)
|   NetBIOS computer name: BASTION\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2021-12-22T15:06:21+01:00
| smb-security-mode: 
|   account_used: guest
|   authentication_level: user
|   challenge_response: supported
|_  message_signing: disabled (dangerous, but default)
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-12-22T14:06:17
|_  start_date: 2021-12-22T13:37:56

TRACEROUTE (using port 135/tcp)
HOP RTT       ADDRESS
1   566.46 ms 10.10.14.1
2   565.05 ms 10.10.10.134

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 181.76 seconds

```


看到smb有一个用户```guest```，用```smbmap```查看分享目录信息
```
┌──(root💀kali)-[~/htb/Bastion]
└─#  smbmap -H 10.10.10.134 -u guest
[+] IP: 10.10.10.134:445        Name: 10.10.10.134                                      
[-] Work[!] Unable to remove test directory at \\10.10.10.134\Backups\YCUDSRXTPW, please remove manually
        Disk                                                    Permissions     Comment
        ----                                                    -----------     -------
        ADMIN$                                                  NO ACCESS       Remote Admin
        Backups                                                 READ, WRITE
        C$                                                      NO ACCESS       Default share
        IPC$                                                    READ ONLY       Remote IPC

```


进入Backups目录
```
┌──(root💀kali)-[~/htb/Bastion]
└─# smbclient //10.10.10.134/Backups -U guest
Enter WORKGROUP\guest's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Dec 22 10:47:38 2021
  ..                                  D        0  Wed Dec 22 10:47:38 2021
  CFZMBSIEGP                          D        0  Wed Dec 22 10:36:04 2021
  note.txt                           AR      116  Tue Apr 16 06:10:09 2019
  SDT65CB.tmp                         A        0  Fri Feb 22 07:43:08 2019
  TFHLPWIACJ                          D        0  Wed Dec 22 10:47:38 2021
  WindowsImageBackup                 Dn        0  Fri Feb 22 07:44:02 2019
  YCUDSRXTPW                          D        0  Wed Dec 22 10:44:00 2021

```

note.txt内容
```
┌──(root💀kali)-[~/htb/Bastion]
└─# cat note.txt                                    

Sysadmins: please don't transfer the entire backup file locally, the VPN to the subsidiary office is too slow.

```

整个文件备份应该是指```WindowsImageBackup```这个文件夹

这个文件夹里面有几个文件挺有趣
BackupSpecs.xml
```
└─# cat BackupSpecs.xml                         
<BackupSpecs><FileSpecs><Volume Name="\\?\Volume{9b9cfbc3-369e-11e9-a17c-806e6f6e6963}\" AccessPath="" OriginalAccessPath="" Label="" OriginalLabel="" ><FileSpec FilePath="\\?\Volume{9b9cfbc3-369e-11e9-a17c-806e6f6e6963}\" FileName="*" IsRecursive="true" IsInclude="true" /></Volume><Volume Name="\\?\Volume{9b9cfbc4-369e-11e9-a17c-806e6f6e6963}\" AccessPath="C:" OriginalAccessPath="C:" Label="" OriginalLabel="" ><FileSpec FilePath="C:\" FileName="*" IsRecursive="true" IsInclude="true" /></Volume></FileSpecs><SystemState IsPresent="false" /><AllCritical IsPresent="false" /></BackupSpecs>  
```
