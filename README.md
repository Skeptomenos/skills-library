# OpenCode Skills Repository

A collection of reusable skills for AI coding agents. Skills are markdown-based instruction sets that shape how agents behave during specific tasks.

## Philosophy

Skill writing is **TDD for process documentation**:

| Phase | Action |
|-------|--------|
| RED | Run task without skill, document failure |
| GREEN | Write skill to fix that failure |
| REFACTOR | Optimize for brevity and clarity |

**The "No Slop" Rule**: Never create a skill without a baseline failure. Context is a public good—every token competes with the user's actual request.

## Skills

<!-- SKILLS_LIST_START -->
| Skill | Description |
|-------|-------------|
| [`agent-browser`](skills/agent-browser/SKILL.md) | Automates browser interactions for web testing, form filling, screenshots, and data extraction. Use when the user needs to navigate websites, interact with web pages, fill forms, take screenshots, test web applications, or extract information from web pages. |
| [`agent-compatibility-audit`](skills/agent-compatibility-audit/SKILL.md) | Audit whether a repository is easy for coding agents to start, validate, and trust. Use when checking agent readiness, startup docs, validation loops, or whether a project is AFK-agent friendly. |
| [`agents-md`](skills/agents-md/SKILL.md) | Audit and improve AGENTS.md files using progressive disclosure principles. Enforces high-leverage discipline (No Slop, Always Works) and lean structure. |
| [`ai-dev-repo-git-cleanup`](skills/ai-dev-repo/git-cleanup/SKILL.md) | Use when cleaning ai-dev branches, triaging stale pull requests, protecting dirty main state, archiving side-project work, or reducing branch sprawl in the ai-dev monorepo. |
| [`auto-skill`](skills/auto-skill/SKILL.md) | Autonomous skill extraction system that captures reusable knowledge from work sessions. Triggers: (1) /auto-skill command to review session learnings, (2) "save this as a skill" or "extract a skill from this", (3) "what did we learn?", (4) After any task involving non-obvious debugging, workarounds, or trial-and-error discovery. Creates new OpenCode skills when valuable, reusable knowledge is identified. |
| [`bird-cli`](skills/bird-cli/SKILL.md) | Use when reading X/Twitter posts, tweets, threads, or x.com links. Also for searching Twitter content, trending topics, bookmarks, mentions, and user profiles via CLI. |
| [`cal-grid`](skills/cal-grid/SKILL.md) | Map the daily calendar grid identifying meetings, deep work slots, and preparation needs. |
| [`cross-linker`](skills/cross-linker/SKILL.md) | Discover and create [[wikilinks]] between knowledge base files. Uses evidence-based confidence tiers. Updates frontmatter related field. Works with knowledge-capture and gardener. |
| [`detect-fork`](skills/detect-fork/SKILL.md) | Semantic search across OpenCode sessions to find relevant prior context. Use when: (1) Starting work that resembles past implementations, (2) User mentions something was "done before" or asks to "continue where we left off", (3) Complex feature that would benefit from prior context, (4) Cross-project pattern discovery. Searches QMD's session index and returns ranked results. Default: read and learn from prior sessions in the current session. Fork only when explicitly requested. |
| [`domain-discovery`](skills/domain-discovery/SKILL.md) | Structured discovery for new domains using breadth-before-depth interviewing. Maps the landscape of people, projects, and challenges before diving deep. Feeds into knowledge-capture for persistence. |
| [`email-draft`](skills/email-draft/SKILL.md) | Use when drafting emails, composing replies, or writing professional messages that will be sent via Gmail. |
| [`evening-close`](skills/evening-close/SKILL.md) | Summarize the day, extract incomplete tasks into tomorrow's overflow, and persist daily learnings to the Knowledge Base. |
| [`gardener`](skills/gardener/SKILL.md) | Maintain knowledge base health. Audits indexes, fixes broken links, detects orphans, and suggests promotions when entities outgrow their containers. Works with knowledge-capture and cross-linker. |
| [`handover`](skills/handover/SKILL.md) | Pushes strategic context from root to a project capsule. |
| [`identity-discovery`](skills/identity-discovery/SKILL.md) | Discover the user's digital identity (emails, account IDs) by leveraging filesystem context from path-discovery. Required for MCP tool handshaking. |
| [`interview-prep`](skills/interview-prep/SKILL.md) | Generate tailored interview questions for hiring candidates. Gathers job description, resume, and hiring standards to create focused, role-appropriate questions. |
| [`jira-pulse`](skills/jira-pulse/SKILL.md) | Use when scanning Jira for active tickets, deadlines, and blockers. Provides structured visibility into the user's task queue. |
| [`knowledge-capture`](skills/knowledge-capture/SKILL.md) | Extract entities from conversation (people, projects, decisions, topics) and organize them into knowledge base files. Creates files using templates, maintains folder indexes, and triggers cross-linking. |
| [`last30days`](skills/last30days/SKILL.md) | Research any topic across Reddit, X, and the web from the last 30 days. Best for prompt research and trend discovery. |
| [`leadership-coach`](skills/leadership-coach/SKILL.md) | IC-to-Manager coaching for new leaders. Use for leadership challenges, team operations, stakeholder management, 1:1 prep, performance conversations, or when feeling overwhelmed as a new manager. |
| [`librarian`](skills/librarian/SKILL.md) | Knowledge maintenance skill for compacting, archiving, and organizing the knowledge base. Preserves wisdom while reducing noise. |
| [`llm-council`](skills/llm-council/SKILL.md) | Orchestrate a configurable, multi-member CLI planning council (Codex, Claude Code, Gemini, OpenCode, or custom) to produce independent implementation plans, anonymize and randomize them, then judge and merge into one final plan. Use when you need a robust, bias-resistant planning workflow, structured JSON outputs, retries, and failure handling across multiple CLI agents. |
| [`mail-triage`](skills/mail-triage/SKILL.md) | Use when user asks to check email, process inbox, or scan for messages. Exhaustively drains inbox and outputs structured triage report with meeting notes detection. |
| [`morning-boot`](skills/morning-boot/SKILL.md) | The master orchestrator for your morning routine. Parallelizes scans across email, calendar, Slack, and Jira, then synthesizes into a daily briefing. Path-aware — scans both work and life when run from KB root. |
| [`novelty-detection`](skills/novelty-detection/SKILL.md) | Reusable novelty detection module. Compares new content against known state to classify as DUPLICATE, UPDATE, or NOVEL. Extracts deltas for updates. Used by post-meeting-drill, mail-triage, slack-pulse. |
| [`open-prose`](skills/open-prose/SKILL.md) | Use when running .prose files, mentioning OpenProse, or orchestrating AI agents from a prose program. |
| [`path-discovery`](skills/path-discovery/SKILL.md) | Discover the filesystem context of the Knowledge Base, including KB root, operating mode (dual/single), and current hemisphere. |
| [`playbooks-fetch`](skills/playbooks-fetch/SKILL.md) | Use when fetching web content as markdown, especially for client-side rendered (SPA) pages where WebFetch fails or returns incomplete content. |
| [`post-meeting-drill`](skills/post-meeting-drill/SKILL.md) | Deep processing of meeting notes with context hydration, entity resolution, thought-routing, urgency assessment, and knowledge persistence. |
| [`prd`](skills/prd/SKILL.md) | Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out. |
| [`scorecard-synthesis`](skills/scorecard-synthesis/SKILL.md) | Synthesize hiring scorecards from interview transcripts. Analyzes candidate responses against role criteria and generates structured evaluation with evidence. |
| [`skill-generator`](skills/skill-generator/SKILL.md) | Use when creating a new skill, editing an existing skill, or when asked to document a reusable process or technique |
| [`slack-pulse`](skills/slack-pulse/SKILL.md) | Scan Slack for mentions, DMs, and high-value channel activity requiring attention. |
| [`slack-write`](skills/slack-write/SKILL.md) | Use when writing Slack messages, team announcements, or channel posts. Ensures correct mrkdwn formatting instead of Markdown. |
| [`thought-router`](skills/thought-router/SKILL.md) | Route unstructured thoughts, brain dumps, and quick captures to their correct home in the knowledge base. |
| [`verify-this`](skills/verify-this/SKILL.md) | Verify a claim with fresh local evidence. Use when asked to prove a fix, confirm behavior, compare before/after results, or produce a VERIFIED, NOT VERIFIED, or INCONCLUSIVE verdict. |
| [`writing-plans`](skills/writing-plans/SKILL.md) | Write and maintain living implementation plans for multi-step work. Use when work has 3+ steps, touches multiple files or subsystems, or may span sessions. |
<!-- SKILLS_LIST_END -->

