<p align="right">
  <a href="../../README.md">返回目录</a> |
  <a href="../../en-US.md">English</a>
</p>

## 法律依据

本节不是法律意见，而是说明本次公开披露所依据的事实基础和安全行业通行流程。

本次披露符合负责任披露 / 协调披露的基本逻辑：研究员在发现高风险问题后，先通过线上会议和书面材料向项目方说明漏洞性质、影响范围和修复窗口；项目方在合理时间内拥有知情、评估、修复和沟通机会；窗口期届满后，研究员可以在不公开可直接滥用细节的前提下，向用户和公众披露风险。

本次披露的事实基础包括：

1. Donut Browser 阶段测试发生在 Donut 官方 Bug Hunt 活动及后续线上沟通框架内。
2. 2026 年 3 月 11 日，我已通过线上会议向 Donut 演示并说明核心风险。
3. 会后我向 Donut 提交了脱敏报告、PPT 和 PoC 演示材料。
4. 2026 年 3 月 18 日，我以书面方式明确通知计划于 2026 年 6 月 9 日公开披露。
5. 测试过程中未转移第三方用户资金，D0 / OpenClaw 的命令执行验证限定在研究员自有租户 / Pod 内。
6. 正式公开版本会删除可直接复用的 live token、JWT、Cookie、私钥、反弹 Shell 参数和一键化 exploit。

可参考的行业流程包括：

- [ISO/IEC 29147:2018 - Vulnerability disclosure](https://www.iso.org/standard/72311.html)：描述漏洞披露中供应商接收报告、披露信息和降低用户风险的要求与建议。
- [ISO/IEC 30111:2019 - Vulnerability handling processes](https://www.iso.org/standard/69725.html)：描述漏洞处理流程。
- [CERT/CC Coordinated Vulnerability Disclosure Guide](https://certcc.github.io/CERT-Guide-to-CVD/)：协调漏洞披露的实践指南。
- [CERT-EU Coordinated Vulnerability Disclosure Policy](https://www.cert.europa.eu/coordinated-vulnerability-disclosure-policy)：公开披露窗口和协调披露实践参考。

基于上述事实，本文的公开目的在于告知用户风险、记录安全研究过程、推动项目方和行业重视 AI + Crypto 产品的系统性安全边界。
