+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "go source code learning"
date = "2022-11-14"
description = "带着些许问题去源码中找答案"
categories = ["golang"]
tags = ["sourcecode"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img6.png"
+++
<!--more-->
## 问题探索
### 调度器
调度器的工作是在适当的时机将合适的协程分配到合适的位置，在调度过程中需要保证公平和效率。
#### 调度时机
根据调度方式的不同，将调度时机分为主动、被动和抢占调度。<br>
##### 主动调度
需要先从当前协程切换到协程g0，取消G与M之间的绑定关系，将G放入全局运行队列，并调用schedule函数开始新一轮的循环。
{{< highlight go "linenos=table" >}}
func goschedImpl(gp *g) {
	status := readgstatus(gp)
	if status&^_Gscan != _Grunning {
		dumpgstatus(gp)
		throw("bad g status")
	}
	casgstatus(gp, _Grunning, _Grunnable)
	// 取消G与M之间的绑定关系
	dropg()
	lock(&sched.lock)
	// 把G放入全局运行队列
	globrunqput(gp)
	unlock(&sched.lock)
	// 进入新一轮调度
	schedule()
}
{{< / highlight >}}
##### 被动调度
和主动调度类似的是，被动调度需要先从当前协程切换到协程g0，更新协程的状态并解绑与M的关系，重新调度。
和主动调度不同的是，被动调度不会将G放入全局运行队列，因为当前G的状态不是_Grunnable而是_Gwaiting，
所以，被动调度需要一个额外的唤醒机制。
{{< highlight go "linenos=table" >}}
func park_m(gp *g) {
	_g_ := getg()
	casgstatus(gp, _Grunning, _Gwaiting)
	dropg()
	if fn := _g_.m.waitunlockf; fn != nil {
		ok := fn(gp, _g_.m.waitlock)
		_g_.m.waitunlockf = nil
		_g_.m.waitlock = nil
		if !ok {
			if trace.enabled {
				traceGoUnpark(gp, 2)
			}
			casgstatus(gp, _Gwaiting, _Grunnable)
			execute(gp, true) // Schedule it back, never returns.
		}
	}
	schedule()
}
{{< / highlight >}}
##### 抢占调度
为了让每个协程都有执行的机会，并且最大化利用CPU资源，Go语言在初始化时会启动一个特殊的线程来执行系统监控任务。
{{< highlight go "linenos=table" >}}
// proc.retake函数
func retake(now int64) uint32 {
	n := 0
	lock(&allpLock)
	// 遍历所有的P
	for i := 0; i < len(allp); i++ {
		_p_ := allp[i]
		if _p_ == nil {
			continue
		}
		pd := &_p_.sysmontick
		s := _p_.status
		sysretake := false
		if s == _Prunning || s == _Psyscall {
			// 如果G运行时间过长则抢占
			t := int64(_p_.schedtick)
			if int64(pd.schedtick) != t {
				pd.schedtick = uint32(t)
				pd.schedwhen = now
			} else if pd.schedwhen+forcePreemptNS <= now {
				// 连续运行超过10ms，设置抢占请求
				preemptone(_p_)
				sysretake = true
			}
		}
		// P处于系统调用之中，检查是否需要抢占
		if s == _Psyscall {
			// 如果已经超过了一个系统监控的tick(20us)，则从系统调用中抢占P
			// ...省略
		}
	}
	unlock(&allpLock)
	return uint32(n)
}
{{< / highlight >}}
#### 调度策略
调度协程的优先级与顺序如下所示:<br>
{{< mermaid >}}
graph LR
    A[runnext] --> B{nil?};
    B -- Yes --> C[p.runq];
    C --> D{head=tail?};
    D -- Yes ----> F[schet.runq];
    F --> G{runqsize=0?};
    G -- Yes --> H[从其他P窃取];
    H --> J{find?};
    J -- Yes ----> K[找到G];
    J -- No ----> L[未找到G,休眠];
    F -- No ----> I[找到G];
    D -- No --> E[找到G];
    B -- No ----> W[找到G];
{{< /mermaid >}}
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