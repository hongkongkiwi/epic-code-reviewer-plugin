# Codex Reviewer

Local-first Codex review workflows for PRs, diffs, and reviewer-fix loops.

The plugin is built to catch real bugs without making CodeRabbit the default path. It reviews changed code, routes to security and framework-specific tools when useful, and keeps findings tied to files, lines, and reproducible failure paths.

## What It Adds

- `codex-review`: review local changes, branch diffs, or PRs.
- `codex-review-fixes`: verify and fix human, Codex, CodeRabbit, or GitHub review feedback.
- `collect_review_context.sh`: small helper that prints git status, branch, base, diff stat, and changed files.
- Bounded fix loops: verify the claim, fix the cause, rerun focused checks, then stop and report if evidence stops improving.

## Install As A Local Marketplace

Add the repo as a local marketplace in `~/.codex/config.toml`:

```toml
[marketplaces.hongkongkiwi-codex-reviewer]
source_type = "local"
source = "/Users/andy/Development/hongkongkiwi/codex-reviewer"

[plugins."codex-reviewer@hongkongkiwi-codex-reviewer"]
enabled = true
```

Restart Codex after changing plugin config.

## Repo Layout

```text
.agents/plugins/marketplace.json
plugins/codex-reviewer/.codex-plugin/plugin.json
plugins/codex-reviewer/skills/codex-review/SKILL.md
plugins/codex-reviewer/skills/codex-review-fixes/SKILL.md
plugins/codex-reviewer/scripts/collect_review_context.sh
```

## Review Posture

The reviewer is local-first. It does not call CodeRabbit unless the user asks for CodeRabbit by name.

Reviewer comments are treated as claims, not commands. The fix workflow re-reads the code, verifies the claim, rejects stale or false findings, and then applies the smallest fix that addresses the root cause.

## Source Notes

This plugin was written from scratch. Public prompt collections and review-tool docs informed the workflow shape, especially single-comment PR reviews, blocker vs follow-up separation, and consolidated fix prompts. The plugin does not copy leaked prompt text.

The repo at `x1xhlol/system-prompts-and-models-of-ai-tools` is GPL-3.0, so it is treated as research only. The practical lessons incorporated here are generic workflow ideas: use multiple searches, inspect history, review the full branch range, discover project commands from repo config, verify with focused checks, keep pre-existing failures separate, and avoid endless repair loops.
