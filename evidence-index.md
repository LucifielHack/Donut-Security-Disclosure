# Evidence Index

This file tracks public evidence references. Do not add raw secrets, live tokens, unredacted JWTs, cookies, private keys, raw exploit scripts, or third-party personal data.

## HIL System (Donut Browser)

| ID | Screenshot | Description | File | Status |
|---|---|---|---|---|
| S-H1 | Cross-user transaction construction | action-mcp/query request building a transaction from victim wallet — backend accepts without ownership check | `screenshots/hil/hil_query_cross_user.png` | **需要补充** |
| S-H2 | Turnkey AUTH001 rejection | action-mcp/execution forwarded to Turnkey, returns UNAUTHORIZED AUTH001 | `screenshots/hil/hil_execution_auth001.png` | **需要补充** |
| S-H3 | Any-wallet IDOR | Querying another user's wallet balance/portfolio without authorization | `screenshots/hil/hil_wallet_idor.png` | **需要补充** |
| S-H4 | CORS response headers | *.donutbrowser.ai + Access-Control-Allow-Credentials: true | `screenshots/hil/hil_cors_header.png` | **需要补充** |
| S-H5 | Solscan transaction evidence | 2-3 representative transactions on Solscan | `screenshots/hil/hil_solscan_tx.png` | **需要补充** |
| S-H6 | Retest — unpatched | Same vulnerability still exploitable on March 16 | `screenshots/hil/hil_retest_unpatched.png` | **需要补充** |
| S-H7 | MCP tools — no auth | MCP tools/list returning full tool catalog without authentication | `screenshots/hil/hil_mcp_tools_noauth.png` | **需要补充** |
| S-H8 | AI Agent config leak | /aigemix/agents returning full system prompts | `screenshots/hil/hil_agent_config_leak.png` | **需要补充** |

## D0/OpenClaw System

| ID | Screenshot | Description | File | Status |
|---|---|---|---|---|
| S-D1 | /d0/environment API | DevTools Network panel showing IP + port + token (token partially redacted) | `screenshots/d0/d0_environment_api.png` | **需要补充** |
| S-D2 | OpenClaw Control UI | Control panel title bar showing "OpenClaw Control" | `screenshots/d0/d0_openclaw_ui.png` | **需要补充** |
| S-D3 | WebSocket auth success | operator.admin role confirmed after connect challenge | `screenshots/d0/d0_ws_auth_admin.png` | **需要补充** |
| S-D4 | config.get response | Server configuration with sensitive values redacted | `screenshots/d0/d0_config_get.png` | **需要补充** |
| S-D5 | agents.files.set success | Successful file write response | `screenshots/d0/d0_files_set.png` | **需要补充** |
| S-D6 | config.patch success | beforeRun path modification confirmed | `screenshots/d0/d0_config_patch.png` | **需要补充** |
| S-D7 | Container shell | `id && uname -a && hostname` output showing uid=10003, aarch64, AWS kernel | `screenshots/d0/d0_rce_shell.png` | **需要补充** |
| S-D8 | Container processes | `ps aux` showing PID 1 = openclaw-gateway | `screenshots/d0/d0_container_ps.png` | **需要补充** |
| S-D9 | Reverse shell | VPS-side nc output showing interactive bash connection | `screenshots/d0/d0_reverse_shell.png` | **需要补充** |
| S-D10 | Session token file | /run/secrets/session-token content (middle portion redacted) | `screenshots/d0/d0_session_token.png` | **需要补充** |

## Communication Records

| ID | Screenshot | Description | File | Status |
|---|---|---|---|---|
| S-C1 | Bounty inquiry | Ops asking about bounty expectations + researcher's response | `screenshots/comms/chat_bounty_ask.png` | **需要补充** |
| S-C2 | Final bounty response | "Routine community reward... security research principles and threat tendencies" | `screenshots/comms/chat_bounty_final.png` | **需要补充** |
| S-C3 | Disclosure notice | Written notice of June 9 disclosure in group chat | `screenshots/comms/chat_disclosure_notice.png` | **需要补充** |
| S-C4 | Meeting evidence | Meeting invitation or in-progress screenshot | `screenshots/comms/meeting_invite.png` | **需要补充** |

## Other Evidence

| ID | Category | Description | Public Form | Status |
|---|---|---|---|---|
| E-DB-004 | Video | Donut Browser PoC demo video | SHA-256 hash + key frames | pending |
| E-DB-005 | Blockchain | 11 Solana mainnet transactions | Solscan links | ✅ ready |
| E-CVE-001 | CVE | 9 CVE request ticket IDs | ticket ID mapping | ✅ ready |
| E-AI-001 | Side note | D0 AI Agent evaluating the bounty handling | redacted screenshots | optional |

## Optional Enhancement Screenshots

| ID | Screenshot | Description | File | Status |
|---|---|---|---|---|
| S-E1 | D0 AI irony | D0 AI Agent's evaluation of the bounty handling | `screenshots/extra/d0_ai_irony.png` | 可选 |
| S-E2 | Donut funding | Donut website showing $22M funding info | `screenshots/extra/donut_funding.png` | 可选 |
| S-E3 | Bug Hunt announcement | Official Bug Hunt 2.0 rules/announcement | `screenshots/extra/bughunt_announcement.png` | 可选 |
