# Designing the Single Validation Gate

The gate is one deterministic, indivisible command that defines "done." Wire it as a package/make script (`pnpm validate`, `make validate`, `./validate.sh`) chaining stages with `&&` so nothing can be skipped silently.

## Canonical stage order

1. **Build** — produce the production artifact.
2. **Typecheck/lint** — static checks over everything the build excludes (e.g. tests).
3. **Unit/integration tests** — the fast probes.
4. **Smoke** — boot/run the PRODUCTION artifact exactly as deployment does, against throwaway fixtures, and assert deploy-critical behavior end to end.
5. **Drift checks** — cross-check prose against reality (see below).
6. **Hygiene** — `git diff --check`, formatting, schema sync.

Fast and deterministic stages first; every stage must be runnable locally with no credentials or external services (fake/fixture everything).

## The fidelity rule (stage 4)

The smoke stage must exercise the artifact the way production uses it:

- Run the documented start command on the built output — not the source via a dev runner.
- Talk to the real interface with a real client (HTTP client, CLI invocation, SDK) — not internal function calls.
- Include the negative security assertions: requests without credentials are rejected; the process refuses to start in misconfigured-auth states; forbidden inputs (traversal, oversized bodies) are denied.
- Use throwaway fixtures created and destroyed by the script (mktemp), a non-default port, and a trap-based cleanup so the gate never leaks processes or state.

## Per-project-type smoke patterns

- **Server/daemon:** build → boot built entry point with fixture config → poll health → assert auth/permission denials → drive the real protocol end to end (one happy path per public operation, plus the deny paths) → kill and clean up.
- **Web app:** build the production bundle → serve it statically → drive it headless (navigation, one critical flow, console-error budget of zero).
- **Library/package:** `pack` the artifact → install the tarball into a scratch project → import and exercise the public API from there (catches export-map, types, and packaging drift that in-repo tests cannot).
- **CLI:** run the installed binary's documented invocations from the README verbatim; diff output against golden files.
- **Data pipeline:** run on a small frozen input set → diff against golden outputs → assert invariants (row counts, schema, no-NaN) rather than exact values where outputs are legitimately unstable.

## Drift checks (stage 5)

Grep-level cross-checks between prose and code, because docs rot silently and no other stage reads them:

- The documented start/run/install commands must literally appear in the docs AND match the package metadata.
- Forbidden patterns: machine-specific paths, stale output paths, dead URLs you control.
- Everything registered in code (commands, endpoints, public API names) is documented; everything documented exists in code.
- Example configs parse and their literals (ports, env var names) match the docs and integration examples.

Keep these as a small shell script asserting high-value literals. Semantic doc review belongs to the independent verifier, not the script.

## Falsifiability protocol for new gates

Before trusting any new gate or stage:

1. Deliberately break the behavior it guards (comment out the guard, corrupt the path, unset the variable).
2. Run the gate; confirm it fails WITH A MESSAGE that names the real problem (a future agent will see only this message).
3. Restore; confirm green.
4. Record the falsifiability check as evidence in the plan.

A gate that has never been seen failing provides confidence, not protection.
