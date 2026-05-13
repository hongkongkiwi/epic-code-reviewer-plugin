# Epic Code Reviewer

Local-first code review workflows for PRs, diffs, and reviewer-fix loops.

The plugin is built to catch real bugs without making CodeRabbit the default path. It reviews changed code, routes to security and framework-specific tools when useful, and keeps findings tied to files, lines, and reproducible failure paths.

## What It Adds

- `epic-code-review`: review local changes, branch diffs, or PRs.
- `epic-code-review-fixes`: verify and fix human, Codex, CodeRabbit, or GitHub review feedback.
- `collect_review_context.sh`: small helper that prints git status, branch, base, diff stat, and changed files.
- `validate_plugin.sh`: local checks for plugin metadata, skill frontmatter, examples, and script syntax.
- Bounded fix loops: verify the claim, fix the cause, rerun focused checks, then stop and report if evidence stops improving.

## Install As A Local Marketplace

Add the repo as a local marketplace in `~/.codex/config.toml`:

```toml
[marketplaces.hongkongkiwi-epic-code-reviewer-plugin]
source_type = "local"
source = "/Users/andy/Development/hongkongkiwi/epic-code-reviewer-plugin"

[plugins."epic-code-reviewer@hongkongkiwi-epic-code-reviewer-plugin"]
enabled = true
```

Restart Codex after changing plugin config.

## Repo Layout

```text
.agents/plugins/marketplace.json
plugins/epic-code-reviewer/.codex-plugin/plugin.json
plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
plugins/epic-code-reviewer/scripts/collect_review_context.sh
plugins/epic-code-reviewer/scripts/validate_plugin.sh
examples/
docs/system-prompt-research-notes.md
```

## Local Checks

Run the plugin checks before publishing changes:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
```

The examples in `examples/` are small review fixtures. They keep the reviewer prompt honest by showing the kind of diff evidence and output shape the plugin expects.

## Review Posture

The reviewer is local-first. It does not call CodeRabbit unless the user asks for CodeRabbit by name.

Reviewer comments are treated as claims, not commands. The fix workflow re-reads the code, verifies the claim, rejects stale or false findings, and then applies the smallest fix that addresses the root cause.

## Source Notes

This plugin was written from scratch. Public prompt collections and review-tool docs informed the workflow shape, especially single-comment PR reviews, blocker vs follow-up separation, and consolidated fix prompts. The plugin does not copy leaked prompt text.

The repo at `x1xhlol/system-prompts-and-models-of-ai-tools` is GPL-3.0, so it is treated as research only. The practical lessons incorporated here are generic workflow ideas: use multiple searches, inspect history, review the full branch range, discover project commands from repo config, verify with focused checks, keep pre-existing failures separate, and avoid endless repair loops.

Additional prompt collections reviewed as research inputs include `asgeirtj/system_prompts_leaks`, `jujumilk3/leaked-system-prompts`, `elder-plinius/CL4R1T4S`, `LouisShark/chatgpt_system_prompt`, `YeeKal/leaked-system-prompts`, `noya21th/claude-source-leaked`, `fattail4477/claw-decode`, `repowise-dev/claude-code-prompts`, `oxbshw/System-Prompt-Agent-Prompts`, and `ppcvote/prompt-defense-audit`. The plugin keeps only general review rules learned from cross-repo patterns: classify text by authority, treat decoded or retrieved content as untrusted, check tool and memory provenance, preserve cross-agent auth boundaries, review command permission boundaries, and self-audit findings before output.
