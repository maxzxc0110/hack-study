# 当前域所有用户
```
Get-DomainUser | select -ExpandProperty samaccountname
```

# 当前域所有计算机
```
Get-DomainComputer | select dnshostname
```

# 当前林所有域
```
Get-ForestDomain
```

# 枚举域/林信任
```
Get-DomainTrust
Get-ForestTrust
```

# 获取DA组信息
```
Get-DomainGroup "Domain Admins"
```

# 获取DA组成员
```
Get-DomainGroupMember "Domain Admins" | select -ExpandProperty membername
```


# Find interesting shares in the domain, ignore default shares, and check access
# 枚举当前域分享目录，过滤默认目录，检查进入权限
```
Find-DomainShare -ExcludeStandard -ExcludePrint -ExcludeIPC -CheckShareAccess
```

# 获取域的所有OU
```
Get-DomainOU -FullData
```


# Get computers in an OU （在一个OU中获取计算机）
# %{} is a looping statement %{}（是一个循环语句）
```
Get-DomainOU -name Servers | %{ Get-DomainComputer -SearchBase $_.distinguishedname } | select dnshostname
```

# Get GPOs applied to a specific OU（获取应用于特定OU的GPO）
```
Get-DomainOU *WS* | select gplink
Get-DomainGPO -Name "{3E04167E-C2B6-4A9A-8FB7-C811158DC97C}"
```


# Get Restricted Groups set via GPOs, look for interesting group memberships forced via domain（ 通过GPO获得受限组设置，寻找通过域强制的有趣的组成员资格）
```
Get-DomainGPOLocalGroup -ResolveMembersToSIDs | select GPODisplayName, GroupName, GroupMemberOf, GroupMembers
```

# Get the computers where users are part of a local group through a GPO restricted group（通过GPO限制组获得用户属于本地组的计算机）
```
Get-DomainGPOUserLocalGroupMapping -LocalGroup Administrators | select ObjectName, GPODisplayName, ContainerName, ComputerName
```

# Find principals that can create new GPOs in the domain（枚举可以创建gpo的主体）
```
Get-DomainObjectAcl -SearchBase "CN=Policies,CN=System,DC=targetdomain,DC=com" -ResolveGUIDs | ?{ $_.ObjectAceType -eq "Group-Policy-Container" } | select ObjectDN, ActiveDirectoryRights, SecurityIdentifier
```

# Find principals that can link GPOs to OUs（枚举可以链接GPO和OU的主体）
```
Get-DomainOU | Get-DomainObjectAcl -ResolveGUIDs | ? { $_.ObjectAceType -eq "GP-Link" -and $_.ActiveDirectoryRights -match "WriteProperty" } | select ObjectDN, SecurityIdentifier
```

# Get incoming ACL for a specific object（获取一个特定对象的传入ACL）
```
Get-DomainObjectAcl -SamAccountName "Domain Admins" -ResolveGUIDs | Select IdentityReference,ActiveDirectoryRights
```

# Find interesting ACLs for the entire domain, show in a readable (left-to-right) format（为整个域寻找有趣的ACL，以可读（从左到右）的格式显示）
```
Find-InterestingDomainAcl | select identityreferencename,activedirectoryrights,acetype,objectdn | ?{$_.IdentityReferenceName -NotContains "DnsAdmins"} | ft
```
# Get interesting outgoing ACLs for a specific user or group（为一个特定的用户或组获取有趣的出站ACLs）
# ?{} is a filter statement
```
Find-InterestingDomainAcl -ResolveGUIDs | ?{$_.IdentityReference -match "Domain Admins"} | select ObjectDN,ActiveDirectoryRights
```

# 无约束委派计算机

pv
```
Get-DomainComputer -Unconstrained
```

# 约束委派用户
```
Get-DomainUser -TrustedToAuth | select userprincipalname,msds-allowedtodelegateto
```

# 约束委派机器
```
Get-DomainComputer -TrustedToAuth | select name,msds-allowedtodelegateto
```

# LAPS
PV
```
Get-DomainComputer -identity LAPS-COMPUTER -properties ms-Mcs-AdmPwd
```

LAPSToolkit.ps1

```
Get-LAPSComputers
```

允许读取LAPS密码的组
```
Find-LAPSDelegatedGroups
```
