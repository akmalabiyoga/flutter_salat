#!/bin/bash

# Get the absolute path of the project root
PROJECT_ROOT=$(pwd)
BINARY_PATH="$PROJECT_ROOT/build/linux/x64/release/bundle/flutter_salat"
ICON_PATH="$PROJECT_ROOT/assets/app_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/flutter_salat.desktop"

# Check if binary exists
if [ ! -f "$BINARY_PATH" ]; then
    echo "Error: Binary not found at $BINARY_PATH. Please run 'flutter build linux --release' first."
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
echo "You should now be able to find 'Flutter Salat' in your application menu with the correct icon."
