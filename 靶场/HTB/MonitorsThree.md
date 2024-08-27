serveic

```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A -O  10.10.11.30
Starting Nmap 7.93 ( https://nmap.org ) at 2024-08-25 22:35 EDT
Nmap scan report for 10.10.11.30
Host is up (0.36s latency).
Not shown: 997 closed tcp ports (reset)
PORT     STATE    SERVICE VERSION
22/tcp   open     ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 86f87d6f4291bb897291af72f301ff5b (ECDSA)
|_  256 50f9ed8e73649eaaf6089514f0a60d57 (ED25519)
80/tcp   open     http    nginx 1.18.0 (Ubuntu)
|_http-server-header: nginx/1.18.0 (Ubuntu)
|_http-title: Did not follow redirect to http://monitorsthree.htb/
8084/tcp filtered websnp
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=8/25%OT=22%CT=1%CU=35354%PV=Y%DS=2%DC=T%G=Y%TM=66CBEA2
OS:1%P=x86_64-pc-linux-gnu)SEQ(SP=101%GCD=1%ISR=10D%TI=Z%CI=Z%II=I%TS=A)OPS
OS:(O1=M53AST11NW7%O2=M53AST11NW7%O3=M53ANNT11NW7%O4=M53AST11NW7%O5=M53AST1
OS:1NW7%O6=M53AST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN
OS:(R=Y%DF=Y%T=40%W=FAF0%O=M53ANNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD
OS:=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 995/tcp)
HOP RTT       ADDRESS
1   233.00 ms 10.10.16.1
2   407.71 ms 10.10.11.30

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 51.04 seconds
```

域名：monitorsthree.htb


vhost爆破
```
┌──(root㉿kali)-[~]
└─# gobuster vhost -u http://monitorsthree.htb -w /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt --append-domain --no-error
===============================================================
Gobuster v3.6
by OJ Reeves (@TheColonial) & Christian Mehlmauer (@firefart)
===============================================================
[+] Url:             http://monitorsthree.htb
[+] Method:          GET
[+] Threads:         10
[+] Wordlist:        /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt
[+] User Agent:      gobuster/3.6
[+] Timeout:         10s
[+] Append Domain:   true
===============================================================
Starting gobuster in VHOST enumeration mode
===============================================================
Found: cacti.monitorsthree.htb Status: 302 [Size: 0] [--> /cacti]
Progress: 114441 / 114442 (100.00%)
===============================================================
Finished

```

写host
```
echo "10.10.11.30 monitorsthree.htb" >> /etc/hosts
echo "10.10.11.30 cacti.monitorsthree.htb" >> /etc/hosts
```


cacti version 
Version 1.2.26

存在：CVE-2024-25641
但是需要登录密码

默认登录凭据不能使用


monitorsthree.htb登录页面
```
┌──(root㉿kali)-[~/htb/MonitorsThree]
└─# cat data        
POST /login.php HTTP/1.1
Host: monitorsthree.htb
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101 Firefox/102.0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8
Accept-Language: en-US,en;q=0.5
Accept-Encoding: gzip, deflate, br
Content-Type: application/x-www-form-urlencoded
Content-Length: 27
Origin: http://monitorsthree.htb
Connection: close
Referer: http://monitorsthree.htb/login.php
Cookie: PHPSESSID=eji8gath9g27u8usudgvh1rbg2
Upgrade-Insecure-Requests: 1

username=admin&password=123
                                                                                                                      
┌──(root㉿kali)-[~/htb/MonitorsThree]
└─# sqlmap -r data  --risk=3 --level=3 --batch -p 'username,password'

```


sqlmap -r data  --risk=3 --level=3 --batch -p 'username' --dbms mysql  



CVE-2024-31445 需要凭据
CVE-2024-31460 需要二次注入
CVE-2024-31458





git -c http.proxy="http://127.0.0.1:7891" clone https://github.com/FredBrave/CVE-2022-46169-CACTI-1.2.22.git

cewl -d 1 -m 3 -w pass.txt http://monitorsthree.htb


http://cacti.monitorsthree.htb/cacti/graphs.php?action=graph_edit&id=1