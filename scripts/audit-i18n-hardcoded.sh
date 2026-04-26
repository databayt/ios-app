#!/usr/bin/env bash
# audit-i18n-hardcoded.sh — find hardcoded user-visible strings in Swift views
#
# Heuristic: looks for SwiftUI Text("..."), .navigationTitle("..."), Button("...") with
# string literals that aren't obviously a localization key (no dot, no $LOCALIZED).
#
# Exit codes:
#   0 — no violations
#   1 — at least one suspect literal
#   2 — script error

set -euo pipefail

ROOT="${ROOT:-hogwarts}"

if [[ ! -d "$ROOT" ]]; then
    echo "ERROR: $ROOT not found" >&2
    exit 2
fi

violations=0
report_file="/tmp/i18n-audit-$$.txt"
trap 'rm -f "$report_file"' EXIT

# Patterns that suggest a hardcoded UI string:
#   Text("Foo Bar")            — capital letter + space inside, no dot
#   .navigationTitle("Foo")
#   Button("Foo")
#   Label("Foo", systemImage: ...)
#   .alert("Foo", ...)
#   Section("Foo")
#
# Allowed (skip):
#   Text("namespace.key")      — has a dot, looks like a key
#   Text("\(varName)")         — interpolation
#   #Preview, ProgressView, sample data
#   Test files

while IFS= read -r f; do
    # Skip tests
    if [[ "$f" == *Tests/* ]]; then continue; fi
    if [[ "$f" == *test*.swift ]]; then continue; fi
    # Skip atom-studio (catalog/preview)
    if [[ "$f" == *atom-studio* ]]; then continue; fi
    # Skip apple-symbols (system icon constants)
    if [[ "$f" == *apple-symbols* ]]; then continue; fi
    # Skip design-system (constants)
    if [[ "$f" == *design-system/*colors.swift ]]; then continue; fi
    if [[ "$f" == *design-system/*typography.swift ]]; then continue; fi

    # Strip out content inside #Preview { ... } blocks (preview labels are not user-visible)
    # Use awk to nullify lines between #Preview { and matching closing brace
    stripped=$(awk '
        BEGIN { in_preview = 0; depth = 0 }
        /^[[:space:]]*#Preview/ { in_preview = 1; depth = 0 }
        in_preview {
            for (i = 1; i <= length($0); i++) {
                c = substr($0, i, 1)
                if (c == "{") depth++
                else if (c == "}") {
                    depth--
                    if (depth == 0) { in_preview = 0; break }
                }
            }
            print ""
            next
        }
        { print }
    ' "$f")

    # Find suspect lines: capital letter + space inside double quotes after specific UI calls
    matches=$(echo "$stripped" | grep -n -E '\b(Text|Button|Label|Section|navigationTitle|alert|toolbar|placeholder|accessibilityLabel|accessibilityHint)\s*\(\s*"[A-Z][^"]*[a-z][^"]*"' || true)

    if [[ -n "$matches" ]]; then
        # Filter out:
        #   - keys with a dot (e.g., "auth.login.title")
        #   - lines marked // i18n-allow
        filtered=$(echo "$matches" | grep -v '\."[a-z_]\+\.[a-z_]\+' | grep -v 'i18n-allow' || true)

        if [[ -n "$filtered" ]]; then
            echo "=== $f ===" >> "$report_file"
            echo "$filtered" >> "$report_file"
            echo "" >> "$report_file"
            count=$(echo "$filtered" | wc -l | tr -d ' ')
            violations=$((violations + count))
        fi
    fi
done < <(find "$ROOT" -name "*.swift" -type f)

if [[ $violations -gt 0 ]]; then
    echo "Suspect hardcoded UI strings (use String(localized:) or Text(\"namespace.key\"))"
    echo ""
    cat "$report_file"
    echo ""
    echo "FAIL: $violations suspect hardcoded string(s)" >&2
    echo "If a string is intentionally not localized, add // i18n-allow comment on the line"
    exit 1
fi

echo "PASS: no hardcoded UI strings detected"
exit 0
