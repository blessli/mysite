+++
author = "soli"
title = "mysql踩坑记录"
date = "2022-06-18"
description = "mysql踩坑记录"
categories = [
"database"
]
tags = [
"mysql"
]
series = ["Themes Guide"]
aliases = ["migrate-from-jekyl"]
image = "img.png"
+++
<!--more-->
## 防SQL注入
> 禁止使用拼接SQL方式

- PreparedStatement
- 正则表达式
- 字符串过滤

## 字段类型与查询类型不一致导致不走索引
> third_id字段类型是varchar，参数传的却是数字，从而导致了慢SQL

错误的SQL
```sql
SELECT * FROM `meta` WHERE `audit_pass`=1 and `state`=1 and third_id in(1,2,3)
```
![](sql优化前.png)

正确的SQL
```sql
SELECT * FROM `meta` WHERE `audit_pass`=1 and `state`=1 and third_id in('1','2','3')
```
![](sql优化后.png)