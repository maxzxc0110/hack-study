# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 基本命令# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 列出所有命令
Get-Command.

# 获取帮助
Get-Help Command-Name

# 从C盘根目录开始查找 interesting-file.txt 文件的目录位置
Get-ChildItem -Path C:\ -Include *interesting-file.txt* -File -Recurse -ErrorAction SilentlyContinue

# 查看文件内容
Get-Content "C:\Program Files\interesting-file.txt.txt"

# 获取一个文件的md5哈希值
Get-FileHash -Path "C:\Program Files\interesting-file.txt.txt" -Algorithm MD5

# 获取当前路径
Get-Location

# 检查某个文件是否存在
Get-Location -Path "C:\Users\Administrator\Documents\Passwords"

# 对某个文件base64解码
certutil -decode "C:\Users\Administrator\Desktop\b64.txt" decode.txt



# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 枚举机器信息# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # 
# 枚举用户
Get-LocalUser

# 判断某个sid是否属于哪个用户
Get-LocalUser -SID "S-1-5-21-1394777289-3961777894-1791813945-501"

# 枚举passwd设置为false的用户
Get-LocalUser | Where-Object -Property PasswordRequired -Match false


# 枚举本地组
Get-LocalGroup | measure

# 获取IP地址信息
Get-NetIPAddress

# 获取监听端口
GEt-NetTCPConnection | Where-Object -Property State -Match Listen | measure  # 总数
GEt-NetTCPConnection | Where-Object -Property State -Match Listen    # 枚举监听端口

# 枚举补丁
Get-Hotfix | measure   # 获取补丁总数
Get-Hotfix   # 枚举补丁
Get-Hotfix -Id KB4023834  # 查看单个补丁详细信息


# 枚举备份文件内容
Get-ChildItem -Path C:\ -Include *.bak* -File -Recurse -ErrorAction SilentlyContinue


# 搜索所有包含api-key的文件
Get-ChildItem C:\* -Recurse | Select-String -pattern API_KEY

# 枚举所有进程信息
Get-Process

# 获取某个计划任务的路径
Get-ScheduleTask -TaskName new-sched-task

# 查看C:盘的owner
Get-Acl c:/





