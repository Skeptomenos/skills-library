---
name: identity-discovery
description: >-
  Discover the user's digital identity (emails, account IDs) by leveraging
  filesystem context from path-discovery. Required for MCP tool handshaking.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - discover identity
  - who am I
  - resolve email
  - MCP identity
  - account context
when_to_use:
  - >-
    A skill or workflow needs the user's email, account IDs, KB root, or digital
    identity.
  - Tool calls require identity context that is not already supplied.
  - A personal workflow needs account resolution before continuing.
when_not_to_use:
  - The necessary identity context is already known.
  - The task is repository-only and does not need personal account data.
  - The user is asking to change identity configuration rather than discover it.
created: 2026-01-09T00:00:00.000Z
updated: 2026-01-21T00:00:00.000Z
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
