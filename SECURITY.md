# 安全披露说明 / Security Disclosure Policy

本文件用于说明本仓库的性质、负责任披露原则，以及希望与作者就 Donut AI 漏洞披露内容进行联系的方式。

This document explains the nature of this repository, the responsible
disclosure principles it follows, and how to contact the author regarding
the Donut AI vulnerability disclosure.

---

## 仓库性质

本仓库是 Donut AI 漏洞披露的归档（disclosure archive），不是常规的开源软件项目，因此：

- 本仓库不接收针对 Donut 自身产品的新漏洞报告。
  如果你发现了 Donut Browser、D0 或 Donut 其他产品的安全问题，请直接通过 Donut 官方渠道进行报告。
- 本仓库不维护正在生产的代码服务，因此没有传统意义上需要"被攻击者绕过"的运行时。
- 本仓库公开的所有内容均为脱敏后的事实证据、文字记录、攻击链描述和用户风险建议。
- 本仓库不发布、不分发可直接复用的攻击脚本、生产凭据、私钥、Session Token 或第三方用户敏感数据。

## 负责任披露原则

本次披露在公开发布前已经过完整的负责任披露流程：

1. 2026-03-11 通过线上会议向 Donut 团队演示资金安全攻击链。
2. 2026-03-11 会后向 Donut 提交脱敏报告、PPT 和 PoC 演示视频。
3. 2026-03-18 书面同步进入负责任披露流程，并明确通知 2026-06-09 计划公开披露。
4. 2026-03-21 提交 9 个 CVE 申请。
5. 2026-05 独立完成 D0 阶段研究。
6. 2026-06 初进行最终非破坏性复测，并补充正式披露前状态。
7. 2026-06-10 在多日无明确回复后发出最终通知，将公开披露日由 2026-06-09 延至 2026-06-15。
8. 2026-06-15 公开发布完整披露。

本次披露遵循下列行业实践：

- ISO/IEC 29147:2018 - Vulnerability disclosure
- ISO/IEC 30111:2019 - Vulnerability handling processes
- CERT/CC Coordinated Vulnerability Disclosure Guide
- CERT-EU Coordinated Vulnerability Disclosure Policy

## 内容边界

本仓库公开的全部材料属于：

- 脱敏后的事实证据（screenshot 描述、字段层结构）
- 攻击链文字描述（不含可直接复用的请求体、Token、私钥）
- 漏洞编号映射（DB-1 ~ DB-35、D0-1 ~ D0-14）
- CVE 申请草案映射
- 沟通过程时间线
- 对用户的风险提示

本仓库不公开：

- 真实 Session Token、Cookie、JWT
- 真实 Gateway Token / 控制面凭据
- 第三方用户钱包公钥与持仓
- 完整的、可直接 curl 即用的攻击 payload
- 任何能够直接接管真实生产系统的脚本

## 联系方式

如果你属于以下任一类型，欢迎通过下列渠道与作者联系：

1. Donut 官方代表：希望就漏洞处理、修复对接或披露细节进行进一步沟通。
2. 媒体记者：希望就本次披露内容进行报道、采访或事实核对。
3. 安全研究员：希望就攻击链、安全治理观察或后续协作展开讨论。
4. 投资人 / 合规方：希望就 AI + Crypto 产品安全治理观察展开讨论。

联系方式：

- Email: lucifiel99@gmail.com
- Website: https://www.lucifiel.com/
- About: https://www.lucifiel.com/about/

请在邮件标题中清楚说明来意，例如：

```
[Donut Disclosure] Press Inquiry — <媒体名称>
[Donut Disclosure] Vendor Contact — Donut Labs
[Donut Disclosure] Coordination — <Bug Bounty / Security Team / Other>
```

## 引用与转载

本仓库内容采用 [CC BY-NC-ND 4.0](./LICENSE) 授权。允许在保留作者署名、不用于商业目的、不创建派生作品的前提下进行分享和引用。商业用途、翻译或派生作品请通过上述 Email 取得授权。

---

# Security Disclosure Policy (English Summary)

- This is a disclosure archive, not a software project.
- Please report Donut product vulnerabilities directly to Donut, not to this repository.
- All publicly shared materials are redacted facts, attack-chain descriptions, and user-facing risk advice.
- No directly reusable exploits, credentials, private keys, or third-party user data are published.
- Coordinated disclosure followed ISO/IEC 29147:2018, ISO/IEC 30111:2019, CERT/CC and CERT-EU practices.
- Public disclosure date: 2026-06-15 (originally planned 2026-06-09; extended by a final notice on 2026-06-10).
- For media, vendor coordination, research collaboration, or licensing inquiries, contact: lucifiel99@gmail.com.
