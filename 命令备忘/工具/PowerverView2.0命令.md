# Powerview
以下记录Powerview2.0版本的常用方法

## 模块：
```
Get-NetDomain               #查看域名称
Get-NetDomainController     #获取域控的信息
Get-NetForest               #查看域内详细的信息
Get-Netuser                 #获取域内所有用户的详细信息
Get-NetUser | select name   #获得域内所有用户名
Get-NetGroup        #获取域内所有组信息
Get-NetGroup | select name  #获取域内所有的组名
Get-NetGroup *admin* | select name   #获得域内组中带有admin的
Get-NetGroup "Domain Admins"         #查看组"Domain Admins"组的信息
Get-NetGroup -UserName test   #获得域内组中用户test的信息
 
Get-UserEvent        #获取指定用户日志信息
Get-NetComputer             #获取域内所有机器的详细信息
Get-NetComputer | select name   #获得域内主机的名字
Get-Netshare                #获取本机的网络共享
Get-NetProcess              #获取本机进程的详细信息
Get-NetOU                #获取域内OU信息
Get-NetFileServer      #根据SPN获取当前域使用的文件服务器
Get-NetSession         #获取在指定服务器存在的Session信息
Get-NetRDPSESSION           #获取本机的RDP连接session信息
Get-NetGPO           #获取域内所有组策略对象
Get-ADOBJECT                #获取活动目录的信息
Get-DomainPolicy       #获取域默认策略
 
Invoke-UserHunter           #查询指定用户登录过的机器
Invoke-EnumerateLocalAdmin  #枚举出本地的管理员信息
Invoke-ProcessHunter        #判断当前机器哪些进程有管理员权限
Invoke-UserEventHunter    #根据用户日志获取某域用户登陆过哪些域机器
```


# 域信息枚举

## 获取域
```
Get-NetDomain                            
Get-NetDomain –Domain moneycorp.local    
```

## 获取林
```
Get-NetForest                             #当前林

Get-NetForestDomain –Forest eurocorp.local #指定林中所有域
```

## 在当前森林获取所有域
```
Get-NetForestDomain -Forest moneycorp.local
```

## 获取当前域的SID
```
Get-DomainSID
```


# 域组信息，成员信息,计算机枚举

1. 用户信息枚举

## 在当前域获取所有用户
```
get-netuser | select  cn
```

## 获取指定用户信息
```
Get-NetUser –Username student1
```

## 获取域用户信息里的某些属性
```
Get-UserProperty –Properties name,memberof,lastlogon
```

## 在用户属性中搜索特定字符串
```
Find-UserField -SearchField Description -SearchTerm "built"
```

2. 组信息枚举

## 获取所有组信息
```
Get-NetGroup
```

## 获取指定域的组信息
```
Get-NetGroup –Domain <targetdomain>
```

## 获取组名中包含单词“admin”的所有组
```
Get-NetGroup *admin*
```

## 查找DA组里所有成员信息
```
Get-NetGroupMember -GroupName "Domain Admins" -Recurse
```

## 获取组成员信息
```
Get-NetGroup –UserName "student1"
```

## 列出计算机上的所有本地组(需要非 dc计算机上的管理员权限)
```
Get-NetLocalGroup -ComputerName dcorp-dc.dollarcorp.moneycorp.local -ListGroups
```

## 获取计算机上所有本地组的成员(需要非 dc计算机上的管理员权限)
```
Get-NetLocalGroup -ComputerName dcorp-dc.dollarcorp.moneycorp.local -Recurse
```

3. 计算机信息枚举

## 在当前域获取所有计算机
```
Get-NetComputer

Get-NetComputer -Ping

Get-NetComputer -FullData
```

4. 登录信息枚举

## 在计算机上获得主动登录的用户(需要目标上的本地管理员权限)
```
Get-NetLoggedon –ComputerName <servername>
```

## 获取计算机上本地登录的用户(需要目标上的远程注册表-默认情况下在服务器操作系统上启动)
```
Get-LoggedonLocal -ComputerName dcorp-dc.dollarcorp.moneycorp.local
```

## 获取计算机上最后登录的用户(需要目标上的管理权限和远程注册表)
```
Get-LastLoggedOn –ComputerName <servername>
```

# 共享信息枚举

## 在当前域中的主机上查找共享
```
Invoke-ShareFinder –Verbose

Invoke-ShareFinder -ComputerName us-dc.us.dollarcorp.moneycorp.local
```

## 在域中的计算机上查找敏感文件
```
Invoke-FileFinder –Verbose
```

## 获取域的所有文件服务器
```
Get-NetFileServer
```

# 域策略与控制器信息枚举

## 获取当前域的域策略
```
Get-DomainPolicy
```

