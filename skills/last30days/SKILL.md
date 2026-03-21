---
name: last30days
description: Research any topic across Reddit, X, and the web from the last 30 days. Best for prompt research and trend discovery.
metadata:
  {
    "openclaw": {
      "emoji": "📅",
      "requires": { 
        "bins": ["bird"], 
        "env": ["OPENAI_API_KEY"] 
      },
      "install": [
        {
          "id": "npm",
          "kind": "npm",
          "package": "@steipete/bird",
          "bins": ["bird"],
          "label": "Install Bird CLI for X search"
        }
      ]
    }
  }
---

# /last30days

Research any topic across Reddit and X from the last 30 days. This skill finds what the community is actually sharing and upvoting, then synthesizes patterns or writes copy-paste-ready prompts.

## Phase 1: Context Discovery
Identify the topic and the target tool (if any).
- Trigger: `/last30days [topic]` or `/last30days [topic] for [tool]`

## Phase 2: Parallel Scans
Execute research across platforms:
- **Reddit:** Scanned via OpenAI Responses API.
- **X (Twitter):** Scanned via Bird CLI (preferred) or xAI key.
- **Web:** Blogs and news documentation.

## Phase 3: Synthesis
Consolidate findings into:
1. **Research Summary:** Key patterns and community sentiment.
2. **Engagement Stats:** Upvotes, likes, and source diversity.
3. **Generated Output:** A copy-paste-ready prompt or an expert-level answer.

## Options
- `--days=N`: Change lookback window (default 30).
- `--quick`: Faster research with fewer sources.
- `--deep`: Comprehensive research with extended supplemental search.

## Requirements
- `OPENAI_API_KEY`: Required for Reddit synthesis.
- `bird` CLI: Recommended for free X search.
