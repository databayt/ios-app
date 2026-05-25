#!/usr/bin/env bash
# SHIP-002 — Capture App Store screenshots across 2 device sizes × 2 locales.
#
# Usage:
#   scripts/capture-app-store-screenshots.sh                       # all flows × all locales × all sizes
#   FLOW=dashboard scripts/capture-app-store-screenshots.sh        # one flow
#   LOCALE=ar SIZE="iPhone 17 Pro Max" scripts/capture-app-store-screenshots.sh
#
# Output: build/screenshots/{locale}/{size}/{flow}.png
# Apple wants these sizes (App Store Connect 2026):
#   - 6.9" iPhone (iPhone 17 Pro Max)  — 1320 × 2868
#   - 6.1" iPhone (iPhone 17)          — 1206 × 2622
#   - 13" iPad Pro                      — 2064 × 2752
#
# Two locales: en + ar (RTL). Each flow yields one screenshot per
# size × locale combo, so total = flows × 2 × 3 = N images.
#
# The actual flow navigation is driven by HogwartsUITests target
# (XCTest) — this script wraps `xcodebuild test` with the right
# destination + environment, then collects the rendered screenshots
# out of the result bundle.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
cd "$REPO_ROOT"

# ---------------------------------------------------------------------------
# Config — override via env
# ---------------------------------------------------------------------------

FLOWS=( ${FLOW:-login dashboard attendance messages fees} )
LOCALES=( ${LOCALE:-en ar} )
SIZES=( ${SIZE:-"iPhone 17 Pro Max" "iPhone 17" "iPad Pro 13-inch (M4)"} )
OS_VERSION="${OS_VERSION:-26.4}"
SCHEME="${SCHEME:-Hogwarts}"
RESULT_BUNDLE="${RESULT_BUNDLE:-build/screenshots.xcresult}"
OUTPUT_DIR="${OUTPUT_DIR:-build/screenshots}"

mkdir -p "$OUTPUT_DIR"
rm -rf "$RESULT_BUNDLE"

# ---------------------------------------------------------------------------
# Capture loop
# ---------------------------------------------------------------------------

xcodegen generate >/dev/null

for size in "${SIZES[@]}"; do
  for locale in "${LOCALES[@]}"; do
    safe_size="$(echo "$size" | tr -cd '[:alnum:]')"
    bundle="build/screenshots-$safe_size-$locale.xcresult"
    rm -rf "$bundle"

    echo "==> Capturing $size / $locale"

    # The UITest reads HOGWARTS_SCREENSHOT_LOCALE + HOGWARTS_SCREENSHOT_FLOWS
    # from env to know which locale + flow subset to drive. The test
    # uses the demo account (admin role) to surface every flow.
    xcodebuild test \
      -scheme "$SCHEME" \
      -destination "platform=iOS Simulator,name=$size,OS=$OS_VERSION" \
      -only-testing:HogwartsUITests/ScreenshotTests \
      -resultBundlePath "$bundle" \
      -skipPackagePluginValidation \
      HOGWARTS_SCREENSHOT_LOCALE="$locale" \
      HOGWARTS_SCREENSHOT_FLOWS="${FLOWS[*]}" \
      | xcbeautify || {
        echo "Test run failed for $size/$locale — see $bundle"
        continue
    }

    # Extract attachments from the result bundle. Apple stores UI test
    # screenshots as PNG attachments inside the .xcresult; xcparse is
    # the standard tool but xcrun can do it too.
    out="$OUTPUT_DIR/$locale/$safe_size"
    mkdir -p "$out"
    xcrun xcresulttool export attachments \
      --path "$bundle" \
      --output-path "$out" >/dev/null

    echo "    saved → $out"
  done
done

echo
echo "==> Done. Screenshots in: $OUTPUT_DIR"
echo "    Upload to App Store Connect:"
echo "    - 6.9\" iPhone screenshots → iPhone 6.9-inch (iPhone 17 Pro Max)"
echo "    - 6.1\" iPhone screenshots → iPhone 6.1-inch (iPhone 17)"
echo "    - 13\" iPad screenshots    → iPad Pro 13-inch"
