#!/usr/bin/env bash
set -euo pipefail

tag="${1:-}"

if [[ -z "$tag" ]]; then
  echo "Usage: check_release_version.sh vX.Y.Z" >&2
  exit 2
fi

if [[ ! "$tag" =~ ^v[0-9]+[.][0-9]+[.][0-9]+$ ]]; then
  echo "Release tag must look like vX.Y.Z: $tag" >&2
  exit 2
fi

version="$(
  python3 - <<'PY'
import json
from pathlib import Path

plugin = json.loads(Path("plugins/epic-code-reviewer/.codex-plugin/plugin.json").read_text())
print(plugin["version"])
PY
)"

expected="${tag#v}"

if [[ "$version" != "$expected" ]]; then
  echo "Version mismatch: plugin.json has $version but tag is $tag" >&2
  exit 1
fi

echo "PASS release version $tag"
