---
name: skill-router
description: Search the central Skill Catalog MCP server before complex, unfamiliar, multi-step, high-risk, or domain-specific work. Use read_skill directly when the user names a skill.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - "find relevant skill"
  - "local guidance"
  - "complex work"
  - "multi-step work"
  - "high-risk work"
  - "domain-specific work"
when_to_use:
  - "A specialized skill may exist but is not already loaded."
  - "The work is complex, unfamiliar, multi-step, high-risk, or domain-specific."
  - "The user names a skill or asks for local operating guidance."
when_not_to_use:
  - "The request is a trivial one-shot answer or obvious shell command."
  - "The active repository instructions already fully cover the work."
---

# Skill Router

Use this skill to keep native skill context small while still making the full catalog available on demand.

## When To Use

- Complex, unfamiliar, multi-step, high-risk, or domain-specific work.
- Work where a specialized skill may exist but is not already loaded.
- User asks to use a named skill.

## Protocol

1. If the user names a skill, call `read_skill` with that skill name.
2. Otherwise call `search_skills` with a concise task query.
3. Read the best matching skill with `read_skill` only when it is relevant.
4. Read reference files only when the loaded skill explicitly points to them.

Skip catalog search for trivial one-shot answers, obvious shell commands, or work already fully covered by active repository instructions.
