# Technical Deep Dive: Morning Boot Skill

**Version:** 4.1
**Pattern:** Recursive Orchestrated Orchestration (ROO)
**Platform:** OpenCode + OpenProse VM

---

## 1. Executive Overview

The `morning-boot` skill is the master orchestrator for the user's daily work routine. It solves the "Data Overload" problem by parallelizing the retrieval of context from multiple sources (Email, Calendar, Slack, Jira) and synthesizing it through an **Executive Filter**.

Its primary goal is to produce a high-fidelity **Daily Log** (`daily-log.md`) that serves as the single source of truth for the day's commitments.

---

## 2. Architecture: The "Russian Doll" Pattern

The skill operates on a recursive architecture that enables massive data processing while keeping the main conversation context clean.

### Layer 1: The Master Skill (`SKILL.md`)
The "Program Manager." It handles context discovery, state management, and final synthesis. It is the only layer with access to the user's long-term Knowledge Base (KB).

### Layer 2: The Orchestrator (`.prose`)
The "Instruction Set." A specialized OpenProse program that defines the topology of parallel agents. It defines *who* does the work, but not *how* they do it.

### Layer 3: The VM (OpenProse VM)
The "Execution Engine." It manages the spawning of isolated sessions, tracks their completion status, and aggregates their results.

### Layer 4: The Sub-Agents (Sessions)
The "Workers." Isolated agents spawned by the VM. They have short-lived memories and one specific mission.

### Layer 5: Specialized Skills (`mail-triage`, `jira-pulse`, etc.)
The "Domain Experts." Highly specialized instruction sets that know how to interact with specific APIs and format raw data into markdown reports.

---

## 3. Orchestration Flow Diagram

```text
      [ USER TRIGGER ]
             |
             v
+----------------------------+
| MASTER SKILL (SKILL.md)    | <--- LAYER 1: Program Manager
| (morning-boot)             |      Access to KB (dashboard.md)
+-------------+--------------+
              |
              |--[ Call: identity-discovery ]
              v
+----------------------------+
| ORCHESTRATOR (.prose)      | <--- LAYER 2: Instruction Set
| (morning-boot.prose)       |      Topology of Agents
+-------------+--------------+
              |
              |--[ Boot OpenProse VM ]
              v
+----------------------------+
| OPENPROSE VM (Execution)   | <--- LAYER 3: VM
| (Parallel Management)      |      Spawns N Sessions
+-------+-----+------+-------+
        |     |      |
        v     v      v
  +-----+  +-----+  +-----+
  | SES |  | SES |  | SES | <--- LAYER 4: Sub-Agents (Sessions)
  +--+--+  +--+--+  +--+--+      Isolated Workers
     |        |        |
     | [Load Skill]    |
     v        v        v
  +-----+  +-----+  +-----+
  | SKL |  | SKL |  | SKL | <--- LAYER 5: Domain Skills
  +-----+  +-----+  +-----+      (mail-triage, jira-pulse, etc.)
     |        |        |
     v        v        v
  [Report] [Report] [Report]  --- (Markdown files per domain)
     |        |        |
     +--------+--------+
              |
              v (Aggregate Results)
+----------------------------+
| MASTER SKILL (Synthesis)   | <--- Executive Filter
| (Produce daily-log.md)     |
+----------------------------+
```

---

## 4. Workflow Lifecycle

### Phase 1: Context Bootstrapping
Before any scan starts, the Master Skill calls `skill({ name: "identity-discovery" })`.
- **Mission:** Identify `identity.email` and `kb_root`.
- **Why:** This ensures scanners use the correct credentials and files are written to the right hemisphere (Work vs. Life).

### Phase 2: Parallel Fan-Out (Concurrent Scanning)
The Master Skill triggers the OpenProse VM to run `morning-boot.prose`.
- **Fan-out:** 4–6 parallel sessions are launched.
- **Isolation:** Each scanner reads hundreds of lines of API data (Gmail threads, JQL results) without polluting the main agent's context window.
- **Persistence:** Each scanner writes its own domain report (e.g., `mail-triage.md`) to the daily operations folder.

### Phase 3: Executive Synthesis
Once the VM returns all reports, the **Master Skill** takes control again.
- **Synthesis Logic:** It reads the reports + `dashboard.md` (spillover).
- **Complexity Budgeting:** It calculates meeting load vs. task capacity.
- **The Filter:** It selects the "Top 3" based on urgency signals from Jira and Calendar.

### Phase 4: Persistence & Delivery
The final `daily-log.md` is generated from a template and presented to the user.

---

## 4. Safety & Robustness Design

### 1. Token Isolation (Critical)
If a single agent tried to read 20 emails, 15 Jira tickets, and 10 calendar events, the context window would saturate, causing hallucinations. By using sub-agents, we "burn" tokens in temporary sessions, only returning the distilled results.

### 2. Failure Decoupling
If the Slack API is down, only the `slack_scanner` fails. The OpenProse VM reports the error, but the Master Skill continues to synthesize the day based on Email, Jira, and Calendar.

### 3. Path-Awareness
The skill detects its location in the KB.
- Running from root? → Dual mode (Work + Life).
- Running from `/work`? → Single mode (Work only).

---

## 5. Blueprint: Adding a New Scanner

To add a new platform (e.g., GitHub PRs), follow these steps:

1.  **Create Domain Skill:** Build `skills/github-pulse/SKILL.md` to scan PRs and output a markdown report.
2.  **Define Agent:** Add a `github_scanner` to `morning-boot.prose`.
3.  **Update Fan-out:** Include `github = session: github_scanner` in the `parallel:` block.
4.  **Update Synthesis:** Add GitHub input analysis to `SKILL.md` Phase 3.
5.  **Update Template:** Add `{{GITHUB_PR_COUNT}}` to `daily-log-template.md`.

---

## 6. Implementation Guidelines for Engineers

- **No Synthesis in Sub-Agents:** Workers should only fetch and report. Synthesis requires "Total Context," which only the Master Skill has.
- **Templates are Mandatory:** Use template files for output. Never allow the LLM to decide the markdown structure on the fly.
- **Absolute Paths Only:** When moving between sessions and skills, always use absolute paths derived from `kb_root`.
- **"No Surprises" Rule:** High-priority items from any scanner (Overdue Jira, Urgent Email) must be surfaced in the main briefing summary.

---

*This document serves as the technical specification for maintaining and scaling the OpenCode Morning Boot routine.*
