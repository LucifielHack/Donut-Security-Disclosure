# CVE 申请记录

[返回主文](../README.md) ｜ 相关页：[Donut Browser 证据](./donut-browser.md) ｜ [D0 证据](./d0.md) ｜ [沟通过程](./communication.md)

本页集中整理与 Donut Browser 阶段 9 个 CVE 申请有关的记录。

## 申请概况

- 申请提交日期：2026 年 3 月 21 日
- 申请数量：9 个 CVE 候选编号
- 申请发起方：Lucifiel（独立安全研究员）
- 申请受理平台：MITRE / 相应 CNA
- 状态：处理中。最终编号、CVSS 与 CWE 映射将在 2026 年 6 月 15 日公开披露之前完成统一。

## 1. CVE 申请清单

### 截图 1：CVE ticket 或申请记录列表

> CVE 申请受理平台返回的 ticket 列表截图，包含 9 个 ticket ID 和申请时间戳。截图中保留 ticket ID 和大致状态，受理平台账号信息打码。

## 2. 申请状态与往来说明

### 截图 2：MITRE 或相关平台回复记录

> MITRE / 相关平台对申请的回复截图：包括版本说明、托管服务说明、补充材料请求或后续邮件沟通。具体邮件地址、平台账号、内部工单编号打码。

## 3. 漏洞条目对应关系

下表为草案阶段映射，最终公开版本将以正式获得的 CVE 编号替换 Ticket ID 并补充 CWE / CVSS 信息：

| Ticket ID | 对应漏洞编号 | 漏洞标题 | CWE 候选 | 严重性 |
|---|---|---|---|---|
| 2012016 | DB-1 | 服务端交易自动签名 / 执行链路缺失强授权边界 | CWE-862 / CWE-306 | Critical |
| 2012018 | DB-4 | CORS 子域通配符与 credentials 组合 | CWE-942 | Critical |
| 2012020 | DB-3 | 钱包 / 资产接口 IDOR | CWE-639 | Critical |
| 2012022 | DB-6 | Role 参数注入 | CWE-20 / CWE-915 | High |
| 2012024 | DB-5 | MCP 工具层认证或权限边界不足 | CWE-287 / CWE-285 | Critical |
| 2012026 | DB-7 | 弱认证 / 无认证钱包创建 | CWE-306 | High |
| 2012030 | DB-8 | Credits / 使用次数限制绕过 | CWE-840 | High |
| 2012032 | DB-9 | AI Agent 配置与 Prompt 泄露 | CWE-200 / CWE-552 | High |
| 2012034 | DB-10 | 跨用户限价单取消 | CWE-639 | High |

> 注 1：Ticket ID 为申请阶段编号，正式发布版本会替换为实际 CVE 编号。
>
> 注 2：CWE 候选为研究员推荐项，最终以受理平台审定结果为准。
>
> 注 3：CVSS 数值与向量将随最终编号一起在 2026-06-15 公开披露中给出。

## 与 49 漏洞总览的关系

- 9 个 CVE 申请聚焦 Donut Browser 阶段（DB-1 ~ DB-35），覆盖资金安全、IDOR、CORS、MCP、订阅滥用和配置泄露等核心攻击面。
- 其余 DB 编号大多属于辅助攻击面（信息泄露、调试端点、安全加固缺失），不单独申请 CVE，将作为攻击链的辅助证据出现。
- D0 阶段（D0-1 ~ D0-14）的问题是否单独申请 CVE，将根据 D0 系统在公开披露日的状态另行决定，避免与 OpenClaw 上游问题边界混淆。

## 与主文档的关系

- [README §CVE 申请状态](../README.md#cve)：草案映射的简要版。
- [Donut-AI-Disclosure-Site / Donut-AI-CVE-Evidence.html](../../Donut-AI-Disclosure-Site/Donut-AI-CVE-Evidence.html)：博客版同步页。
