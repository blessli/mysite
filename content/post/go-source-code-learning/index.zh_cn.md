+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "带着些许问题去源码中找答案"
date = "2022-11-14"
description = ""
categories = ["language"]
tags = ["sourcecode"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img6.png"
+++
<!--more-->
## 问题探索
### 调度器
## 其他
### 编译
编译脚本(all.bash/make.bash)中注释掉，跳过编译test，因为太慢
```sh
mkdir -p ~/mygo/bin
cd ~/mygo/bin
ln -sf /usr/local/projs/go/bin/go mygo
mygo version
mygo run helloworld.go
```