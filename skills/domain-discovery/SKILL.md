---
name: domain-discovery
description: Structured discovery for new domains using breadth-before-depth interviewing. Maps the landscape of people, projects, and challenges before diving deep. Feeds into knowledge-capture for persistence.
---

# Domain Discovery

**Core principle:** Map the landscape before diving deep. Breadth-first discovery prevents the "depth trap" where you learn everything about one thing and nothing about everything else.

---

## When to Use

- Starting work with a new domain (work, life, specific area)
- User says "help me set up tracking for X"
- User wants you to "learn about my [team/projects/situation]"
- Beginning of a longer engagement with a new context

**Do NOT use when:**
- User is sharing a quick thought (use knowledge-capture)
- User already has established KB structure
- User wants to take action, not discover

---

## Quick Reference

| Phase | Focus | Output |
| ----- | ----- | ------ |
| Orient | Scope, goals, sources | Clear boundaries |
| Scan | Data from email/calendar (if available) | Entity list |
| Discover | Interview for people, projects, challenges | Landscape map |
| Step Back | "What else?" before going deep | Complete picture |
| Deepen | Detail prioritized entities | Knowledge files |
| Close | Summary, gaps, expectations | Next steps |

---

## Philosophy

1. **Breadth before depth** — Map the landscape before diving deep
2. **Step back pattern** — After 5-10 minutes on any topic, ask "What else?"
3. **Prevent premature action** — Focus on understanding, not doing
4. **Structured but conversational** — Have a framework, follow user's energy
5. **Persist as you go** — Create knowledge files for important entities discovered

---

## Process

### Phase 1: Orient

Ask these questions before anything else:

```
1. What domain are we discovering? (work, life, specific project, area)
2. What's the goal? (understand context, set up tracking, prepare for something)
3. What data sources are available? (email, calendar, documents, nothing yet)
```

**Output:** Clear understanding of scope and available data.

### Phase 2: Scan (If Data Available)

If user has connected email, calendar, or documents:

1. Scan recent emails for people, projects, recurring themes
2. Scan calendar for meetings, recurring events, key people
3. Synthesize findings:
   - Key people mentioned
   - Active projects/areas
   - Recurring themes
   - Open items/commitments

**Output:** Data-driven overview of the domain landscape.

### Phase 3: Discover (Interview)

Ask clarifying questions about what you found (or start here if no data):

| Area | Questions |
| ---- | --------- |
| **People** | Who are the key people? (just names for now) |
| **Projects/Areas** | What are the main projects or areas of focus? |
| **Challenges** | What's the biggest challenge or pain point? |
| **Success** | What does success look like? What are you optimizing for? |
| **Gaps** | What's not working? What falls through the cracks? |

**Key rule:** Collect NAMES and TOPICS first. Don't drill into any one area yet.

**Output:** List of people, projects, challenges, and goals.

### Phase 4: Step Back (CRITICAL)

After covering one area for 5-10 minutes, ALWAYS ask:

- "We've covered [X]. Before going deeper, are there other areas we should map out?"
- "What else is on your mind that we haven't touched?"
- "Is there anything blocking you that we should address first?"
- "Are there other people or projects I should know about?"

**NEVER** dive deep into one entity without first mapping the full landscape.

**Anti-Pattern Detection:** If you've been discussing one project or person for >5 minutes without asking about others, STOP and step back.

### Phase 5: Deepen (After Breadth)

Once the landscape is mapped, ask which area to explore first:

- "We've identified [projects A, B, C] and [people X, Y, Z]. Which would you like to detail first?"
- "What's most urgent or important to capture deeply?"

For each prioritized entity, invoke knowledge-capture:

```
skill({ name: "knowledge-capture", context: { entity: "Sarah Chen", type: "person" } })
```

### Phase 6: Close

Before ending the discovery session:

1. **Summarize** what was learned:
   - Domain scope
   - Key entities discovered
   - Relationships identified

2. **Identify gaps** for follow-up:
   - "We didn't get to [X, Y, Z]. Should we cover that next time?"
   - "I'm missing context on [A, B]. Can we discuss later?"

3. **Set expectations**:
   - "I'll continue learning as we interact. Correct me when I'm wrong."
   - "Mention new people or projects as they come up."

---

## Anti-Pattern: The Depth Trap

### WRONG

```
User: "Let's learn about my work"
Agent: "Tell me about Project Alpha"
User: [explains Project Alpha for 20 minutes]
Agent: [asks more Project Alpha questions]
[30 minutes later, deep in Project Alpha details]
[Never asked about other projects, colleagues, goals]
```

### RIGHT

```
User: "Let's learn about my work"
Agent: "Before we dive deep, let me understand the landscape. 
        Who are the key people you work with?"
User: [lists 5 people]
Agent: "And what are the main projects you're focused on?"
User: [lists 3 projects]
Agent: "Got it. What's your biggest challenge right now?"
User: [explains challenge]
Agent: "Before we go deeper on any of these, is there anything 
        else I should know about?"
User: [adds 2 more things]
Agent: "Now, which of these would you like to detail first?"
```

---

## Integration with Knowledge Capture

Domain discovery is the **interview phase**. Knowledge capture is the **persistence phase**.

```
domain-discovery → knowledge-capture → cross-linker → gardener
   (interview)        (persist)         (connect)     (maintain)
```

**During discovery:**
- Note entities but don't create files immediately
- Wait until Phase 5 (Deepen) to persist
- Use knowledge-capture for file creation

**Handoff to knowledge-capture:**
```
Discovered entities:
- Person: Sarah Chen (Platform team lead)
- Person: John Park (Engineering)
- Project: Apollo (Identity migration)
- Challenge: Q2 timeline risk

→ knowledge-capture creates files with proper templates
→ cross-linker connects them
```

---

## Common Mistakes

| Mistake | Prevention |
| ------- | ---------- |
| Diving deep too early | Use step-back pattern after 5 minutes |
| Creating files during discovery | Wait until Phase 5 (Deepen) |
| Forgetting to ask "what else?" | Build it into your flow after each topic |
| Taking action during discovery | Focus on understanding, not doing |
| Not summarizing at close | Always recap what was learned |

---

## Red Flags - STOP

- Spent >10 minutes on one entity without stepping back
- Started creating files before mapping landscape
- Began taking actions (emails, tasks) during discovery
- Never asked about people OR projects OR challenges
- Ended without summarizing discoveries

---

## Verification Checklist

- [ ] Asked about multiple areas (people, projects, challenges, goals)
- [ ] Used step-back pattern at least once
- [ ] Didn't spend >10 minutes on any single entity before mapping others
- [ ] Landscape mapped before deepening
- [ ] Handed off to knowledge-capture for file creation
- [ ] Identified gaps for follow-up
- [ ] User knows what to expect going forward

---

*Domain Discovery v2.0 | Breadth-Before-Depth Interview Protocol*
