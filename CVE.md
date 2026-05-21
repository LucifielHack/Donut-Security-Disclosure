# CVE Ticket Mapping

Submitted on: **2026-03-21**  
Current status: under review (no CVE IDs assigned as of 2026-05-21)

## Donut Browser (HIL) — 9 Tickets

| Ticket ID | Issue | CWE | CVSS |
|---|---|---|---|
| 2012016 | Server-side transaction signing without user authorization | CWE-862 | 10.0 |
| 2012018 | CORS wildcard subdomain + credentials enabling remote attack chain | CWE-942 | 8.0 |
| 2012020 | Insecure direct object reference — any wallet full asset exposure | CWE-639 | 9.0 |
| 2012022 | Role parameter injection in AI chat interface | CWE-20 | 9.0 |
| 2012024 | MCP server authentication bypass | CWE-306 | 9.0 |
| 2012026 | Unauthenticated wallet creation across 13 blockchain networks | CWE-306 | 8.5 |
| 2012030 | Credits bypass via PATCH method | CWE-863 | 9.1 |
| 2012032 | AI Agent system prompt and configuration disclosure | CWE-200 | 9.5 |
| 2012034 | Cross-user limit order cancellation without ownership verification | CWE-639 | 8.0 |

## D0 / OpenClaw — Pending Submission

The following D0-phase vulnerabilities are candidates for CVE submission before the June 9 disclosure:

| Issue | CWE | CVSS | Decision |
|---|---|---|---|
| OpenClaw RCE via beforeRun configuration | CWE-94 | 9.8 | Recommended |
| Environment API credential disclosure | CWE-200 | 9.5 | Recommended |
| Unrestricted operator.admin authorization | CWE-269 | 9.2 | Recommended |
| Arbitrary file write via agents.files.set | CWE-434 | 9.0 | Recommended |

## Notes

- All 9 HIL tickets received MITRE confirmation emails on 2026-03-21.
- No CVE IDs have been assigned after 2 months — follow-up is planned.
- D0 CVE submissions will be finalized before the June 9 public disclosure.
