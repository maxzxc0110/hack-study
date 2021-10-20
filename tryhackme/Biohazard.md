# 服务发现
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# nmap -sV -Pn 10.10.38.183    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-19 04:07 EDT
Nmap scan report for 10.10.38.183
Host is up (0.30s latency).
Not shown: 997 closed ports
PORT   STATE SERVICE VERSION
21/tcp open  ftp     vsftpd 3.0.3
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.29 ((Ubuntu))
Service Info: OSs: Unix, Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 49.55 seconds

```

>问题：How many open ports?
>答案：3

# 打开80端口首页，根据文字描述得知team name

>问题：What is the team name in operation
>答案：STARS alpha team

页面：```/mansionmain/```源代码显示一行注释
>It is in the /diningRoom/

打开上面提示的页面：```/diningRoom/```,写了一行加密的注释：
>SG93IGFib3V0IHRoZSAvdGVhUm9vbS8= 

base64解密后为：
>How about the /teaRoom/

点击yes导航到:```/diningRoom/emblem.php```
拿到``` emblem flag```
>问题：What is the emblem flag
>答案：emblem{fec832623ea498e20bf4fe1821d58727}


打开```/teaRoom/```,点击``` Lockpick. ```拿到pick flag
>问题：What is the lock pick flag
>答案：lock_pick{037b35e2ff90916a9abf99129c8e1837}


根据提示，打开：```/artRoom/```,点击YES，拿到一个目录map
```
Look like a map

Location:
/diningRoom/
/teaRoom/
/artRoom/
/barRoom/
/diningRoom2F/
/tigerStatusRoom/
/galleryRoom/
/studyRoom/
/armorRoom/
/attic/
```

在```/barRoom/```填入```lock_pick{037b35e2ff90916a9abf99129c8e1837}```跳转到```/barRoom357162e3db904857963e6e0b64b96ba7/```
点击```read```,显示
```
Look like a music note
NV2XG2LDL5ZWQZLFOR5TGNRSMQ3TEZDFMFTDMNLGGVRGIYZWGNSGCZLDMU3GCMLGGY3TMZL5 
```

上面密文是base_32，解密出来是:
>music_sheet{362d72deaf65f5bdc63daece6a1f676e}

>问题：What is the music sheet flag
>答案：music_sheet{362d72deaf65f5bdc63daece6a1f676e}

输入到flag，来到```/barRoom357162e3db904857963e6e0b64b96ba7/barRoomHidden.php```

点击Yes,拿到gold emblem
```
gold_emblem{58a8c41a9d08b8a4e38d02a4d7ff4843}

Look like you can put something on the emblem slot, refresh the previous page
```

>问题：What is the gold emblem flag
>答案：gold_emblem{58a8c41a9d08b8a4e38d02a4d7ff4843}

回到```/diningRoom```输入上面的flag后拿到一行密文：

>klfvg ks r wimgnd biz mpuiui ulg fiemok tqod. Xii jvmc tbkg ks tempgf tyi_hvgct_jljinf_kvc

看提示上面这一段是Vigenère加密,去到[这个网站](https://www.guballa.de/vigenere-solver)解密出来是：
>there is a shield key inside the dining room. The html page is called the_great_shield_key

打开```/diningRoom/the_great_shield_key.html```拿到shield_key


>问题：What is the shield key flag
>答案：shield_key{48a7a9227cd7eb89f0a062590798cbac}


在```/diningRoom2F/```的注释找到一行密文：
>Lbh trg gur oyhr trz ol chfuvat gur fgnghf gb gur ybjre sybbe. Gur trz vf ba gur qvavatEbbz svefg sybbe. Ivfvg fnccuver.ugzy

经验证这个是凯撒加密，偏移量是：13
解密出来是：
>You get the blue gem by pushing the status to the lower floor. The gem is on the diningRoom first floor. Visit sapphire.html

打开```/diningRoom/sapphire.html```，拿到blue_jewel


>问题：What is the blue gem flag
>答案：blue_jewel{e1d457e96cac640f863ec7bc475d48aa}

把上面flag输入到```tigerStatusRoom```,获得另一段密文：
```
crest 1:
S0pXRkVVS0pKQkxIVVdTWUpFM0VTUlk9
Hint 1: Crest 1 has been encoded twice
Hint 2: Crest 1 contanis 14 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```
crest 1先base64,再base32解出来是：RlRQIHVzZXI6IG


在```/galleryRoom/note.txt```找到```crest 2```
```
crest 2:
GVFWK5KHK5WTGTCILE4DKY3DNN4GQQRTM5AVCTKE
Hint 1: Crest 2 has been encoded twice
Hint 2: Crest 2 contanis 18 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it

```
crest 2先base32转，再base58转得到：h1bnRlciwgRlRQIHBh


在```/armorRoom/```输入shield_key后跳转页面点击reame得到```crest 3```
```
crest 3:
MDAxMTAxMTAgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAxMDAgMDExMDAxMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMTEgMDAxMDAwMDAgMDAxMTAxMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTAxMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMDEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTEwMDA=
Hint 1: Crest 3 has been encoded three times
Hint 2: Crest 3 contanis 19 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it

