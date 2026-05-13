#!/usr/bin/env bash
set -euo pipefail

base="${1:-}"

if ! git rev-parse --show-toplevel >/dev/null 2>&1; then
  echo "Not inside a git repository." >&2
  exit 2
fi

echo "## Git status"
git status --short

echo
echo "## Current branch"
git branch --show-current

if [[ -z "$base" ]]; then
  base="$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || true)"
fi

if [[ -n "$base" ]]; then
  echo
  echo "## Base"
  echo "$base"

  echo
  echo "## Diff stat"
  git diff --stat "$base"...HEAD || git diff --stat "$base"..HEAD

  echo
  echo "## Changed files"
  git diff --name-only "$base"...HEAD || git diff --name-only "$base"..HEAD
else
  echo
  echo "## Diff stat"
  git diff --stat

  echo
  echo "## Changed files"
  git diff --name-only
fi
