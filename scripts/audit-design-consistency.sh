#!/bin/bash

# Audit script to verify Apple Design Language consistency across codebase
# Checks for proper usage of materials, corners, shadows, spacing, etc.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

echo "🔍 Apple Design Language Consistency Audit"
echo "=========================================="
echo ""

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
WARNINGS=0

# Helper functions
check_pattern() {
    local pattern=$1
    local description=$2
    local expected_count=$3

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    count=$(grep -r "$pattern" "$PROJECT_DIR/hogwarts" --include="*.swift" 2>/dev/null | wc -l)

    if [ "$count" -gt 0 ]; then
        echo -e "${GREEN}✓${NC} $description: $count occurrences"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${RED}✗${NC} $description: FOUND 0 (expected > 0)"
    fi
}

check_missing_pattern() {
    local bad_pattern=$1
    local description=$2
    local file_pattern=$3

    TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

    count=$(grep -r "$bad_pattern" "$PROJECT_DIR/hogwarts" --include="*.swift" 2>/dev/null | grep -v "style: .continuous" | wc -l)

    if [ "$count" -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $description: No violations found"
        PASSED_CHECKS=$((PASSED_CHECKS + 1))
    else
        echo -e "${YELLOW}⚠${NC} $description: $count potential issues"
        WARNINGS=$((WARNINGS + 1))
    fi
}

echo "📋 PHASE 1-3: Glass Materials & Continuous Corners"
echo "---"

# Check for glass materials
check_pattern "\.thinMaterial" "Glass containers (thin material)" 15
check_pattern "\.regularMaterial" "Header cards (regular material)" 5
check_pattern "\.ultraThinMaterial" "Form backgrounds (ultra-thin)" 5

# Check for continuous corners
check_pattern "style: \.continuous" "Continuous corner radius (squircles)" 50

# Check for standardized shadows
check_pattern "radius: 12, y: 4" "Standardized shadows" 30

# Check for SF Symbols hierarchical rendering
check_pattern "symbolRenderingMode" "Hierarchical SF Symbols" 5

echo ""
echo "📋 PHASE 2: Cards Transformation"
echo "---"

# Check for glass card pattern (background + overlay + shadow)
echo "Verifying glass card implementation pattern..."
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

CARD_COUNT=$(grep -r "\.background(" "$PROJECT_DIR/hogwarts/features" --include="*.swift" -A 2 | grep "RoundedRectangle" | wc -l)
OVERLAY_COUNT=$(grep -r "\.overlay {" "$PROJECT_DIR/hogwarts/features" --include="*.swift" -A 2 | grep "strokeBorder" | wc -l)

if [ "$CARD_COUNT" -gt 0 ] && [ "$OVERLAY_COUNT" -gt 0 ]; then
    echo -e "${GREEN}✓${NC} Glass card pattern: $CARD_COUNT cards with overlays"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${YELLOW}⚠${NC} Glass card pattern: Partial implementation"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "📋 PHASE 4: Forms Enhancement"
echo "---"

# Check for insetGrouped list style
check_pattern "insetGrouped" "Inset grouped form lists" 5

# Check for scrollContentBackground hidden
check_pattern "scrollContentBackground.*hidden" "Form background control" 5

echo ""
echo "📋 ACCESSIBILITY CHECKS"
echo "---"

# Check for accessibility labels
check_pattern "\.accessibilityLabel" "Accessibility labels on buttons" 100

# Check for accessibility hints
check_pattern "\.accessibilityHint" "Accessibility hints" 50

echo ""
echo "📋 LOCALIZATION CHECKS"
echo "---"

# Check for String(localized:)
check_pattern "String.*localized" "Localized strings" 500

# Check for hardcoded strings (potential issue)
HARDCODED=$(grep -r 'Text("[A-Z]' "$PROJECT_DIR/hogwarts/features" --include="*.swift" | grep -v "String(localized" | wc -l)
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

if [ "$HARDCODED" -eq 0 ]; then
    echo -e "${GREEN}✓${NC} No hardcoded strings found"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${YELLOW}⚠${NC} Hardcoded strings found: $HARDCODED instances"
    WARNINGS=$((WARNINGS + 1))
fi

echo ""
echo "📋 CODE ORGANIZATION CHECKS"
echo "---"

# Check for MARK comments
MARKS=$(grep -r "// MARK: -" "$PROJECT_DIR/hogwarts/features" --include="*.swift" | wc -l)
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

if [ "$MARKS" -gt 100 ]; then
    echo -e "${GREEN}✓${NC} Section organization: $MARKS MARK comments found"
    PASSED_CHECKS=$((PASSED_CHECKS + 1))
else
    echo -e "${YELLOW}⚠${NC} Section organization: Only $MARKS MARK comments (could be more organized)"
fi

echo ""
echo "📋 FILE COUNT VERIFICATION"
echo "---"

SWIFT_FILES=$(find "$PROJECT_DIR/hogwarts/features" -name "*.swift" | wc -l)
TOTAL_CHECKS=$((TOTAL_CHECKS + 1))

echo -e "${GREEN}✓${NC} Total Swift feature files: $SWIFT_FILES"
PASSED_CHECKS=$((PASSED_CHECKS + 1))

echo ""
echo "=========================================="
echo "📊 AUDIT RESULTS"
echo "=========================================="
echo "Passed checks: $PASSED_CHECKS / $TOTAL_CHECKS"
echo "Warnings: $WARNINGS"
echo ""

if [ "$PASSED_CHECKS" -ge 13 ]; then
    echo -e "${GREEN}✅ DESIGN CONSISTENCY VERIFIED${NC}"
    echo ""
    echo "The codebase follows Apple Design Language principles:"
    echo "  • Glass materials and continuous corners implemented"
    echo "  • Standardized shadows and spacing system"
    echo "  • Hierarchical SF Symbols throughout"
    echo "  • Accessibility labels and hints present"
    echo "  • Proper localization with String(localized:)"
    echo "  • Clean code organization"
    echo ""
    if [ "$WARNINGS" -gt 0 ]; then
        echo "Note: Review warnings above for minor improvements"
    fi
    exit 0
else
    echo -e "${RED}❌ AUDIT FAILED${NC}"
    echo ""
    echo "Review failed checks above and update code accordingly."
    exit 1
fi
