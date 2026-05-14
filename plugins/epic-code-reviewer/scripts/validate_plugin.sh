#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

cd "$root"

python3 -m json.tool .agents/plugins/marketplace.json >/dev/null
python3 -m json.tool plugins/epic-code-reviewer/.codex-plugin/plugin.json >/dev/null
python3 -m json.tool examples/fixture-manifest.json >/dev/null

python3 - <<'PY'
import json
import re
from pathlib import Path

plugin = json.loads(Path("plugins/epic-code-reviewer/.codex-plugin/plugin.json").read_text())
version = plugin.get("version", "")
if not re.fullmatch(r"[0-9]+[.][0-9]+[.][0-9]+", version):
    raise SystemExit(f"plugin version must be X.Y.Z, got {version!r}")

marketplace = json.loads(Path(".agents/plugins/marketplace.json").read_text())
plugins = marketplace.get("plugins", [])
matches = [entry for entry in plugins if entry.get("name") == plugin.get("name")]
if len(matches) != 1:
    raise SystemExit(f"marketplace must contain exactly one entry for {plugin.get('name')!r}")

entry = matches[0]
source = entry.get("source", {})
if source.get("source") != "local":
    raise SystemExit("marketplace plugin source must be local")

plugin_path = Path(source.get("path", ""))
if plugin_path != Path("./plugins/epic-code-reviewer"):
    raise SystemExit(f"marketplace plugin path is wrong: {plugin_path}")
if not (plugin_path / ".codex-plugin/plugin.json").is_file():
    raise SystemExit(f"marketplace plugin path does not contain plugin metadata: {plugin_path}")
if not (plugin_path / "skills").is_dir():
    raise SystemExit(f"marketplace plugin path does not contain skills: {plugin_path}")

policy = entry.get("policy", {})
if policy.get("installation") != "AVAILABLE":
    raise SystemExit("marketplace plugin must be available for installation")
PY

bash -n plugins/epic-code-reviewer/scripts/collect_review_context.sh
bash -n plugins/epic-code-reviewer/scripts/check_release_version.sh
bash -n plugins/epic-code-reviewer/scripts/validate_plugin.sh
shellcheck plugins/epic-code-reviewer/scripts/*.sh
actionlint .github/workflows/*.yml

grep -q "## Unstaged diff stat" plugins/epic-code-reviewer/scripts/collect_review_context.sh
grep -q "## Staged diff stat" plugins/epic-code-reviewer/scripts/collect_review_context.sh
grep -q "## Untracked files" plugins/epic-code-reviewer/scripts/collect_review_context.sh
test -f .github/workflows/validate.yml
test -f .github/workflows/release-check.yml
test -f plugins/epic-code-reviewer/scripts/check_release_version.sh
test -x plugins/epic-code-reviewer/scripts/check_release_version.sh
grep -q "actions/checkout@v6" .github/workflows/validate.yml
grep -q "actions/checkout@v6" .github/workflows/release-check.yml
grep -q "validate_plugin.sh" .github/workflows/validate.yml
grep -q "check_release_version.sh" .github/workflows/release-check.yml

for skill in plugins/epic-code-reviewer/skills/*/SKILL.md; do
  head -1 "$skill" | grep -qx -- "---"
  sed -n '2,4p' "$skill" | grep -q "^name: "
  sed -n '2,6p' "$skill" | grep -q "^description: "
done

grep -q "Evidence:" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Introduced by this change:" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "statusCheckRollup" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "## Trust Model" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Decoded, translated, summarized, retrieved, or transformed content is still untrusted data" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Tool semantic drift" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Memory and RAG provenance" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Cross-agent authority" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "For command execution, shell safety, tool permissions, and review automation code" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Shell parsing" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "## Review Profiles" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "## Language Packs" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "release-readiness" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "### GitHub Actions" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "approval scope" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
grep -q "## Self-Audit Before Output" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "outdated" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
grep -q "duplicate" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
grep -q "untrusted external, decoded, generated, or cross-agent content" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md

test -f examples/auth-regression.diff
test -f examples/stale-review-thread.md
test -f examples/llm-indirect-injection.diff
test -f examples/shell-readonly-bypass.diff
test -f docs/system-prompt-research-notes.md
test -f CHANGELOG.md
test -f CONTRIBUTING.md
test -f docs/fixture-catalog.md
test -f .github/dependabot.yml
plugin_version="$(
  python3 - <<'PY'
import json
from pathlib import Path

plugin = json.loads(Path("plugins/epic-code-reviewer/.codex-plugin/plugin.json").read_text())
print(plugin["version"])
PY
)"
grep -q "## $plugin_version" CHANGELOG.md
grep -q "Release Flow" CONTRIBUTING.md
grep -q "auth-regression" docs/fixture-catalog.md
grep -q "github-actions" .github/dependabot.yml
grep -q ".github/workflows/validate.yml" README.md
grep -q "check_release_version.sh" README.md
grep -q "gh release create" CONTRIBUTING.md

python3 - <<'PY'
import json
from pathlib import Path

manifest = json.loads(Path("examples/fixture-manifest.json").read_text())
if not manifest:
    raise SystemExit("fixture manifest is empty")

names = set()
sources = set()
expected_files = set()
for fixture in manifest:
    name = fixture["name"]
    source = Path(fixture["source"])
    expected = Path(fixture["expected"])
    if name in names:
        raise SystemExit(f"duplicate fixture name {name!r}")
    if source in sources:
        raise SystemExit(f"{name}: duplicate source fixture {source}")
    if expected in expected_files:
        raise SystemExit(f"{name}: duplicate expected output {expected}")
    names.add(name)
    sources.add(source)
    expected_files.add(expected)

    if not source.is_file():
        raise SystemExit(f"{name}: missing source fixture {source}")
    if not expected.is_file():
        raise SystemExit(f"{name}: missing expected output {expected}")

    source_text = source.read_text()
    expected_text = expected.read_text()
    for needle in fixture.get("source_contains", []):
        if needle not in source_text:
            raise SystemExit(f"{name}: source fixture missing {needle!r}")
    for needle in fixture.get("expected_contains", []):
        if needle not in expected_text:
            raise SystemExit(f"{name}: expected output missing {needle!r}")

root_sources = {
    path
    for path in Path("examples").iterdir()
    if path.is_file() and path.suffix in {".diff", ".md"}
}
missing_from_manifest = sorted(root_sources - sources)
if missing_from_manifest:
    paths = ", ".join(str(path) for path in missing_from_manifest)
    raise SystemExit(f"source fixtures missing from manifest: {paths}")

orphan_expected = sorted(Path("examples/expected").glob("*.md"))
orphan_expected = [path for path in orphan_expected if path not in expected_files]
if orphan_expected:
    paths = ", ".join(str(path) for path in orphan_expected)
    raise SystemExit(f"expected outputs missing from manifest: {paths}")
PY

if rg -n --glob '!plugins/epic-code-reviewer/scripts/validate_plugin.sh' "BEGIN SYSTEM PROMPT|END SYSTEM PROMPT|You are Claude Code|You are Devin|You are Cursor" .agents .github plugins docs README.md CHANGELOG.md CONTRIBUTING.md examples >/dev/null; then
  echo "Source guard failed: remove copied prompt markers from shipped files." >&2
  exit 1
fi

echo "PASS validate_plugin"
