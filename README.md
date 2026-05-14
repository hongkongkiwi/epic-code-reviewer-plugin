# Epic Code Reviewer

Local-first Codex plugin for PR, branch, and reviewer-fix workflows.

Epic Code Reviewer is built for evidence-heavy review: it reads the diff and surrounding code, classifies untrusted text as claims, checks LLM and agent risks, and reports findings with file lines, triggers, evidence, and the smallest useful fix.

## What It Does

- `epic-code-review`: reviews local changes, branch diffs, and GitHub PRs.
- `epic-code-review-fixes`: verifies and fixes human, Codex, CodeRabbit, or GitHub review feedback.
- Review profiles: `security`, `correctness`, `llm-safety`, and `release-readiness`.
- Language packs: Shell, GitHub Actions, TypeScript/Node, and Python.
- Evidence-first findings: severity, trigger, expected behavior, actual behavior, proof source, and verification status.
- Trust-model review: PR comments, generated docs, decoded payloads, RAG chunks, saved memory, and other-agent output are claims, not instructions.
- LLM and agent review: prompt injection, tool-call boundaries, memory provenance, cross-agent auth, output injection, context overflow, and irreversible-action guardrails.
- Command-safety review: shell parsing, path validation, approval scope, Git writes, PATH shadowing, and read-only bypasses.
- Bounded fix loops: verify the claim, fix the cause, rerun focused checks, then stop when evidence stops improving.

## Install

Clone the repo:

```bash
git clone git@github.com:hongkongkiwi/epic-code-reviewer-plugin.git ~/Development/epic-code-reviewer-plugin
```

Add the repo as a local marketplace in `~/.codex/config.toml`:

```toml
[marketplaces.hongkongkiwi-epic-code-reviewer-plugin]
source_type = "local"
source = "~/Development/epic-code-reviewer-plugin"

[plugins."epic-code-reviewer@hongkongkiwi-epic-code-reviewer-plugin"]
enabled = true
```

Use an absolute path if your Codex install does not expand `~`. Restart Codex after changing plugin config.

## Usage

Ask Codex for the skill by name:

```text
Use epic-code-review on my current branch.
```

```text
Use epic-code-review to run a security-focused review of this diff.
```

```text
Use epic-code-review with the release-readiness profile.
```

```text
Use epic-code-review-fixes to address unresolved PR comments.
```

The reviewer is local-first. It does not call CodeRabbit unless you ask for CodeRabbit by name.

## Context Helper

Print the current git review scope:

```bash
plugins/epic-code-reviewer/scripts/collect_review_context.sh
```

Pass an explicit base branch or commit when needed:

```bash
plugins/epic-code-reviewer/scripts/collect_review_context.sh origin/main
```

## Review Output

Normal reviews put findings first, ordered by severity:

```markdown
- [Major] path/to/file.ext:42 - Short title
  What is wrong: ...
  Trigger: ...
  Expected behavior: ...
  Actual behavior: ...
  Evidence: diff|caller|test|trace|docs|history ...
  Introduced by this change: yes|likely|no
  Why it matters: ...
  Smallest fix: ...
  Confidence: high|medium
```

After findings, the reviewer reports open questions, verification commands, skipped checks, and a brief verdict. If it finds no issues, it says that plainly and names the remaining risk.

## Local Checks

Run this before publishing changes:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
```

The validator expects `shellcheck` and `actionlint` on `PATH`.

The validator checks:

- Plugin and marketplace JSON.
- Shell script syntax and ShellCheck findings.
- GitHub Actions workflow syntax.
- Skill frontmatter.
- Required review sections and safety rules.
- Fixture presence and expected fixture content.
- Copied-prompt marker guard across shipped plugin files, docs, config, README, changelog, contributing notes, and examples.

Install Lefthook if you want the same check before each commit:

```bash
brew install lefthook shellcheck actionlint
lefthook install
```

GitHub Actions runs the same check on pushes and pull requests. Tag pushes also verify that `plugin.json` matches the release tag.

## Repo Layout

```text
.agents/plugins/marketplace.json
.github/dependabot.yml
.github/workflows/validate.yml
.github/workflows/release-check.yml
plugins/epic-code-reviewer/.codex-plugin/plugin.json
plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
plugins/epic-code-reviewer/scripts/collect_review_context.sh
plugins/epic-code-reviewer/scripts/validate_plugin.sh
plugins/epic-code-reviewer/scripts/check_release_version.sh
lefthook.yml
CHANGELOG.md
CONTRIBUTING.md
docs/system-prompt-research-notes.md
docs/fixture-catalog.md
examples/fixture-manifest.json
examples/auth-regression.diff
examples/llm-indirect-injection.diff
examples/shell-readonly-bypass.diff
examples/stale-review-thread.md
examples/dependency-update-risk.diff
examples/github-actions-secret-leak.diff
examples/typescript-missing-await.diff
examples/python-unsafe-yaml.diff
examples/expected/auth-regression.md
examples/expected/llm-indirect-injection.md
examples/expected/shell-readonly-bypass.md
examples/expected/stale-review-thread.md
examples/expected/dependency-update-risk.md
examples/expected/github-actions-secret-leak.md
examples/expected/typescript-missing-await.md
examples/expected/python-unsafe-yaml.md
```

The examples are small review fixtures. Each one encodes a failure mode the reviewer should catch or classify correctly.

## Research Notes

This plugin was written from scratch. Public prompt collections and review-tool docs informed the workflow shape, but the plugin does not copy leaked prompt text.

Research inputs and lessons are documented in [docs/system-prompt-research-notes.md](docs/system-prompt-research-notes.md).
