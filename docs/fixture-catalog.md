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

## dependency-update-risk

- Source: `examples/dependency-update-risk.diff`
- Expected: `examples/expected/dependency-update-risk.md`
- Review result: `classification: finding`, `severity: P2`

This fixture downgrades `jsonwebtoken` from `^9.0.0` to `^8.5.1`. The expected review reports a dependency regression and asks for proof that the downgrade is intentional and safe.

## github-actions-secret-leak

- Source: `examples/github-actions-secret-leak.diff`
- Expected: `examples/expected/github-actions-secret-leak.md`
- Review result: `classification: finding`, `severity: P1`

This fixture changes a workflow to `pull_request_target` and prints an npm token. The expected review reports secret exposure to untrusted pull request code.

## typescript-missing-await

- Source: `examples/typescript-missing-await.diff`
- Expected: `examples/expected/typescript-missing-await.md`
- Review result: `classification: finding`, `severity: P2`

This fixture removes `await` from a welcome-email send path while keeping later audit logging. The expected review reports that email failures can escape the request contract and test assertions.

## python-unsafe-yaml

- Source: `examples/python-unsafe-yaml.diff`
- Expected: `examples/expected/python-unsafe-yaml.md`
- Review result: `classification: finding`, `severity: P1`

This fixture replaces `yaml.safe_load` with `yaml.load`. The expected review reports unsafe YAML deserialization risk.
