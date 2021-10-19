# 服务发现
```
┌──(root💀kali)-[~/tryhackme/biohazard]
└─# nmap -sV -Pn 10.10.164.186    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-19 04:07 EDT
Nmap scan report for 10.10.164.186
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

页面：```http://10.10.164.186/mansionmain/```源代码显示一行注释
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


根据提示，打开：```http://10.10.164.186/artRoom/```,点击YES，拿到一个目录map
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

在```http://10.10.164.186/barRoom/```填入```lock_pick{037b35e2ff90916a9abf99129c8e1837}```跳转到```http://10.10.164.186/barRoom357162e3db904857963e6e0b64b96ba7/```
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

把上面flag输入到```tigerStatusRoom```,获得另一端密文：
```
crest 1:
S0pXRkVVS0pKQkxIVVdTWUpFM0VTUlk9
Hint 1: Crest 1 has been encoded twice
Hint 2: Crest 1 contanis 14 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it
```

在```/galleryRoom/note.txt```找到```crest 2```
```
crest 2:
GVFWK5KHK5WTGTCILE4DKY3DNN4GQQRTM5AVCTKE
Hint 1: Crest 2 has been encoded twice
Hint 2: Crest 2 contanis 18 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it

```

在```/armorRoom/```输入shield_key后跳转页面点击reame得到```crest 3```
```
crest 3:
MDAxMTAxMTAgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTEgMDAxMDAwMDAgMDAxMTAxMDAgMDExMDAxMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDAgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMTEgMDAxMDAwMDAgMDAxMTAxMTEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTAxMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMTAgMDExMDAwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDEgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTAxMTEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAxMDEgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMDAgMDAxMDAwMDAgMDAxMTAxMDEgMDAxMTEwMDAgMDAxMDAwMDAgMDAxMTAwMTEgMDAxMTAwMTAgMDAxMDAwMDAgMDAxMTAxMTAgMDAxMTEwMDA=
Hint 1: Crest 3 has been encoded three times
Hint 2: Crest 3 contanis 19 letters
Note: You need to collect all 4 crests, combine and decode to reavel another path
The combination should be crest 1 + crest 2 + crest 3 + crest 4. Also, the combination is a type of encoded base and you need to decode it

```