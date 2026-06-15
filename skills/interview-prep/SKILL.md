---
name: interview-prep
description: >-
  Generate tailored interview questions for hiring candidates. Gathers job
  description, resume, and hiring standards to create focused, role-appropriate
  questions.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - interview prep
  - prepare for interview
  - candidate packet
  - hiring loop
---

# Interview Prep

**Core principle:** Generate high-fidelity interview questions by gathering context and delegating to a specialized agent.

---

## When to Use

- Preparing for a candidate interview
- Need structured questions with evaluation guides
- Want questions tailored to specific role/career level

**Do NOT use when:**
- Conducting the actual interview (use questions already generated)
- Synthesizing results after interview (use scorecard-synthesis)

---

## Quick Reference

| Input | Source |
|-------|--------|
| Job Description | Google Drive or provided by user |
| Candidate CV/Resume | Gmail attachment or Google Drive |
| Hiring Standards | `docs/hiring-standards.md` (customize for your org) |
| Target Career Step | User provides (e.g., Junior, Senior, Staff) |

---

## Process

### 1. Identify Target

Confirm with user:
- `candidate_name`
- `target_career_step` (e.g., Senior, Staff, CS5)
- `primary_goal` (e.g., "validate system design skills", "assess cultural fit")

### 2. Context Retrieval

```
Read: docs/hiring-standards.md (for cultural rubric)
Search Gmail: candidate's resume/CV
Search Drive: Job Description document
```

### 3. Delegate to InterviewCraft Agent

Launch a subagent with the InterviewCraft persona:

```
task(
  subagent_type="general",
  description="Generate Interview Questions for [Candidate]",
  prompt="You are acting as the InterviewCraft agent (see docs/interview-craft-agent.md).
  
  Perform a DIRECT EXECUTION with these inputs:
  - Hiring Standards: [Standards Context]
  - Job Description: [JD Content]
  - Candidate CV: [CV Content]
  - Goal: [Primary Goal]
  - Target Career Step: [Career Step]
  
  Generate questions with evaluation guides."
)
```

### 4. Save Output

Save the generated questions to your preferred location:
- Interview prep folder
- Candidate tracking system
- Hiring pipeline document

---

## Related Docs

- `docs/interview-craft-agent.md` — The InterviewCraft agent persona
- `docs/hiring-standards.md` — Hiring standards and cultural rubric

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Generic questions | Ensure CV and JD are loaded; questions should reference candidate's specific experience |
| Missing evaluation guides | Every question MUST have a guide explaining good/average/bad answers |
| Internal info leakage | Never mention internal project names or crises to candidates |