```

crest 3先base64转，得到一串二进制数字，2进制转文本得到一个16进制的串，16进制转ASCII得到：c3M6IHlvdV9jYW50X2h


在```/attic/```输入输入shield_key后跳转页面点击reame得到```crest 4```
```
crest 4:
gSUERauVpvKzRpyPpuYz66JDmRTbJubaoArM6CAQsnVwte6zF9J4GGYyun3k5qM9ma4s
Hint 1: Crest 2 has been encoded twice
Hint 2: Crest 2 contanis 17 characters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

crest 4先base58解码得到一个16进制字符串，再转ASCII得到：pZGVfZm9yZXZlcg==

所以crest 1 + crest 2 + crest 3 + crest 4得到一个字符串：

```RlRQIHVzZXI6IGh1bnRlciwgRlRQIHBhc3M6IHlvdV9jYW50X2hpZGVfZm9yZXZlcg==```

base64解密出来是：
```FTP user: hunter, FTP pass: you_cant_hide_forever```


所以我们现在得到了ftp的登入权限，登录到靶机，把文件全部下载下来待分析：
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# ftp 10.10.38.183
Connected to 10.10.38.183.
220 (vsFTPd 3.0.3)
Name (10.10.38.183:root): hunter
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxrwxrwx    2 1002     1002         4096 Sep 20  2019 .
drwxrwxrwx    2 1002     1002         4096 Sep 20  2019 ..
-rw-r--r--    1 0        0            7994 Sep 19  2019 001-key.jpg
-rw-r--r--    1 0        0            2210 Sep 19  2019 002-key.jpg
-rw-r--r--    1 0        0            2146 Sep 19  2019 003-key.jpg
-rw-r--r--    1 0        0             121 Sep 19  2019 helmet_key.txt.gpg
-rw-r--r--    1 0        0             170 Sep 20  2019 important.txt
```

important.txt文件透露出隐藏文件夹：
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# cat important.txt                                                                                                                                                                                                                 127 ⨯
Jill,

I think the helmet key is inside the text file, but I have no clue on decrypting stuff. Also, I come across a /hidden_closet/ door but it was locked.

From,
Barry

```


>问题：Where is the hidden directory mentioned by Barry
>答案：/hidden_closet/ 



001-key.jpg用steghide 分离出一个文件：
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# steghide extract -sf 001-key.jpg 
Enter passphrase: 
wrote extracted data to "key-001.txt".
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# cat key-001.txt 
cGxhbnQ0Ml9jYW
```
key1字符串：cGxhbnQ0Ml9jYW

002-key.jpg的文件信息Comment里有一个奇怪的字符串，我们先记录下来：
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# exiftool 002-key.jpg
ExifTool Version Number         : 12.16
File Name                       : 002-key.jpg
Directory                       : .
File Size                       : 2.2 KiB
File Modification Date/Time     : 2021:10:19 23:46:31-04:00
File Access Date/Time           : 2021:10:19 23:47:26-04:00
File Inode Change Date/Time     : 2021:10:19 23:46:31-04:00
File Permissions                : rw-r--r--
File Type                       : JPEG
File Type Extension             : jpg
MIME Type                       : image/jpeg
JFIF Version                    : 1.01
Resolution Unit                 : None
X Resolution                    : 1
Y Resolution                    : 1
Comment                         : 5fYmVfZGVzdHJveV9
Image Width                     : 100
Image Height                    : 80
Encoding Process                : Progressive DCT, Huffman coding
Bits Per Sample                 : 8
Color Components                : 3
Y Cb Cr Sub Sampling            : YCbCr4:2:0 (2 2)
Image Size                      : 100x80
Megapixels                      : 0.008

```

key2字符串：5fYmVfZGVzdHJveV9

key3用binwalk分离出一个文件：
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# binwalk -e 003-key.jpg

DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             JPEG image data, JFIF standard 1.01
1930          0x78A           Zip archive data, at least v2.0 to extract, uncompressed size: 14, name: key-003.txt
2124          0x84C           End of Zip archive, footer length: 22

                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# cd _003-key.jpg.extracted 
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/biohazard/_003-key.jpg.extracted]
└─# ls
78A.zip  key-003.txt
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/biohazard/_003-key.jpg.extracted]
└─# cat key-003.txt          
3aXRoX3Zqb2x0

```

key3字符串：3aXRoX3Zqb2x0


结合key1+key2+key3得到的字符串是：

>cGxhbnQ0Ml9jYW5fYmVfZGVzdHJveV93aXRoX3Zqb2x0

这个是base64串，解出来是：

>plant42_can_be_destroy_with_vjolt


>问题：Password for the encrypted file
>答案：plant42_can_be_destroy_with_vjolt


用上面的秘钥 解密gpg文件
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# gpg --decrypt helmet_key.txt.gpg > helmet_key.txt                                                                 
gpg: AES256 encrypted data
gpg: 以 1 个密码加密
                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# cat helmet_key.txt
helmet_key{458493193501d2b94bbab2e727f8db4b}

```

