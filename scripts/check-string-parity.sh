#!/usr/bin/env bash
# check-string-parity.sh — enforce ≥99% EN/AR string parity in Localizable.xcstrings
#
# Exit codes:
#   0 — parity ≥ threshold
#   1 — parity below threshold
#   2 — script error (file missing, jq missing, etc.)

set -euo pipefail

CATALOG="${CATALOG:-hogwarts/resources/Localizable.xcstrings}"
THRESHOLD="${THRESHOLD:-0.99}"

if [[ ! -f "$CATALOG" ]]; then
    echo "ERROR: $CATALOG not found" >&2
    exit 2
fi

if ! command -v jq >/dev/null 2>&1; then
    echo "ERROR: jq is required (brew install jq)" >&2
    exit 2
fi

# Count keys with EN value and AR value
en_count=$(jq -r '
  [.strings | to_entries[] |
    select(.value.localizations.en.stringUnit.value != null and .value.localizations.en.stringUnit.value != "")
  ] | length' "$CATALOG")

ar_count=$(jq -r '
  [.strings | to_entries[] |
    select(.value.localizations.ar.stringUnit.value != null and .value.localizations.ar.stringUnit.value != "")
  ] | length' "$CATALOG")

total_keys=$(jq -r '.strings | length' "$CATALOG")

if [[ "$total_keys" == "0" ]]; then
    echo "WARN: catalog is empty"
    exit 0
fi

# Parity = min(en, ar) / total
min_count=$(( en_count < ar_count ? en_count : ar_count ))
parity=$(echo "scale=4; $min_count / $total_keys" | bc)

echo "String catalog: $CATALOG"
echo "  Total keys: $total_keys"
echo "  EN translated: $en_count"
echo "  AR translated: $ar_count"
echo "  Parity: $parity (threshold: $THRESHOLD)"

# Find untranslated keys (have EN but no AR, or vice versa)
echo ""
echo "Keys missing AR translation (top 20):"
jq -r '
  .strings | to_entries[] |
    select(.value.localizations.en.stringUnit.value != null) |
    select(.value.localizations.ar.stringUnit.value == null or .value.localizations.ar.stringUnit.value == "") |
    .key
' "$CATALOG" | head -20

echo ""
echo "Keys missing EN translation (top 20):"
jq -r '
  .strings | to_entries[] |
    select(.value.localizations.ar.stringUnit.value != null) |
    select(.value.localizations.en.stringUnit.value == null or .value.localizations.en.stringUnit.value == "") |
    .key
' "$CATALOG" | head -20

# Compare to threshold
if (( $(echo "$parity < $THRESHOLD" | bc -l) )); then
    echo ""
    echo "FAIL: parity $parity is below threshold $THRESHOLD" >&2
    exit 1
fi

echo ""
echo "PASS"
exit 0
