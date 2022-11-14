+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "linux cmd collection"
date = "2022-11-14"
description = ""
categories = ["unknown"]
tags = ["linux"]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
centos版本
```sh
cat /etc/redhat-release
```
## alias
解决重启后alias失效问题：
```sh
vim ~/.bashrc
alias cdcode='cd /usr/local/projs'
source ~/.bashrc
```
## 查看项目代码行数
```sh
yum -y install cloc
cloc src
```
