+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "redis工作笔记"
date = "2022-11-14"
description = ""
categories = ["database"]
tags = ["redis"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## 问题探索
### 事件处理
## 其他
### vscode本地调试
{{< highlight json "linenos=table" >}}
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
{{< / highlight >}}
### redis-benchmark压测
{{< highlight sh "linenos=table" >}}
cd /usr/local/projs/redis/src && ./redis-benchmark -h
./redis-benchmark -t set -n 1000000 -r 100000000
47496.91 requests per second
./redis-benchmark -t set -n 1000000 -r 100000000 -P 16
291290.41 requests per second
{{< / highlight >}}
### 查看RDB快照文件
rdb -c memory dump.rdb > dump_rdb.csv<br>
其中：size_in_bytes 内存的大小，由此可以查询内存最高的key
### redis5.0搭建伪分布式集群
[具体配置参考commit](https://github.com/blessli/redis/commit/cae296cf3035b8529250eb72ffb3263f380b3ef6)
```sh
/home/github/redis/src/redis-cli --cluster create --cluster-replicas 1 10.0.12.2:7001 10.0.12.2:7002 10.0.12.2:7003 10.0.12.2:7004 10.0.12.2:7005 10.0.12.2:7006
./src/redis-cli -h 10.0.12.2 -p 7001 -c
cluser nodes
cluser info
```
### 参考资料
- [Redis中文网](https://www.redis.net.cn/)