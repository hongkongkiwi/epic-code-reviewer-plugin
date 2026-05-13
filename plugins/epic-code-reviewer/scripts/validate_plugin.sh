#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

cd "$root"

python3 -m json.tool .agents/plugins/marketplace.json >/dev/null
python3 -m json.tool plugins/epic-code-reviewer/.codex-plugin/plugin.json >/dev/null

bash -n plugins/epic-code-reviewer/scripts/collect_review_context.sh
bash -n plugins/epic-code-reviewer/scripts/validate_plugin.sh

for skill in plugins/epic-code-reviewer/skills/*/SKILL.md; do
  head -1 "$skill" | grep -qx -- "---"
  sed -n '2,4p' "$skill" | grep -q "^name: "
  sed -n '2,6p' "$skill" | grep -q "^description: "
done

grep -q "Evidence:" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "Introduced by this change:" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "statusCheckRollup" plugins/epic-code-reviewer/skills/epic-code-review/SKILL.md
grep -q "outdated" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md
grep -q "duplicate" plugins/epic-code-reviewer/skills/epic-code-review-fixes/SKILL.md

test -f examples/auth-regression.diff
test -f examples/stale-review-thread.md

if rg -n --glob '!plugins/epic-code-reviewer/scripts/validate_plugin.sh' "BEGIN SYSTEM PROMPT|END SYSTEM PROMPT|You are Claude Code|You are Devin|You are Cursor" plugins README.md examples >/dev/null; then
  echo "Source guard failed: remove copied prompt markers from shipped files." >&2
  exit 1
fi

echo "PASS validate_plugin"
