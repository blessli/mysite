+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "mysql source code learning"
date = "2022-11-14"
description = ""
categories = ["database"]
tags = ["mysql","sourcecode"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## mysql8.0.24源码编译安装
主要是参考[这篇文章](https://www.cnblogs.com/jhno1/p/15324343.html#autoid-0-8-0)，操作过程中根据报错进行fix
### 编译遇到的问题
1. OpenSSL 版本不兼容<br>
不兼容1.1版本，需要openssl1.0.2，通过yum install openssl-devel。<br>
2. 磁盘空间不足<br>
fatal error: error writing to /tmp/ccFtecZv.s: No space left on device<br>
60g磁盘满了，导致make 终止，/data目录删掉即可。<br>
3. 内存不足<br>
```sh
g++: internal compiler error: Killed (program cc1plus)。
[ 88%] Building CXX object sql/CMakeFiles/sql_gis.dir/gis/transform.cc.o
[ 88%] Building CXX object sql/CMakeFiles/sql_gis.dir/gis/union.cc.o
g++: internal compiler error: Killed (program cc1plus)
Please submit a full bug report
```
1. 缺少依赖组件
yum install ncurses-devel cmake libaio bison zlib-devel openssl openssl-devel patch
### 启动遇到的问题
#### 磁盘空间不足
> 注意my.cnf配置文件，特别innodb参数配置，可能因系统内存或磁盘容量导致启动失败

查看系统磁盘: df -h<br>
[InnoDB] Error number 28 means 'No space left on device'
## vscode本地调试mysql8.0.24
```json
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
```
![static/mysql-debug-capture](static/mysql-debug-capture.jpg)
## 源码剖析
todo tomorrow...