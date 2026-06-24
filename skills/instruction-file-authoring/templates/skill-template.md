---
name: skill-name            # MUST match the parent directory name
description: "What it solves + exact trigger symptoms/conditions ('Use when …'). This is the discovery key the model reads to decide whether to load the skill."
compatibility: opencode
---

# Skill Name

## When to Use
- Trigger conditions.
- "Do not use this skill for <exclusions>."

## Preconditions
VERIFY these before starting. If any fail, stop and report.
- [ ] <precondition 1>

## Inputs Required
- <input 1>
- <input 2>

## Steps

### Step 1 — <title>
1. <atomic action>
2. <atomic action>
VERIFY: <checkpoint>

### Step 2 — <title>
1. <atomic action>
VERIFY: <checkpoint>

## Done Criteria
DONE WHEN all of the following are true:
- [ ] <criterion 1>
- [ ] <criterion 2>

## Error Recovery
1. Do not continue to the next step.
2. State which step failed and paste the exact error.
3. Attempt to fix within the current step scope only.
