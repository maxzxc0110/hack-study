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