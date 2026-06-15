# 静态资源目录

本目录用于存放公开披露所需的脱敏截图与图示。

## 目录结构

```
assets/
└── images/
    ├── communication/   # 沟通过程相关脱敏截图
    ├── cve/             # CVE 申请相关脱敏截图
    ├── d0/              # D0 漏洞相关脱敏截图
    └── donut-browser/   # Donut Browser 漏洞相关脱敏截图
```

## 命名约定

为便于在 Markdown 中稳定引用，建议使用以下命名约定：

```
<page>-<section>-<index>.<ext>
```

例如：

- `donut-browser-1click-01.png` — Donut Browser §1 的第 1 张截图
- `donut-browser-cross-wallet-03.png` — Donut Browser §2 的第 3 张截图
- `d0-control-plane-02.png` — D0 §1 的第 2 张截图
- `communication-meeting-01.png` — 沟通过程 §1 的第 1 张截图

## 脱敏要求

任何放入本目录的截图，发布前都需满足以下脱敏要求：

1. 钱包公钥、Solana 地址、交易哈希按需打码（保留必要的可识别度即可）。
2. Session Cookie、JWT、Gateway Token、Turnkey 凭据全部打码。
3. 容器 hostname、外部 IP、内部 ELB 域名、内部 ARN 全部打码。
4. 第三方个人信息：群成员真实姓名、头像、邮箱、电话全部打码。
5. 与漏洞处理无关的私人聊天内容不予包含。
6. 截图不应保留可直接复用的攻击 payload。

## 引用方式

在 Markdown 中以相对路径引用：

```markdown
![Donut Browser 1-click 自有钱包交易](../assets/images/donut-browser/donut-browser-1click-01.png)
```

> 注：在 2026-06-09 公开披露日前，本目录可能仅包含占位说明，最终截图随复测一同补充。