>问题：What is the helmet key flag
>答案：helmet_key{458493193501d2b94bbab2e727f8db4b}

用上面的key打开隐藏页面```/hidden_closet/```

点击READ，得到一串密文：
>wpbwbxr wpkzg pltwnhro, txrks_xfqsxrd_bvv_fy_rvmexa_ajk

去到[这个网站](https://www.guballa.de/vigenere-solver),利用```vigenere-solver```解密得到：
>weasker login password, stars_members_are_my_guinea_pig

去到```/studyroom```,输入helmet_key，解锁房间拿到里面的gz文件，解压后得到ssh登录用户名：
>SSH user: umbrella_guest

点击EXAMINE，得到ssh密码：
>SSH password: T_virus_rules


>问题：What is the SSH login username
>答案：umbrella_guest

>问题：What is the SSH login password
>答案：T_virus_rules


全局寻找```STARS bravo team```:

```find / |xargs grep -ri 'STARS bravo team' -l >f.txt```

在```/var/www/html/hiddenCloset8997e740cb7f5cece994381b9477ec38/index.php```找到文本：
```
umbrella_guest@umbrella_corp:/tmp$ cat /var/www/html/hiddenCloset8997e740cb7f5cece994381b9477ec38/index.php
<html>
        <head>
                <title>Closet room</title>
                <h1 align="center">Closet room</h1>
        </head>

        <body>
        <img alt="closet_room" src="../images/maxresdefault.jpg.5" style="display: block;margin-left: auto;margin-right: auto; width: 50%;"/>

        <p>The closet room lead to an underground cave</p>
        <p>In the cave, Jill met injured Enrico, the leader of the STARS Bravo team. He mentioned there is a traitor among the STARTS Alpha team.</p>
        <p>When he was about to tell the traitor name, suddenly, a gun shot can be heard and Enrico was shot dead.</p>
        <p>Jill somehow cannot figure out who did that. Also, Jill found a MO disk 1 and a wolf Medal</p>
        <p><b>Read the MO disk 1?</b>   <a href="MO_DISK1.txt">READ</a></p>
        <p><b>Examine the wolf medal?</b>  <a href="wolf_medal.txt">EXAMINE</a></p> 
        </body>

</html>

```

>问题：Who the STARS bravo team leader
>答案：Enrico


全局寻找```Chris```:

```find / |xargs grep -ri 'Chris' -l >c.txt```

在```/home/umbrella_guest/.jailcell/chris.txt```找到文本：
```
umbrella_guest@umbrella_corp:/tmp$ cat /home/umbrella_guest/.jailcell/chris.txt
Jill: Chris, is that you?
Chris: Jill, you finally come. I was locked in the Jail cell for a while. It seem that weasker is behind all this.
Jil, What? Weasker? He is the traitor?
Chris: Yes, Jill. Unfortunately, he play us like a damn fiddle.
Jill: Let's get out of here first, I have contact brad for helicopter support.
Chris: Thanks Jill, here, take this MO Disk 2 with you. It look like the key to decipher something.
Jill: Alright, I will deal with him later.
Chris: see ya.

MO disk 2: albert 
```

>问题：Where you found Chris
>答案：jailcell


>问题：Who is the traitor
>答案：weasker


```albert```其实就是上面密串```wpbwbxr wpkzg pltwnhro, txrks_xfqsxrd_bvv_fy_rvmexa_ajk```的维吉利亚解密密串，解出来是：
>weasker login password, stars_members_are_my_guinea_pig


>问题：The login password for the traitor
>答案：stars_members_are_my_guinea_pig


切换到```weasker```,查看sudo -l，发现这个账号拥有root的一切权限
```
umbrella_guest@umbrella_corp:/var/www/html$ su weasker
Password: 
weasker@umbrella_corp:/var/www/html$ sudo -l
[sudo] password for weasker: 
Matching Defaults entries for weasker on umbrella_corp:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User weasker may run the following commands on umbrella_corp:
    (ALL : ALL) ALL
```

直接sudo su切换到root,拿到root.txt
```
weasker@umbrella_corp:/var/www/html$ sudo su  
root@umbrella_corp:/var/www/html# cat /root/root.txt 
In the state of emergency, Jill, Barry and Chris are reaching the helipad and awaiting for the helicopter support.

Suddenly, the Tyrant jump out from nowhere. After a tough fight, brad, throw a rocket launcher on the helipad. Without thinking twice, Jill pick up the launcher and fire at the Tyrant.

The Tyrant shredded into pieces and the Mansion was blowed. The survivor able to escape with the helicopter and prepare for their next fight.

The End

flag: 3c5794a00dc56c35f2bf096571edf3bf

```

>问题：The name of the ultimate form
>答案：Tyrant


>问题：The root flag
>答案：3c5794a00dc56c35f2bf096571edf3bf