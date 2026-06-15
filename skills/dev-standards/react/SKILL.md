---
name: react-standards
description: >-
  React and frontend standards — component purity, hooks rules, server state via
  TanStack Query, accessibility, performance. Use when writing or reviewing
  React components or frontend code.
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - writing React
  - React component
  - useEffect
  - frontend state management
when_to_use:
  - Writing or modifying React components or hooks
  - Choosing frontend state management
  - Reviewing frontend code quality or accessibility
when_not_to_use:
  - Pure TypeScript/Node backend work (load ts-standards)
  - Visual design and interaction polish (load ui-ux-standards)
---

# React & Frontend Standards

> **Mandate:** Component Purity, Accessibility, and Performance.

## 1. React Core
- **Functional Only:** Class components are forbidden.
- **Hooks Rules:**
  - Call hooks at top level only.
  - Custom hooks must start with `use`.
  - **Exhaustive Deps:** `useEffect` / `useMemo` dependency arrays must be exhaustive. Fix the logic, don't suppress the lint rule.
- **No Side Effects:** Render logic must be pure. Side effects belong in `useEffect` (rarely) or Event Handlers (mostly).

## 2. State Management
- **Server State:** Use `TanStack Query` / `SWR`. **NEVER** use `useEffect` + `fetch` manually.
- **Global State:** Avoid Redux/Context for everything. Use URL params for filter/pagination state.
- **Prop Drilling:** Acceptable for 1-2 levels. Use Composition (passing children) to avoid deep drilling.

## 3. JSX & Accessibility (a11y)
- **Semantic HTML:** `<button>` not `<div onClick>`.
- **Images:** `alt` text is mandatory. Use `alt=""` for decorative images.
- **Forms:** Inputs must have associated `<label>` (via `htmlFor` or nesting).
- **Interactive:** Interactive elements need `tabIndex` and keyboard handlers (Enter/Space).

## 4. Performance
- **Memoization:** Do NOT pre-optimize. Use `useMemo` only for expensive calculations or reference stability.
- **Code Splitting:** Use `lazy()` / `Suspense` for heavy routes.
- **Images:** Use `next/image` or modern `avif`/`webp` formats with `loading="lazy"`.

## 5. Negative Patterns (Don'ts)
- **NO** inline object literals in deps arrays (`useEffect(..., [{id: 1}])`).
- **NO** accessing `document` or `window` without checking `typeof window !== 'undefined'` (SSR safety).
- **NO** `dangerouslySetInnerHTML` without explicit sanitization.

Related skills: `ts-standards`, `ui-ux-standards`, `testing-standards`.
