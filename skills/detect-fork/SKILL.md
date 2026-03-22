---
name: detect-fork
description: |
  Semantic search across OpenCode sessions to find relevant prior context.
  Use when: (1) Starting work that resembles past implementations, (2) User mentions something 
  was "done before" or asks to "continue where we left off", (3) Complex feature that would 
  benefit from prior context, (4) Cross-project pattern discovery. Searches QMD's session 
  index and returns ranked results. Default: read and learn from prior sessions in the current
  session. Fork only when explicitly requested.
license: MIT
compatibility: opencode
created: 2025-01-21
updated: 2026-03-22
---

# Session Discovery: Find and Learn from Prior Work

You are a session discovery system that finds relevant prior OpenCode sessions,
extracts learnings from them, and applies that knowledge to the current task —
so you build on past work instead of starting from scratch.

## Core Principle

Every completed OpenCode session contains valuable context — codebase understanding,
solved problems, architectural decisions, debugging journeys. This skill makes that
context searchable and reusable.

**Default mode: Read and Learn.** Stay in the current session, search for relevant
prior sessions, read the key findings, and apply them here. No context switching.

**Fork mode (only when requested):** Leave the current session and open a prior
session with its full conversation history intact.

## When to Use This Skill

Invoke when:

1. **New Feature Work**: User describes a feature similar to past implementations
2. **Continuation**: User wants to "pick up where I left off" or "continue the refactoring"
3. **Pattern Reuse**: User mentions "we did this before" or "like we did in project X"
4. **Complex Tasks**: Work that would benefit from prior debugging or architectural context
5. **Cross-Project Learning**: "How did I handle this in another project?"

## Execution Flow

### Step 1: Determine User Intent

If the user hasn't provided a clear intent, ask:

> "What are you trying to accomplish? I'll search for sessions with relevant context."

Accept natural language descriptions — QMD handles semantic matching.

### Step 2: Search QMD

Use the `qmd_query` MCP tool to search the `opencode-sessions` collection:

```
qmd_query:
  searches:
    - type: vec
      query: "<user's intent as a natural language question>"
    - type: lex
      query: "<key terms from the intent>"
  collections: ["opencode-sessions"]
  limit: 5
```

For repo-scoped search (current project only), add a lex filter:
```
    - type: lex
      query: "directory: /path/to/current/repo"
```

### Step 3: Present Results

Display results as a ranked list:

```
Found 3 relevant sessions:

1. [94%] "Webhook signature verification" — gws-mcp-advanced, 3 days ago
   Key context: implemented HMAC-SHA256 verification, solved timing attack issue

2. [87%] "Stripe webhook handling" — account-management, 1 week ago
   Key context: retry logic, idempotency keys, error handling patterns

3. [76%] "Event-driven callbacks" — its-fusion-kitchen, 2 weeks ago
   Key context: webhook registration, payload validation
```

### Step 4: Read and Learn (Default)

For the top result (or user-selected result), fetch the full session content:

```
qmd_get:
  file: "opencode-sessions/<session-id>.md"
```

Read the session and extract:
- **Key decisions** made during the session
- **Problems encountered** and how they were solved
- **Architecture patterns** used
- **Code patterns** worth reusing
- **Mistakes** to avoid

Present a structured summary:

```
## Learnings from "Webhook signature verification" (3 days ago)

**Problem solved:** API endpoint accepted unsigned webhooks — security vulnerability.

**Approach:** HMAC-SHA256 with constant-time comparison to prevent timing attacks.
Used `crypto.timingSafeEqual()` instead of `===`.

**Key files:** `src/middleware/webhook-verify.ts`, `tests/webhook.test.ts`

**Gotchas discovered:**
- Raw body must be preserved before JSON parsing (Express consumes it)
- Signature header format varies by provider (Stripe vs GitHub vs custom)

**Applicable to current task:** Yes — the timing-safe comparison pattern
and raw body preservation are directly relevant.
```

Continue working in the current session with these learnings applied.

### Step 5: Fork (Only When Explicitly Requested)

If the user explicitly asks to fork ("fork that session", "continue in that session"):

Provide the fork command:

```
→ opencode --session ses_abc123def456
```

Explain the tradeoff:

> "This opens a new terminal session with the full conversation history from that session.
> You'll have all the context but will lose the current session's context.
> The forked session's code references may be stale if the codebase changed since then."

**When fork is better than read:**
- Literally continuing interrupted work from yesterday
- The prior session has deep, multi-step context that's hard to summarize
- Same project, codebase hasn't changed

**When read is better than fork:**
- Different project, reusing patterns
- Codebase has changed significantly
- Only need specific findings, not the full journey
- You've already built up context in the current session

## Data Source

| Component | Location |
|-----------|----------|
| Session transcripts | `~/.local/share/qmd/sessions/*.md` (exported from opencode.db) |
| QMD index | `~/.cache/qmd/index.sqlite` |
| QMD MCP tools | `qmd_query`, `qmd_get`, `qmd_status` |

Sessions are exported incrementally by `scripts/qmd-sync.sh` (runs every 30 min via LaunchAgent).

## QMD Query Tips

**Broad search** (cross-project discovery):
```
searches:
  - type: vec
    query: "how to implement rate limiting"
collections: ["opencode-sessions"]
```

**Targeted search** (specific project):
```
searches:
  - type: lex
    query: "directory: /Users/david.helmus/repos/ai-dev rate limiting"
  - type: vec
    query: "rate limiting implementation"
collections: ["opencode-sessions"]
```

**Search all collections** (sessions + docs + knowledge base):
```
searches:
  - type: vec
    query: "rate limiting patterns"
# no collections filter = searches everything
```
