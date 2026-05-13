# Expected Review: Dependency Update Risk

classification: finding
severity: P2

The reviewer should report that this change downgrades `jsonwebtoken` from `^9.0.0` to `^8.5.1`. Dependency downgrades can remove a security patch or reintroduce old behavior, so the review should ask for a reason, lockfile proof, and a safer alternative if compatibility is the problem.
