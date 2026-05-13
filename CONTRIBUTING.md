# Contributing

## Local Setup

Install the validation tools:

```bash
brew install lefthook shellcheck actionlint
lefthook install
```

Run the validator before opening a PR or cutting a release:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
```

## Release Flow

1. Update `plugins/epic-code-reviewer/.codex-plugin/plugin.json`.
2. Update `CHANGELOG.md`.
3. Run:

```bash
plugins/epic-code-reviewer/scripts/validate_plugin.sh
plugins/epic-code-reviewer/scripts/check_release_version.sh vX.Y.Z
git diff --check
```

4. Commit the change.
5. Tag the same commit:

```bash
git tag vX.Y.Z
```

6. Push the branch and tag:

```bash
git push origin main
git push origin vX.Y.Z
```

The release workflow checks that the tag version matches `plugin.json`.

## Fixture Changes

Each review fixture needs:

- A source file under `examples/`.
- An expected output file under `examples/expected/`.
- An entry in `examples/fixture-manifest.json`.
- A short description in `docs/fixture-catalog.md`.

Fixtures should describe the failure mode with enough detail for a reviewer to know what must be reported, but they should stay small enough to read in one pass.
