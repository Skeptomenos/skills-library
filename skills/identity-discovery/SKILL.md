---
name: identity-discovery
description: Discover the user's digital identity (emails, account IDs) by leveraging filesystem context from path-discovery. Required for MCP tool handshaking.
triggers: 
created: 2026-01-09
updated: 2026-01-21
---

<!--
ARCHITECTURE REFERENCE: docs/concepts/skill-architecture.md
This is an "OS" level skill. It calls path-discovery (BIOS) internally to get the filesystem context before resolving accounts.
-->

# Identity Discovery

**Core principle:** Resolve "Who am I?" by mapping filesystem location to digital accounts and MCP credentials, adapting to floating hemispheres and non-standard folder names.

---

## Process

### Phase 1: Environment Handshake (BIOS)
First, invoke `path-discovery` to get the Knowledge Base context.

```
skill({ name: "path-discovery" })
```

**Store returned values:** `kb_root`, `mode`, `hemisphere`.

### Phase 2: Resolve Digital Identity
Based on the `mode` and `hemisphere`, extract account details.

#### 1. Locate the Identity File
Search for the identity file in this priority:
1. `{kb_root}/{hemisphere}/AGENTS.md`
2. `./AGENTS.md` (if in single mode or floating)
3. `{kb_root}/{hemisphere}/digital-identity.md`
4. `{kb_root}/{hemisphere}/_identity.md`

#### 2. Extract Email (Gmail/Google Workspace)
Find the **MCP Tool Configuration** table in the identified file:

| MCP Server | Required Parameter | Value |
|------------|-------------------|-------|
| google-workspace | user_google_email | user@example.com |

**Flexible Extraction:** If the table is missing, search the file for any line containing `user_google_email` or `email:`.

#### 3. Resolve Atlassian Identity (Jira/Confluence)
If Atlassian tools are present in the environment:
1. Call `atlassian_atlassianUserInfo()` to get your `accountId`.
2. Call `atlassian_getAccessibleAtlassianResources()` to get your `cloudId`.
3. If multiple resources exist, check for a `jira-config.json` in the hemisphere or root.

### Phase 3: Build Combined Context
Return a unified object that includes both filesystem and identity data.

**Example (Single Mode):**
```json
{
  "kb_root": "/path/to/thoth-kb",
  "mode": "single",
  "hemisphere": "work",
  "identity": {
    "email": "user@company.com",
    "atlassian": {
      "accountId": "...",
      "cloudId": "..."
    }
  },
  "ready": true
}
```

---

## Backward Compatibility
This skill MUST return the `kb_root` and `mode` fields in the root of the response object so that existing skills (like `morning-boot` and `evening-close`) do not break.

---

*Identity Discovery v2.2 | Layered Identity Resolution*
