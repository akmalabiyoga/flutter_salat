#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DESKTOP_FILE="$HOME/.local/share/applications/com.dedoy.flutter_salat.desktop"
LEGACY_DESKTOP_FILE="$HOME/.local/share/applications/flutter_salat.desktop"

# Remove the .desktop files
if [ -f "$DESKTOP_FILE" ]; then
    rm "$DESKTOP_FILE"
    echo "Removed desktop entry: $DESKTOP_FILE"
else
    echo "Desktop entry not found: $DESKTOP_FILE"
fi

if [ -f "$LEGACY_DESKTOP_FILE" ]; then
    rm "$LEGACY_DESKTOP_FILE"
    echo "Removed legacy desktop entry: $LEGACY_DESKTOP_FILE"
fi

# Optional: remove the generated wrapper script if it exists in the script directory
WRAPPER_PATH="$SCRIPT_DIR/run_app.sh"
if [ -f "$WRAPPER_PATH" ]; then
    # We only remove it if it was likely created by the install script
    # but since it's inside the bundle, it's usually fine to leave it
    # or remove it. Let's remove it to be clean if they are "uninstalling"
    # the integration.
    rm "$WRAPPER_PATH"
    echo "Removed wrapper script: $WRAPPER_PATH"
fi

echo "Uninstallation of desktop integration complete."
