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
## 源码剖析
todo tomorrow...