## 获取指定域的域策略
```
(Get-DomainPolicy –domain moneycorp.local)."system access"
```

## 获取当前域的DC服务器信息
```
Get-NetDomainController
```

## 获取指定域的DC服务器信息
```
Get-NetDomainController –Domain moneycorp.local
```

# GPO（组策略信息）枚举

## 获取当前域中的GPO列表
```
Get-NetGPO

Get-NetGPO -ComputerName dcorp-student1.dollarcorp.moneycorp.local Get-GPO -All  (GroupPolicy module)
```

## 获取计算机并通过GPO枚举确定谁对其具有管理权限
```
Find-GPOComputerAdmin –Computername dcorp-student366.dollarcorp.moneycorp.local
```

## 获取用户/组，并通过GPO枚举和关联使其具有有效权限的计算机
```
Find-GPOLocation -UserName student1 -Verbose
```

## 获取所有OU信息
```
Get-NetOU -FullData

Get-NetOU -OUName StudentMachines -FullData
```


## Get GPO applied on an OU. Read GPOname from gplink attribute from Get-NetOU
```
Get-NetGPO -GPOname "{AB306569-220D-43FF-B03B-83E8F4EF8081}"
```

# ACL信息枚举

## 获取与指定对象关联的 ACL
```
Get-ObjectAcl -SamAccountName student1 –ResolveGUIDs
```

## 查找Users组的所有ACL
```
Get-ObjectAcl -SamAccountName "users" -ResolveGUIDs -Verbose

Get-ObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs -Verbose
```

## 查找本账户（sudent366）的所有modify rights/permissions
```
Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "sudent366"}

Invoke-ACLScanner -ResolveGUIDs | ?{$_.IdentityReference -match "RDPUsers"}  #同样的命令，查询RDPUsers组的权限
```

## 获取与要用于搜索的指定前缀相关联的 Acl
```
Get-ObjectAcl -ADSprefix 'CN=Administrator,CN=Users' -Verbose
```

## 获取与要用于搜索的指定 LDAP路径相关联的ACL
```
Get-ObjectAcl -ADSpath "LDAP://CN=Domain Admins,CN=Users,DC=dollarcorp,DC=moneycorp,DC=local" -ResolveGUIDs - Verbose
```

## 搜索有趣的 ACEs
```
Invoke-ACLScanner -ResolveGUIDs
```

## 获取与指定路径关联的 ACL
```
Get-PathAcl -Path "\\dcorp-dc.dollarcorp.moneycorp.local\sysvol"
```


# 域Trust信息枚举
## 获取域的Trust
```
Get-NetDomainTrust

Get-NetDomainTrust -Domain dollarcorp.moneycorp.local


```

## 获取林的Trust
```
Get-NetForestTrust

Get-NetForestDomain -Verbose | Get-NetDomainTrust

Get-NetForestTrust –Forest eurocorp.local
```

## 枚举林中所有的External trusts（外部信任）
```
Get-NetForestDomain -Verbose | Get-NetDomainTrust | ?{$_.TrustType -eq "External"}
```

## 枚举指定林中的所有信任关系
```
Get-NetForestDomain -Forest eurocorp.local -Verbose | Get-NetDomainTrust
```


##在DA权限的shell下枚举所有Trust tikets
```
Invoke-Mimikatz -Command '"lsadump::trust /patch"' -ComputerName dcorp-dc
```


# User Hunting

## Find local admins on all machines of the domain (needs administrator privs on non-dc machines).（在域的所有计算机上查找本地管理员(在非 dc计算机上需要管理员权限)。）

```
Invoke-EnumerateLocalAdmin –Verbose
```

##  查找域管理员(或指定的用户/组)有会话的计算机
```
Invoke-UserHunter

Invoke-UserHunter -GroupName "RDPUsers"
```

## 确认管理员访问权限
```
Invoke-UserHunter -CheckAccess
```

## 查找域管理员登录的计算机
```
Invoke-UserHunter -Stealth
```

# 枚举约束委派用户
需要dev版本powerview
```
Get-DomainUser –TrustedToAuth
```

# 枚举约束委派的计算机，需要用dev版本Powerview
```
Get-DomainComputer –TrustedToAuth
```


# 枚举非约束委派计算机（Unconstrained Delegation），使用powerview的dev版本
```
Get-NetComputer -UnConstrained
```



# 使用```net```命令枚举域信息

获取域用户
```
net user /domain
```

获取指定域用户信息
```
net user zoe.marshall /domain
```

获取域组信息
```
net group /domain
```

获取指定域组信息
```
net group "Tier 1 Admins" /domain
```

获取用户密码政策相关信息
```
net accounts /domain
```