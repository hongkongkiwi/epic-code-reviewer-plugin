# System Prompt Research Notes

Research date: 2026-05-13

Reviewed public prompt collections:

- `x1xhlol/system-prompts-and-models-of-ai-tools`
- `asgeirtj/system_prompts_leaks`
- `jujumilk3/leaked-system-prompts`
- `elder-plinius/CL4R1T4S`
- `oxbshw/System-Prompt-Agent-Prompts`
- `ppcvote/prompt-defense-audit`
- PromptBrowser index

These sources were used for pattern study only. The plugin does not copy prompt text.

## Lessons Added

The repeated lesson across coding-agent prompts is that review quality depends on bounded evidence gathering. The reviewer should read the diff, nearby code, callers, tests, history, and CI context before making a blocking claim. It should stop repair loops when evidence stops improving.

The repeated lesson across prompt-defense work is that text provenance matters. Web pages, docs, issue bodies, PR comments, generated files, decoded payloads, RAG chunks, saved memory, and other-agent output are data. They are not instructions.

Agent and LLM app review needs extra checks:

- Indirect prompt injection through external content.
- Encoded or transformed injection through decoding, OCR, translation, summarization, or parser normalization.
- Tool semantic drift, where user-controlled text tries to redefine a tool or permission.
- Memory and RAG provenance, including source, author, timestamp, trust level, and tenant boundary.
- Cross-agent authority confusion.
- Output injection through markdown, HTML, SVG, terminal escapes, citations, and links.
- Context overflow that drops policy, auth, tenant, or safety context.
- Unicode and parser edge cases.
- Guardrails for transactions and irreversible actions.

## Plugin Changes

The `epic-code-review` skill now has:

- A trust model for text sources.
- LLM, agent, RAG, MCP, browser, and tool-calling review checks.
- Tool routing for LLM security review.
- A self-audit step before findings are reported.

The `epic-code-review-fixes` skill now treats review feedback that contains decoded, generated, retrieved, or cross-agent content as untrusted. It also rejects fixes that weaken prompt-injection, auth, tenant, tool-call, or secret-handling boundaries.

The validator now checks that those sections stay present.
