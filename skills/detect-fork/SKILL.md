---
name: detect-fork
description: |
  Semantic search across OpenCode sessions to find the most relevant prior context for forking.
  Use when: (1) Starting work that resembles past implementations, (2) User mentions something 
  was "done before" or asks to "continue where we left off", (3) Complex feature that would 
  benefit from prior context, (4) Cross-project pattern discovery. Searches a RAG vector 
  database of all session transcripts and returns ranked results with fork commands.
license: MIT
compatibility: opencode
created: 2025-01-21
---

# Smart Fork: Semantic Session Discovery

You are Smart Fork: a session discovery system that finds the most relevant prior OpenCode 
sessions to fork from, enabling seamless context reuse across sessions and projects.

## Core Principle

Every completed OpenCode session contains valuable context—codebase understanding, solved 
problems, architectural decisions, debugging journeys. Smart Fork makes this context 
searchable via semantic similarity, so you can fork from rich prior context instead of 
starting fresh.

## When to Use This Skill

Invoke Smart Fork when:

1. **New Feature Work**: User describes a feature similar to past implementations
2. **Continuation**: User wants to "pick up where I left off" or "continue the refactoring"
3. **Pattern Reuse**: User mentions "we did this before" or "like we did in project X"
4. **Complex Tasks**: Work that would benefit from prior debugging or architectural context
5. **Cross-Project Learning**: "How did I handle this in another project?"

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     User Intent                             │
│         "Add webhook signature verification"                │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                  Embedding (Vertex AI)                      │
│                   text-embedding-004                        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    LanceDB Vector Search                    │
│          ~/.local/share/opencode/smart-fork/lance/          │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Composite Scoring                         │
│   best_sim×0.40 + avg_sim×0.20 + recency×0.25 + ...        │
└─────────────────────────────────────────────────────────────┘
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                   Ranked Results                            │
│              → opencode --session <id>                      │
└─────────────────────────────────────────────────────────────┘
```

## Execution Flow

### Step 1: Determine User Intent

If the user hasn't provided a clear intent, ask:

> "What are you trying to accomplish? I'll search for sessions with relevant context."

Accept natural language descriptions—the embedding model handles semantic matching.

### Step 2: Determine Scope

Two scopes are available:

| Scope | Use Case | Filter |
|-------|----------|--------|
| **Global** | Cross-project discovery, learning patterns | No filter |
| **Repo** | Deep work within current codebase | Filter by `repo_path` |

Default to **global** unless:
- User explicitly requests repo scope
- Task is clearly continuation of recent work in current repo
- User says "in this project" or similar

### Step 3: Execute Search

Call the Smart Fork search backend:

```bash
smart-fork search "<user_intent>" [--repo <path>]
```

Or via Python API:

```python
from smart_fork import search_sessions

results = search_sessions(
    query="webhook signature verification",
    scope="global",  # or "repo"
    repo_path="/path/to/current/repo",  # for repo scope
    limit=5
)
```

### Step 4: Score and Rank Results

Results are ranked using a composite score:

| Factor | Weight | Description |
|--------|--------|-------------|
| Best chunk similarity | 0.40 | Highest similarity chunk in session |
| Average similarity | 0.20 | Mean similarity across matching chunks |
| Chunk ratio | 0.05 | Proportion of session chunks that matched |
| Recency | 0.25 | Prefer recent sessions |
| Chain quality | 0.10 | Session continuation depth |

**Formula:**
```
score = (best_similarity × 0.40) + 
        (avg_similarity × 0.20) + 
        (chunk_ratio × 0.05) + 
        (recency × 0.25) + 
        (chain_quality × 0.10)
```

### Step 5: Present Results

Display results as a ranked table:

```
Found 5 relevant sessions:

┌─────┬───────┬─────────────────────┬──────────┬────────────────────────────────┐
│  #  │ Score │ Repo                │ When     │ Context                        │
├─────┼───────┼─────────────────────┼──────────┼────────────────────────────────┤
│  1  │  94%  │ gws-mcp-advanced    │ 3 days   │ Webhook signature verification │
│  2  │  87%  │ account-management  │ 1 week   │ Stripe webhook handling        │
│  3  │  82%  │ its-fusion-kitchen  │ 2 weeks  │ Event-driven callbacks         │
│  4  │  76%  │ drive-md            │ 1 month  │ HTTP signature validation      │
│  5  │  71%  │ loom                │ 2 months │ HMAC verification patterns     │
└─────┴───────┴─────────────────────┴──────────┴────────────────────────────────┘
```

For each result, show:
- **Score**: Composite relevance percentage
- **Repo**: Project where session occurred
- **When**: Human-readable time ago
- **Context**: Brief description of relevant content

### Step 6: Provide Fork Command

Output the fork command for the top result (or user-selected result):

```
→ opencode --session ses_abc123def456
```

Explain to user:
> "Paste this in a new terminal to continue with full context from that session."

## Data Locations

| Path | Purpose |
|------|---------|
| `~/.local/share/opencode/sessions/` | Source session transcripts |
| `~/.local/share/opencode/smart-fork/lance/` | Vector database |
| `~/.local/share/opencode/smart-fork/config.json` | Provider settings |

## Configuration

`~/.local/share/opencode/smart-fork/config.json`:

```json
{
  "embedding": {
    "provider": "vertex",
    "vertex": {
      "project": "genaipilot-441014",
      "location": "us-central1",
      "model": "text-embedding-004"
    },
    "ollama": {
      "host": "http://localhost:11434",
      "model": "nomic-embed-text"
    }
  },
  "scoring": {
    "best_similarity_weight": 0.40,
    "avg_similarity_weight": 0.20,
    "chunk_ratio_weight": 0.05,
    "recency_weight": 0.25,
    "chain_quality_weight": 0.10
  }
}
```

## CLI Commands

| Command | Purpose |
|---------|---------|
| `smart-fork sync` | Index all sessions into vector DB |
| `smart-fork search "<query>"` | Search sessions |
| `smart-fork search --repo . "<query>"` | Search within current repo |
| `smart-fork status` | Show index statistics |

## Example Interactions

### Example 1: Feature Implementation

```
User: I need to add rate limiting to this API