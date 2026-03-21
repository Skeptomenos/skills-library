---
name: bird-cli
description: Use when reading X/Twitter posts, tweets, threads, or x.com links. Also for searching Twitter content, trending topics, bookmarks, mentions, and user profiles via CLI.
license: MIT
compatibility: opencode
updated: 2026-02-01
---

# bird-cli

Fast X/Twitter command-line tool using GraphQL and browser cookies (no API keys needed).

## When to Use

- Read tweets, threads, replies
- Search Twitter/X content
- Check trending topics and news
- View bookmarks, mentions, likes
- Get user profiles and social graphs

## Core Commands

```bash
# Read tweets & threads
bird read <tweet-url-or-id>
bird thread <tweet-url-or-id>
bird replies <tweet-url-or-id>

# Search & discover
bird search "query" -n 20
bird news -n 10
bird news --ai-only -n 20

# User content
bird user-tweets @username -n 20
bird mentions -n 10
bird bookmarks -n 20

# Profile & social
bird about @username
bird following -n 20
bird followers -n 20
```

## JSON Mode

Add `--json` for structured output:

```bash
bird search "query" -n 50 --json
bird bookmarks --all --json
```

## Critical Rules

1. **Check syntax first:** Always run `bird --help` or `bird <command> --help` before using
2. **Use JSON for parsing:** Never parse human-readable output, use `--json`
3. **Respect rate limits:** GraphQL endpoints return 429 on excessive requests
4. **Avoid posting:** X blocks automated tweets aggressively

## Auth

Uses browser cookies automatically (Safari default). Override: `--cookie-source chrome`

## Docs

Full reference: https://github.com/steipete/bird
