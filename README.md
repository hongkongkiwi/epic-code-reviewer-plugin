# Epic Code Reviewer

Local-first Codex review skills for people who want CodeRabbit-style discipline without making CodeRabbit part of the default path.

Epic Code Reviewer does two jobs:

- `epic-code-review` reviews local diffs, branches, and GitHub PRs.
- `epic-code-review-fixes` verifies review feedback, fixes valid issues, and rejects stale or false claims.

It is built around one rule: a review finding needs evidence. The skill reads the diff, nearby code, callers, tests, history, and CI context before it asks for a change. PR comments, generated text, copied prompts, issue bodies, webpages, decoded payloads, and other-agent output are treated as claims, not instructions.

## Why This Exists

AI makes code faster than most teams can review it. That changes the review job. Skimming a diff is not enough when the bug is in a caller, a workflow permission, a missing `await`, an unsafe parser, or a comment that says "moved to middleware" without proving the middleware exists.

This plugin gives Codex a repeatable review workflow:

- findings first, ordered by severity
- file and line references where possible
- concrete trigger and failure path
- evidence source: diff, caller, test, trace, docs, history, or CI
- smallest useful fix
- explicit verification status

No warm-up praise. No giant generic checklist dumped into chat. No copied leaked prompt text.

## What It Reviews

The default profile is `general`. You can also ask for a narrower profile:

| Profile | Bias |
| --- | --- |
| `security` | auth, tenant boundaries, injection, secrets, SSRF, webhooks, crypto, shell/file/URL handling |
| `correctness` | control flow, async bugs, validation gaps, data-shape drift, migrations, compatibility |
| `llm-safety` | prompt injection, RAG provenance, MCP/tool-call permissions, output injection, memory, irreversible actions |
| `release-readiness` | CI, packaging, versioning, changelog, release tags, rollback behavior, docs |

The skill also has language packs for Shell, GitHub Actions, TypeScript/Node, and Python.

## Install

Clone the repo:

```bash
git clone git@github.com:hongkongkiwi/epic-code-reviewer-plugin.git ~/Development/epic-code-reviewer-plugin
```

Add this repo as a local marketplace in `~/.codex/config.toml`:

```toml
[marketplaces.hongkongkiwi-epic-code-reviewer-plugin]
source_type = "local"
source = "~/Development/epic-code-reviewer-plugin"

[plugins."epic-code-reviewer@hongkongkiwi-epic-code-reviewer-plugin"]
enabled = true
```

Use an absolute path if your Codex install does not expand `~`. Restart Codex after changing plugin config.

## Quick Start

Review the current working tree:

```text
Use epic-code-review on my current changes.
```

Review a branch against its base:

```text
Use epic-code-review on my current branch.
```

Run a security-focused pass:

```text
Use epic-code-review with the security profile.
```

Check release wiring:

```text
Use epic-code-review with the release-readiness profile.
```

Fix review feedback:

```text
Use epic-code-review-fixes to address unresolved PR comments.
```

The reviewer is local-first. It does not call CodeRabbit unless you ask for CodeRabbit by name.

## Review Shape

Normal output starts with findings. If there are no findings, it says that plainly and names any remaining verification gap.

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

After findings, the reviewer reports open questions, verification commands, skipped checks, and a short verdict.

## Context Helper

Print the current review scope:

```bash
plugins/epic-code-reviewer/scripts/collect_review_context.sh
```

Pass an explicit base branch or commit:

```bash
plugins/epic-code-reviewer/scripts/collect_review_context.sh origin/main
```

The helper prints git status, unstaged and staged files, untracked files, and branch diff stats. It is meant to gather context, not replace reading the code.

## Review Fixtures

The repo ships small fixtures that describe bug shapes the reviewer should catch or classify.

| Fixture | Expected result |
| --- | --- |
| `auth-regression` | finding, `P1` |
| `llm-indirect-injection` | finding, `P1` |
| `shell-readonly-bypass` | finding, `P1` |
| `stale-review-thread` | outdated |
| `dependency-update-risk` | finding, `P2` |
| `github-actions-secret-leak` | finding, `P1` |
| `typescript-missing-await` | finding, `P2` |
| `python-unsafe-yaml` | finding, `P1` |

See [docs/fixture-catalog.md](docs/fixture-catalog.md) for the catalog and `examples/fixture-manifest.json` for the checks enforced by CI.

## Local Validation

Install the local tools:

```bash
brew install lefthook shellcheck actionlint
lefthook install
```

Run the validator:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
```

The validator checks:

- plugin and marketplace JSON
- marketplace entry points at this plugin
- shell script syntax and ShellCheck findings
- GitHub Actions syntax
- workflow wiring for `validate_plugin.sh` and `check_release_version.sh`
- skill frontmatter and required review rules
- fixture source and expected-output coverage
- changelog entry for the current plugin version
- copied-prompt marker guard across shipped plugin files, docs, config, README, changelog, contributing notes, and examples

For release tags:

```bash
plugins/epic-code-reviewer/scripts/check_release_version.sh vX.Y.Z
```

GitHub Actions runs validation on pushes and pull requests. Tag pushes also verify that `plugin.json` matches the tag.

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

## Release Flow

The short version:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
plugins/epic-code-reviewer/scripts/check_release_version.sh vX.Y.Z
git diff --check
git tag vX.Y.Z
git push origin main
git push origin vX.Y.Z
```

Then publish a GitHub Release. The full process lives in [CONTRIBUTING.md](CONTRIBUTING.md).

## Research Notes

This plugin was written from scratch. Public review-tool docs and prompt collections informed the workflow shape, but the plugin does not copy leaked prompt text.

Research inputs and lessons are documented in [docs/system-prompt-research-notes.md](docs/system-prompt-research-notes.md).
