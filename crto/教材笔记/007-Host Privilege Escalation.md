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