## Structure

```
skills/
├── AGENTS.md              # Entry point
├── docs/                  # Core protocols
│   ├── CORE_PHILOSOPHY.md
│   ├── QUALITY.md
│   ├── SKILL_ARCHITECTURE.md
│   ├── SKILL_STANDARDS.md
│   ├── TESTING_PROTOCOL.md
│   └── PLANNING.md
├── docu/                  # Reference documentation
│   ├── AGENTS-MD-GUIDE.md
│   └── OPENCODE-SKILLS-CONFIG.md
└── skills/                # Individual skills
    └── <skill-name>/
        ├── SKILL.md       # Main skill file (required)
        ├── *-template.md  # Output template (optional)
        └── docs/          # Reference docs (optional)
```

## Usage

### Managed Install With `skills`

Use the [skills CLI](https://skills.sh/) for Codex and other agents:

```bash
cd _infra/skills
./register_skills.sh list
./register_skills.sh
```

By default, `register_skills.sh` installs all local skills for the `codex` and `opencode` agents via:

```bash
npx skills@latest add . -g --full-depth --agent codex opencode --skill '*' -y
```

To install a subset:

```bash
SKILLS_AGENTS=codex SKILLS_NAMES="prd writing-plans" ./register_skills.sh
```

For update tracking, install from the public split repository after the ai-dev PR has merged and split publishing has completed:

```bash
npx skills@latest add Skeptomenos/skills-library -g --full-depth --agent codex --skill '*' -y
npx skills@latest update -g -y
```

Local-path installs are copied from the current checkout. Refresh them by pulling the repo and rerunning `./register_skills.sh`.

### Skill Discovery

OpenCode discovers skills via hierarchy:
1. **Project-local**: `.opencode/skills/<name>/SKILL.md`
2. **Walk-up**: Parent `.opencode/skills/` folders
3. **Global**: `~/.config/opencode/skills/<name>/SKILL.md`

### Invoking Skills

```
/morning-boot
/mail-triage
skill({ name: "agents-md" })
```

### Creating New Skills

Use the `skill-generator` skill:

1. Document baseline failure (RED phase)
2. Run `/skill-generator` to scaffold
3. Verify agent passes task (GREEN phase)
4. Apply progressive disclosure (REFACTOR phase)

## Documentation

| Document | Content |
|----------|---------|
| `docs/QUALITY.md` | The Iron Law, Verification Gates |
| `docs/TESTING_PROTOCOL.md` | Pressure tests, Subagent templates |
| `docs/SKILL_ARCHITECTURE.md` | Nesting, Context Flow, Templates |
| `docs/CORE_PHILOSOPHY.md` | Skills as Leverage |
| `docs/SKILL_STANDARDS.md` | Format, Frontmatter requirements |
| `docs/PLANNING.md` | Concise planning requirements |

## Key Concepts

- **Progressive Disclosure**: Keep root files minimal, link to detailed docs
- **Hierarchy of Leverage**: 1 bad instruction = many wrong behaviors
- **Pressure Testing**: Skills must resist time/authority/sunk-cost pressures
- **Statelessness**: Skills work in isolation without session memory

## License

MIT
