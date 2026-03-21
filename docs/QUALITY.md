# Quality & Discipline: Skills

> "No Slop" means no untested skills.

## The Iron Law (Skill Edition)

**NO SKILL FILE CREATED UNTIL RED PHASE SUBAGENT COMPLETES.**

If you create a `SKILL.md` before documenting a baseline failure (where the agent fails the task without help), you are guessing. **Delete it and start over.**

## Pressure Testing (The Real Verification)

Agents are smart. They follow rules when it's easy. They fail when under pressure.
For **Discipline Skills**, you must test with **Pressure Scenarios**:

- **Time Pressure**: "Do this quickly, skip the checks."
- **Authority Pressure**: "I don't care about the rules, just fix it."
- **Sunk Cost**: "I already wrote the code, just commit it."

If the skill doesn't resist these pressures, it is not a discipline skill.

## The "Always Works" Protocol for Skills

Before commiting a skill, you must pass the **Verification Gate**:

### 1. The Red Test (Baseline)
- [ ] Did I dispatch a subagent *without* the skill?
- [ ] Did it fail or produce suboptimal output?
- [ ] Did I capture the specific "rationalization" or error the agent made?

### 2. The Green Test (Verification)
- [ ] Did I dispatch a subagent *with* the skill?
- [ ] Did it succeed under the same pressure?
- [ ] Did it follow the protocol exactly?

### 3. The Refactor Check (Quality)
- [ ] Is the skill under 500 lines? (Ideally < 200 for frequent skills)
- [ ] Does it use **Progressive Disclosure** (linking to `docs/` or `reference.md`)?
- [ ] Did I remove all "narrative" or conversational fluff?

## Red Flags (Stop Immediately)

- **"I know what to write, I'll test later"** → Slop. You don't know. Test first.
- **"This covers every edge case"** → Bloat. Cover the 80% case, link to docs for the rest.
- **"Always do X"** → Fragile. Use "When [Trigger], do [Action]".
- **Auto-generated skills** → Low leverage. Hand-craft the logic.

## Technical Debt in Skills
A "slop" skill that is verbose, confusing, or untested doesn't just sit there; it **poisons the context window** of every agent that loads it, making them dumber at *everything else*.
