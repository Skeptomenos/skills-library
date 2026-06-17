---
name: grill-me
description: Interview the user relentlessly about a plan or design until reaching shared understanding, resolving each branch of the decision tree. Use when user wants to stress-test a plan, get grilled on their design, or mentions "grill me".
author: David Helmus
version: 0.1.0
source:
  type: self
  name: ai-dev
triggers:
  - "grill me"
  - "stress-test a plan"
  - "challenge my design"
  - "interview me about this plan"
when_to_use:
  - "The user wants a rigorous questioning session about a plan or design."
  - "The goal is shared understanding before implementation."
  - "The session should ask one question at a time and recommend answers."
when_not_to_use:
  - "The user wants direct implementation without a planning interview."
  - "Decisions should be documented inline; use grill-with-docs instead."
---

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask the questions one at a time.

If a question can be answered by exploring the codebase, explore the codebase instead.
