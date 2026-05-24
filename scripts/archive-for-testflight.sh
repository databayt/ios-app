#!/bin/bash

# Archive Hogwarts iOS app for TestFlight distribution
# Usage: ./scripts/archive-for-testflight.sh [optional-team-id]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$PROJECT_DIR/build"

# Configuration
SCHEME="Hogwarts"
CONFIGURATION="Release"
ARCHIVE_NAME="Hogwarts.xcarchive"
ARCHIVE_PATH="$BUILD_DIR/$ARCHIVE_NAME"
EXPORT_PLIST="$PROJECT_DIR/ExportOptions.plist"

# Optional: Set team ID from argument or environment
TEAM_ID="${1:-${HOGWARTS_TEAM_ID:-}}"

echo "🏗️  Archiving Hogwarts for TestFlight..."
echo "  Scheme: $SCHEME"
echo "  Configuration: $CONFIGURATION"
echo "  Archive: $ARCHIVE_PATH"
[ -n "$TEAM_ID" ] && echo "  Team ID: $TEAM_ID"

# Create build directory
mkdir -p "$BUILD_DIR"

# Build archive
echo ""
echo "📦 Creating archive..."

XCODEBUILD_ARGS=(
    "archive"
    "-scheme" "$SCHEME"
    "-archivePath" "$ARCHIVE_PATH"
    "-configuration" "$CONFIGURATION"
)

# Add team ID if provided
if [ -n "$TEAM_ID" ]; then
    XCODEBUILD_ARGS+=(
        "DEVELOPMENT_TEAM=$TEAM_ID"
        "CODE_SIGN_IDENTITY=Apple Distribution"
    )
fi

xcodebuild "${XCODEBUILD_ARGS[@]}"

if [ ! -d "$ARCHIVE_PATH" ]; then
    echo "❌ Archive failed: $ARCHIVE_PATH not created"
    exit 1
fi

echo "✅ Archive created: $ARCHIVE_PATH"

# Export IPA
echo ""
echo "📤 Exporting IPA..."

IPA_PATH="$BUILD_DIR"
XCODEBUILD_EXPORT_ARGS=(
    "-exportArchive"
    "-archivePath" "$ARCHIVE_PATH"
    "-exportPath" "$IPA_PATH"
    "-exportOptionsPlist" "$EXPORT_PLIST"
)

# Add team ID if provided
if [ -n "$TEAM_ID" ]; then
    XCODEBUILD_EXPORT_ARGS+=(
        "DEVELOPMENT_TEAM=$TEAM_ID"
    )
fi

xcodebuild "${XCODEBUILD_EXPORT_ARGS[@]}"

if [ -f "$IPA_PATH/Hogwarts.ipa" ]; then
    echo "✅ IPA exported: $IPA_PATH/Hogwarts.ipa"
    echo ""
    echo "📊 Build complete!"
    echo ""
    echo "Next steps:"
    echo "  1. Open App Store Connect (https://appstoreconnect.apple.com)"
    echo "  2. Select your app: Hogwarts"
    echo "  3. Go to TestFlight tab"
    echo "  4. Click '+ Version' or '+ Build'"
    echo "  5. Use Xcode or Transporter to upload:"
    echo "     xcrun altool --upload-app -f '$IPA_PATH/Hogwarts.ipa' -t ios -u APPLE_ID -p APP_PASSWORD"
    echo ""
else
    echo "❌ IPA export failed"
    exit 1
fi
