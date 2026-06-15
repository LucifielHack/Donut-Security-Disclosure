# 漏洞索引 / Vulnerability Index

[返回主文](../README.md)

本目录用于按单个漏洞维度索引 Donut AI 的 49 个安全问题。

主文 [README.md §漏洞总览](../README.md#vulnerabilities) 已经包含了完整的 49 漏洞列表。本目录提供的是"逐个漏洞、逐条编号"的索引视图，便于以下用途：

- 媒体引用：直接定位到单个漏洞编号。
- 安全研究员：按编号交叉引用攻击链证据。
- CVE 与 CWE 映射：把每个 DB / D0 编号对应到其所属攻击链与证据页。

## 索引结构

| 编号 | 严重性 | 类型 | 攻击链 | 证据页 | CVE 申请 |
|---|---|---|---|---|---|
| [DB-1](#db-1) | Critical | 资金安全 / 授权缺陷 | Browser Chain 01、Chain 02 | [证据](../evidence/evidence.md#db-1) | 2012016 |
| [DB-2](#db-2) | Critical | IDOR / 业务逻辑 | Browser Chain 02 | [证据](../evidence/evidence.md#db-2) | — |
| [DB-3](#db-3) | Critical | 越权访问 / 信息泄露 | Browser Chain 03 | [证据](../evidence/evidence.md#db-3) | 2012020 |
| [DB-4](#db-4) | Critical | Web 配置错误 | Browser Chain 04 | [证据](../evidence/evidence.md#db-4) | 2012018 |
| [DB-5](#db-5) | Critical | 认证绕过 / 工具滥用 | Browser Chain 04 | [证据](../evidence/evidence.md#db-5) | 2012024 |
| [DB-6](#db-6) | High | 输入校验 / 权限提升 | Browser 辅助 | — | 2012022 |
| [DB-7](#db-7) | High | 认证缺失 / 资源滥用 | Browser 辅助 | — | 2012026 |
| [DB-8](#db-8) | High | 业务逻辑 | Browser 辅助 | — | 2012030 |
| [DB-9](#db-9) | High | 信息泄露 / Prompt 注入原料 | Browser 辅助 | — | 2012032 |
| [DB-10](#db-10) | High | 越权访问 | Browser 辅助 | — | 2012034 |
| [DB-11](#db-11) | Critical | 资金安全 | Browser Chain 01 | [证据](../evidence/evidence.md#db-11) | — |
| [DB-12](#db-12) | High | 信息泄露 / 业务逻辑 | Browser 辅助 | — | — |
| [DB-13](#db-13) | High | 信息泄露 | Browser 辅助 | — | — |
| [DB-14](#db-14) | High | 输入校验 | Browser 辅助 | — | — |
| [DB-15](#db-15) | Medium | 认证缺失 / 配额滥用 | Browser 辅助 | — | — |
| [DB-16](#db-16) | Medium | 信息泄露 | Browser 辅助 | — | — |
| [DB-17](#db-17) | Medium | 配置错误 / 滥用防护不足 | Browser 辅助 | — | — |
| [DB-18](#db-18) | Medium | 信息泄露 | Browser 辅助 | — | — |
| [DB-19](#db-19) | Medium | 信息泄露 | Browser 辅助 | — | — |
| [DB-20](#db-20) | Medium | 信息泄露 | Browser Chain 04 | [证据](../evidence/evidence.md#db-20) | — |
| [DB-21](#db-21) | Medium | 信息泄露 | Browser 辅助 | — | — |
| [DB-22](#db-22) | Medium | 认证缺失 | Browser 辅助 | — | — |
| [DB-23](#db-23) | High | 信息泄露 | Browser Chain 03 | [证据](../evidence/evidence.md#db-23) | — |
| [DB-24](#db-24) | Medium | 信息泄露 | Browser 辅助 | — | — |
| [DB-25](#db-25) | High | 攻击面暴露 | Browser 辅助 | — | — |
| [DB-26](#db-26) | High | 越权访问 | Browser Chain 03 | [证据](../evidence/evidence.md#db-26) | — |
| [DB-27](#db-27) | High | 信息泄露 / 权限边界 | Browser 辅助 | — | — |
| [DB-28](#db-28) | Medium | 注入 / 查询污染 | Browser 辅助 | — | — |
| [DB-29](#db-29) | Medium | 认证缺失 / Webhook 暴露 | Browser 辅助 | — | — |
| [DB-30](#db-30) | Medium | 配置错误 | Browser 辅助 | — | — |
| [DB-31](#db-31) | Medium | 信息泄露 | Browser Chain 04 | [证据](../evidence/evidence.md#db-31) | — |
| [DB-32](#db-32) | Low | Web 加固不足 | Browser 辅助 | — | — |
| [DB-33](#db-33) | Low | 会话保护不足 | Browser 辅助 | — | — |
| [DB-34](#db-34) | Low | 信息泄露 | Browser 辅助 | — | — |
| [DB-35](#db-35) | Low | 信息泄露 | Browser 辅助 | — | — |
| [D0-1](#d0-1) | Critical | 凭据泄露 / 权限提升原料 | D0 Chain 01 | [证据](../evidence/evidence.md#d0-1) | — |
| [D0-2](#d0-2) | High | WebSocket 认证边界 | D0 Chain 01 | [证据](../evidence/evidence.md#d0-2) | — |
| [D0-3](#d0-3) | Critical | 权限边界缺陷 | D0 Chain 02 | [证据](../evidence/evidence.md#d0-3) | — |
| [D0-4](#d0-4) | High | 敏感配置泄露 | D0 Chain 02 | [证据](../evidence/evidence.md#d0-4) | — |
| [D0-5](#d0-5) | Critical | 任意文件 / 工作区写入 | D0 Chain 02 | [证据](../evidence/evidence.md#d0-5) | — |
| [D0-6](#d0-6) | Medium | 配置完整性 / 审计缺失 | D0 Chain 02 | [证据](../evidence/evidence.md#d0-6) | — |
| [D0-7](#d0-7) | High | 执行完整性缺陷 | D0 Chain 02 | [证据](../evidence/evidence.md#d0-7) | — |
| [D0-8](#d0-8) | Critical | 远程代码执行 | D0 Chain 02、Chain 03 | [证据](../evidence/evidence.md#d0-8) | — |
| [D0-9](#d0-9) | High | 会话凭据泄露 | D0 Chain 03 | [证据](../evidence/evidence.md#d0-9) | — |
| [D0-10](#d0-10) | High | 敏感信息泄露 | D0 Chain 03 | [证据](../evidence/evidence.md#d0-10) | — |
| [D0-11](#d0-11) | Medium | 架构泄露 / 纵深攻击面 | D0 Chain 03 | [证据](../evidence/evidence.md#d0-11) | — |
| [D0-12](#d0-12) | High | 隔离边界风险 | D0 Chain 03 | [证据](../evidence/evidence.md#d0-12) | — |
| [D0-13](#d0-13) | High | 凭据管理缺陷 | D0 Chain 01 | [证据](../evidence/evidence.md#d0-13) | — |
| [D0-14](#d0-14) | Medium | 会话安全 | D0 Chain 03 | [证据](../evidence/evidence.md#d0-14) | — |

> 表格中的"Browser 辅助"指该问题不是单独的攻击链入口，而是为 Chain 01 ~ Chain 04 提供组合面、降低成本或扩大可达范围的辅助攻击面。

## 等级划分说明

- **Critical（10）**：可能直接导致资金操作、交易执行、控制面接管、远程代码执行或高权限能力失控，影响用户资产或运行环境控制权。
- **High（19）**：可能造成跨用户越权、敏感凭据暴露、订单或策略被影响、关键配置泄露，或作为 Critical 攻击链的重要组成部分。
- **Medium（16）**：会扩大攻击面、泄露系统或业务信息、降低攻击成本，常用于枚举、探测、资源滥用或后续攻击链准备。
- **Low（4）**：主要体现为安全加固不足、浏览器侧防护缺失、调试信息或生产指纹暴露，单独利用影响有限，但会辅助攻击者建模。

---

## 锚点占位说明

各 DB / D0 编号的详细描述、影响、复现思路与脱敏证据，目前由以下两个来源承载：

1. 主文 [README.md §漏洞总览](../README.md#vulnerabilities) 的清单。
2. evidence/ 下分别按攻击链组织的脱敏证据页：
   - [evidence/evidence.md（49 漏洞逐条 · 双语 · 含截图）](../evidence/evidence.md)
   - [evidence/cve.md](../evidence/cve.md)
   - [evidence/communication.md](../evidence/communication.md)

如有需要在公开披露日（2026-06-15）后引用单条漏洞的稳定锚点，请使用 `vulnerabilities/INDEX.md#db-X` 或 `vulnerabilities/INDEX.md#d0-X` 形式，作者会在正式发布版本中保持表格行序与编号稳定。

<a id="db-1"></a>
<a id="db-2"></a>
<a id="db-3"></a>
<a id="db-4"></a>
<a id="db-5"></a>
<a id="db-6"></a>
<a id="db-7"></a>
<a id="db-8"></a>
<a id="db-9"></a>
<a id="db-10"></a>
<a id="db-11"></a>
<a id="db-12"></a>
<a id="db-13"></a>
<a id="db-14"></a>
<a id="db-15"></a>
<a id="db-16"></a>
<a id="db-17"></a>
<a id="db-18"></a>
<a id="db-19"></a>
<a id="db-20"></a>
<a id="db-21"></a>
<a id="db-22"></a>
<a id="db-23"></a>
<a id="db-24"></a>
<a id="db-25"></a>
<a id="db-26"></a>
<a id="db-27"></a>
<a id="db-28"></a>
<a id="db-29"></a>
<a id="db-30"></a>
<a id="db-31"></a>
<a id="db-32"></a>
<a id="db-33"></a>
<a id="db-34"></a>
<a id="db-35"></a>
<a id="d0-8"></a>
<a id="d0-1"></a>
<a id="d0-4"></a>
<a id="d0-3"></a>
<a id="d0-9"></a>
<a id="d0-10"></a>
<a id="d0-11"></a>
<a id="d0-2"></a>
<a id="d0-13"></a>
<a id="d0-5"></a>
<a id="d0-6"></a>
<a id="d0-12"></a>
<a id="d0-7"></a>
<a id="d0-14"></a>
