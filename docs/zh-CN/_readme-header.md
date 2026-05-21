<p align="right">
  <a href="./README.md"><strong>中文</strong></a> |
  <a href="./en-US.md">English</a>
</p>

# 一个融资 2200 万美元的加密项目，如何把用户钱包安全押在第三方策略上

**计划发布日期**：2026 年 6 月 9 日  
**作者**：Lucifiel  
**披露类型**：授权测试后的负责任披露窗口期届满公开  
**当前版本**：公开发布修订草案，待 2026 年 6 月初复测后补充最终状态

---

## 快速摘要

本 README 由 `docs/zh-CN/` 下的模块文件拼接生成，因此打开 GitHub 仓库首页即可直接看到完整披露内容，同时每个部分仍然可以单独维护。

- 共整理 **49 个安全漏洞**：Donut Browser 35 个，D0 / OpenClaw 14 个。
- Donut Browser 阶段验证了服务端交易构建与执行链路中的用户隔离缺陷；实际跨用户资金转出由第三方 Turnkey 策略在最后阶段拦截。
- D0 / OpenClaw 阶段验证了从前端环境信息泄露到控制面访问、配置修改、RCE 和容器数据提取的完整链路，验证边界为研究员自有租户 / Pod。
- 所有正式公开材料不会包含 live token、JWT、Cookie、反弹 shell 参数或一键 exploit 脚本。

## 模块索引

> 维护方式：编辑 `docs/zh-CN/` 下的模块文件，然后运行 `./tools/build-readme.ps1` 刷新首页。
