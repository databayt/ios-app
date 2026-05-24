#!/usr/bin/env bash
# audit-tenant-scope.sh — verify every FetchDescriptor includes a schoolId predicate
#
# Exit codes:
#   0 — all queries scoped
#   1 — at least one query missing schoolId
#   2 — script error

set -euo pipefail

ROOT="${ROOT:-hogwarts}"

if [[ ! -d "$ROOT" ]]; then
    echo "ERROR: $ROOT not found" >&2
    exit 2
fi

violations=0

# Find all FetchDescriptor usages
fetch_files=$(grep -rln "FetchDescriptor" "$ROOT" --include="*.swift" || true)

for f in $fetch_files; do
    # Skip test fixtures
    if [[ "$f" == *Tests/* ]]; then continue; fi
    # Skip generated/__generated__
    if [[ "$f" == *__generated__/* ]]; then continue; fi

    # Read file content
    content=$(cat "$f")

    # Look for FetchDescriptor blocks (multi-line)
    # A "block" is FetchDescriptor<T>(...) — we check the surrounding ~15 lines for `schoolId`
    if grep -qE "FetchDescriptor<[A-Z]" "$f"; then
        # Use awk to check each FetchDescriptor block
        awk '
            /FetchDescriptor</ {
                in_block = 1
                block_start = NR
                block = $0
                block_has_school_id = 0
                if (match($0, /schoolId/)) block_has_school_id = 1
                next
            }
            in_block {
                block = block "\n" $0
                if (match($0, /schoolId/)) block_has_school_id = 1
                # End of block heuristic: matched paren count goes to 0
                if (match($0, /\)$/)) {
                    if (!block_has_school_id) {
                        printf "  %s:%d  FetchDescriptor without schoolId predicate\n", FILENAME, block_start
                        exit_code = 1
                    }
                    in_block = 0
                }
            }
            END { exit exit_code+0 }
        ' "$f" || violations=$((violations + 1))
    fi
done

# Also flag direct .filter/.first calls on @Query without schoolId
suspect_queries=$(grep -rn "@Query\b" "$ROOT" --include="*.swift" | grep -v "schoolId" | grep -v "Tests/" || true)

if [[ -n "$suspect_queries" ]]; then
    echo "Suspect @Query without schoolId:"
    echo "$suspect_queries"
    violations=$((violations + 1))
fi

echo ""
if [[ $violations -gt 0 ]]; then
    echo "FAIL: $violations file(s) with un-scoped queries" >&2
    exit 1
fi

echo "PASS: every FetchDescriptor / @Query includes schoolId predicate"
exit 0
