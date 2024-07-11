服务
```
┌──(root㉿kali)-[~/htb/Blurry]
└─# nmap -Pn -sV 10.10.11.19  
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-11 05:46 EDT
Nmap scan report for 10.10.11.19
Host is up (0.51s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.4p1 Debian 5+deb11u3 (protocol 2.0)
80/tcp open  http    nginx 1.18.0
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 16.03 seconds

```



写host
```
echo "10.10.11.19 blurry.htb" >> /etc/hosts
echo "10.10.11.19 app.blurry.htb" >> /etc/hosts
```

vhost爆破
```
┌──(root㉿kali)-[~]
└─# ffuf -w /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt -H "Host: FUZZ.blurry.htb" -u http://blurry.htb -mc 200

        /'___\  /'___\           /'___\       
       /\ \__/ /\ \__/  __  __  /\ \__/       
       \ \ ,__\\ \ ,__\/\ \/\ \ \ \ ,__\      
        \ \ \_/ \ \ \_/\ \ \_\ \ \ \ \_/      
         \ \_\   \ \_\  \ \____/  \ \_\       
          \/_/    \/_/   \/___/    \/_/       

       v2.1.0-dev
________________________________________________

 :: Method           : GET
 :: URL              : http://blurry.htb
 :: Wordlist         : FUZZ: /usr/share/wordlists/SecLists-2023.2/Discovery/DNS/subdomains-top1million-110000.txt
 :: Header           : Host: FUZZ.blurry.htb
 :: Follow redirects : false
 :: Calibration      : false
 :: Timeout          : 10
 :: Threads          : 40
 :: Matcher          : Response status: 200
________________________________________________

app                     [Status: 200, Size: 13327, Words: 382, Lines: 29, Duration: 319ms]
files                   [Status: 200, Size: 2, Words: 1, Lines: 1, Duration: 789ms]
chat                    [Status: 200, Size: 218733, Words: 12692, Lines: 449, Duration: 424ms]

```

写host
```
echo "10.10.11.19 files.blurry.htb" >> /etc/hosts
echo "10.10.11.19 chat.blurry.htb" >> /etc/hosts
```


CVE-2024-24590