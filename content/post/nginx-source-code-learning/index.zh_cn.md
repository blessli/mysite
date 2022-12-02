+++
author = "soli"
keywords = ["cockymang","mqtt broker","in action","mqttaction"]
title = "nginx工作笔记"
date = "2022-11-22"
description = "带着些许问题去源码中找答案"
categories = ["nginx"]
tags = ["sourcecode"]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/img1.png"
+++
<!--more-->
## Questions
### Q1:master与worker进程通信方式？
即master进程如何通知worker进程停止服务或更换日志文件呢？
对于这样控制进程运行的进程间通信方式，Nginx采用的是信号。见ngx_signal_handler方法。<br>
在ngx_worker_process_cycle方法中，通过检查ngx_exiting、ngx_terminate、ngx_quit、
ngx_reopen这4个标志位来决定后续动作。
### Q2:worker进程的惊群问题？
即如何解决多个worker子进程监听同一端口引起的“惊群”现象的?<br>
加锁：ngx_process_events_and_timers方法中调用了ngx_trylock_accept_mutex方法。<br>
nginx规定了同一时刻只能有唯一一个worker子进程监听Web端口，这样就不会发生“惊
群”了，此时新连接事件只能唤醒唯一正在监听端口的worker子进程。
### Q3:worker进程的均衡问题？
即如何均衡多个worker子进程上处理的连接数?<br>
与“惊群”问题的解决方法一样，只有打开了accept_mutex锁，才能实现worker子进程间的
负载均衡。
### Q4:master进程主要功能？
master进程不需要处理网络事件，它不负责业务的执行，只会通过管理worker等子进程
来实现重启服务、平滑升级、更换日志文件、配置文件实时生效等功能。
## 问题探索
### nginx特点
选择Nginx的核心理由还是它能在支持高并发请求的同时保持高效的服务。<br>
1. 低内存消耗
2. 高可靠性:一个master管理进程、多个worker工作进程的设计方式
3. 高扩展性:高度模块化的设计
4. 更快
### 事件处理
### 开发一个简单的HTTP模块 
todo: 开发ngx_http_mytest_module<br>
[参考例子](https://www.open-open.com/lib/view/open1451446610308.html)

## 其他
### vscode本地调试
{{< highlight json "linenos=table" >}}
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "debug nginx",
            "type": "cppdbg",
            "request": "launch",
            "program": "${workspaceFolder}/objs/nginx",
            "stopAtEntry": false,
            "cwd": "${workspaceFolder}",
            "environment": [],
            "externalConsole": false
        }
    ]
}
{{< / highlight >}}
### mkcert创建自签名SSL证书
{{< highlight sh "linenos=table" >}}
mkcert -install # 将 mkcert 的认证机构安装到服务器上
mkcert -CAROOT # 查看 CA 证书的位置，在PC上安装 rootCA.crt 证书
mkcert www.aaa.com aiPlatform.dev localhost 127.0.0.1 ::1 43.139.87.74 # 生成证书，配置在nginx.conf中
{{< / highlight >}}

### nginx四层转发
源码编译时，执行以下命令手动加载stream模块:<br>
./auto/configure --with-http_ssl_module --prefix=/home/github/nginx --with-stream<br>
然后在nginx.conf添加以下配置内容支持tcp转发，[stream_backend程序](git@github.com:blessli/epoll-cpp-demo.git):
{{< highlight cfg "linenos=table" >}}
stream {
  upstream stream_backend {
      zone tcp_servers 64k;
      hash $remote_addr;
      server 127.0.0.1:18000;
  }

  server {
      listen 8000;
      proxy_pass stream_backend;
  }
}

{{< / highlight >}}