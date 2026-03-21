---
name: scorecard-synthesis
description: Synthesize hiring scorecards from interview transcripts. Analyzes candidate responses against role criteria and generates structured evaluation with evidence.
---

# Scorecard Synthesis

**Core principle:** Forensically audit candidate performance against the hiring bar—not summarize, but analyze with evidence.

---

## When to Use

- After completing a candidate interview
- Have a transcript (from meeting notes, recording, or manual notes)
- Need structured evaluation with HIRE/NO HIRE recommendation

**Do NOT use when:**
- Preparing for interview (use interview-prep)
- No transcript or notes available

---

## Quick Reference

| Input | Source |
|-------|--------|
| Interview Transcript | Meeting transcript, manual notes, or recording |
| Prepared Questions | Output from interview-prep skill |
| Candidate CV | Gmail attachment or Google Drive |
| Target Career Step | Established during interview-prep |

---

## Process

### 1. Identify Target

Confirm:
- `candidate_name`
- `target_career_step`

### 2. Select Lens

Ask user which scorecard type:
- **Technical**: Focus on technical depth, system design, coding skills
- **Hiring Manager**: Focus on cultural fit, leadership, collaboration

### 3. Artifact Retrieval

```
Gather: Full meeting transcript
Read: Manual notes from session
Read: Prepared questions (from interview-prep output)
Read: Candidate CV for baseline facts
```

### 4. Delegate to Hiring Analyst Agent

Launch a subagent with the Hiring Analyst persona:

```
task(
  subagent_type="general",
  description="Synthesize Scorecard for [Candidate]",
  prompt="You are acting as the Hiring Analyst agent (see docs/hiring-analyst-agent.md).
  
  Perform a DIRECT EXECUTION with these inputs:
  - Lens: [Technical or Hiring Manager]
  - Full Transcript: [Transcript Content]
  - Manual Notes: [Notes]
  - Prepared Questions: [Questions with Evaluation Guides]
  - Target Career Step: [Career Step]
  
  Generate a Zero Trust scorecard with evidence."
)
```

### 5. Parse and Save Output

The agent output contains two sections separated by `===QA_LOG_START===`:

| Section | Content | Save To |
|---------|---------|---------|
| Part 1 | Scorecard (Verdict, DNA Test, Analysis) | `[Candidate]/scorecard.md` |
| Part 2 | Q&A Log (Detailed question analysis) | `[Candidate]/qa_log.md` |

Update your hiring tracker with the result summary.

---

## Related Docs

- `docs/hiring-analyst-agent.md` — The Hiring Analyst agent persona
- `docs/hiring-standards.md` — Hiring standards and cultural rubric (shared with interview-prep)

---

## Common Mistakes

| Mistake | Fix |
|---------|-----|
| Summarizing instead of auditing | Every claim must have a quote or specific evidence from transcript |
| Giving benefit of the doubt | Zero Trust: if keyword/metric not in transcript, mark as WEAK |
| Ignoring CV discrepancies | Flag any gap between CV claims and interview answers as Red Flag |
