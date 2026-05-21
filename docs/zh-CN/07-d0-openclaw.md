<p align="right">
  <a href="../../README.md">返回目录</a> |
  <a href="../../en-US.md">English</a>
</p>

## D0 / OpenClaw 系统

D0 是 Donut 生态中的 AI Agent 平台，基于 OpenClaw 运行。每个用户会被分配一个独立运行环境 / Pod，前端通过 WebSocket 与对应 Gateway 通信。

D0 / OpenClaw 系统的核心风险在于：连接控制面所需的关键信息会被前端环境接口返回，包括公网入口、端口和 Gateway Token。攻击者只要拥有自己的正常 D0 登录态，就可以获取自己的控制面连接信息，并进一步调用 OpenClaw 控制面能力。

简化链路如下：

```text
用户登录 D0
  -> 调用环境接口获取 Gateway 连接信息
  -> 连接 OpenClaw WebSocket Gateway
  -> 以高权限角色完成认证
  -> 读取 / 修改配置
  -> 写入文件或修改 beforeRun
  -> 等待 heartbeat 或触发执行路径
  -> 在对应 Pod 内执行命令
  -> 读取 Session Token / ENV / 内部服务地址等信息
```

这条链路的关键问题不是 AI 模型是否“拒绝危险请求”，而是 Agent 运行环境本身存在可被控制面能力影响的执行路径。beforeRun、heartbeat、文件写入和配置修改属于运行时执行机制，不应被前端可获得的普通会话材料轻易触达。

当前验证边界为研究员自有租户 / Pod。研究已证明从控制面连接到命令执行、环境变量读取、Session Token 读取和内部服务地址提取的完整路径存在；未对其他用户 Pod 进行未授权横向攻击。

正式公开版本会删除仍可能直接复用的 Token、JWT、IP、反弹 Shell 参数和一键化脚本，仅保留脱敏后的请求路径、风险解释、截图占位和证据哈希。

图片 12：D0 / OpenClaw 控制面连接材料

（这里放脱敏后的环境接口或控制面连接截图）

图片 13：自有 Pod 内命令执行验证

（这里放脱敏后的 RCE 验证截图）

图片 14：容器环境信息与敏感材料读取验证

（这里放脱敏后的环境变量、Session Token 文件或内部服务地址截图）
