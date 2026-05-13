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
  if [[ -z "$base" ]] && git rev-parse --verify origin/main >/dev/null 2>&1; then
    base="origin/main"
  fi
fi

echo
echo "## Unstaged diff stat"
git diff --stat

echo
echo "## Unstaged changed files"
git diff --name-only

echo
echo "## Staged diff stat"
git diff --cached --stat

echo
echo "## Staged changed files"
git diff --cached --name-only

echo
echo "## Untracked files"
git ls-files --others --exclude-standard

if [[ -n "$base" ]]; then
  echo
  echo "## Base"
  echo "$base"

  echo
  echo "## Branch diff stat"
  git diff --stat "$base"...HEAD || git diff --stat "$base"..HEAD

  echo
  echo "## Branch changed files"
  git diff --name-only "$base"...HEAD || git diff --name-only "$base"..HEAD
else
  echo
  echo "## Base"
  echo "No base branch detected."
fi
