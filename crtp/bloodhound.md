# Linux

## 开启neo4j
```
neo4j console
```

## 开启bloodhound
```
bloodhound --no-sandbox
```

# windows
## 初始化
```
.\neo4j.bat install-service
```

## 开启neo4j
```
.\neo4j.bat start
```

## 开启bloodhound

双击BloodHound.exe




# 执行
```
Invoke-BloodHound -CollectionMethod All -verbose
```



# ACE

**ForceChangePassword**：我们可以在不知道用户当前密码的情况下设置用户当前密码。
**AddMembers**：我们有能力将用户（包括我们自己的帐户）、组或计算机添加到目标组。
**GenericAll**：我们可以完全控制对象，包括更改用户密码、注册 SPN 或将 AD 对象添加到目标组的能力。
**GenericWrite**：我们可以更新目标对象的任何非保护参数。例如，这可以让我们更新 scriptPath 参数，这将导致脚本在用户下次登录时执行。
**WriteOwner**：我们有能力更新目标对象的所有者。我们可以让自己成为所有者，从而获得对该对象的额外权限。
**WriteDACL**：我们有能力将新的 ACE 写入目标对象的DACL。例如，我们可以编写一个 ACE，授予我们的帐户对目标对象的完全控制权。
**AllExtendedRights**：我们能够针对目标对象执行与扩展 AD 权限相关的任何操作。例如，这包括强制更改用户密码的能力。



# 所有session

```
MATCH p=(m:Computer)-[r:HasSession]->(n:User) RETURN p
```

# 查找所有域计算机上的活动用户会话

```
MATCH p1=shortestPath(((u1:User)-[r1:MemberOf*1..]->(g1:Group))) MATCH p2=(c:Computer)-[*1]->(u1) RETURN p2
```

# 所有用户

```
MATCH (u:User) return u
```

# 所有计算机

```
MATCH (c:Computer) return c
```

# 所有GPO

```
Match (n:GPO) return n
```

# 所有spn的用户

```
MATCH (n: User) WHERE n.hasspn = true RETURN n
```

# 无约束委托机器

```
MATCH (c:Computer {unconstraineddelegation:true}) return c
```

# 查找包含admin的所有组

```
Match (n:Group) WHERE n.name CONTAINS "ADMIN" return n
```

# 查找关闭kerberos预认证的用户

```
MATCH (u:User {dontreqpreauth: true}) RETURN u
```

# Find interesting ACL

```
MATCH (n:User {admincount:False}) MATCH (m:User) WHERE NOT m.name = n.name MATCH p=allShortestPaths((n)-[r:AllExtendedRights|ForceChangePassword|GenericAll|GenericWrite|Owns|WriteDacl|WriteOwner*1..]->(m)) RETURN p
```