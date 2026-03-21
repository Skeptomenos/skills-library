# Quality & Discipline

> "I'm not paid to write code, I'm paid to solve problems."

## No Slop Rule

**Do not take shortcuts while coding.**
Each instance of "slop" (hasty, messy, or untested code) makes it harder for your future self (the next iteration) to follow and maintain the code. Technical debt compounds instantly in this environment.

## The "Always Works" Protocol

Ensure what you implement **Always Works™** for the given arguments.

### The 30-Second Reality Check
Must answer **YES** to ALL before claiming completion:
1.  Did I run/build the code?
2.  Did I trigger the *exact* feature I changed?
3.  Did I see the expected result with my own observation (logs/UI)?
4.  Did I check for error messages?
5.  **Would I bet $100 this works?**

### Phrases to Avoid (Red Flags)
- "This *should* work now" (Pattern matching is not thinking)
- "I've fixed the issue" (without verifying)
- "Try it now" (without trying it myself)
- "The logic is correct so..."

### The Embarrassment Test
> "If the user records trying this and it fails, will I feel embarrassed to see their face?"

### Time Reality
- Time saved skipping tests: **30 seconds**
- Time wasted when it doesn't work: **30 minutes**
- User trust lost: **Immeasurable**

A user describing a bug for the third time isn't thinking "this AI is trying hard" — they're thinking "why am I wasting time with this incompetent tool?"

## Specific Test Requirements

| Change Type | Requirement |
| :--- | :--- |
| **UI Changes** | Actually click the button/link/form. |
| **API Changes** | Make the actual API call (curl/script). |
| **Data Changes** | Query the database to verify state. |
| **Logic Changes** | Run the specific scenario/test case. |
| **Config Changes** | Restart the service and verify it loads. |

---
*Sources: "Always Works" Snippet, User "No Slop" Instruction*
