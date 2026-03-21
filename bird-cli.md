# bird-cli

**Type:** Tool Integration  
**Trigger:** Twitter, X, tweet, read tweets, trending, bookmarks, mentions

## Purpose

Lightweight integration for the `bird` CLI - a fast X/Twitter command-line tool that uses GraphQL and browser cookies for authentication.

## When to Use

- Reading tweets, threads, or replies
- Searching Twitter/X content
- Checking trending topics and news
- Managing bookmarks
- Viewing mentions, likes, followers, following
- Getting user profile information
- Posting tweets (use sparingly - may trigger blocks)

## Authentication

Bird automatically uses browser cookies (Safari by default). No API keys needed.

## Common Commands

```bash
# Account info
bird whoami

# Read tweets
bird read <tweet-url-or-id>
bird <tweet-id>  # shorthand for read

# Get thread context
bird thread <tweet-url-or-id>
bird replies <tweet-url-or-id>

# Search
bird search "query" -n 20
bird search "from:username" -n 10

# User content
bird user-tweets @username -n 20
bird mentions -n 10

# Bookmarks & likes
bird bookmarks -n 20
bird bookmarks --folder-id <id> -n 10
bird likes -n 20

# Trending & news
bird news -n 10
bird news --ai-only -n 20

# Social graph
bird following -n 20
bird followers -n 20

# User info
bird about @username
```

## JSON Output

Add `--json` to most commands for structured output. Useful for processing multiple tweets or extracting specific data.

```bash
bird search "query" -n 50 --json
bird bookmarks --all --json
bird user-tweets @username -n 100 --json
```

## Important Notes

- **Reading is safe, posting is risky:** X aggressively blocks automated posting. Use sparingly.
- **Undocumented API:** Uses X's internal GraphQL endpoints - may break when X updates.
- **Rate limits:** GraphQL endpoints can return 429 errors if you make too many requests.
- **Cookie sources:** Default is Safari. Override with `--cookie-source chrome` or `--cookie-source firefox`

## Full Documentation

For all options and advanced usage:

```bash
bird --help
bird <command> --help
```

**Official Repository & Docs:** https://github.com/steipete/bird

## Workflow

1. Always start with `bird --help` or `bird <command> --help` for current syntax
2. Use `--json` when you need to process output programmatically
3. Use `--plain` for stable, script-friendly output (no emoji, no color)
4. For pagination, use `-n <count>` or `--all` with `--max-pages`

## Anti-Patterns

- Don't automate tweet posting - you'll get blocked quickly
- Don't assume command syntax - always check `--help` first
- Don't parse human-readable output - use `--json` instead
- Don't spam requests - respect rate limits

---

**This is a lightweight reference. Bird is a standalone CLI tool. Use `bird --help` for authoritative documentation.**
