+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "mysql source code learning"
date = "2022-11-14"
description = "带着些许问题去源码中找答案"
categories = ["database","mysql"]
tags = ["sourcecode"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img2.png"
+++
<!--more-->
## 指南
```
建议一： 从handler出发
MySQL插件式引擎，连接MySQL Server与各种存储引擎的，是其Handler
模块 —— hanlder模块是灵魂；
以InnoDB引擎为例，从ha_innodb.cc文件出发，理解其中的每一个接口的
功能，能够上达MySQL Server，下抵InnoDB引擎的内部实现；
建议二： 不放过源码中的每一处注释
MySQL/InnoDB源码中，有很多注释，一些注释相当详细，对理解某一个
函数/某一个功能模块都相当有用；
```
## 问题探索
### 一条SQL的生命周期
[参考文章](https://blog.mipa.site/2020/06/021934.html)
### mysql插件化架构
### mysql8.0取消查询缓存
[官方说明](https://dev.mysql.com/blog-archive/mysql-8-0-retiring-support-for-the-query-cache/)
### 网络IO模型
[参考文章](https://blog.51cto.com/u_15069490/2937369)
## 其他
### mysql8.0.24源码编译安装
主要是参考[这篇文章](https://www.cnblogs.com/jhno1/p/15324343.html#autoid-0-8-0)，操作过程中根据报错进行fix，特别是修改my.cnf配置文件。
### 编译安装问题
1. OpenSSL 版本不兼容<br>
不兼容1.1版本，需要openssl1.0.2，通过yum install openssl-devel。<br>
2. 磁盘空间不足<br>
60g磁盘满了，导致make 终止，/data目录删掉即可。<br>
```sh
fatal error: error writing to /tmp/ccFtecZv.s: No space left on device
```
3. 内存不足<br>
需要开启swap分区
```sh
g++: internal compiler error: Killed (program cc1plus)
```
4. 太吃内存，make巨慢<br>
没找到解决方案...
5. 缺少依赖组件<br>
可能是缺少ncurses-devel
```sh
yum install ncurses-devel libaio bison zlib-devel openssl openssl-devel patch
```
### mysqld启动问题
1. 磁盘空间不足
> 注意my.cnf配置文件，特别innodb参数配置，可能因系统内存或磁盘容量导致启动失败

查看系统磁盘: df -h<br>
[InnoDB] Error number 28 means 'No space left on device'
### vscode本地调试mysql8.0.24
先在云服务器上执行以下命令：
```sh
./mysqld --initialize --user=mysql --basedir=/usr/local/mysql --datadir=/usr/local/mysql/data
```
launch.json配置文件如下：
{{< highlight json "linenos=table" >}}
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "debug mysql",
            "type": "cppdbg",
            "request": "launch",
            "program": "/usr/local/mysql/bin/mysqld",
            "args": ["--defaults-file=/usr/local/mysql/etc/my.cnf"],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        }
    ]
}
{{< / highlight >}}
![static/mysql-debug-capture](static/mysql-debug-capture.jpg)
## 源码结构
安装tree工具，执行tree -d -L 1命令：
```
|-- build
|-- client
|-- cmake
|-- components
|-- Docs
|-- doxygen_resources
|-- extra
|-- include
|-- libbinlogevents
|-- libbinlogstandalone
|-- libmysql
|-- libservices
|-- man
|-- mysql-test
|-- mysys
|-- packaging
|-- plugin
|-- router
|-- scripts
|-- share
|-- source_downloads
|-- sql
|-- sql-common
|-- storage
|-- strings
|-- support-files
|-- testclients
|-- unittest
|-- utilities
`-- vio
```
语雀代码画时序图：
https://www.bookstack.cn/read/yuque/34.md
### Mysql线程的基本设置
```
mysql> show variables like 'thread%';
+-------------------+---------------------------+
| Variable_name     | Value                     |
+-------------------+---------------------------+
| thread_cache_size | 1536                      |
| thread_handling   | one-thread-per-connection |
| thread_stack      | 524288                    |
+-------------------+---------------------------+
3 rows in set (0.05 sec)
mysql> show global status like 'Thread%';
+-------------------+-------+
| Variable_name     | Value |
+-------------------+-------+
| Threads_cached    | 0     |
| Threads_connected | 1     |
| Threads_created   | 1     |
| Threads_running   | 1     |
+-------------------+-------+
4 rows in set (0.07 sec)
```
## 远程连接
root忘记密码
```sql
--- mysqld模块下增加skip-grant-tables配置,免密登录后执行以下命令：
update user set authentication_string = '' where user ='root';
--- 注释掉skip-grant-tables配置,重新登录，设置新密码：
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root123456';
```
允许外部访问
```sql
use mysql;
update user set host='%' where user ='root';
FLUSH PRIVILEGES;
```
## 测试mermaid
{{< mermaid >}}
sequenceDiagram
    participant Alice
    participant Bob
    Alice->>John: Hello John, how are you?
    loop Healthcheck
        John->John: Fight against hypochondria
    end
    Note right of John: Rational thoughts prevail...
    John-->Alice: Great!
    John->Bob: How about you?
    Bob-->John: Jolly good!
{{< /mermaid >}}