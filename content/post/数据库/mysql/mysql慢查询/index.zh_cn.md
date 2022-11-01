+++
author = "soli"
title = "mysql慢查询"
date = "2022-06-18"
description = "记录慢查询的几个例子"
categories = [
"数据库"
]
tags = [
"mysql"
]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## 字段类型与查询类型不一致导致不走索引
> third_id字段类型是varchar，参数传的却是数字，这种情况下不会走索引，导致慢查<br/>

SQL示例
{{< highlight sql "linenos=table" >}}
SELECT * FROM `meta` WHERE `audit_pass`=1 and `state`=1 and third_id in(1,2,3)
{{< / highlight >}}