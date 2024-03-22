+++
author = "soli"
keywords = ["MQTT消息服务器在部门服务落地"]
title = "MQTT消息服务器在部门服务落地"
date = "2024-03-22"
description = ""
categories = [
"mqtt"
]
tags = [
"mqtt"
]
series = ["Themes Guide"]
image = "https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/mqtt_cover.webp"
+++
<!--more-->
## MQTT是什么
> MQTT 协议的全称是 Message Queuing Telemetry Transport，翻译为消息队列传输探测。

MQTT是一个轻量的发布订阅模式消息传输协议，专门针对低带宽和不稳定网络环境的物联网应用设计。  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/WechatIMG214.jpg)
### MQTT的特点及应用
#### 特点
- 开放消息协议，简单易实现  
- 发布订阅模式，一对多消息发布  
- 基于TCP/IP网络连接  
- 1字节固定报头，2字节心跳报文，报文结构紧凑  
- 消息QoS支持，可靠传输保证
#### 应用
- 内网服务调用，比如代码构建服务  
- 客户端插件下发  
- 站内信/消息中心  
- 业务开关  
- 支付状态回调（前端接收）  
- 页面方法调用（下发一段js脚本，innerHTML到页面执行）
### MQTT协议数据包
从Wireshark抓包工具中可以看到MQTT协议位于应用层，协议结构简单，分别由固定头、可变头、消息体三部分组成，最多可以有16种报文类型。  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG212.jpg)
#### Fixed Header  
所有MQTT报文类型都包含  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG213.jpg)
#### Variable Header  
不同的报文类型会不同，比如PUBACK报文、CONNECT报文  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG210.jpg)
#### Payload  
不同的报文类型会不同，比如CONNECT报文。
### 消息发布质量(QoS)
订阅者收到MQTT消息的QoS级别，最终取决于发布消息的QoS和主题订阅的QoS(取两者最小)。  
QoS 0：消息至多送达一次 (At most once delivery)  
允许消息少量丢失，最多传输一次  
QoS 1：消息至少送达一次 (At least once delivery)  
确保消息一定到达，可少量重复  
QoS 2：消息只送达一次 (Exactly once delivery)  
避免消息重复或丢失会导致不正确的结果 
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG209.jpg) 
## MQTT在服务端的应用-部门PC前端插件构建任务下发为例
### 背景
前端插件打包需要从git仓库拉取代码，考虑到安全问题，代码构建服务部署在内网金山云主机上。在前端同学提交工单后，运维人员需要手动发起构建任务生成的版本号再配置在对OP后台。  
为了降低人工运维成本，将原本人工处理升级为自动化PC端插件下发，这个过程中需要解决外网服务如何调用内网服务的问题(注：代码构建服务部署在内网，无法被外网服务寻址到)。
### 设计与实现
设计理念：计算机科学领域的任何问题都可以通过增加一个间接的中间层来解决。  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG208.jpg)
#### 核心代码  
订阅端断线自动重连，并自动订阅成功的关键代码

{{< highlight go "linenos=table" >}}
func NewMqtt() {
    serverURL, err := url.Parse("tcp://xxx.xxx.xxx.xxx:1883")
    if err != nil {
        panic(fmt.Errorf("environmental variable %s must be a valid URL (%w)", serverURL, err))
    }
    h := NewHandler(true, "sub.log", true)
    defer h.Close()

    cliCfg := autopaho.ClientConfig{
        BrokerUrls: []*url.URL{serverURL},
        KeepAlive:  30,
        OnConnectionUp: func(cm *autopaho.ConnectionManager, connAck *paho.Connack) {
            fmt.Println("mqtt connection up")
            if _, err := cm.Subscribe(context.Background(), &paho.Subscribe{
                Subscriptions: map[string]paho.SubscribeOptions{
                    "testtopic": {QoS: byte(1)}, // 订阅testtopic主题
                },
            }); err != nil {
                fmt.Printf("failed to subscribe (%s). This is likely to mean no messages will be received.", err)
                return
            }
            fmt.Println("mqtt subscription made")
        },
        OnConnectError: func(err error) { fmt.Printf("error whilst attempting connection: %s\n", err) },
        ClientConfig: paho.ClientConfig{
            ClientID: "deploy.docer.wps.cn", // 客户端标识
            Router: paho.NewSingleHandlerRouter(func(m *paho.Publish) {
                h.handle(m) // 业务逻辑处理
            }),
            OnClientError: func(err error) { fmt.Printf("server requested disconnect: %s\n", err) },
            OnServerDisconnect: func(d *paho.Disconnect) {
                if d.Properties != nil {
                    fmt.Printf("server requested disconnect: %s\n", d.Properties.ReasonString)
                } else {
                    fmt.Printf("server requested disconnect; reason code: %d\n", d.ReasonCode)
                }
            },
        },
    }
    cliCfg.SetConnectPacketConfigurator(func(c *paho.Connect) *paho.Connect {
        c.CleanStart = false // 开启持久会话
        return c
    })
    cliCfg.SetUsernamePassword(config.Config.Mqtt.Username, []byte(config.Config.Mqtt.Password)) // 用户名/密码认证
    cliCfg.Debug = logger{prefix: "autoPaho"}
    cliCfg.PahoDebug = logger{prefix: "paho"}
    //
    // Connect to the broker
    //
    ctx, cancel := context.WithCancel(context.Background())
    defer cancel()
    cm, err := autopaho.NewConnection(ctx, cliCfg)
    if err != nil {
        panic(err)
    }
    sig := make(chan os.Signal, 1)
    signal.Notify(sig, os.Interrupt)
    signal.Notify(sig, syscall.SIGTERM)

    <-sig
    fmt.Println("signal caught - exiting")
    ctx, cancel = context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()
    _ = cm.Disconnect(ctx)

    fmt.Println("shutdown complete")
}
{{< / highlight >}}

