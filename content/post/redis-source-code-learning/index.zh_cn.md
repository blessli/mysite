+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "redis source code learning"
date = "2022-11-14"
description = ""
categories = ["database"]
tags = ["redis","sourcecode"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## vscode本地调试
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "debug redis",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/src/redis-server",
            "args": ["redis.conf"],
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        }
    ]
}
```
## redis-benchmark压测
```sh
cd /usr/local/projs/redis/src && ./redis-benchmark -h
./redis-benchmark -t set -n 1000000 -r 100000000
47496.91 requests per second
./redis-benchmark -t set -n 1000000 -r 100000000 -P 16
291290.41 requests per second
```
## 查看RDB快照文件
rdb -c memory dump.rdb > dump_rdb.csv<br>
其中：size_in_bytes 内存的大小，由此可以查询内存最高的key