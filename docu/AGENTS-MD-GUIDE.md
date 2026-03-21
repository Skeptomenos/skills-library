# A Guide to AGENTS.md

`AGENTS.md` is a configuration file checked into your repository that customizes how AI coding agents (like OpenCode or Claude Code) behave in your project.

## Core Philosophy: Progressive Disclosure

The most important principle for `AGENTS.md` is **progressive disclosure**. Since this file is loaded at the beginning of every conversation, it consumes tokens on every single request.

- **Bad**: Putting 500 lines of coding rules, file paths, and testing instructions in the root `AGENTS.md`.
- **Good**: Keeping the root file minimal and linking to specialized documentation files (e.g., `docs/TYPESCRIPT.md`) that the agent can read only when relevant.

## The Essential Minimum

A root `AGENTS.md` should ideally only contain:

1.  **Project Description**: A one-sentence summary of what the project does.
2.  **Package Manager**: Specify if not `npm` (e.g., `pnpm`, `bun`).
3.  **Build/Verification Commands**: Non-standard commands for building, linting, or testing.

### Example Minimal `AGENTS.md`

```markdown
This is a React component library for accessible data visualization.

This project uses pnpm workspaces.

For TypeScript conventions, see docs/TYPESCRIPT.md
For testing patterns, see docs/TESTING.md
```

## Best Practices

- **Describe Capabilities, Not Paths**: File paths change often. Describe where logic "lives" by domain concepts rather than hardcoded strings.
- **Use Light Touch Language**: Avoid all-caps "ALWAYS" or "NEVER". Use conversational references like "Follow the patterns in...".
- **Domain Concepts Over File Paths**: Concepts like "organization" or "workspace" are more stable than `src/auth/utils.ts`.
- **Merge Logic**: In monorepos, `AGENTS.md` files in subdirectories merge with the root file. Keep each level focused on its specific scope.

## Anti-Patterns to Avoid

- **The "Ball of Mud"**: Adding a new rule every time the agent makes a mistake. Instead, group rules into logical, linked documents.
- **Auto-Generation**: Avoid scripts that flood the file with "useful" but redundant instructions.
- **Stale Docs**: Stale information in a documentation file that is read every request actively poisons the agent's context.

## Refactoring Workflow

If your `AGENTS.md` is too large:
1.  **Extract Essentials**: Move everything except the project description and core commands out.
2.  **Categorize**: Group the remaining instructions (e.g., "API", "Testing", "Style").
3.  **Link**: Create specialized files in `docs/` and link to them from `AGENTS.md`.
4.  **Delete**: Remove redundant, vague, or obvious instructions (e.g., "write clean code").

---
*Derived from Matt Pocock's "A Complete Guide to AGENTS.md"*
