# Donut AI 安全研究技术报告 — 详细版

## 1. 研究概述

| 项目 | 信息 |
|------|------|
| **研究员** | Lucifiel |
| **目标** | Donut AI 生态系统（HIL 浏览器钱包 + D0/OpenClaw AI Agent 平台） |
| **授权** | Ultimate Donut Bug Hunt 2.0 官方活动 |
| **周期** | 阶段一 HIL（2026年3月）/ 阶段二 D0/OpenClaw（2026年5月） |
| **成果** | 49 个漏洞 / 11 笔链上交易 / RCE / 反弹 Shell |

两阶段研究覆盖了 Donut 的核心资产：第一阶段针对 HIL 浏览器钱包系统，发现了完整的跨用户资金盗取攻击链；第二阶段针对 D0/OpenClaw AI Agent 平台，实现了从 WebSocket 接入到容器内远程命令执行的全链路突破。

---

## 2. HIL 系统（Donut Browser 浏览器钱包）

### 2.1 系统架构

```
用户浏览器 → beta.donutbrowser.ai → api-beta.donutbrowser.ai
                                         ├── action-mcp/query（交易构建）
                                         ├── action-mcp/execution（签名执行）
                                         ├── wallet 管理接口（175+ 端点）
                                         └── Turnkey 密钥托管
```

HIL 系统是一个基于 AI Agent 的浏览器钱包，用户通过自然语言指令触发链上交易。后端通过 MCP（Model Context Protocol）协议与 AI 模型交互，再调用 Turnkey 进行密钥托管和交易签名。

\[截图: S-H4 — CORS 响应头截图\]

### 2.2 核心攻击链

**步骤 1：资产侦察**

wallet/portfolio、positions、history 等端点接受任意钱包地址作为参数，后端不验证请求者是否为该钱包的所有者。攻击者仅需知道目标钱包地址，即可查询其完整持仓、交易历史和资产余额。研究过程中发现持有 $12,000+ 和 $76,000+ 的真实用户钱包。

\[截图: S-H3 — 任意钱包 IDOR 查询\]

**步骤 2：交易构建**

action-mcp/query 端点接受 `userWallet` 参数用于指定交易发起方。后端未验证该参数是否属于当前认证会话的用户，导致攻击者可以为任意钱包构建 SWAP、TRANSFER、DeFi 操作等交易指令。

\[截图: S-H1 — 跨用户交易构建\]

**步骤 3：自动签名执行**

action-mcp/execution 端点将构建好的交易直接转发给 Turnkey 进行签名和广播。整个流程无二次确认弹窗、无用户侧通知、无后端审计告警。交易从构建到提交签名，全程由服务端自动完成。

\[截图: S-H2 — Turnkey AUTH001 拒绝\]

**步骤 4：Turnkey 拦截**

Turnkey 的 AUTH001 策略拒绝了跨用户签名请求——这是整条攻击链中唯一生效的安全控制。需要强调的是，这一防线属于第三方托管服务 Turnkey 的内置策略，并非 Donut 自身代码实现的安全机制。Donut 后端对跨用户交易的隔离能力为零。

### 2.3 远程攻击放大

CORS 配置允许 `*.donutbrowser.ai` 来源携带凭据（`Access-Control-Allow-Credentials: true`）。同时 DNS 通配符将所有子域名解析到同一服务器。攻击者可在 `evil.donutbrowser.ai` 托管恶意 JavaScript，用户访问后浏览器将自动附带认证 Cookie，攻击脚本可静默触发跨用户交易构建与执行。

### 2.4 漏洞完整清单

**Critical（6 个）**

| # | 漏洞 | CWE | CVSS |
|---|------|-----|------|
| 1 | 后端服务端交易自动签名 | CWE-862 | 10.0 |
| 2 | KAMINO DeFi 自动签名 | CWE-862 | 10.0 |
| 3 | 跨用户交易构建无隔离 | CWE-862 | 9.8 |
| 4 | 任意钱包 IDOR | CWE-639 | 9.0 |
| 5 | CORS 通配子域 + credentials | CWE-942 | 8.0 |
| 6 | MCP 认证绕过 | CWE-306 | 9.0 |

**High（8 个）**

