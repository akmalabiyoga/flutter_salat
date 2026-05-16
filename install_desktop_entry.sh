#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BINARY_PATH="$SCRIPT_DIR/flutter_salat"
ICON_PATH="$SCRIPT_DIR/app_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/flutter_salat.desktop"

# Check if binary exists
if [ ! -f "$BINARY_PATH" ]; then
    # Try one level up (in case it's in a subfolder)
    BINARY_PATH="$SCRIPT_DIR/bundle/flutter_salat"
    ICON_PATH="$SCRIPT_DIR/bundle/app_icon.png"
fi

if [ ! -f "$BINARY_PATH" ]; then
    echo "Error: Binary not found. Please ensure you are running this from the extracted app folder."
    exit 1
fi

# Create the .desktop file
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Flutter Salat
Comment=Prayer Schedule Application
Exec=$BINARY_PATH
Icon=$ICON_PATH
Terminal=false
Categories=Utility;
StartupWMClass=com.dedoy.flutter_salat
EOF

chmod +x "$DESKTOP_FILE"

echo "Desktop entry created successfully at $DESKTOP_FILE"
echo "You can now find 'Flutter Salat' in your application menu!"
