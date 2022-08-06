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


# Reverse Port Forwards

lab里一共有四个域，互相之间的通信关系 

![img](https://rto-assets.s3.eu-west-2.amazonaws.com/reverse-port-forward/domain-traffic-flow.png?width=1920)

## netsh

这个实验是```dc-2.dev.cyberbotic.io```做中继，把```ad.subsidiary.external```上4444端口的流量绑定到自身

此时，```dc-1.cyberbotic.io```连接```dc-2.dev.cyberbotic.io```上的4444端口，就等于访问```ad.subsidiary.external```的4444端口


在操作```dc-2.dev.cyberbotic.io```上操作，添加一个反向端口转发，名字```v4tov4```
```
netsh interface portproxy add v4tov4 listenaddress=0.0.0.0 listenport=4444 connectaddress=10.10.14.55 connectport=4444 protocol=tcp
```

显示上面的转发
```
netsh interface portproxy show v4tov4
```


删除上面的反向端口转发
```
netsh interface portproxy delete v4tov4 listenaddress=0.0.0.0 listenport=4444
```

1. ```ad.subsidiary.external```监听4444端口访问

![img](1659771422544.png)


2. ```dc-2.dev.cyberbotic.io```做一个反向端口转发，把```ad.subsidiary.external```4444端口上的流量转发到本地4444端口

![img](1659771509846.png)


3. 在```dc-1.cyberbotic.io```上连接```dc-2.dev.cyberbotic.io```上的4444端口

![img](1659771713194.png)


4. ```ad.subsidiary.external```监听到4444端口被连接

![img](1659771687607.png)


## rportfwd 

1. 
![img](1659772122017.png)