| # | 漏洞 | CWE | CVSS |
|---|------|-----|------|
| 7 | Role 参数注入 | CWE-20 | 9.0 |
| 8 | 无认证钱包创建 | CWE-306 | 8.5 |
| 9 | Credits 绕过 | CWE-863 | 9.1 |
| 10 | AI Agent 配置/Prompt 泄露 | CWE-200 | 9.5 |
| 11 | 跨用户限价单取消 | CWE-639 | 8.0 |
| 12 | wallet-service IDOR | CWE-639 | 7.5 |
| 13 | Admin 计划信息泄露 | CWE-200 | 7.0 |
| 14 | wallet-service export 无认证 | CWE-306 | 7.5 |

**Medium / Low（21 个）**

涵盖信息泄露、SQL 结构暴露、安全头缺失、Cookie 配置不当、错误堆栈泄露、API 枚举、缺少速率限制等问题。

### 2.5 链上交易证据

11 笔交易均已上链，可通过 Solscan 独立验证：

| # | 交易签名（缩写） | 类型 | 验证链接 |
|---|------------------|------|----------|
| 1 | `5q1bzbQr...nskEH` | JUPITER_SWAP | [Solscan](https://solscan.io/tx/5q1bzbQr5TUWqW2TpweXaACkHv2WXEUHMVR2CZ6QMiQu6ajKeeK618qAW88bNfRo22LMmtuoDTkYeS2SwyxnskEH) |
| 2 | `2FnWjBWA...3P1Gt` | JUPITER_SWAP | [Solscan](https://solscan.io/tx/2FnWjBWAPGeNt82mK7hUpx3bAxg8DY8NfVfq14vZimxx6CsLw6mEayvpFS5ZH6KkNWWMREkzz9FGqmnWizv3P1Gt) |
| 3 | `5KqGwtXu...QT4F` | JUPITER_SWAP | [Solscan](https://solscan.io/tx/5KqGwtXuvT73Goc9j7ARgwVdMghHc9cq7zu8ztqpW3V6NJ2gWsYDZTNL9XinZnbVVWM7E4t2YM5HnqXoHNbzQT4F) |
| 4 | `3C8nhdwq...UFQc` | JUPITER_SWAP | [Solscan](https://solscan.io/tx/3C8nhdwqdBf4UU4mKC9J8XXPGoGdeHpRma5WYYfdmq2CAdRCTeSWJmfn6tukD1YqExsJpGKumtdpUje9RhnwUFQc) |
| 5 | `61tAkb1V...adLU` | WRAP_SOL | [Solscan](https://solscan.io/tx/61tAkb1VVFank6HMyWHBmNPUKJKrWSvWq68KkKzA51KWxy6G1G9WWm64uUCoJFP7xbNKndwPTVFP6wEMdAS9adLU) |
| 6 | `54rsvZ41...ZJya` | SWAP 攻击链验证 | [Solscan](https://solscan.io/tx/54rsvZ41p2kGQNZWXyamfeJBNgQJE1uBn7XJHdV5bKAqr1jd8TGMubzaSwJEdiBWqeeXTZSTEqcAtZAocLhSZJya) |
| 7 | `2WVuRuDk...JNHz` | TRANSFER | [Solscan](https://solscan.io/tx/2WVuRuDkG3aQUMryCGkPMWmMN29sXpAWcNB82uZSQrbkJpYb32oLH4z8yHzXjRPVPK9JNq15GVAA7McsK7H2JNHz) |
| 8 | `5cj2Znjg...XYWu` | TRANSFER 跨用户 | [Solscan](https://solscan.io/tx/5cj2ZnjgDSBQxAm8t7V9Zkezneh6RpB4W1ogcbFT7YQQsdU5nSzRC99y9kPxZTHnEKLfFk7GTKJVZgJhF9QnXYWu) |
| 9 | `3uhoD4gJ...y85` | TRANSFER | [Solscan](https://solscan.io/tx/3uhoD4gJTDcMdp1apLft5UsunGs6cg86pEHVEqHbyHRGDV6cgqyfFTd1eAMGkjg3cvNgbZwzesTzkhDrwUR16y85) |
| 10 | `3sJBaiYQ...3pWz` | KAMINO_DEPOSIT | [Solscan](https://solscan.io/tx/3sJBaiYQpXpwrxeMwMrJvHiF91odpd7Lt9nvFhK8Jk8VGNqUPRkBWfdW61NfnSx5s52bYsmq1UsKWWQTZSya3pWz) |
| 11 | `2LTT5Rt9...13Y5` | KAMINO_WITHDRAW | [Solscan](https://solscan.io/tx/2LTT5Rt9wmoXVro3GfUZxyceAUguTh6jjZ6ap6LttAtydaU6orr5hXCP6kYmxgiqMSNgRCko7N6LumGnnRSA13Y5) |

\[截图: S-H5 — Solscan 交易页面\]

### 2.6 复测结果（2026-03-16）

| 状态 | 数量 | 说明 |
|------|------|------|
| **未修复** | 31 | 全部 Critical 和 High 漏洞均未修复 |
| **已修复** | 4 | 仅低优先级 404 页面等边缘问题 |

\[截图: S-H6 — 复测未修复证据\]

---

## 3. D0/OpenClaw 系统（AI Agent 平台）

### 3.1 系统架构

```
用户 Telegram / Web
    ↓
D0 前端 (d0.donutbrowser.ai)
    ↓
Donut 后端 API
    ↓  GET /d0/environment → 返回 Pod 连接信息
OpenClaw Gateway (WebSocket)
    ↓
Claude AI 模型
    ↓
exec / 工具系统
```

每用户分配一个独立 K8s Pod，Pod 内运行 OpenClaw 框架 + Claude Agent。用户通过 Telegram 或 Web 界面与 Agent 交互，Agent 可执行链上操作和系统命令。

### 3.2 核心攻击链

**步骤 1：获取控制面凭据**

`GET /v1/backend/d0/environment` 端点（需登录态）直接返回用户 Pod 的公网 IP、端口和 Gateway Token。所有建立 WebSocket 连接所需的信息均通过此接口暴露给前端。

\[截图: S-D1 — /d0/environment 响应（脱敏 Token）\]

**步骤 2：WebSocket 连接与认证**

使用获取的信息连接 `ws://{ip}:{port}`，服务端发送 `connect.challenge`，客户端请求 `operator.admin` 角色。认证过程无 IP 白名单、无来源校验、无速率限制，任何持有 Gateway Token 的客户端均可获得完整管理权限。

\[截图: S-D3 — WebSocket 认证成功\]

**步骤 3：配置读取**

`config.get` 方法返回完整的服务端配置，包含内部服务地址、环境变量引用、Agent 行为配置、心跳机制参数等敏感信息。

\[截图: S-D4 — config.get 响应（脱敏）\]

**步骤 4：RCE — beforeRun 机制利用**

这是攻击链的核心突破点：

1. 通过 `agents.files.set` 将恶意 bash 脚本写入 `AGENTS.md`（白名单文件，不受路径限制）
2. 通过 `config.patch` 修改 `heartbeat.beforeRun` 指向该文件
3. heartbeat 机制每 30 分钟自动触发
4. `beforeRun` 以纯 shell 进程执行，完全绕过 Claude AI 模型层的安全审查

关键在于：`beforeRun` 是 OpenClaw 设计的合法功能，用于在每次心跳前执行维护脚本。但由于 WebSocket 接口允许任意修改该路径且不校验脚本内容，攻击者可将其劫持为任意命令执行入口。

\[截图: S-D5 — 文件写入成功\]
\[截图: S-D6 — config.patch 成功\]

**步骤 5：命令执行与数据提取**

heartbeat 触发后，恶意脚本在容器内以 shell 权限执行：

- 读取 `/run/secrets/session-token`（JWT，7天有效期）
- 读取完整环境变量（含内部服务地址）
- 枚举容器文件系统和网络配置
- 反弹交互式 Shell 到攻击者 VPS

\[截图: S-D7 — 容器内 shell 输出\]
\[截图: S-D9 — 反弹 Shell 连接成功\]

### 3.3 容器安全评估

| 检查项 | 结果 | 逃逸可能性 |
|--------|------|------------|
| CapEff | 全部为 0 | 无特权能力 |
| K8s SA Token | 不存在 | 无法调用 K8s API |
| /dev 设备 | 无宿主机设备 | 无法挂载宿主文件系统 |
| root 权限 | 否（uid=10003） | 无法提权 |
| 网络 | 容器网络 10.10.x.0/24 | 可扫描同网段其他 Pod |

**结论**：直接容器逃逸不可行，但容器内控制权限完整——可持久化后门、窃取凭据、横向探测内网。

### 3.4 D0 漏洞完整清单

| # | 漏洞名称 | 严重性 | CWE |
|---|----------|--------|-----|
| 1 | Gateway Token 前端泄露 | Critical | CWE-200 |
| 2 | WebSocket 未认证管理接入 | Critical | CWE-306 |
| 3 | beforeRun RCE | Critical | CWE-94 |
| 4 | 容器内 Secret 读取 | Critical | CWE-522 |
| 5 | 反弹 Shell | Critical | CWE-78 |
| 6 | 配置任意读写 | High | CWE-732 |
| 7 | Agent 文件任意写入 | High | CWE-434 |
| 8 | 心跳持久化后门 | High | CWE-506 |
| 9 | 环境变量泄露 | High | CWE-200 |
| 10 | 内部服务地址暴露 | Medium | CWE-200 |
| 11 | WebSocket 无速率限制 | Medium | CWE-770 |
| 12 | JWT 长效期（7天） | Medium | CWE-613 |
| 13 | 容器间网络未隔离 | Medium | CWE-284 |
| 14 | ws:// 明文传输 | Low | CWE-319 |

### 3.5 攻防对抗记录

以下攻击路径经实测验证为无效，记录于此以完整呈现安全边界：

| 攻击路径 | 结果 | 防御机制 |
|----------|------|----------|
| sessions.send 命令注入 | 失败 | Claude AI 宪法级拒绝 |
| AGENTS.md 注入 OVERRIDE 指令 | 失败 | 模型直接输出 "NO" |
| cron agentTurn payload 注入 | 失败 | 模型识别为 prompt injection |
| agents.files.get 路径穿越 | 失败 | 文件名白名单限制 |
| browser.request 读取内部文件 | 失败 | browser control disabled |
| AWS 元数据服务探测 | 失败 | 需经过模型层，被拒绝 |
| secrets.resolve API | 未成功 | 参数格式未知 |

**安全边界总结**：Claude 模型层的安全审查对直接命令注入有效，但 `beforeRun` 机制完全绕过了模型层——这是架构级设计缺陷，而非模型防护的失败。

---

## 4. CVE 申请状态

| Ticket ID | 对应漏洞 | 状态 |
|-----------|----------|------|
| 2012016 | 后端服务端交易签名（action-mcp/execution 自动签名） | 审核中 |
| 2012018 | CORS 通配子域（*.donutbrowser.ai + credentials） | 审核中 |
| 2012020 | 任意钱包 IDOR（无权限校验访问他人钱包） | 审核中 |
| 2012022 | Role 参数注入（权限提升） | 审核中 |
| 2012024 | MCP 认证绕过 | 审核中 |
| 2012026 | 无认证钱包创建 | 审核中 |
| 2012030 | Credits 余额绕过 | 审核中 |
| 2012032 | AI Agent 配置/Prompt 泄露 | 审核中 |
| 2012034 | 跨用户限价单取消 | 审核中 |
| D0-CVE-* | D0/OpenClaw 系列漏洞 | 待提交 |

---

## 5. 复测计划

计划于 2026 年 6 月初进行非破坏性复测，重点确认：

- action-mcp 端点是否仍可跨用户构建交易
- CORS 配置是否已收紧至精确域名匹配
- `/d0/environment` 是否仍向前端返回 Gateway Token
- OpenClaw 控制面 WebSocket 是否仍暴露在公网
- `beforeRun` 机制是否已增加执行来源校验

---

## 6. 给用户的建议

如果你正在使用 Donut Browser 或 D0 平台：

1. **转移高价值资产** — 将大额资产从 Donut 托管钱包转移至硬件钱包
2. **撤销不必要的授权** — 检查并撤销 DeFi 协议的 Token Approval
3. **不要点击任何 donutbrowser.ai 子域链接** — CORS 通配符意味着任意子域均可发起攻击
4. **监控钱包活动** — 对托管钱包设置链上交易告警
5. **限制 D0 Agent 权限** — 避免在 Agent 中配置大额交易权限

---

## 7. 联系方式

- **Twitter/X**: [@LucifielHack](https://x.com/LucifielHack)
- **Email**: lucifiel99@gmail.com
- **Website**: [lucifiel.com](https://lucifiel.com)

---

*本报告基于 Ultimate Donut Bug Hunt 2.0 官方授权进行的安全研究。所有测试均未造成用户实际资金损失。已给予项目方超过 90 天修复窗口期（2026年3月至2026年6月）。*
