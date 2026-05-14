# Changelog

## 0.2.6

- Added validator checks for workflow wiring and README release-script coverage.
- Updated release docs with GitHub Release creation.
- Fixed README repo layout and copied-prompt guard wording.

## 0.2.5

- Updated GitHub Actions checkout usage from `v4` to `v6`.

## 0.2.4

- Made changelog validation follow the current plugin version instead of a fixed historical version.
- Added duplicate and coverage checks for fixture manifest entries.
- Expanded copied-prompt marker scanning to marketplace and GitHub config files.

## 0.2.3

- Added fixtures for dependency update risk, GitHub Actions secret exposure, TypeScript missing `await`, and Python unsafe YAML loading.
- Added expected review outputs for the new fixture batch.
- Updated the fixture catalog with the new cases.

## 0.2.2

- Added ShellCheck and actionlint validation in CI, Lefthook, and the local validator.
- Added a fixture manifest plus expected review-output files.
- Added review profiles and language packs to the review skill.
- Added contributing docs, Dependabot, and a fixture catalog.
- Documented local tool requirements.

## 0.2.1

- Added Lefthook pre-commit checks.
- Tightened fixture validation and copied-prompt scanning.
- Fixed branch-review base fallback behavior.

## 0.2.0

- Added release-tag validation for plugin metadata.
- Added GitHub Actions checks for plugin validation.
