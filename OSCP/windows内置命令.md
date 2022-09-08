# net start列出正在运行的服务

```
PS C:\Users\thm> net start

THM Demo
```

# 根据服务名查找更多服务信息

```
PS C:\Users\thm> wmic service where "name like 'THM Demo'" get Name,PathName
 Name         PathName
THM Service  c:\Windows\thm-demo.exe
```

# 根据二进制文件名查找进程名
```
PS C:\Users\thm> Get-Process -Name thm-demo

Handles  NPM(K)    PM(K)      WS(K)     CPU(s)     Id  SI ProcessName
-------  ------    -----      -----     ------     --  -- -----------
     82       9    13128       6200              3212   0 thm-service
```

# 根据进程名ID查找监听信息
```
PS C:\Users\thm> netstat -noa |findstr "LISTENING" |findstr "3212"
  TCP    0.0.0.0:8080          0.0.0.0:0              LISTENING       3212
  TCP    [::]:8080             [::]:0                 LISTENING       3212
```