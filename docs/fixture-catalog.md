# Fixture Catalog

These fixtures keep the reviewer honest about the bug shapes it claims to catch.

## auth-regression

- Source: `examples/auth-regression.diff`
- Expected: `examples/expected/auth-regression.md`
- Review result: `classification: finding`, `severity: P1`

This fixture removes an inline `canEditAccount` check and replaces it with a comment saying the check moved to middleware. The expected review asks for proof of the middleware or restoration of the local guard.

## llm-indirect-injection

- Source: `examples/llm-indirect-injection.diff`
- Expected: `examples/expected/llm-indirect-injection.md`
- Review result: `classification: finding`, `severity: P1`

This fixture removes the rule that webpage content is untrusted evidence rather than model instructions. The expected review reports indirect prompt injection risk.

## shell-readonly-bypass

- Source: `examples/shell-readonly-bypass.diff`
- Expected: `examples/expected/shell-readonly-bypass.md`
- Review result: `classification: finding`, `severity: P1`

This fixture changes command review logic so all `find` and `xargs` calls count as read-only. The expected review reports that these command builders can execute or write through arguments.

## stale-review-thread

- Source: `examples/stale-review-thread.md`
- Expected: `examples/expected/stale-review-thread.md`
- Review result: `classification: outdated`

This fixture represents old PR feedback after the route now runs `requireAccountEditor`. The expected review classifies the thread as outdated instead of asking for another code change.
