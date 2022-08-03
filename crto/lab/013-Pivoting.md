# SOCKS Proxies

1. CS创建socket
```
socks 1080
```

![img](1659515539543.jpg)

2. 设置proxychains

设置proxychains
```
vi /etc/proxychains4.conf
```

![img](1659515683605.jpg)

查看CS服务端（kali）上监听的转发端口

```
ss -lpnt
```

![img](1659515773959.jpg)

3. 使用

nmap验证，需要加```-Pn```和```-sT```

![img](1659516222390.jpg)

cme验证

![img](1659518671269.jpg)


# Windows Apps


# Browsers

FoxyProxy设置

![img](1659519528397.jpg)

浏览器上访问，现在流量走1080端口上的sock4服务

![img](1659519619361.jpg)


# Metasploit

1. 打开beacon里的```View > Proxy Pivots```,点击Tunnel按钮

![img](1659519840063.jpg)

出现一行文字：
```
setg Proxies socks4:192.168.3.67:1080
```

2. 打开msf

把上面文字复制到msfconsole

![img](1659520016347.jpg)

现在所有msf模块的流量都走1080端口的socks4

尝试使用smb 登录模块，走的是socks4，登录成功

![img](1659520233753.jpg)



