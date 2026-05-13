# Expected Review: GitHub Actions Secret Leak

classification: finding
severity: P1

The reviewer should report that `pull_request_target` runs with privileged context and this workflow prints a secret. The combination can expose `NPM_TOKEN` when untrusted pull request code affects the job.

The finding should ask to avoid printing the secret, keep untrusted PR code away from privileged tokens, and use a safer event or split workflow.