#### 问题
• Broker暴露在公网，如何做好访问控制？  
• 发布/订阅模式下，如何保证消息下发成功率？  
• Broker用在通用化场景，如何保证高可用？
### 开源 MQTT Broker 对比
| 竞品 | 开发语言 | Star数 | 优点 | 缺点 |
| --- | --- | --- | --- | --- |
| EMQX | erlang | 10.4k | 功能全面，文档齐全，社区活跃，完善的运维配套 | erlang语言，对于其他语言的开发者自己扩展有一定难度。开源版本不支持消息持久化 |
| Mosquitto | c | 6.6k |足够轻量，可以运行在任何低功率单片机上 | c实现，对于其他语言的开发者很难扩展 |  

目前最好选择是[EMQX](https://www.emqx.io/docs/zh/v5.0/)
### 消息下发成功率
- 服务发布质量：Broker提供3种QoS，通常选择QoS 1报文(至少送达一次)来兼顾吞吐量和发布质量。  
- 订阅端断线重连：选择合适的客户端SDK并配置对应参数，使用CleanSession=false来开启持久化订阅模式。  
- 性能测试：经过压测发现，未确认的QoS 1报文数量超过max_mqueue_len参数会丢失消息。  
- 消息状态码：客户端SDK需要支持MQTT 5.0协议，这样每次connect/pub/sub操作才能得到正确的状态码。  
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG206.jpg)
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG207.jpg)
### MQTT Broker高可用
- 负载均衡：使用HAProxy作为整个集群的接入点，反向代理MQTT Broker。
- 粘性会话：在重新连接时将客户端路由到之前服务器，以粘性方式分派连接。
- 监控告警：Broker内置监控与告警功能，支持CPU、内存等资源状态进行告警，管理后台可查询。

![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG205.jpg)
### 访问控制
#### 实现原理
EMQX本身的设计是插件化架构，启用emqx_auth_mysql.conf插件，根据该配置文件中的模板化SQL查询语句即可实现灵活的访问控制。
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/QQ%E6%88%AA%E5%9B%BE/WechatIMG204.jpg)
#### 认证
用户名/密码认证防止非法客户端连接。
![认证](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/WechatIMG203.jpg)
#### 授权
对 MQTT 客户端的发布和订阅操作进行权限控制。控制哪些客户端可以发布或者订阅哪些MQTT主题。  
![授权](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/WechatIMG202.jpg)

## 常见问题
### 消息持久化
MQTT消息publish出来没有接受者就会丢失，持久化的能力是指，对所有的消息进行记录，把数据持久化下来。emqx是broker不是消息队列，持久化属于拓展的能力。emqx开源版不支持服务器内部消息持久化，这是一个架构设计选择。而且emqx 解决的核心问题是处理海量的并发 MQTT 连接与路由消息，在概念上更像是网络路由器，保证服务质量是第一要求，宕机的可能非常小。  
解决方法：根据业务场景决定是否需要拓展持久化功能，若需要则选择emqx企业版，通过自带的规则引擎或插件的方式，持久化消息到Redis、MongoDB、MySQL等数据库，以及 RabbitMQ、Kafka 等消息队列。
### 断线重连收不到消息
解决方法：使用 CleanSession=false来开启持久化订阅模式。  
客户端下线后，emqx 会为这个设备保留一个会话（Session），它在被清理前都会一直收消息。除非会话被清理（默认2h）；消息队列满了也会丢弃不再存储（默认1000）；存储方式是内存的，重启会全部丢掉。
### 连接异常断开
- 客户端本身的接收buffer满了，broker收不到心跳包则会认为客户端已不存活，主动断开连接。因此尽量加快客户端的处理速度。
- 不同的客户端使用相同的Client ID连接Broker时，连接会被强制断开。因此需要确保Client ID全局唯一，不能重复。
- 权限不匹配。需要检查acl.conf和emqx_auth_mysql.conf配置文件，以及数据库中是否授予了pub/sub权限。
### Broker重启，订阅端重连订阅成功，收不到消息
![](https://someblogs.oss-cn-shenzhen.aliyuncs.com/thumb/WechatIMG215.jpg)
图中关键日志：[warning] [CM] kicked_an_unknown_session deploy.docer.wps.cn  
从管理后台的集群只有一个节点判断，是集群问题，订阅端虽然重连成功但连接到了未在集群内的节点，订阅端以为订阅成功，但broker感知不到，发布端发送消息而订阅端收不到消息。  
解决方法：Broker重启后，需要确保静态集群保证有全部的两个节点，如果节点缺失，手动执行命令：emqx_ctl cluster join emqx@node2.emqx.io。

## 总结
本文主要是介绍MQTT消息服务器在部门服务落地的实战过程中遇到的一些问题以及解决方案。MQTT消息服务器目前实现了协议接入、集群部署、接入安全等主要功能，能稳定承载百分级客户端连接。部门的很多业务场景都可以接入MQTT消息服务器的发布订阅能力来提效和精准触达用户，能为业务带来一定的价值。
