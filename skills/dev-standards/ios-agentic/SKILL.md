---
name: ios-agentic-standards
description: >-
  iOS agentic development workflow — XcodeBuildMCP usage, long-running agent
  loops, test-driven agent patterns, project structure for unsupervised
  sessions. Use when setting up or running agent-driven iOS development.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - iOS agent workflow
  - xcodebuild
  - Xcode automation
when_to_use:
  - Setting up an iOS project for agent-driven development
  - Running build/test/simulator loops on iOS projects
when_not_to_use:
  - Swift language style (load swift-standards)
  - Concurrency patterns (load swift-concurrency-standards)
---

# iOS Agentic Development Standards

> **Mandate:** Enable 30+ minute unsupervised agent sessions.

## 1. XcodeBuildMCP (Required)

Use XcodeBuildMCP instead of raw `xcodebuild`. Provides:
- Scheme/simulator discovery
- Build/test execution
- Simulator interaction (tap, screenshot)
- Console log reading

## 2. Long-Running Task Pattern

```
Implement → Build → Test → Fix failures → Run app → Screenshot → Verify → Repeat
```

## 3. Project Structure

- **Document patterns in AGENTS.md immediately** (architecture, navigation, naming)
- **Create one reference feature first** - agents duplicate patterns well
- **Clear scheme organization** - separate app/test/UI test schemes

## 4. Multi-Repo Workflow

Cross-reference freely:
```
"Look at ../backend and implement the corresponding API client here"
"Review changes in ../web-app since yesterday, retrofit to iOS"
```

## 5. Test-Driven Agent Loop

1. Agent writes tests
2. Human reviews tests carefully
3. If tests are correct, trust the code
4. Run `/review` multiple times (each pass finds different issues)

## 6. Context Building

- Point to example files with `@path/to/file.swift`
- Paste Figma mockups for layout intent
- Let agent ask for more context if needed

## 7. Anti-Patterns

- **NO** raw `xcodebuild` (use MCP)
- **NO** skipping tests
- **NO** single mega-prompts (break into steps)
- **NO** ignoring `/review` findings
- **NO** undocumented patterns

Related skills: `swift-standards`, `swift-concurrency-standards`, `testing-standards`.
