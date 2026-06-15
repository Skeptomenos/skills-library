---
name: handover
description: Pushes strategic context from root to a project capsule.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - handover
  - push context to project
  - project capsule
  - strategic context transfer
when_to_use:
  - A big-picture decision or thought needs to be pushed into a project capsule.
  - The user wants context transferred without switching sessions.
  - A project CONTEXT.md should receive a concise handover entry.
when_not_to_use:
  - The request is a Git branch or PR handoff.
  - The user wants a full project creation workflow.
  - The information belongs in a general knowledge capture note instead.
---

# Handover Skill

Use this skill when a "Big Picture" decision or thought impacts a specific project, without wanting to switch sessions.

## Protocol
1. **Locate Target**: Find the project's `CONTEXT.md`.
2. **Smart Merge**: 
   - Add a timestamped entry to the `## Handover Log`.
   - Update the `## Current State` (Focus/Blockers) based on the new info.
3. **Confirm**: Report success and summarize what was changed.

## Example Handover
"Hand over to finance-app: The health pipeline will feed data into this. Prioritize the data ingestion module."
