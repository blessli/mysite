+++
author = "soli"
title = "专题2：性能压测"
date = "2022-12-26"
description = "talk about benchmark systematically"
categories = ["专题"]
tags = ["压测"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## 背景
1. 稳定性
2. 潜在性能瓶颈
3. 熔断降级演练
4. 容量规划

压测成本<br>
压测目标<br>
压测场景<br>
严格<br>
GC<br>
## business-benchmark-issues
1. 日志浪费cpu
2. 第三方、自建SDK高并发性能问题
3. 压力评估<br>
***单看cpu和内存无法准时评估***，一定要结合load average看是否大于cpu核数，并结合cs指标看是否cpu空闲时间过高导致cpu无法跑满。<br>
压测时长过短，也会导致load average不准

## how to choose benchmark tool

## reference
- [记一次业务压测过程中发现的问题](https://juejin.cn/post/7133851547477213221#heading-10)

