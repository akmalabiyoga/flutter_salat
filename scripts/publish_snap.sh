#!/bin/bash

# Exit on error
set -e

echo "🚀 Preparing to build and publish Jadwal Salat Snap..."

# Ensure we are in the project root
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Please run this script from the project root."
    exit 1
fi

# 1. Clean and build Flutter Linux (optional but good for testing)
echo "🧹 Cleaning project..."
flutter clean
flutter pub get

# 2. Build the Snap
echo "📦 Building Snap (this might take a while)..."
if command -v snapcraft >/dev/null 2>&1; then
    snapcraft pack
else
    echo "❌ Error: snapcraft is not installed. Please install it with: sudo snap install snapcraft --classic"
    exit 1
fi

# 3. Check generated snap file
SNAP_FILE=$(ls *.snap 2>/dev/null | head -n 1)
if [ -z "$SNAP_FILE" ]; then
    echo "❌ Error: Snap file was not generated."
    exit 1
fi

echo "✅ Snap built successfully: $SNAP_FILE"

# 4. Instructions for local testing
echo ""
echo "📝 To test the snap locally, run:"
echo "   sudo snap install --dangerous $SNAP_FILE"
echo ""

# 5. Instructions for publishing
echo "🌐 To publish to the Snap Store:"
echo "   1. snapcraft login"
echo "   2. snapcraft register jadwal-salat  (if not registered yet)"
echo "   3. snapcraft upload --release=stable $SNAP_FILE"
echo ""
