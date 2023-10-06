# 免责声明
> 本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责

# 为什么需要IPLC

最近在使用offsec的lab时发现网络巨卡，连接offsec数据中心（英国）的网络延迟平均在300ms左右，开个RDP基本上就是ppt，没法玩。我在南方城市独享一条电信的千兆网络，讲道理这个延迟我不是很认可。而且我之前打OSCP的lab时网络（数据中心在美国）是非常顺畅的，不知道英国这个节点为什么这么坑，然后我们还不能自己选择节点，因此需要另外研究一套网络解决方案。

需要注意，如果你对网络速度需求不敏感是不需要IPLC的,普通v2ray基本可以满足需求。

# 可选方案

第一种是用vps做一个中转机器，然后在openvpn里做一个前置代理，优点是简单，自己搭个vps就行，我打cp时用的是这种，缺点还是要过公网以及GFW，而GFW这个东西大家都知道就是网络大姨妈，会给我们网络的使用带来很多不确定性。

第二种是走IPLC，IPLC 是 International Private Leased Circuit 的缩写，中文翻译是国际私用出租线路，理论上不用过GFW,而且是私有路线，不用走公网。我理解就是你去长隆乐园玩买的那个快速通道，可以省很多排队的时间。下面是我偷的一个网络上的概念图。



![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681831089636.jpg)


很明显，IPLC的优点就是快，而缺点就是贵，我买的套餐是49元一个月。

# 如何在kali Linux中使用IPLC？

windows和手机使用IPLC非常简单，直接下载软件打开订阅即可，这里不再赘述，主要说明如何在kali中使用。

1. 首先要租用一个IPLC服务，我使用的是WgetCloud，可以点击[这里](https://invite.wgetcloud.ltd/auth/register?code=i37y)注册，你也可以使用其他家的服务，这里不做广告。

需要注意，IPLC线路的选择最好根据自己网络所在地就近选择，比如你在北方，那就选择日韩线路，在南方，选择香港，新加坡线路。请自己甄别各个服务商提供有哪些节点。

2. 下载一个[clash](https://github.com/Dreamacro/clash/releases/tag/premium)

关于clash的详细使用教程请查阅其他文章资料，这里单单示范如何连接offsec的vpn

第一次执行会在```~/.config/clash/```生成两个文件
```
┌──(root㉿kali)-[~]
└─# ./clash-linux-amd64                       
11:30:55 INF [Config] can't find config, create a initial config file path=/root/.config/clash/config.yaml
11:30:55 INF [MMDB] can't find DB, start download path=/root/.config/clash/Country.mmdb

```


来到```~/.config/clash/```目录，执行


```
wget -O config.yaml '你的IPLC订阅地址'
```

下载[Country.mmdb](https://github.com/Dreamacro/maxmind-geoip/releases/latest/download/Country.mmdb)覆盖到```~/.config/clash/```目录


再次执行，已连接上服务
```
./clash-linux-amd64
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681832433238.png)


查看config.yaml文件，里面有相关服务的端口配置


![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681832588697.png)


给kali的firefox配置，需要FoxyProxy插件


![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681832687815.png)

测试谷歌，没有任何问题



![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681832754502.png)

设置openvpn,加一行

```
socks-proxy 127.0.0.1 7891
```


![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681832856739.png)


现在可以使用IPLC加速网络了，我个人体验速度提升还是非常可观的，开RDP服务的时候不会再卡了。



![img](https://github.com/maxzxc0110/hack-study/blob/main/%E8%80%83%E8%AF%81%E9%82%A3%E7%82%B9%E4%BA%8B/OSEP/img/1681833225045.png)