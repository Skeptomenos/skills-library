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
| [`agent-browser`](skills/agent-browser/SKILL.md) | Browser automation CLI for AI agents. Use when the user needs to interact with websites, including navigating pages, filling forms, clicking buttons, taking screenshots, extracting data, testing web apps, or automating any browser task. Triggers include requests to "open a website", "fill out a form", "click a button", "take a screenshot", "scrape data from a page", "test this web app", "login to a site", "automate browser actions", or any task requiring programmatic web interaction. |
| [`agent-compatibility-audit`](skills/agent-compatibility-audit/SKILL.md) | Audit whether a repository is easy for coding agents to start, validate, and trust. Use when checking agent readiness, startup docs, validation loops, or whether a project is AFK-agent friendly. |
| [`agents-md`](skills/agents-md/SKILL.md) | Audit and improve AGENTS.md files using progressive disclosure principles. Enforces high-leverage discipline (No Slop, Always Works) and lean structure. |
| [`ai-dev-repo-git-cleanup`](skills/ai-dev-repo/git-cleanup/SKILL.md) | Use when cleaning ai-dev branches, triaging stale pull requests, protecting dirty main state, archiving side-project work, or reducing branch sprawl in the ai-dev monorepo. |
| [`app-creator`](skills/app-creator/SKILL.md) | Orchestrate iOS/macOS app scaffolding and optional skill adoption for existing projects. Use when users want a guided wizard that can scaffold with XcodeGen and optionally install xcode-makefiles and simple-tasks. |
| [`api-design-standards`](skills/dev-standards/api-design/SKILL.md) | API design standards — RESTful resources, JSON response envelope, status codes, pagination, versioning, input/output safety. Use when designing or modifying an API endpoint or contract. |
| [`architecture-standards`](skills/dev-standards/architecture/SKILL.md) | Architecture standards — 3-layer pattern (presentation/service/data), feature-sliced frontend structure, DTOs between layers, no-breadcrumbs code hygiene. Use when designing module structure or organizing a codebase. |
| [`auto-skill`](skills/auto-skill/SKILL.md) | Autonomous skill extraction system that captures reusable knowledge from work sessions. Triggers: (1) /auto-skill command to review session learnings, (2) "save this as a skill" or "extract a skill from this", (3) "what did we learn?", (4) After any task involving non-obvious debugging, workarounds, or trial-and-error discovery. Creates new OpenCode skills when valuable, reusable knowledge is identified. |
| [`bird-cli`](skills/bird-cli/SKILL.md) | Use when reading X/Twitter posts, tweets, threads, or x.com links. Also for searching Twitter content, trending topics, bookmarks, mentions, and user profiles via CLI. |
| [`cal-grid`](skills/cal-grid/SKILL.md) | Map the daily calendar grid identifying meetings, deep work slots, and preparation needs. |
| [`create-agents-md`](skills/create-agents-md/SKILL.md) | How to write AGENTS.md files for the ai-dev monorepo. Covers size targets, required fields, what goes in vs out, templates for each level. Use when creating a new AGENTS.md, reviewing an existing one, or asking about AGENTS.md conventions. Does NOT create projects (load create-project) or update indexes (load update-index). |
| [`create-project`](skills/create-project/SKILL.md) | How to create a new project in the ai-dev monorepo. Covers placement via decision tree, required files, naming, scope map, and index.md updates. Use when asked to "create a new", "add a project", "start a new", "scaffold", or when a new piece of work needs a home. Does NOT cover AGENTS.md writing conventions (load create-agents-md) or index maintenance (load update-index). |
| [`cross-linker`](skills/cross-linker/SKILL.md) | Discover and create [[wikilinks]] between knowledge base files. Uses evidence-based confidence tiers. Updates frontmatter related field. Works with knowledge-capture and gardener. |
| [`detect-fork`](skills/detect-fork/SKILL.md) | Semantic search across OpenCode sessions to find relevant prior context. Use when: (1) Starting work that resembles past implementations, (2) User mentions something was "done before" or asks to "continue where we left off", (3) Complex feature that would benefit from prior context, (4) Cross-project pattern discovery. Searches QMD's session index and returns ranked results. Default: read and learn from prior sessions in the current session. Fork only when explicitly requested. |
| [`devops-standards`](skills/dev-standards/devops/SKILL.md) | DevOps and infrastructure standards — Terraform/IaC, least-privilege IAM, SHA-pinned GitHub Actions, OIDC auth, Docker hardening, vulnerability scanning. Use when working on infrastructure, CI/CD, Docker, or Terraform. |
| [`documentation-standards`](skills/dev-standards/documentation/SKILL.md) | Documentation standards — intent-over-syntax comments, README structure, API doc generation, commit message context. Use when writing documentation, READMEs, or code comments. |
| [`dogfood`](skills/dogfood/SKILL.md) | Systematically explore and test a web application to find bugs, UX issues, and other problems. Use when asked to "dogfood", "QA", "exploratory test", "find issues", "bug hunt", "test this app/site/platform", or review the quality of a web application. Produces a structured report with full reproduction evidence -- step-by-step screenshots, repro videos, and detailed repro steps for every issue -- so findings can be handed directly to the responsible teams. |
| [`domain-discovery`](skills/domain-discovery/SKILL.md) | Structured discovery for new domains using breadth-before-depth interviewing. Maps the landscape of people, projects, and challenges before diving deep. Feeds into knowledge-capture for persistence. |
| [`email-draft`](skills/email-draft/SKILL.md) | Use when drafting emails, composing replies, or writing professional messages that will be sent via Gmail. |
| [`evening-close`](skills/evening-close/SKILL.md) | Summarize the day, extract incomplete tasks into tomorrow's overflow, and persist daily learnings to the Knowledge Base. |
| [`gardener`](skills/gardener/SKILL.md) | Maintain knowledge base health. Audits indexes, fixes broken links, detects orphans, and suggests promotions when entities outgrow their containers. Works with knowledge-capture and cross-linker. |
| [`git-workflow`](skills/git-workflow/SKILL.md) | Git branching, commits, PRs, scope enforcement, multi-session safety, Alfred auto-review, and split publishing for the ai-dev monorepo. Use when creating branches, committing, pushing, creating PRs, or when working alongside other agents/sessions. Bridges with linear-workflow via `linear issue start` and `linear issue pr`. Does NOT cover Linear ticket lifecycle (load linear-workflow) or project creation (load create-project). |
| [`grill-me`](skills/grill-me/SKILL.md) | Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me". |
| [`grill-with-docs`](skills/grill-with-docs/SKILL.md) | Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates documentation (CONTEXT.md, ADRs) inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions. |
| [`handover`](skills/handover/SKILL.md) | Pushes strategic context from root to a project capsule. |
| [`identity-discovery`](skills/identity-discovery/SKILL.md) | Discover the user's digital identity (emails, account IDs) by leveraging filesystem context from path-discovery. Required for MCP tool handshaking. |
| [`interview-prep`](skills/interview-prep/SKILL.md) | Generate tailored interview questions for hiring candidates. Gathers job description, resume, and hiring standards to create focused, role-appropriate questions. |
| [`ios-agentic-standards`](skills/dev-standards/ios-agentic/SKILL.md) | iOS agentic development workflow — XcodeBuildMCP usage, long-running agent loops, test-driven agent patterns, project structure for unsupervised sessions. Use when setting up or running agent-driven iOS development. |
| [`jira-pulse`](skills/jira-pulse/SKILL.md) | Use when scanning Jira for active tickets, deadlines, and blockers. Provides structured visibility into the user's task queue. |
| [`knowledge-capture`](skills/knowledge-capture/SKILL.md) | Extract entities from conversation (people, projects, decisions, topics) and organize them into knowledge base files. Creates files using templates, maintains folder indexes, and triggers cross-linking. |
| [`last30days`](skills/last30days/SKILL.md) | Research any topic across Reddit, X, and the web from the last 30 days. Best for prompt research and trend discovery. |
| [`leadership-coach`](skills/leadership-coach/SKILL.md) | IC-to-Manager coaching for new leaders. Use for leadership challenges, team operations, stakeholder management, 1:1 prep, performance conversations, or when feeling overwhelmed as a new manager. |
| [`librarian`](skills/librarian/SKILL.md) | Knowledge maintenance skill for compacting, archiving, and organizing the knowledge base. Preserves wisdom while reducing noise. |
| [`linear-workflow`](skills/linear-workflow/SKILL.md) | Session lifecycle with Linear issue tracking for the ai-dev monorepo. Uses the `linear` CLI (schpet/linear-cli), not the Linear MCP. Covers issue discovery at session start, milestone comments during work, status transitions, and session-end summaries. Use when working on tracked work, starting a session, or ending a session. Does NOT cover git branching or PRs (load git-workflow). |
| [`llm-council`](skills/llm-council/SKILL.md) | Orchestrate a configurable, multi-member CLI planning council (Codex, Claude Code, Gemini, OpenCode, or custom) to produce independent implementation plans, anonymize and randomize them, then judge and merge into one final plan. Use when you need a robust, bias-resistant planning workflow, structured JSON outputs, retries, and failure handling across multiple CLI agents. |
| [`logging-standards`](skills/dev-standards/logging/SKILL.md) | Logging standards — structured JSON logging (Pino/Consola), log levels, request IDs, PII redaction, no console.log. Use when implementing or reviewing logging. |
| [`mail-triage`](skills/mail-triage/SKILL.md) | Use when user asks to check email, process inbox, or scan for messages. Exhaustively drains inbox and outputs structured triage report with meeting notes detection. |
| [`morning-boot`](skills/morning-boot/SKILL.md) | The master orchestrator for your morning routine. Parallelizes scans across email, calendar, Slack, and Jira, then synthesizes into a daily briefing. Path-aware — scans both work and life when run from KB root. |
| [`novelty-detection`](skills/novelty-detection/SKILL.md) | Reusable novelty detection module. Compares new content against known state to classify as DUPLICATE, UPDATE, or NOVEL. Extracts deltas for updates. Used by post-meeting-drill, mail-triage, slack-pulse. |
| [`open-prose`](skills/open-prose/SKILL.md) | Use when running .prose files, mentioning OpenProse, or orchestrating AI agents from a prose program. |
| [`path-discovery`](skills/path-discovery/SKILL.md) | Discover the filesystem context of the Knowledge Base, including KB root, operating mode (dual/single), and current hemisphere. |
| [`playbooks-fetch`](skills/playbooks-fetch/SKILL.md) | Use when fetching web content as markdown, especially for client-side rendered (SPA) pages where WebFetch fails or returns incomplete content. |
| [`post-meeting-drill`](skills/post-meeting-drill/SKILL.md) | Deep processing of meeting notes with context hydration, entity resolution, thought-routing, urgency assessment, and knowledge persistence. |
| [`prd`](skills/prd/SKILL.md) | Generate a Product Requirements Document (PRD) for a new feature. Use when planning a feature, starting a new project, or when asked to create a PRD. Triggers on: create a prd, write prd for, plan this feature, requirements for, spec out. |
| [`python-standards`](skills/dev-standards/python/SKILL.md) | Python coding standards — 100% type hints, Pydantic for structured data, uv/ruff toolchain, modern 3.12+ idioms. Use when writing or reviewing Python code. |
| [`react-standards`](skills/dev-standards/react/SKILL.md) | React and frontend standards — component purity, hooks rules, server state via TanStack Query, accessibility, performance. Use when writing or reviewing React components or frontend code. |
| [`repo-conventions`](skills/repo-conventions/SKILL.md) | Naming conventions, file placement, lifecycle states, branch naming, and organizational rules for the ai-dev monorepo. Use when asked "where should I put", "how do I name", "what's the convention", or any organizational question. Does NOT cover project creation steps (load create-project) or navigation (load repo-navigation). |
| [`repo-navigation`](skills/repo-navigation/SKILL.md) | How to navigate the ai-dev monorepo, find projects, discover what exists, or understand where things are located. Use when asked "where is", "find the", "what projects exist", "show me", or any navigation question about the repo. Does NOT cover conventions or placement decisions (load repo-conventions). |
| [`rust-standards`](skills/dev-standards/rust/SKILL.md) | Rust coding standards — no unwrap in production, clippy-clean, library-first structure, thiserror/anyhow error handling. Use when writing or reviewing Rust code. |
| [`scorecard-synthesis`](skills/scorecard-synthesis/SKILL.md) | Synthesize hiring scorecards from interview transcripts. Analyzes candidate responses against role criteria and generates structured evaluation with evidence. |
| [`security-standards`](skills/dev-standards/security/SKILL.md) | Security standards — edge input validation, auth/authorization patterns, BOLA checks, secrets handling, PII redaction, OWASP web headers. Use when handling user input, authentication, secrets, or reviewing security. |
| [`self-correction-loop`](skills/self-correction-loop/SKILL.md) | Use when implementing multi-step work where the agent must catch its own mistakes and wrong assumptions during implementation, not at review. Defines the plan → probe → implement → validate → fix loop: a single validation gate, falsifiable assumptions, evidence-gated checkboxes, gate falsifiability, and independent fresh-context verification. Triggers on: implementation loop, self-correction, validation gate, fix own mistakes, verify assumptions, evidence rule, independent verification. |
| [`simple-tasks`](skills/simple-tasks/SKILL.md) | Install a fast local task workflow for single-project planning with `scripts/task.sh` (claim, done, status, reporting) backed by `tasks/TASKS.md` and optional `tasks/details/` notes. Use for lightweight in-progress task coordination, not full team issue tracking. |
| [`skill-generator`](skills/skill-generator/SKILL.md) | Use when creating a new skill, editing an existing skill, or when asked to document a reusable process or technique |
| [`skill-router`](skills/skill-router/SKILL.md) | Search the central Skill Catalog MCP server before complex, unfamiliar, multi-step, high-risk, or domain-specific work. Use read_skill directly when the user names a skill. |
| [`slack-pulse`](skills/slack-pulse/SKILL.md) | Scan Slack for mentions, DMs, and high-value channel activity requiring attention. |
| [`slack-write`](skills/slack-write/SKILL.md) | Use when writing Slack messages, team announcements, or channel posts. Ensures correct mrkdwn formatting instead of Markdown. |
| [`sql-standards`](skills/dev-standards/sql/SKILL.md) | SQL and database standards — schema design, parameterized queries, indexing, versioned migrations. Use when designing schemas, writing SQL, or planning migrations. |
| [`swift-concurrency-standards`](skills/dev-standards/swift-concurrency/SKILL.md) | Swift 6.x concurrency standards — strict actor isolation, Sendable conformance, structured concurrency, legacy GCD replacements, common error fixes. Use when writing async Swift code or fixing concurrency errors. |
| [`swift-standards`](skills/dev-standards/swift/SKILL.md) | Swift & SwiftUI coding standards — deprecated API replacements, SwiftUI architecture, accessibility, type safety, hallucination watch. Use when writing or reviewing Swift or SwiftUI code. |
| [`testing-standards`](skills/dev-standards/testing/SKILL.md) | Testing standards — TDD workflow, testing pyramid (unit/integration/e2e), mocking rules (prefer real over fake), test organization, back-pressure gates. Use when writing, restructuring, or reviewing tests. |
| [`thought-router`](skills/thought-router/SKILL.md) | Route unstructured thoughts, brain dumps, and quick captures to their correct home in the knowledge base. |
| [`tooling-standards`](skills/dev-standards/tooling/SKILL.md) | Tooling standards — task runner preference (just > make), required package managers (pnpm/uv/cargo), AST-based code transformation, linter/formatter matrix. Use when choosing tools, task runners, or setting up linting. |
| [`ts-standards`](skills/dev-standards/ts/SKILL.md) | TypeScript & Node.js coding standards — strict typing, Zod at IO boundaries, async patterns, 3-layer separation, pnpm ecosystem rules. Use when writing or reviewing TypeScript or Node.js code. |
| [`ui-ux-standards`](skills/dev-standards/ui-ux/SKILL.md) | UI/UX interaction standards — keyboard operability, loading/feedback states, accessibility (WCAG), mobile touch targets, design tokens. Use when building or reviewing user-facing UI. |
| [`update-index`](skills/update-index/SKILL.md) | How to maintain index.md catalog files in the ai-dev monorepo. Covers the read-before-write protocol, required columns, By Status regeneration, and staleness checks. Use when adding a project to an index, changing a project's status, or checking for stale entries. Does NOT create projects (load create-project) or write AGENTS.md files (load create-agents-md). |
| [`verify-this`](skills/verify-this/SKILL.md) | Verify a claim with fresh local evidence. Use when asked to prove a fix, confirm behavior, compare before/after results, or produce a VERIFIED, NOT VERIFIED, or INCONCLUSIVE verdict. |
| [`workflow-standards`](skills/dev-standards/workflow/SKILL.md) | Generic git and ops workflow standards — conventional commits, atomic PRs, env config validation, command timeout policy, multi-agent concurrency safety, dependency vetting. Use for git workflow, branching, PRs, or env/config setup in any repo. |
| [`writing-plans`](skills/writing-plans/SKILL.md) | Write and maintain living implementation plans for multi-step work. Use when work has 3+ steps, touches multiple files or subsystems, or may span sessions. |
| [`xcode-makefiles`](skills/xcode-makefiles/SKILL.md) | Install strict Xcode Makefile tooling for iOS/macOS projects, including build/run/test scripts with AGENT_NAME-based per-agent isolation under build/. Use when a project needs reproducible local CLI builds without full app scaffolding. |
| [`xcodebuildmcp`](skills/xcodebuildmcp/SKILL.md) | Official skill for XcodeBuildMCP (preferred). Use when doing iOS/macOS/watchOS/tvOS/visionOS work (build, test, run, debug, log, UI automation). |
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
