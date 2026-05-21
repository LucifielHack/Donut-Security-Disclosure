# Donut AI Security Research — Technical Report

**Researcher:** Lucifiel  
**Published:** June 9, 2026  
**Contact:** [@LucifielHack](https://twitter.com/LucifielHack) | lucifiel99@gmail.com | [lucifiel.com](https://lucifiel.com)

---

## 1. Research Overview

This report documents authorized security research conducted against Donut Labs infrastructure — a crypto-native AI browser project that raised $22M from BITKRAFT, HackVC, Sky9 Capital, Altos Ventures, and Makers Fund. The research was performed in two distinct phases under the **Ultimate Donut Bug Hunt 2.0** official program.

**Phase 1 — HIL System (March 2026):** Assessment of the Human-in-the-Loop browser wallet infrastructure. Identified 35 vulnerabilities and executed 11 on-chain transactions demonstrating cross-user wallet control on Solana mainnet.

**Phase 2 — D0/OpenClaw System (May 2026):** Assessment of the AI Agent platform. Identified 14 vulnerabilities culminating in Remote Code Execution within production Kubernetes pods and interactive reverse shell access.

**Aggregate Results:**
- 49 vulnerabilities across two production systems
- 11 on-chain transactions proving cross-user asset manipulation
- Remote Code Execution in production containers
- Interactive reverse shell with full data exfiltration
- Session token extraction enabling authenticated API access
- 4 AI Agent system prompts and configurations disclosed

All critical vulnerabilities remained unpatched as of retesting on March 16, 2026. Nine CVE tickets (2012016–2012034) were filed on March 21, 2026.

| Date | Event |
|------|-------|
| March 2026 | Phase 1 complete: HIL system — 35 vulnerabilities, 11 on-chain transactions |
| March 16, 2026 | Retest confirms all critical vulnerabilities remain unpatched |
| March 21, 2026 | 9 CVE tickets filed |
| May 2026 | Phase 2 complete: D0/OpenClaw — 14 vulnerabilities, RCE, reverse shell |
| June 9, 2026 | Public disclosure (90+ days after initial report) |

---

## 2. HIL System (Donut Browser Wallet)

### 2.1 Architecture

The HIL (Human-in-the-Loop) system manages user wallet operations through a Model Context Protocol (MCP) action layer. The architecture positions itself as a trusted intermediary between users and their custodied private keys.

```
User Browser → beta.donutbrowser.ai → api-beta.donutbrowser.ai
                                           ├── action-mcp/query (transaction construction)
                                           ├── action-mcp/execution (signing/execution)
                                           ├── wallet management (175+ endpoints)
                                           └── Turnkey key custody (HSM-backed)
```

Key architectural properties:
- CORS policy permits all `*.donutbrowser.ai` subdomains with credentials
- DNS wildcard resolves any subdomain to the application server
- MCP action layer intermediates between user sessions and Turnkey signing infrastructure
- No per-request ownership validation between authenticated session and target wallet

### 2.2 Attack Chain

The complete cross-user wallet theft chain operates in four steps. In plain terms: any authenticated Donut user could construct and submit a fund transfer from any other user's wallet, with the backend automatically forwarding it for signing — no victim interaction required.

**Step 1: Asset Reconnaissance**

Wallet portfolio, positions, and transaction history endpoints accept arbitrary wallet identifiers without verifying ownership against the authenticated session. During testing, wallets holding $12,000+ and $76,000+ in assets were fully enumerated, including token balances, DeFi positions, and transaction histories.

[Screenshot: S-H3 — Portfolio endpoint returning full asset breakdown for non-owned wallet]

**Step 2: Cross-User Transaction Construction**

The `action-mcp/query` endpoint accepts a user-controlled wallet parameter specifying the source of funds. The backend does not validate that the specified wallet belongs to the currently authenticated user. A TRANSFER operation from the victim's wallet to the researcher's wallet was successfully constructed and returned a valid transaction payload.

[Screenshot: S-H1 — Transaction construction response showing cross-user transfer parameters]

**Step 3: Auto-Signing via MCP Execution**

The `action-mcp/execution` endpoint forwards the constructed transaction to the Turnkey signing infrastructure without performing ownership verification. No user confirmation prompt, no notification to the wallet owner, no secondary authentication factor. The backend acts as a fully trusted proxy — if you can reach the endpoint with a valid session (any session), the transaction proceeds to signing.

[Screenshot: S-H2 — Execution endpoint processing cross-user transaction without authorization check]

**Step 4: Turnkey Policy Interception**

The Turnkey custody provider's AUTH001 policy engine rejected the unauthorized signing request. This was the **only effective security control** in the entire transaction flow — and it belongs to a third-party provider, not to Donut's own code. If the Turnkey policy were misconfigured or relaxed (e.g., for DeFi automation use cases), all user funds would be immediately drainable.

### 2.3 Remote Attack Amplification

Two additional findings transform this from a same-origin vulnerability to a one-click remote attack:

1. **CORS Wildcard with Credentials:** The backend returns `Access-Control-Allow-Origin: *.donutbrowser.ai` with `Access-Control-Allow-Credentials: true`. Any script executing under a matching subdomain can make authenticated cross-origin requests.

2. **DNS Wildcard Resolution:** Any subdomain of `donutbrowser.ai` resolves to the application server, meaning an attacker can host a malicious page at `attacker-controlled.donutbrowser.ai` (via any XSS or subdomain takeover vector).

Combined, these enable a scenario where a victim clicks a single link and the attacker silently performs wallet operations using the victim's authenticated session — with no visible indicators.

### 2.4 Full Vulnerability List (35 Items)

#### Critical (CVSS 9.4–10.0)

| # | Vulnerability | CWE | CVSS |
|---|--------------|-----|------|
| 1 | Backend auto-signs transactions without ownership verification | CWE-862 | 10.0 |
| 2 | Cross-user transaction construction via MCP query (no isolation) | CWE-862 | 9.6 |
| 3 | KAMINO DeFi protocol auto-signing (same mechanism, DeFi context) | CWE-862 | 10.0 |
| 4 | Any-wallet IDOR — full portfolio/balance exposure | CWE-639 | 9.4 |
| 5 | MCP server authentication bypass | CWE-306 | 9.0 |

#### High (CVSS 7.0–9.1)

| # | Vulnerability | CWE | CVSS |
|---|--------------|-----|------|
| 6 | Credits balance bypass via PATCH method | CWE-863 | 9.1 |
| 7 | CORS subdomain wildcard with credentials | CWE-942 | 9.1 |
| 8 | Role parameter injection in AI chat interface | CWE-20 | 9.0 |
| 9 | AI Agent system prompt and configuration disclosure (4 agents) | CWE-200 | 9.5 |
| 10 | Unauthenticated wallet creation across 13 blockchain networks | CWE-306 | 8.5 |
| 11 | Cross-user limit order cancellation without ownership check | CWE-639 | 8.0 |
| 12 | Session fixation | CWE-384 | 7.5 |
| 13 | User enumeration via API responses | CWE-203 | 7.2 |

#### Medium (CVSS 4.0–6.9)

11 additional findings including: API endpoint information disclosure, missing rate limiting on sensitive operations, insecure default configurations, verbose error messages exposing internal state, and log injection vectors.

#### Low (CVSS 1.0–3.9)

12 additional findings including: missing HTTP security headers, cookie configuration weaknesses, and unnecessary information in response bodies.

### 2.5 On-Chain Evidence (11 Transactions)

All transactions were executed on Solana mainnet during authorized testing, demonstrating complete cross-user asset control across multiple operation types:

| # | Transaction (abbreviated) | Type | Solscan |
|---|--------------------------|------|---------|
| 1 | `5q1bzbQr...nskEH` | JUPITER_SWAP | [View](https://solscan.io/tx/5q1bzbQr5TUWqW2TpweXaACkHv2WXEUHMVR2CZ6QMiQu6ajKeeK618qAW88bNfRo22LMmtuoDTkYeS2SwyxnskEH) |
| 2 | `2FnWjBWA...3P1Gt` | JUPITER_SWAP | [View](https://solscan.io/tx/2FnWjBWAPGeNt82mK7hUpx3bAxg8DY8NfVfq14vZimxx6CsLw6mEayvpFS5ZH6KkNWWMREkzz9FGqmnWizv3P1Gt) |
| 3 | `5KqGwtXu...QT4F` | JUPITER_SWAP | [View](https://solscan.io/tx/5KqGwtXuvT73Goc9j7ARgwVdMghHc9cq7zu8ztqpW3V6NJ2gWsYDZTNL9XinZnbVVWM7E4t2YM5HnqXoHNbzQT4F) |
| 4 | `3C8nhdwq...UFQc` | JUPITER_SWAP | [View](https://solscan.io/tx/3C8nhdwqdBf4UU4mKC9J8XXPGoGdeHpRma5WYYfdmq2CAdRCTeSWJmfn6tukD1YqExsJpGKumtdpUje9RhnwUFQc) |
| 5 | `61tAkb1V...adLU` | WRAP_SOL | [View](https://solscan.io/tx/61tAkb1VVFank6HMyWHBmNPUKJKrWSvWq68KkKzA51KWxy6G1G9WWm64uUCoJFP7xbNKndwPTVFP6wEMdAS9adLU) |
| 6 | `54rsvZ41...ZJya` | SWAP (chain validation) | [View](https://solscan.io/tx/54rsvZ41p2kGQNZWXyamfeJBNgQJE1uBn7XJHdV5bKAqr1jd8TGMubzaSwJEdiBWqeeXTZSTEqcAtZAocLhSZJya) |
| 7 | `2WVuRuDk...JNHz` | TRANSFER | [View](https://solscan.io/tx/2WVuRuDkG3aQUMryCGkPMWmMN29sXpAWcNB82uZSQrbkJpYb32oLH4z8yHzXjRPVPK9JNq15GVAA7McsK7H2JNHz) |
| 8 | `5cj2Znjg...XYWu` | TRANSFER (cross-user) | [View](https://solscan.io/tx/5cj2ZnjgDSBQxAm8t7V9Zkezneh6RpB4W1ogcbFT7YQQsdU5nSzRC99y9kPxZTHnEKLfFk7GTKJVZgJhF9QnXYWu) |
| 9 | `3uhoD4gJ...y85` | TRANSFER | [View](https://solscan.io/tx/3uhoD4gJTDcMdp1apLft5UsunGs6cg86pEHVEqHbyHRGDV6cgqyfFTd1eAMGkjg3cvNgbZwzesTzkhDrwUR16y85) |
| 10 | `3sJBaiYQ...3pWz` | KAMINO_DEPOSIT | [View](https://solscan.io/tx/3sJBaiYQpXpwrxeMwMrJvHiF91odpd7Lt9nvFhK8Jk8VGNqUPRkBWfdW61NfnSx5s52bYsmq1UsKWWQTZSya3pWz) |
| 11 | `2LTT5Rt9...13Y5` | KAMINO_WITHDRAW | [View](https://solscan.io/tx/2LTT5Rt9wmoXVro3GfUZxyceAUguTh6jjZ6ap6LttAtydaU6orr5hXCP6kYmxgiqMSNgRCko7N6LumGnnRSA13Y5) |

### 2.6 Retest Results (March 16, 2026)

A non-destructive retest confirmed that all critical vulnerabilities remained fully exploitable. The cross-user transaction construction and auto-signing chain was completely reproducible. Only 4 low-priority endpoints returned 404 (removed or renamed). No authorization checks had been implemented on any MCP action endpoint.

---

## 3. D0/OpenClaw System (AI Agent Platform)

### 3.1 Architecture

D0 is Donut's AI Agent platform built on the OpenClaw framework. Each user is provisioned a dedicated Kubernetes pod running an agent instance powered by Claude (via Amazon Bedrock). Users interact with their agent through a WebSocket-based protocol.

```
User Browser → d0.donutbrowser.ai → GET /d0/environment (returns pod credentials)
                                         ↓
                              WebSocket connection to pod gateway
                                         ↓
                              operator.admin role authentication
                                         ├── agents.files.set (arbitrary file write)
                                         ├── config.patch (modify execution hooks)
                                         └── heartbeat trigger → shell execution → RCE
```

**Critical design flaw:** The `/d0/environment` endpoint returns all information needed to directly connect to a user's pod — IP address, port, and gateway authentication token — in a single frontend API response.

### 3.2 Attack Chain (5 Steps)

**Step 1: Credential Disclosure**

The `/d0/environment` API endpoint, accessible to any authenticated user, returns the pod's direct IP address, gateway port, and bearer token in plaintext. This information is intended for the frontend WebSocket client but is trivially extractable.

[Screenshot: S-D1 — Environment endpoint response showing pod connection credentials]

**Step 2: WebSocket Authentication**

Upon connecting to the gateway WebSocket, the server issues a `connect.challenge` event. The client responds with a `connect` request specifying role as `operator` with scopes including `operator.admin`. The gateway accepts this without IP whitelisting, rate limiting, or scope restriction — any valid token grants full administrative access.

[Screenshot: S-D3 — Successful operator.admin authentication via WebSocket]

**Step 3: Configuration Access**

The `config.get` WebSocket method returns the complete server configuration including agent definitions, heartbeat intervals, `beforeRun` hook paths, concurrency settings, and all registered agent metadata. This provides the attacker with full knowledge of the execution environment.

[Screenshot: S-D4 — Full configuration dump showing heartbeat and agent parameters]

**Step 4: Remote Code Execution via beforeRun**

The OpenClaw framework supports a `beforeRun` hook that executes a shell script before each heartbeat cycle (approximately every 30 minutes). The attack proceeds as:

1. Write a malicious bash script to the agent workspace using `agents.files.set`
2. Modify `heartbeat.beforeRun` to point to the malicious script using `config.patch`
3. Wait for the next heartbeat cycle to trigger execution

The `beforeRun` mechanism executes **pure shell commands** — it completely bypasses the Claude AI layer and its behavioral guardrails. There is no integrity verification on the script, no allowlist for executable paths, and no audit trail for configuration changes.

[Screenshot: S-D5 — Malicious script written via agents.files.set]
[Screenshot: S-D6 — config.patch redirecting beforeRun to attacker-controlled script]

**Step 5: Data Extraction and Reverse Shell**

Upon heartbeat execution, the script exfiltrates sensitive data and establishes an interactive reverse shell:

- **Session token** read from `/run/secrets/session-token` — a JWT granting authenticated access to the Donut Wallet Service and all backend APIs
- **Full environment variables** including internal service URLs, user identifiers, and framework configuration
- **Interactive reverse shell** providing persistent container access

[Screenshot: S-D7 — Session token and environment variables exfiltrated via HTTP callback]
[Screenshot: S-D9 — Interactive reverse shell session established]

### 3.3 Container Security Assessment

Post-exploitation analysis of the container environment:

| Property | Value | Impact |
|----------|-------|--------|
| Linux capabilities | 0x0 (none) | No privilege escalation via capabilities |
| Kubernetes Service Account | Not mounted | No lateral movement to K8s API |
| Root access | Non-root user (node) | Limited filesystem access |
| Host devices | Not accessible | No container escape via devices |
| Network | Pod-to-internet allowed | Data exfiltration possible |

**Assessment:** Container escape to the host or adjacent pods was not feasible given the hardened pod configuration. However, full control within the container was achieved, including access to all secrets, environment variables, and the ability to execute arbitrary code persistently. The stolen session token could potentially be used to access the HIL wallet system's MCP endpoints via the internal load balancer.

### 3.4 D0 Vulnerability List (14 Items)

| # | Vulnerability | Severity | CWE | CVSS |
|---|--------------|----------|-----|------|
| D0-1 | RCE via beforeRun configuration injection | Critical | CWE-94 | 9.8 |
| D0-2 | /d0/environment credential disclosure | Critical | CWE-200 | 9.5 |
| D0-3 | operator.admin unrestricted authorization | Critical | CWE-269 | 9.2 |
| D0-4 | Arbitrary file write via agents.files.set | Critical | CWE-434 | 9.0 |
| D0-5 | Session token exposed in filesystem | High | CWE-522 | 8.8 |
| D0-6 | Full container environment variable disclosure | High | CWE-200 | 8.0 |
| D0-7 | WebSocket missing Origin validation | High | CWE-346 | 7.8 |
| D0-8 | Gateway token static (no rotation) | High | CWE-798 | 7.5 |
| D0-9 | Pod-to-pod network isolation not enforced | High | CWE-284 | 7.8 |
| D0-10 | Missing heartbeat script integrity validation | High | CWE-354 | 8.2 |
| D0-11 | Internal load balancer URL exposure | Medium | CWE-200 | 6.5 |
| D0-12 | config.patch lacks operation audit trail | Medium | CWE-778 | 6.0 |
| D0-13 | JWT validity period excessive (7 days) | Medium | CWE-613 | 5.5 |
| D0-14 | No rate limiting on WebSocket operations | Medium | CWE-770 | 5.0 |

### 3.5 Attack Paths Attempted and Blocked

The following escalation paths were tested and found to be effectively mitigated:

| # | Path | Defense | Assessment |
|---|------|---------|------------|
| 1 | Container escape via capabilities | Capabilities set to 0x0 | Effective |
| 2 | K8s API lateral movement | No service account mounted | Effective |
| 3 | Direct prompt injection to Claude | Model-level behavioral refusal | Partially effective (bypassed via beforeRun) |
| 4 | Host filesystem access | Non-root, no host mounts | Effective |
| 5 | Adjacent pod network access | Pod network policies | Partially effective |
| 6 | Bedrock API key extraction | Keys managed via IAM roles, not environment | Effective |
| 7 | File write outside workspace | OpenClaw file whitelist enforcement | Effective for direct paths (bypassed via config) |

---

## 4. CVE Status

Nine CVE tickets were filed on March 21, 2026 via the MITRE CVE form:

| Ticket | Vulnerability | CWE | CVSS |
|--------|--------------|-----|------|
| 2012016 | Backend server-side transaction auto-signing | CWE-862 | 10.0 |
| 2012018 | CORS wildcard subdomain with credentials | CWE-942 | 8.0 |
| 2012020 | IDOR: arbitrary wallet full asset exposure | CWE-639 | 9.0 |
| 2012022 | Role parameter injection in AI chat interface | CWE-20 | 9.0 |
| 2012024 | MCP server authentication bypass | CWE-306 | 9.0 |
| 2012026 | Unauthenticated wallet creation across 13 networks | CWE-306 | 8.5 |
| 2012030 | Credits balance bypass via PATCH method | CWE-863 | 9.1 |
| 2012032 | AI Agent system prompt and configuration disclosure | CWE-200 | 9.5 |
| 2012034 | Cross-user limit order cancellation without ownership check | CWE-639 | 8.0 |

**Current status:** Under review. Additional CVE filings for D0 system vulnerabilities (RCE, credential disclosure, unrestricted admin authorization) are planned.

---

## 5. Retest Plan

A non-destructive verification retest is planned for early June 2026 to determine whether any remediation has been deployed since the initial testing phases. The retest will focus on:

1. MCP endpoint authorization checks (ownership validation)
2. CORS policy restriction
3. Gateway token rotation and access controls
4. beforeRun integrity validation mechanisms

Results will be appended to this report upon completion.

---

## 6. User Recommendations

If you are a current or former Donut AI user:

1. **Do not store significant funds in Donut-managed wallets.** The application layer has a fundamental absence of user isolation. The only control preventing fund theft is a third-party custody provider's policy engine — not Donut's own code.

2. **Treat D0 agent data as compromised.** Any information shared with the AI agent (messages, files, credentials) exists in a container environment where arbitrary code execution has been demonstrated.

3. **Monitor wallet transactions.** Configure blockchain alerting for any unexpected operations on wallet addresses associated with Donut.

4. **Revoke token approvals.** If you have granted any on-chain token approvals to contracts associated with Donut operations, consider revoking them.

5. **Do not rely on the "Human-in-the-Loop" label.** This research demonstrates that the human was not in the loop — transactions were constructed and submitted for signing without any user confirmation or notification mechanism.

---

## 7. Contact

- **Twitter/X:** [@LucifielHack](https://twitter.com/LucifielHack)
- **Email:** lucifiel99@gmail.com
- **Website:** [lucifiel.com](https://lucifiel.com)

---

## Legal Notice

This research was conducted under explicit authorization via the Ultimate Donut Bug Hunt 2.0 program. All testing was performed within the program's defined scope. On-chain transactions were executed solely to demonstrate impact using minimal amounts — no user funds were permanently displaced or stolen. The researcher reported all findings through proper channels, allowed 90+ days for remediation before disclosure, and filed CVE tickets through standard processes. This disclosure is made in the public interest: over 1,375 active wallets and 160,000 waitlisted users remain exposed to unpatched critical vulnerabilities.

---

*This report has been sanitized for public disclosure. Live tokens, credentials, internal infrastructure URLs, and executable exploit code have been removed. Full technical evidence is retained and available to authorized parties upon request.*
