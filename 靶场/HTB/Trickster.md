svr
```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A -O  10.10.11.34
Starting Nmap 7.93 ( https://nmap.org ) at 2024-09-25 22:43 EDT
Nmap scan report for 10.10.11.34
Host is up (0.31s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.10 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 8c010e7bb4dab72fbb2fd3a38ca66d87 (ECDSA)
|_  256 90c6f3d83f96999469fed372cbfe6cc5 (ED25519)
80/tcp open  http    Apache httpd 2.4.52
|_http-title: Did not follow redirect to http://trickster.htb/
|_http-server-header: Apache/2.4.52 (Ubuntu)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=9/25%OT=22%CT=1%CU=33370%PV=Y%DS=2%DC=T%G=Y%TM=66F4CA7
OS:D%P=x86_64-pc-linux-gnu)SEQ(SP=104%GCD=1%ISR=10B%TI=Z%CI=Z%II=I%TS=A)OPS
OS:(O1=M53AST11NW7%O2=M53AST11NW7%O3=M53ANNT11NW7%O4=M53AST11NW7%O5=M53AST1
OS:1NW7%O6=M53AST11)WIN(W1=FE88%W2=FE88%W3=FE88%W4=FE88%W5=FE88%W6=FE88)ECN
OS:(R=Y%DF=Y%T=40%W=FAF0%O=M53ANNSNW7%CC=Y%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=A
OS:S%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R
OS:=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F
OS:=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%
OS:T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD
OS:=S)

Network Distance: 2 hops
Service Info: Host: _; OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 1025/tcp)
HOP RTT       ADDRESS
1   214.13 ms 10.10.16.1
2   392.96 ms 10.10.11.34

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 42.77 seconds

```


首页网页源代码发现一个shop.trickster.htb子域名

host
```
echo "10.10.11.34 trickster.htb" >> /etc/hosts
echo "10.10.11.34 shop.trickster.htb" >> /etc/hosts
```

gobuster dir -t 100  --no-error --url http://trickster.htb -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt 

ffuf -w  /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -u http://trickster.htb/FUZZ -mc 200,301

ffuf -w /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt -H "Host: FUZZ.trickster.htb" -u http://trickster.htb -mc 200