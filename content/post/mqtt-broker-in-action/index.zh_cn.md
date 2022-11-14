+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "MQTT Broker in Action"
date = "2022-11-13"
description = "MQTT消息服务器实战"
categories = [
"mqtt"
]
tags = [
"inaction","emqx"
]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## MQTT协议
使用wireshark工具捕获mqtt协议包，主要包括3.0和5.0版本。
## 部署EMQX
> EMQX 是一款大规模可弹性伸缩的云原生分布式物联网 MQTT 消息服务器:joy:。
### 单机版
### 集群版
#### 伪分布式集群
> 修改emqx.conf配置文件，集群节点开放某些端口
```conf
cluster.discovery = static
cluster.static.seeds = emqx@120.92.94.79,emqx@120.92.88.242
rpc.port_discovery = manual
rpc.tcp_server_port = 5369
```
两个集群节点分别执行docker run命令：
```sh
docker run -d --name emqx_cluster -v /usr/local/emqx444/emqx_cluster_remote/docker/dockeremqx/emqx.conf:/opt/emqx/etc/emqx.conf -v /usr/local/emqx444/emqx_cluster_remote/docker/dockeremqx/emqx_auth_mysql.conf:/opt/emqx/etc/plugins/emqx_auth_mysql.conf -v /usr/local/emqx444/emqx_cluster_remote/docker/dockeremqx/loaded_plugins:/opt/emqx/data/loaded_plugins --env EMQX_LOG__TO=both --env EMQX_HOST=120.92.94.79 -p 1883:1883 -p 8081:8081 -p 8083:8083 -p 8084:8084 -p 8883:8883 -p 18083:18083 -p 4370:4370 -p 5370:5370 -p 4369:4369 -p 5369:5369 -p 6369:6369 -p 6370:6370 emqx/emqx:4.4.4
```
#### 分布式集群


## 安全
### 接入安全
> 服务端访问控制
### 客户端SDK安全
> SDK引入了第三方库， 要走中台统一的三方库报备、审查，看看有没有漏洞或其他风险。

## 客户端SDK
### [MQTT Go 客户端库](https://github.com/eclipse/paho.golang)
### [MQTT C++ 客户端库](https://github.com/eclipse/paho.mqtt.cpp)
### MQTT JavaScript 客户端库