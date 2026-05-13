# Expected Review: LLM Indirect Injection

classification: finding
severity: P1

The reviewer should report that web page markdown is still untrusted evidence and must not be treated as model instructions. Removing the explicit system instruction reopens indirect prompt injection risk in the web-context path.

The finding should ask to keep the untrusted-content boundary in the system message or enforce it through an equivalent prompt/tool contract.
