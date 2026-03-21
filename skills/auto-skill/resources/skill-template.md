---
name: skill-template
description: Reference template for creating new skills via auto-skill extraction
---

# Skill Template for Auto-Skill Extraction

Use this template when extracting knowledge into a new skill.

---

## SKILL.md Template

```markdown
---
name: [descriptive-kebab-case-name]
description: |
  [REQUIRED: Precise description that enables semantic matching. Include:
  (1) What problem this solves
  (2) Specific trigger conditions - exact error messages, symptoms, scenarios
  (3) Key technologies/frameworks involved
  Use phrases like "Use when:", "Helps with:", "Solves:"]
license: MIT
compatibility: opencode
---

# [Skill Name - Human Readable Title]

## Problem

[Clear, concise description of the problem this skill addresses. 
What pain point does this solve? Why is it non-obvious?]

## Context / Trigger Conditions

[When should this skill be activated? Be specific:]

- [Exact error message 1]
- [Exact error message 2]
- [Observable symptom or behavior]
- [Environmental condition (framework, tool, platform)]

## Solution

[Step-by-step instructions to resolve the problem]

### Step 1: [First Action]

[Detailed instructions with code examples if applicable]

```language
// Example code
```

### Step 2: [Second Action]

[Continue with clear, actionable steps]

### Step 3: [Third Action]

[Include alternatives or variations if relevant]

## Verification

[How to confirm the solution worked:]

1. [Verification step 1]
2. [Verification step 2]
3. [Expected outcome]

## Example

**Scenario**: [Concrete example of when this skill applies]

**Before**:
```
[Error message or problematic code]
```

**After**:
```
[Fixed code or successful output]
```

## Notes

[Important caveats, edge cases, and related considerations:]

- [Caveat 1]
- [Related skill or documentation link]
- [Known limitation]
- [When NOT to use this skill]

## References

[Links to official documentation, articles, or resources that informed this skill]

- [Source 1](url)
- [Source 2](url)
```

---

## Extraction Checklist

Before saving a new skill, verify:

- [ ] Name is descriptive and uses kebab-case
- [ ] Name matches parent directory
- [ ] Description includes specific error messages/symptoms
- [ ] Description starts with action phrase ("Use when...", "Fix for...")
- [ ] Problem is clearly stated
- [ ] Trigger conditions are specific and searchable
- [ ] Solution is step-by-step and actionable
- [ ] Code examples are complete and tested
- [ ] Verification steps are included
- [ ] Example is concrete and realistic
- [ ] Notes cover edge cases and caveats
- [ ] No sensitive information (credentials, internal URLs)
- [ ] References section included if web sources were consulted

---

## Description Writing Guidelines

The description is what the skill loader sees. Make it count.

### Good Description Patterns

```yaml
description: |
  Fix for "ENOENT: no such file or directory" errors when running npm scripts 
  in monorepos. Use when: (1) npm run fails with ENOENT in a workspace, 
  (2) paths work in root but not in packages.
```

```yaml
description: |
  Debug getServerSideProps and getStaticProps errors in Next.js. Use when: 
  (1) Page shows generic error but browser console is empty, (2) API routes 
  return 500 with no details. Check terminal for actual errors.
```

```yaml
description: |
  Resolve PrismaClientKnownRequestError: Too many database connections in 
  serverless environments. Use when connection count errors appear after 
  ~5 concurrent requests in Vercel, AWS Lambda, or similar.
```

### Bad Description Patterns

```yaml
# Too vague - won't match anything useful
description: Helps with database problems

# Summarizes workflow instead of triggers
description: A skill that first checks the logs, then restarts the service

# No specific symptoms
description: Use when you have errors in your Next.js app
```

---

## File Locations

| Scope | Path |
|-------|------|
| Project-specific | `.opencode/skills/[skill-name]/SKILL.md` |
| User-wide | `~/.config/opencode/skills/[skill-name]/SKILL.md` |
| Cross-tool compatible | `.claude/skills/[skill-name]/SKILL.md` |

---

*Template v1.0.0 | For use with auto-skill extraction*
