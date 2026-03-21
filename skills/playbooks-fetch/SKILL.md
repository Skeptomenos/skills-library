---
name: playbooks-fetch
description: Use when fetching web content as markdown, especially for client-side rendered (SPA) pages where WebFetch fails or returns incomplete content.
license: MIT
compatibility: opencode
---

# Playbooks Fetch

**Core principle:** Use `npx playbooks get <url>` for reliable URL-to-markdown conversion, especially for JavaScript-heavy sites.

---

## When to Use

- Fetching content from SPAs or client-side rendered pages
- When WebFetch returns incomplete, empty, or garbled content
- When you need clean markdown with YAML frontmatter (title, description, url)
- When you need to verify if a page required headless browser rendering

**Do NOT use for:** Simple static pages where WebFetch works fine.

---

## Quick Reference

```bash
# Basic: output markdown to stdout
npx playbooks get <url>

# Save to file
npx playbooks get <url> out notes.md

# JSON with metadata (includes rendering strategy info)
npx playbooks get <url> --json
```

---

## Output Format

### Markdown Output
```markdown
---
title: "Page Title"
description: "Meta description"
url: "https://final-url-after-redirects/"
---

## Content heading
Page content as clean markdown...
```

### JSON Output (--json flag)
```json
{
  "markdown": "---\ntitle: ...",
  "title": "Page Title",
  "description": "Meta description", 
  "finalUrl": "https://...",
  "report": {
    "strategy": "readability",
    "wasHeadless": false
  }
}
```

**Key metadata:**
- `wasHeadless: true` = Page required browser rendering (CSR/SPA)
- `wasHeadless: false` = Static content extraction worked

---

## Process

1. **Identify need**: WebFetch failed, returned empty, or content looks incomplete
2. **Run command**: `npx playbooks get <url>` via Bash tool
3. **Use output**: Content is clean markdown, ready to use

---

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| Using for every URL | Only use when WebFetch insufficient |
| Forgetting timeout | Add `--timeout` for Bash if page is slow |
| Ignoring JSON metadata | Use `--json` to debug rendering issues |

---

## Red Flags

- If `npx` is not available, inform user to install Node.js
- If command hangs, the page may have anti-bot protection
- If output is empty, page may require authentication

---

## Verification

After fetching:
- [ ] Content has YAML frontmatter with title/description
- [ ] Markdown is clean and readable
- [ ] No garbled JS or HTML fragments
