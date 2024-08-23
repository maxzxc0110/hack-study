# 路径遍历

这些漏洞可使攻击者在运行应用程序的服务器上读取任意文件。 这可能包括：
1. 应用程序代码和数据。
2. 后端系统的凭证。
3. 敏感的操作系统文件

在某些情况甚至可以任意写文件


可能存在路径遍历的点：

如果一个路径如：
```
<img src="/loadImage?filename=218.png">
```

或者
```
https://insecure-website.com/loadImage?filename=../../../etc/passwd
```

# 访问控制

作用：
1. 用户身份确认
2. Session管理
3. 控制操作


## Unprotected functionality

1. 没有做session管理的管理页面，如普通用户可以直接访问/admin
2. 网页代码里泄露的管理界面url
```
<script>
	var isAdmin = false;
	if (isAdmin) {
		...
		var adminPanelTag = document.createElement('a');
		adminPanelTag.setAttribute('https://insecure-website.com/administrator-panel-yb556');
		adminPanelTag.innerText = 'Admin panel';
		...
	}
</script>
```

### 垂直权限提升
基于参数的访问控制方法

如：
```
https://insecure-website.com/login/home.jsp?admin=true
https://insecure-website.com/login/home.jsp?role=1
```

### 水平权限提升

类似于上面的方法：
```
https://insecure-website.com/myaccount?id=123
```