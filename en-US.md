<p align="right">
  <a href="./README.md">中文</a> |
  <a href="./en-US.md"><strong>English</strong></a>
</p>

# Donut AI Vulnerability Disclosure

> This is the English version; the Chinese [README.md](./README.md) is the authoritative record. **English is not the author's native language, so this version may contain grammatical or semantic inaccuracies — in case of any discrepancy, the Chinese version prevails.** The Telegram and meeting records, and every verbatim quotation drawn from them, are kept in the original Chinese and are **not translated**; only the surrounding explanation is in English.

<p align="center">
  <a href="#tldr">One-minute summary</a> ·
  <a href="./evidence/evidence.md">Evidence (49)</a> ·
  <a href="./vulnerabilities/INDEX.md">Findings overview</a> ·
  <a href="./evidence/meetings.md">Meetings</a> ·
  <a href="./evidence/telegram.md">Telegram</a> ·
  <a href="./evidence/chain.md">On-chain</a> ·
  <a href="./evidence/cve.md">CVE</a> ·
  <a href="https://www.lucifiel.com/donut-disclosure/">Full site (blog)</a>
</p>

## Table of Contents

> 👉 [**One-minute summary**](#tldr)

1. [Background](#summary)
2. [Advice for users](#user-advice)
3. [Disclosure scope & test boundaries](#scope-boundaries)
4. [Project background](#project-background)
5. [Communication process](#communication-process)
6. [Timeline](#timeline)
7. [Donut Browser system](#donut-browser)
8. [D0 system](#d0-system)
9. [Vulnerability overview](#vulnerabilities)
10. [CVE filing status](#cve)
11. [Open questions](#open-questions)
12. [Security-governance observations](#security-governance)
13. [Disclosure basis](#legal-basis)
14. [About the author & cooperation](#author-and-cooperation)

---

<a id="tldr"></a>

## One-minute summary

- **Who**: independent security researcher and founder of 数字循真, Lucifiel, a Donut user and beta tester since 2025-12.
- **Authorization**: within Donut's two official Bug Hunts (1.0 in 2026-02, 2.0 in 2026-03) and the subsequent online-communication framework.
- **Findings**: **49 issues** across the two systems, Donut Browser and D0 (Critical 10 / High 19 / Medium 16 / Low 4). The two core ones:
    - **① Donut Browser auto-signing fund-theft chain**: the backend can auto-sign and broadcast a transaction with no user signature confirmation, and it can be triggered remotely via a lured click (proven with the researcher's own account — 11 on-chain transactions verifiable on Solscan); cross-user transfer requests can be built and let through on the platform side, ultimately blocked by the third-party custodian Turnkey — no third-party funds were actually moved. 🎬 [Redacted PoC video](./assets/poc-demo.mp4) (plays right in GitHub; also see the [embedded version on the blog](https://www.lucifiel.com/donut-disclosure/#poc-demo))
    - **② D0 remote code execution**: RCE obtained inside the researcher's own Pod (proven).
- **Process**: the vendor was informed through three online meetings + a redacted report + slides + a PoC video + written notices, with a 90-day-plus remediation window; the product lead confirmed the disclosure process on the call.
- **Outcome** (as of the 2026-06 retest):
    - **Remediation status**: of the 49 issues, **only 11 are fully fixed**, 9 partially fixed, and 29 still unfixed (including several core Criticals).
    - **How it was handled**: the system-level research (49 vulns / attack chains / RCE) was processed under the vendor's ordinary community-reward track, with no separate assessment or dedicated bounty, and no formal recognition on any public channel (website acknowledgements, security hall of fame, disclosure credits, etc. — only an informal thank-you in the Discord community); the two Bug Hunt events each paid 100 USDC (200 USDC total) — ordinary event prizes the researcher won by competing (the Bug Hunt 2.0 prize was earned with 13 separately submitted vulnerabilities), unrelated to this system-level research; as early as 2026-03-18 the researcher asked in writing that the contest prizes and the system-level research be assessed separately, objecting to folding the latter into the routine community-reward track.
    - **Final response**: after the researcher sent the final notice, the vendor did not continue to engage on the substance, switched to a legal-posture reply, asserted a reservation of the right to pursue liability, **and made several false allegations** (all of which contradict the meeting and written records, rebutted point-by-point below; the original meeting audio and written records have been fully preserved and redaction-archived, and are open to institutional verification).
- **Technical support**: the 数字循真 platform analysis framework (attack-chain modeling and risk assessment).
- **This document**: a fully-redacted, zero-PoC, zero-reusable-weapon responsible-disclosure record.

<a id="poc-video"></a>

### 🎬 1-click silent fund-theft PoC demo (redacted · ~30s)

https://github.com/user-attachments/assets/ccc89bb3-dfba-4aeb-989f-fc51b5a9e06c

> Also see the [embedded version on the blog](https://www.lucifiel.com/donut-disclosure/#poc-demo), or [view it on the file page](./assets/poc-demo.mp4).

---

<a id="summary"></a>

## Background

The author of this document is a security researcher. In June 2025, drawn by Donut's project narrative, the researcher began following the product and joined its official Discord community; in December 2025 the researcher took part in the official product interviews and beta testing. After Donut launched its official security events (Bug Hunt), the researcher moved into systematic security research and took part in two successive Bug Hunts.

Within those two events and the subsequent communication framework, the researcher found 49 security issues across the two systems, Donut Browser and D0, mainly involving wallet-transaction authorization, user isolation, asset-ownership validation, control-plane access, and runtime-environment isolation — covering core risks such as attack chains that can affect user funds (evidenced by 11 on-chain transactions) and remote code execution on the D0 platform. The researcher's ask was public and consistent from the start: as early as the first meeting they clearly expressed wanting to join Donut (verbatim "if possible, I'd quite like to take part on this side", "I really want to get involved", and mentioned having already discussed this with the [COO]); in early Telegram communications they stressed "personally I care more about a long-term cooperation"; and in the third meeting they further made clear they hoped to join the team full-time.

On the bounty question, the researcher consistently said the amount was negotiable and repeatedly asked the vendor to assess and quote a price themselves based on impact and against industry standards; only about three months later, at the third meeting the vendor itself invited, did the researcher give a self-assessed range and explain the basis for it, while again asking the vendor to price by industry standards. Throughout, pricing remained a negotiable suggestion; the researcher never used public disclosure as a threat, and this was not “敲诈”。

The researcher followed a responsible-disclosure process from the start, and explained that process in full at the first meeting: informing the vendor of the risks through an online meeting, a redacted report, slides, a PoC video, and written notices, giving a 90-day-plus remediation window, which the product lead confirmed on the call; and making clear that once the window expired — whether or not the issues were fixed — the redacted research would be disclosed as is standard practice. This disclosure plan was set from the first communication and is an established step of the responsible-disclosure process.

Subsequently, this body of system-level research was processed under the ordinary community-reward track with no separate assessment or dedicated bounty; after the researcher sent the final notice, the vendor did not continue to engage on the substance and switched to a legal-posture reply. As of public release, most of the core vulnerabilities are still unfixed.

The researcher, acting on the established responsible-disclosure plan above, is publishing this fully-redacted, zero-reusable-weapon research record.

---
<a id="user-advice"></a>

## Advice for users

> The advice below is based on objective facts: as of the June 2026 retest, of the 49 issues compiled here only 11 are fully fixed, 9 partially fixed, and 29 still unfixed (including several core Criticals), and as of publication no third-party security audit or remediation-retest report from Donut has been seen. The following are general crypto-asset protection measures applicable to any early-stage product involving custodial wallets, auto-signing, and automated execution — not aimed at any specific party; whether to adopt them is your own call.

If you use Donut Browser, the Donut wallet, D0, or Donut AI Agent features, consider the following first.

1. Avoid keeping large assets in Donut-related wallets long-term — top up as needed and withdraw when done.
2. Periodically review and revoke unnecessary token allowances, contract approvals, and automated-trading authorizations.
3. Continuously monitor on-chain transaction records; if you spot anything abnormal, move assets immediately and keep the transaction hashes, screenshots, and timeline.
4. Do not handle private keys, mnemonics, exchange API keys, internal documents, trade secrets, or non-public personal data inside a D0 / AI-Agent environment.
5. If you have used automated trading, AI-Agent execution, wallet custody, or strategy-execution features, reassess whether that account is still suitable as a primary or high-value wallet.
6. Until Donut publishes a third-party security audit and remediation-retest results, treat it as an early-stage, high-risk experimental product and control your exposure yourself.

---

<a id="scope-boundaries"></a>

## Disclosure scope & test boundaries

This disclosure is compiled from authorized testing, subsequent retests, public communications, and security-research records. To avoid misunderstanding, the scope and test boundaries are as follows.

1. Authorized-test boundary: the Donut Browser phase took place within Donut's official Bug Hunt events and the subsequent online-communication framework. The relevant risks were disclosed to Donut in meetings and written communications.
2. Non-destructive-verification boundary: no third-party user funds were moved during the research, and no third-party user data or service availability was damaged.
3. Fund-verification boundary: on-chain transaction verification was done with the researcher's own test account, to prove that the transaction-build and execution path has a server-side authorization-boundary flaw.
4. Third-party-interception boundary: in the cross-user wallet-ownership-check tests, the researcher used their own account to construct a transaction request for someone else's wallet; the Donut backend / API layer still built, submitted, and advanced the request, and it was ultimately Turnkey that returned AUTH001 and blocked the fund transfer.
5. Tenant & container boundary: command execution and data reads in the D0 phase were confined to the researcher's own tenant / Pod, with no unauthorized lateral attacks against other users' Pods; the specific D0-phase findings were not submitted separately in advance and are included in this public disclosure together with Donut Browser.
6. Sensitive-information boundary: the disclosed content contains only redacted evidence, verification conclusions, and public basis relevant to proving the facts; it does not contain directly reusable access credentials, private keys, or attack scripts.
7. Purpose boundary: this document serves to record security-research facts, user risk, the communication process, and the basis for disclosure; it is not an attack guide, investment advice, or legal opinion.

---

<a id="project-background"></a>

## Project background

Donut is one of the most talked-about AI × Crypto newcomers of the past year, billing itself as “the world’s first agentic crypto browser for traders.” Its developer, Donut Labs (headquartered in New York), closed two rounds totaling **US$22 million** within about **six months** of founding (a US$7M Pre-seed in 2025-05 + a US$15M Seed in 2025-11), with a marquee investor lineup — top firms such as **HongShan (Sequoia China), BITKRAFT, Hack VC, Makers Fund, Sky9 Capital, Matrix Partners, and Altos Ventures**, plus backing from chains like Solana, Sui, and Monad and core teams from Jupiter, Drift, and Manifold Trading. Per Donut’s official funding announcement, the company **drew 160,000+ waitlist users in its first quarter** — extremely high market interest.

On the product side, Donut’s vision is an “AI-native crypto browser”: Donut Browser is the browser + wallet entry point, and D0 is a user-facing AI-Agent platform. **Its core selling point is letting autonomous agents directly take over the wallet, signing, and on-chain fund execution — in the CEO’s (ex-ByteDance) own words, “it can trade for you even while you sleep.”** That also implies a security bar far above an ordinary app. It is precisely on such a well-funded, top-tier-backed project — whose core selling point is “AI managing money automatically” — that this research found 49 security issues across its two systems, Donut Browser and D0 (including the auto-signing fund-theft chain and own-Pod RCE).

---

<a id="communication-process"></a>

## Communication process

This disclosure is not a sudden release, nor a one-sided exposure that skipped the communication process. Donut had clear opportunities to be informed about the nature of the vulnerabilities, the severity of the attack chains, the remediation window, and the disclosure timing.

Before 2026-03-11, the researcher had already told Donut: Critical-level vulnerabilities that may affect user funds had been found, requiring an online discussion with management and the technical lead. Donut then brought in the technical lead and asked the researcher to share a redacted report after the meeting.

In the online meeting on 2026-03-11, the researcher demonstrated the Donut Browser fund-safety attack chain and explained that this is not a single-point parameter bypass but a systemic risk at the level of the transaction path, wallet-ownership validation, and the trust model. The meeting also covered the disclosure handling: a communication-and-remediation window first, then disclosure coordinated according to remediation progress; and the right to disclose independently after the window ends.

After the meeting, the researcher submitted a redacted report, slides, and a PoC video to Donut. On 2026-03-18, the researcher again confirmed the disclosure timeline in writing: based on the 90-day window after the 2026-03-11 meeting, public disclosure was planned for 2026-06-09.

On bounty and follow-up handling: the vendor explicitly said it had a bug-bounty budget, but processed this system-level security research under the ordinary community-reward track. The two Bug Hunt events each paid 100 USDC (200 USDC total, received 2026-02-22 and 2026-03-28) — ordinary event prizes the researcher won by competing, corresponding to community-event-level ordinary vulnerabilities (including the 13 separately submitted in the second round); this system-level research (49 vulns / attack chains / RCE) received no separate or dedicated bounty. Notably, at the second meeting the vendor’s product lead said the researcher’s first report was, in his words, “比花了很多钱找的那个专业团队给的报告，有些角度是比较深的” (see the [second meeting](./evidence/meetings.md#m2-audit)) — even as the vendor itself judged it this way, the research was still handled under the routine community-reward track. As early as 2026-03-18 the researcher asked in writing that the two be assessed separately and objected to folding the system-level research into the routine community-reward track. On salary / full-time roles, the vendor stated clearly in the third meeting that "there isn't a role at that level" — i.e. a clear "cannot offer", which should be viewed separately from the bounty question and not conflated.

In June 2026 the vendor re-engaged and discussed a long-term cooperation and a dedicated bounty; on June 8 the researcher proactively offered to provide a complete vulnerability list for assessment and said that if cooperation moved forward they were willing to coordinate (even postpone) the disclosure pace. After several days with no clear reply, on June 10 the researcher sent a final notice (extending the public disclosure date to June 15, again reserving a communication window). On the same day, the vendor's side did not continue to engage on the substance, switched to an adversarial legal posture, and made five allegations that contradict the meeting and written records. To avoid "selective editing", the vendor's reply is first reproduced in full below (redaction-only, unabridged; original at [Telegram record · 2026-06-10](./evidence/telegram.md#tg-0610)), and then its false allegations are set against the real evidence point by point:

> **Vendor's reply · 2026-06-10 · [Tech Lead] (complete, unabridged, redaction-only — original Chinese preserved verbatim)**
>
> 这件事已经没有继续沟通的必要了。
>
> 从一开始，你的核心诉求就很明确——利用漏洞作为筹码施压，目的无非是获取奖金，并借此争取一个高薪岗位。这个套路太常见了。在上次会议中，我们已经明确表态：与你的合作和漏洞披露之间没有任何绑定关系，你完全可以按照自己的节奏去走披露流程。你在会议记录中也亲口承诺过，仅披露技术细节，不会公开双方的沟通过程。现在看来，这个承诺你打算不认了也 ok
>
> 而且，在我们已经反复强调两者无关的情况下，你仍然开出 10 万美元以上的 完全不合理的奖金报酬外加高薪职位的条件。看穿了敲诈和强买强卖就不要再演戏了。
>
> 最后，有两点需要正式说明：
> 1. 截至目前，我们没有收到任何完整跨用户攻击链路的证明，也没有收到任何 RCE 的证明。
> 2. 你目前的披露流程和施压 索要不合理报酬的行为方式，完全不符合白帽安全研究者的行业规范。
>
> 你可以按照你自己的方式去披露，这是你的权利。但我们在此明确告知：如果在披露过程中出现任何不实陈述、歪曲事实、或对沟通记录进行选择性剪辑的行为，我方法务团队将深究。

Each piece of evidence is clickable: [Three meeting records](./evidence/meetings.md) · [Full Telegram record](./evidence/telegram.md) · [Solana on-chain transaction evidence](./evidence/chain.md) · [full per-finding evidence (49 · with screenshots)](./evidence/evidence.md).

> The vendor's exact words, the allegations, and every quotation drawn from the records in the table below are kept verbatim in the original Chinese; only the surrounding explanation is in English. The records themselves are not translated.

| Vendor's false allegation | Excerpt of real evidence (full audio preserved; institutional verification welcome) |
|---|---|
| ① "你在会议记录中也亲口承诺过，仅披露技术细节，不会公开双方的沟通过程。" | [Second meeting (2026-06-04) audio and transcript](./evidence/meetings.md#m2-disclose): **the researcher never promised "not to disclose the communications".** In the meeting, the vendor ([Tech Lead]) first said "披露这一块跟这个是比较独立的，你可以按照自己的节奏去披露，然后内容的话就一定要保持、保证公平客观，包括沟通过程" — i.e. the vendor explicitly placed the communication process within the scope of what may be disclosed, only requiring it stay fair and objective, not forbidding publication. The researcher responded "只做技术层面的披露，不会掺杂个人情绪化的内容" — i.e. proceeding by the responsible-disclosure process without injecting personal subjective views, not a promise "not to disclose the communications". The vendor then confirmed again "按之前的节奏去披露就 OK 了。" The "promise" this allegation claims contradicts the vendor's own words in the meeting. |
| ② "截至目前，我们没有收到任何完整跨用户攻击链路的证明，也没有收到任何 RCE 的证明。" | **1. Verified, with proof:** ① the own-account 1-click silent fund-theft chain was [demonstrated in full live at the 2026-03-11 meeting](./evidence/meetings.md#poc-demo) (bypassing signing, completing a transaction with no authorization, 🎬 [redacted PoC video](./assets/poc-demo.mp4)), with [11 real on-chain transactions as proof (verifiable on Solscan)](./evidence/chain.md); ② [cross-user cancellation of someone else's limit order was verified successful](./evidence/meetings.md#m2-order) (no interception on the platform side); ③ a shell was obtained inside the researcher's own D0 Pod (own-environment RCE verified, [see D0 evidence](./evidence/evidence.md#d0sec)).<br>**2. Not fully verified (white-hat compliance boundary):** actually transferring someone else's funds cross-user — [only built successfully on the platform side and ultimately blocked by the third-party Turnkey, not actually executed](./evidence/meetings.md#m2-turnkey) (as a compliant white-hat, one cannot cause actual financial harm to another account); [container escape is theoretically feasible but not tested](./evidence/meetings.md#m2-container). All of this was stated honestly in the meetings.<br>**3. The delivery precondition for full reproducible proof (including a complete PoC and complete report) tightened over time**: at the first meeting the precondition was reaching a cooperation intent; only after a long period with no substantive response did it tighten, at the third meeting, to payment of the bug bounty; this precondition was [made clear from the first communication](./evidence/meetings.md#m1-precondition); the researcher also [proactively offered to provide a complete vulnerability list for assessment](./evidence/telegram.md#tg-0608) (see also the [third meeting](./evidence/meetings.md#m3-list)), which the vendor did not request.<br>**Therefore, the reason "complete proof was not provided" is the unmet consideration and the white-hat compliance boundary, not that the vulnerabilities do not exist.** |
| ③ "从一开始，你的核心诉求就很明确——利用漏洞作为筹码施压，目的无非是获取奖金，并借此争取一个高薪岗位。……看穿了敲诈和强买强卖就不要再演戏了。" | At the first meeting, the researcher **first proactively demonstrated the complete attack chain (including a live on-chain PoC), and only afterwards said “如果团队有漏洞赏金方面的计划，我个人希望可以争取到一些奖励”** — delivering the value for free first and only then softly expressing a bounty wish, the opposite in both order and nature of “利用漏洞作为筹码施压”。 From the first submission the researcher openly stated they were looking for career opportunities; the [first meeting](./evidence/meetings.md#m1-bounty) raised both bounty and long-term cooperation, with the ask public and consistent from the start. The researcher explicitly declined to set the price themselves (verbatim "金额这块我不太好定的，这有违安全研究的原则，会有威胁的倾向在里面", see the [Telegram record](./evidence/telegram.md#tg-noprice)), and asked the vendor to assess by impact. The vendor's own technical lead, in Telegram before the second meeting, explicitly said "专项赏金按劳分配是应该的" and that they were "很缺这一块的人才" (see the [Telegram record](./evidence/telegram.md#tg-anlao)); the researcher then gave a negotiable price range by impact and explained the basis — exactly the “按劳分配” the other side endorsed, which contradicts the “敲诈和强买强卖” allegation. Throughout, the researcher kept to responsible disclosure and never disclosed early or used disclosure as a threat. |
| ④ "你仍然开出 10 万美元以上的完全不合理的奖金报酬外加高薪职位的条件。" | The researcher's industry self-assessment for the whole set of 49 vulns + 3–4 attack chains was 500,000–1,000,000 USD (against HackerOne / Web3 peer standards); considering the startup stage, they proactively lowered it sharply to 150,000–200,000 USD and made clear it was "可以沟通商量" (see the [third meeting](./evidence/meetings.md#m3-price)). That number is a starting point for negotiation; the bounty and the full-time salary are two separate matters. To be precise, the researcher did not unilaterally “set conditions”: at the third meeting it was the researcher who first asked the team about their expectation, and the team ([legal / finance / HR lead]) explicitly asked the researcher to name a price first (verbatim “你希望的价格是多少”, see the [third meeting](./evidence/meetings.md#m3-price)) before the researcher gave the negotiable range of US$150k–200k; and “专项赏金按劳分配是应该的” was a principle the vendor’s own tech lead had endorsed (see the [Telegram record](./evidence/telegram.md#tg-anlao)). A negotiating starting point given at the team’s own request, consistent with a principle the other side itself endorsed, is the opposite in nature of imposing unreasonable conditions or “敲诈”. |
| ⑤ "你目前的披露流程和施压索要不合理报酬的行为方式，完全不符合白帽安全研究者的行业规范。" | Responsible disclosure was followed throughout (per ISO/IEC 29147, 30111, CERT/CC): repeated notices by meeting + writing, a 90-day-plus window, two extra reserved communication windows, and published content with zero PoC / zero reusable weapon (see the [timeline](#timeline)). Pursuing a reasonable bounty or career opportunity through responsible disclosure is a legitimate, industry-standard reward mechanism. |

The handling above is one of the security-governance problems this document records.

After communication broke down, the researcher discussed the incident with the AI Agent on Donut's D0 platform. That content cannot substitute for factual evidence, but as a side note it reflects that even at an abstract level, the relationship between a Critical-level fund-attack chain, a private report, a remediation window, and public disclosure should be taken seriously.

Related evidence: [communication-process & vendor-response evidence (summary)](./evidence/communication.md). Full, unedited, redaction-only original records: [three online meeting records](./evidence/meetings.md) · [full Telegram communication record](./evidence/telegram.md).

---

<a id="timeline"></a>

## Timeline

At the first meeting on 2026-03-11 the researcher stated the responsible-disclosure framework in full and the product lead confirmed it on the call ("OK, sure, right right"); the vendor confirmed again at the second meeting on 2026-06-04 that "disclosure is independent and can proceed at your own pace." The framework is: **0–7 days** to settle the remediation and disclosure process; **7–30 days** to assist with remediation; **30–90 days** to coordinate disclosure depending on remediation progress; **after 90 days** the window expires and there is the right to disclose.

| Date | Event |
|---|---|
| 2025-06 | Began following Donut for its project narrative and joined the official Discord community |
| 2025-12 | As a Donut user, took part in the official product interviews and received an interview reward, then joined beta testing |
| 2026-02-02 | Took part in Donut Labs' first Discord Bug Hunt (Bug Hunt 1.0); submitted 8 bugs and a formal security report |
| 2026-02-22 | Bug Hunt 1.0 contest prize of 100 USDC paid out (won with the vulnerabilities submitted for the event) |
| 2026-03-07 | Took part in the second Bug Hunt (Ultimate Donut Bug Hunt 2.0); submitted 13 ordinary vulnerabilities |
| 2026-03-11 | During the second Bug Hunt, found the highest-severity (Critical) vulnerabilities and called the first online meeting: demonstrated the Donut Browser fund-safety attack chain and explained the severity; stated the disclosure framework in full, which the product lead confirmed on the call; after the meeting submitted a redacted report, slides, and a PoC video, and explained the communication window, the remediation-coordination window, and the post-window independent-disclosure arrangement |
| 2026-03-18 | Last day of the first 7-day communication window: formally entered the responsible-disclosure process in writing; the vendor folded the system-level research into the “routine community-reward” track (in its words “是常规社区奖励”), and the researcher objected in writing that same day, asking for a separate assessment of the system-level security incident; based on the 90-day window, clearly notified that public disclosure was planned for 2026-06-09 |
| 2026-03-21 | Submitted 9 CVE filings |
| 2026-03-28 | Bug Hunt 2.0 contest prize of 100 USDC paid out (won with the 13 vulnerabilities submitted for the event; 200 USDC across both events, both unrelated to the system-level research) |
| 2026-04 ~ 05 | Remediation / observation window: the researcher stayed on standby to assist and awaited remediation progress and a clear handling plan; during this period the vendor did not actually engage on remediation |
| 2026-05 | Independently completed the D0-phase research, verifying control-plane credential leakage, config modification, RCE, and the container-data-extraction path |
| 2026-06-02 | Completed the final non-destructive retest (of 49 issues: 11 fully fixed, 9 partially fixed, 29 still unfixed, several core Criticals unfixed); reminded that the set public disclosure date (June 9) was only a week away, reserving a 48-hour communication window |
| 2026-06-03 | After the 2026-03-18 downgrade reply and ~2.5 months with no substantive progress, the vendor (technical lead) reached out only the day after the disclosure-deadline reminder (June 2), proposing a long-term cooperation |
| 2026-06-04 | Second online meeting: technical-detail review and cooperation intent; the vendor confirmed again that "disclosure is independent and can proceed at your own pace" |
| 2026-06-05 | Third online meeting: discussed the cooperation arrangement and the vulnerability bounty with the [Legal / Finance / HR lead]; no clear answer was given |
| 2026-06-08 | Proactively offered to provide a complete vulnerability list for assessment, and said that if cooperation moved forward they were willing to coordinate (even postpone) the disclosure pace |
| 2026-06-10 | After several days with no clear reply, the researcher sent the final notice, extending the public disclosure date to 2026-06-15 (again reserving a communication window) |
| 2026-06-10 | The vendor's side did not continue to engage on the substance, switched to an adversarial legal-posture reply, and made groundless allegations such as "using vulnerabilities to extort", "received no proof of any complete attack chain / RCE", and "promised not to disclose the communications" (all contradicting the meeting and written records) |
| 2026-06-15 | The disclosure window expired; this research is published per the established responsible-disclosure process |

---

<a id="donut-browser"></a>

## Donut Browser system

The core risk of the Donut Browser system is concentrated on the path of "the backend builds and advances a transaction on the user's behalf". The system tries to let the browser, the AI, or backend services help the user complete on-chain transactions, but testing found that the backend has not established sufficiently strict user isolation, wallet-ownership validation, or a second-authorization boundary.

A simplified path:

```text
User browser
  -> Donut Browser front end
  -> Donut backend API
       -> action-mcp/query        build transaction
       -> action-mcp/execution    execute transaction / call signing service
       -> wallet / portfolio      wallet & asset endpoints
       -> Turnkey                 third-party key custody & policy interception
```

The core conclusions are in two parts. First, the 1-click silent transaction chain was verified successful within the researcher's own wallet / own funds, showing that a single visit or click by the user can — with no authorization or signature confirmation — bypass the signing-authorization flow and have the Donut backend auto-sign and broadcast the transaction to move funds out — with no confirmation. Second, the cross-user wallet-ownership-check chain shows that when the researcher used their own account to construct a transaction request for someone else's wallet, the Donut backend still built, submitted, and advanced the request, until Turnkey returned AUTH001 and blocked the fund transfer.

A typical risk scenario:

**Scenario A: the 1-click silent transaction chain (verified with own wallet / own funds)**

1. The attacker lures the user into a single visit or click via a phishing entry, a malicious page, or a credential-bearing browser context.
2. With no authorization or signature confirmation by the user, the browser carries the session to make a request to a Donut transaction endpoint.
3. The Donut backend bypasses the signing-authorization step that should occur and goes on to build and execute the on-chain transaction flow.
4. This path was verified successful within the researcher's own wallet / own funds, proving the 1-click silent transaction chain holds.

**Scenario B: the cross-user wallet-ownership-check chain (AUTH001 interception)**

1. The researcher initiates the test with their own Donut account and session.
2. The request references a wallet not belonging to the current account, constructing a transaction request originating from someone else's wallet.
3. The Donut backend / API layer still builds, submits, and advances the transaction request.
4. The request enters Turnkey's policy-decision stage.
5. Turnkey returns AUTH001, recognizes that the privilege does not match the wallet's owning user, and blocks the final fund transfer.

The severity of the cross-user wallet-ownership-check chain is that Donut itself does not first block, at the API layer, a transaction request for a wallet that does not belong to the current user. For a product that handles user wallets and transactions, the security boundary should be built into Donut's own backend authorization model, not rely on a third-party signing policy to backstop at the last moment.

The research also verified IDOR risks such as arbitrary-wallet asset, holdings, and trade-history queries, as well as combined issues like CORS, the MCP tool layer, quota bypass, and AI-Agent config leakage. These lower the cost of an attack and widen the reachable range of the attack chain.

Related evidence: [Donut Browser per-finding evidence (with screenshots)](./evidence/evidence.md#browser).

---

<a id="d0-system"></a>

## D0 system

D0 is the AI-Agent platform Donut offers externally. Each user is assigned an isolated runtime environment / Pod, and the front end communicates with the corresponding Gateway over WebSocket. During the research, the researcher obtained control-plane access material through a D0 vulnerability and completed verification along the path "front-end environment API -> control-plane connection -> config read / modify -> file write -> beforeRun / heartbeat execution mechanism -> own-Pod RCE -> reading Session Token, environment variables, and internal service addresses." When accessing the corresponding control plane, the page clearly displayed the OpenClaw logo and the docs link pointed to the OpenClaw official documentation; this is used to confirm the origin of the underlying control plane, while the focus of the vulnerability discussion remains the control-plane authorization boundary and Agent-runtime isolation that D0 exposed.

The core risk of the D0 system is that the front-end environment API returns the key information needed to connect to the underlying control plane, including the public entry point, port, and Gateway Token. An attacker only needs their own ordinary D0 login state to obtain the control-plane connection info and proceed into the combined chain of config read, config modify, file write, and execution mechanisms.

A simplified path:

```text
User logs in to D0
  -> calls the environment API to obtain Gateway connection info
  -> connects to the underlying OpenClaw WebSocket Gateway
  -> authenticates as a high-privilege role
  -> reads / modifies config
  -> writes a file or modifies beforeRun
  -> waits for heartbeat or triggers the execution path
  -> executes commands inside the corresponding Pod
  -> reads Session Token / ENV / internal service addresses, etc.
```

The key problem on this path is not whether the AI model "refuses dangerous requests", but that the Agent runtime environment itself has an execution path that can be influenced by control-plane capabilities. beforeRun, heartbeat, file writes, and config modification are runtime execution mechanisms that should not be easily reachable by ordinary session material obtainable from the front end.

The current verification boundary is the researcher's own tenant / Pod. The research has proven that the full path exists, from control-plane connection to command execution, environment-variable reading, Session Token reading, and internal-service-address extraction; no unauthorized lateral attack was carried out against other users' Pods.

Related evidence: [D0 per-finding evidence (with screenshots)](./evidence/evidence.md#d0sec).

---

<a id="vulnerabilities"></a>

## Vulnerability overview

This section lists, per individual vulnerability, the security issues compiled in this disclosure. Each entry keeps its number, name, impact, severity, and evidence status; severity is graded by impact on fund safety, account privileges, control-plane capabilities, runtime-environment control, and attack-chain reachability.

- **Critical**: may directly lead to fund operations, transaction execution, control-plane takeover, remote code execution, or loss of control over high-privilege capabilities, affecting user assets or control over the runtime environment.
- **High**: may cause cross-user privilege escalation, sensitive-credential exposure, impact on orders or strategies, or key-config leakage, or serve as a major component of a Critical attack chain.
- **Medium**: widens the attack surface, leaks system or business information, lowers attack cost; commonly used for enumeration, probing, resource abuse, or preparing a follow-up attack chain.
- **Low**: mainly insufficient hardening, missing browser-side protection, or debug/production-fingerprint exposure; limited impact on its own, but assists an attacker in modeling.

Status legend: **❌ Unfixed** · **⚠️ Partially fixed** · **✅ Fixed** (as of the 2026-06 retest).

### Donut Browser vulnerabilities DB-1 to DB-35

| ID | Name | Severity | Type | Impact & evidence status | Retest status |
|---|---|---|---|---|---|
| DB-1 | User signature-authorization can be forged / transaction silently confirmed on-chain | Critical | Fund safety / authorization flaw | The 1-click silent transaction chain was verified within own wallet / own funds; separately, in cross-user wallet tests the Donut backend can advance a transaction request for a non-current-user wallet, ultimately blocked by Turnkey AUTH001 | ❌ Unfixed |
| DB-2 | Cross-user transaction build not bound to the current session’s wallet ownership | Critical | IDOR / business logic | The build stage does not adequately prove `from_wallet` belongs to the current session user, usable as a fund-attack-chain entry | ⚠️ Partially fixed |
| DB-3 | IDOR on any wallet’s assets, holdings, and trade history | Critical | Broken access control / info leak | Can read a non-current-user wallet's portfolio, cost basis, holdings, and history; a high-value wallet sample was found | ❌ Unfixed |
| DB-4 | CORS subdomain-wildcard combined with credentials | Critical | Web misconfiguration | A malicious or controlled subdomain can carry the login state to call sensitive APIs, amplifying into a remote-trigger path | ⚠️ Partially fixed |
| DB-5 | Insufficient auth and privilege boundary in the MCP tool layer | Critical | Auth bypass / tool abuse | MCP tools can be enumerated or invoked directly, bypassing front-end restrictions and reaching the tool-execution layer | ❌ Unfixed |
| DB-6 | Role-parameter injection | High | Input validation / privilege escalation | Can forge high-privilege message roles like system/assistant, weakening the AI Agent's behavior boundary | ❌ Unfixed |
| DB-7 | Wallet Service wallet creation with no / weak authentication | High | Missing auth / resource abuse | Can create wallets across 13 chains, causing resource consumption, abuse, and compliance risk | ✅ Fixed |
| DB-8 | Credits / usage-limit bypass | High | Business logic | Can bypass AI-Agent usage quota and subscription limits, lowering attack cost and affecting the business model | ❌ Unfixed |
| DB-9 | AI Agent config and system-prompt leakage | High | Info leak / prompt-injection material | Multiple Agents' prompts, tool configs, and invocation rules are exposed, usable for targeted prompt attacks | ⚠️ Partially fixed |
| DB-10 | Cross-user limit-order cancellation | High | Broken access control | Order cancellation lacks wallet-ownership checks, potentially affecting other users' trading strategies and asset operations | ❌ Unfixed |
| DB-11 | DeFi auto-signing transaction path lacks user authorization | Critical | Fund safety | DeFi operations can enter the backend signing path with no user authorization; the execution path was proven via own-account transactions | ⚠️ Partially fixed |
| DB-12 | Admin Plan / subscription-plan info leakage | High | Info leak / business logic | Management-plan, subscription-policy, or taskKey-related info is exposed, usable to bypass or abuse the subscription system | ❌ Unfixed |
| DB-13 | SQL query-structure and schema leakage | High | Info leak | Error responses or API returns expose SQL structure, fields, and business-table info, aiding follow-up attack modeling | ⚠️ Partially fixed |
| DB-14 | Insufficient input validation across endpoints causing 500 errors | High | Input validation | Insufficient handling of abnormal types, object operators, and boundary values exposes internal error-handling flaws | ⚠️ Partially fixed |
| DB-15 | Unauthenticated Solana RPC proxy | Medium | Missing auth / quota abuse | Can abuse Donut's RPC resources for balance, transaction, and on-chain queries, consuming platform quota | ✅ Fixed |
| DB-16 | Private analytics-data leakage | Medium | Info leak | Analytics, risk, or internal statistics can be read unauthorized, usable for user profiling and target selection | ✅ Fixed |
| DB-17 | Missing API rate limiting | Medium | Misconfiguration / weak abuse protection | Sensitive endpoints can be called in bulk, increasing enumeration, credential-stuffing, resource-consumption, and on-chain-probing risk | ⚠️ Partially fixed |
| DB-18 | Public S3 bucket or static-asset directory | Medium | Info leak | A public directory may expose reports, build artifacts, or future-uploaded sensitive files | ✅ Fixed |
| DB-19 | Health / ops-endpoint info leakage | Medium | Info leak | The health-check endpoint exposes version, environment, memory, uptime, task-queue, or cluster status | ⚠️ Partially fixed |
| DB-20 | MCP tool configuration fully public | Medium | Info leak | Tool names, providers, parameter schemas, and capability boundaries can be enumerated, aiding tool-abuse-chain construction | ✅ Fixed |
| DB-21 | OpenAPI / Scalar docs exposure | Medium | Info leak | Production exposes full API docs and an endpoint list, lowering enumeration cost | ✅ Fixed |
| DB-22 | Unauthenticated monitoring-report endpoint | Medium | Missing auth | Internal monitoring or reporting endpoints can be accessed unauthorized, leaking runtime status and business metrics | ✅ Fixed |
| DB-23 | Arbitrary wallet-balance probing | High | Info leak | Any wallet's balance can be probed via error responses, balance endpoints, or transaction-construction side channels | ⚠️ Partially fixed |
| DB-24 | risk-metrics platform-wide data leakage | Medium | Info leak | Platform-level risk metrics or statistics are exposed, usable to identify high-value users and system status | ✅ Fixed |
| DB-25 | beta.donutlabs.dev second-backend exposure | High | Attack-surface exposure | A backup or test backend exposes an independent API surface that may bypass the main site's fixes and access control | ❌ Unfixed |
| DB-26 | wallet-service wallet-detail unauthenticated query | High | Broken access control | Wallet-detail queries lack authentication or binding checks, combinable with asset enumeration and a fund-attack chain | ✅ Fixed |
| DB-27 | Admin taskKey / management-plan path exposure | High | Info leak / privilege boundary | Management-type paths or hidden parameters are exposed, providing an attack entry into subscriptions, plans, and backend logic | ❌ Unfixed |
| DB-28 | ORM operator-injection indicators | Medium | Injection / query pollution | Object operators like `$ne`, `$gt`, `$regex`, `$in` trigger abnormal behavior; impact boundary needs retest confirmation | ❌ Unfixed |
| DB-29 | Helius webhook path still accessible | Medium | Missing auth / webhook exposure | After changing paths the webhook still has an accessible entry, increasing event-forgery or probing risk | ✅ Fixed |
| DB-30 | donutlabs.dev wildcard DNS / subdomain resolution | Medium | Misconfiguration | Arbitrary subdomain resolution widens CORS, phishing, malicious-page-hosting, and same-site trust-boundary risk | ❌ Unfixed |
| DB-31 | Full enumeration of the MCP tool ecosystem | Medium | Info leak | The tool ecosystem, invocation methods, and parameter schemas can be enumerated, lowering the cost of building a follow-up attack chain | ❌ Unfixed |
| DB-32 | Missing HTTP security headers | Low | Insufficient web hardening | Missing necessary security response headers increases clickjacking, content-sniffing, and browser-side attack surface | ❌ Unfixed |
| DB-33 | Insufficient cookie security attributes | Low | Insufficient session protection | Cookies lack attributes like HttpOnly / SameSite, widening session risk under XSS or cross-site scenarios | ❌ Unfixed |
| DB-34 | Front-end sensitive-info exposure | Low | Info leak | localStorage, front-end bundles, or source code expose session, config, internal paths, or debug info | ❌ Unfixed |
| DB-35 | Verbose error messages, debug endpoints, and production-fingerprint exposure | Low | Info leak | Error responses, test endpoints, and debug info expose environment, dependencies, internal paths, or execution context | ✅ Fixed |

### D0 vulnerabilities D0-1 to D0-14

| ID | Name | Severity | Type | Impact & evidence status | Retest status |
|---|---|---|---|---|---|
| D0-1 | Environment API leaks Gateway connection info and Token | Critical | Credential leak / privilege-escalation material | The front end can obtain control-plane connection material, forming a direct path from login state to the control plane | ❌ Unfixed |
| D0-2 | Insufficient WebSocket Origin / source boundary | High | WebSocket auth boundary | The control-plane connection insufficiently constrains source and client context, increasing cross-site or proxy-abuse risk | ❌ Unfixed |
| D0-3 | operator/admin high-privilege capabilities exposed or under-restricted | Critical | Privilege-boundary flaw | After authentication one can obtain overly broad control-plane capabilities, widening config-modification, file-write, and execution risk | ❌ Unfixed |
| D0-4 | WebSocket control-plane config read | High | Sensitive-config leak | Can read Agent, heartbeat, beforeRun, registered-Agent, and runtime config | ❌ Unfixed |
| D0-5 | Overly broad file-write capability (agents.files.set, etc.) | Critical | Arbitrary file/workspace write | Can write files into the Agent workspace and combine with beforeRun / heartbeat into an execution chain | ❌ Unfixed |
| D0-6 | config.patch lacks adequate audit and change protection | Medium | Config integrity / missing audit | Key runtime config can be modified, with no clear audit, rollback, or integrity-protection evidence | ❌ Unfixed |
| D0-7 | Insufficient integrity checking of heartbeat scripts | High | Execution-integrity flaw | The heartbeat pre-script can become a persistent execution point, bypassing the AI model-layer safety review | ❌ Unfixed |
| D0-8 | RCE via OpenClaw beforeRun / control-plane mechanisms | Critical | Remote code execution | Can execute commands inside the own D0 Pod; in-container execution and a data-extraction path were verified | ❌ Unfixed |
| D0-9 | Session Token file readable by in-container processes | High | Session-credential leak | After RCE the session token can be read, forming the condition to access the backend API as the user | ❌ Unfixed |
| D0-10 | Container environment-variable leakage | High | Sensitive-info leak | Environment variables expose the production marker, internal service addresses, and runtime config | ❌ Unfixed |
| D0-11 | Internal ELB / backend-entry exposure | Medium | Architecture leak / lateral attack surface | An internal backend entry appears in the container config, providing a target for further internal probing | ❌ Unfixed |
| D0-12 | Pod-to-Pod network isolation needs further authorized verification | High | Isolation-boundary risk | Own-Pod RCE is verified; the lateral-movement boundary needs further authorized testing to confirm | ❌ Unfixed |
| D0-13 | Insufficient Gateway Token lifecycle and rotation | High | Credential-management flaw | When the token is static or insufficiently rotated, the control-plane access window after a leak is too long | ❌ Unfixed |
| D0-14 | JWT validity period and sensitive-credential exposure risk | Medium | Session security | The token has a long lifetime and is readable inside the container, increasing the abuse window after theft | ❌ Unfixed |

---

<a id="cve"></a>

## CVE filing status

On 2026-03-21 the researcher submitted 9 CVE filings based on the Donut Browser-phase issues. The formal release will list the ticket IDs, vulnerability mappings, CWE, and finalized unified CVSS information.

The current draft-stage mapping:

| Ticket ID | Corresponding issue |
|---|---|
| 2012016 | Server-side transaction signing / execution path lacks an authorization boundary |
| 2012018 | CORS subdomain policy combined with credentials |
| 2012020 | Wallet / asset endpoint IDOR |
| 2012022 | Role-parameter injection |
| 2012024 | Insufficient MCP authentication or privilege boundary |
| 2012026 | Weak / no-auth wallet creation |
| 2012030 | Credits / usage-limit bypass |
| 2012032 | AI Agent config and prompt leakage |
| 2012034 | Cross-user limit-order cancellation |

Whether the D0-phase issues will be filed as separate CVEs will be decided later based on follow-up work.

Related record: [CVE filing record](./evidence/cve.md).

---

<a id="open-questions"></a>

## Open questions

The questions below arise from the attack chains disclosed here, the communication records, the vulnerability-response process, and the gap between Donut's external security narrative and its actual security performance.

**Q1: Donut directly handles users' real funds and can initiate and execute irreversible on-chain transactions. For such a product, basics like user authorization, wallet-ownership checks, and control-plane / runtime-environment isolation should be a non-negotiable bottom line — so why do Donut Browser and D0 still fail at these fundamentals?**

**Q2: Donut's official docs assure users that “所有交易都需经你批准（All transactions require your approval）” (see [official docs · Wallet & Security](https://docs.donutbrowser.ai/reference/faq)). But the verified 1-click silent-transaction chain shows a path that bypasses this approval and can initiate and execute a transaction with no authorization or signature confirmation from the user (verified on the researcher's own account, evidenced by [11 on-chain transactions](./evidence/chain.md)). When a core user-facing security guarantee can be bypassed, how far can it still be relied on in practice?**

**Q3: D0 was verified to obtain control-plane connection material from an ordinary login, then combine it into config reading, config modification, file writing, own-Pod RCE, and reading of sensitive session material (see [D0 evidence](./evidence/evidence.md#d0sec)). Does such control-plane exposure match the security boundary an AI-Agent product ought to have?**

**Q4: After the researcher submitted major security research, joined the meetings, provided the redacted report, slides, and PoC video, and clearly set a responsible-disclosure window, the vendor still downgraded the Critical-level vulnerabilities to routine community-event handling (vendor's own words “是常规社区奖励,” see [Telegram · 2026-03-18](./evidence/telegram.md); see also the [third meeting](./evidence/meetings.md)). Was this attention and response commensurate with the risk level?**

**Q5: If an independent researcher submits major vulnerability findings under a responsible-disclosure framework only to be downgraded to routine community-event handling, will this make more researchers lose confidence in compliant disclosure?**

**Q6: The cost-and-reward of security research is highly asymmetric between attackers and white-hats: an attacker only needs to find one exploitable path, with no regard for authorization, compliance, or recognition; a white-hat must spend heavily on authorization boundaries, responsible disclosure, and long-running communication, and may end up without even a single public acknowledgement — and may even, while legitimately seeking a reasonable reward within a compliant framework, be recast as “施压” or “敲诈” and then face legal threats. When compliant disclosure long goes without a response commensurate with the risk and researchers leave as a result, does this not weaken the very coordinated-disclosure mechanism the whole industry relies on — while real attackers never need any of these prerequisites?**

**Q7: In officially introducing its core product D0, Donut stressed that “金融操作不可逆，对安全的要求从根本上就不同（the bar for safety is fundamentally different）” (official [X @DonutAI](https://x.com/DonutAI/status/2052440302003081555)). Yet D0 is built on top of an open-source project that had been live for only a short time, and this research achieved RCE and control-plane takeover on it — is that commensurate with its security positioning, funding scale, and market expectations? Have the corresponding potential security risks received matching security investment?**

---

<a id="security-governance"></a>
## Security-governance observations

This incident is not just a collection of API bugs; it also exposes several common security-governance problems for AI + Crypto products.

First, once an AI Agent connects wallets, trading, signing, strategy execution, and on-chain assets, it is no longer an ordinary chatbot but an automated system with financial-execution capability. Such a system needs an enforced backend authorization model, asset-ownership validation, least privilege, signature confirmation, audit logging, and anomaly interception.

Second, a third-party security policy cannot substitute for the project's own authorization model. Turnkey returning AUTH001 and blocking a high-risk transaction shows that the third-party service acted as an interceptor at the final stage. Donut's own backend still exposes binding-validation problems between users and wallets, orders, and transactions.

Third, a Bug Hunt or community-feedback mechanism cannot substitute for a formal vulnerability-response process. When a project publicly encourages community testing, it should also be ready to handle real Critical-level security incidents, including graded assessment, remediation coordination, disclosure coordination, retest feedback, and reasonable rewards.

Fourth, the control-plane security of an AI-Agent runtime environment should be treated as a core asset boundary. If there is no strong isolation between front-end sessions, the Gateway Token, config modification, file writes, beforeRun, and heartbeat, an attacker may bypass the model-layer safety review and reach the execution layer directly.

Fifth, open-source dependency and secondary development are not themselves a problem. The problem is that a company disclosing US$22M raised across two rounds and presenting D0 as its core AI-Agent product has a core control plane that, on actual access, clearly displays the OpenClaw logo, with the docs link pointing to the OpenClaw official documentation. This fact should be discussed openly: there is a clear gap between D0's external packaging, its in-house-development narrative, the transparency of its key open-source dependency, the security review of its secondary development, and its actual security-engineering capability. What truly warrants attention is not the use of open source, but that, under a high-funding narrative, the core product's dependency on OpenClaw was not adequately disclosed, nor was a security-engineering and vulnerability-response capability commensurate with the funding scale demonstrated.

Sixth, the recognition mechanism for security research is itself part of security governance. A mature responsible-disclosure system usually rewards researchers through dedicated bounties and public acknowledgement (website credits, a security hall of fame, disclosure credits) — both an acknowledgement of the research's value and a foundation for attracting sustained, compliant security research. This system-level research (49 vulns / attack chains / RCE) received neither any separate assessment or dedicated bounty, nor any formal recognition on any public channel (only an informal thank-you in the Discord community). To be clear, submitting security research for free is not uncommon in the industry, and the researcher never made a bounty a precondition for public disclosure; the point of observation here is not "whether it was paid", but that the vendor itself explicitly stated it has a bug-bounty budget, yet still processed this kind of system-level research under the ordinary community-reward track. How major security research is treated itself reflects a product's security-governance maturity.

The purpose of recording these problems is to let users, media, investors, and the development team see more clearly: the security capability of an AI + Crypto product should not be reflected only in narrative and UI, but in the backend authorization model, runtime-environment isolation, and the vulnerability-response mechanism.

---

<a id="legal-basis"></a>

## Disclosure basis

This section is not a legal opinion; it explains the factual basis and the industry-standard process on which this public disclosure relies.

This disclosure conforms to the basic logic of responsible / coordinated disclosure: after finding high-risk issues, the researcher first explained the nature, impact scope, and remediation window to the vendor through an online meeting and written materials; the vendor had the opportunity to be informed, assess, remediate, and communicate within a reasonable time; and after the window expired, the researcher may disclose the risk to users and the public without releasing directly-abusable details.

The factual basis of this disclosure includes:

1. The Donut Browser-phase testing took place within Donut's official Bug Hunt events and the subsequent online-communication framework.
2. On 2026-03-11, the researcher demonstrated and explained the core risks to Donut in an online meeting.
3. After the meeting, the researcher submitted a redacted report, slides, and PoC demonstration material to Donut.
4. On 2026-03-18, the researcher gave written notice that public disclosure was planned for 2026-06-09; after re-engagement in June, on June 10 the researcher again gave written notice extending the public disclosure date to June 15, once more reserving a communication window.
5. No third-party user funds were moved during testing, and the D0 command-execution verification was confined to the researcher's own tenant / Pod.
6. The disclosed content shows only redacted factual evidence, verification conclusions, and the public basis; it provides no directly-reusable access credentials, private keys, or attack scripts.

Industry processes for reference:

- [ISO/IEC 29147:2018 - Vulnerability disclosure](https://www.iso.org/standard/72311.html): requirements and recommendations for vendors receiving reports, disclosing information, and reducing user risk during vulnerability disclosure.
- [ISO/IEC 30111:2019 - Vulnerability handling processes](https://www.iso.org/standard/69725.html): describes the vulnerability-handling process.
- [CERT/CC Coordinated Vulnerability Disclosure Guide](https://certcc.github.io/CERT-Guide-to-CVD/): a practical guide to coordinated vulnerability disclosure.
- [CERT-EU Coordinated Vulnerability Disclosure Policy](https://www.cert.europa.eu/coordinated-vulnerability-disclosure-policy): a reference for the public-disclosure window and coordinated-disclosure practice.

Based on the facts above, the purpose of this publication is to inform users of the risks, record the security-research process, and push the vendor and the industry to take the systemic security boundaries of AI + Crypto products seriously.

---

<a id="author-and-cooperation"></a>

## About the author & cooperation

**Lucifiel**, independent security researcher and founder of 数字循真. Around ten years of offensive-security and red-team experience, with a long focus on Web3 security, AI-Agent security, business-logic security, and the privilege-boundary and trust-model problems of complex systems; this Donut AI security research was carried out independently by me.

数字循真 is a **Runtime Semantic Intelligence (RSI) framework**. It first aggregates and cleans the traffic, product documentation, and various known information related to the target system, reconstructing a complete business-operation model (a business flowchart); it then annotates potential risk points on that model and uses a state machine to track state transitions and judge whether a risk holds in the real business flow; combined with a risk model and AI trained on the team’s cybersecurity knowledge and experience, it makes a clear determination and finally outputs a professional report with evidence and conclusions. Its application is not limited to security — we believe the future belongs to AI, and having humans police every AI action one by one is both inefficient and unrealistic; what 数字循真 aims to do is make “whether an action is reasonable and whether it crosses a line” something that can be judged automatically and explainably.

The risks this Donut research reveals — the server-side auto-signing fund path, cross-user wallet overreach, asset-profile leakage, and the breakdown of control-plane and agent-tool boundaries — are exactly the kind of business-logic risk that is “locally normal but globally anomalous”: a single action looks fine on its own, yet becomes a global risk once placed in the full business state and flow, and traditional security tools often struggle to find it. We founded 数字循真 precisely to tackle this class of problem systematically; the business attack chains and evidence methods distilled in this research have also become real cases in the 数字循真 risk knowledge base.

I and the 数字循真 team welcome discussion on the following:

1. Security services such as security testing, auditing, and research, plus career and long-term opportunities such as Head of Security or technical co-founder.
2. Security assessment, attack-chain analysis, and advisory engagements in business-logic security, Web3 security, and AI-Agent security.
3. 数字循真 is seeking investment and is open to product pilots (PoC) and ecosystem partnerships.
4. Media interviews, technical coverage, community talks, and industry-observation collaborations.

Contact:

- Email: lucifiel99@gmail.com
- X: [https://x.com/LucifielHack](https://x.com/LucifielHack)
- Website: [https://www.lucifiel.com/](https://www.lucifiel.com/)
- GitHub: [https://github.com/LucifielHack/Donut-Security-Disclosure](https://github.com/LucifielHack/Donut-Security-Disclosure)

---
