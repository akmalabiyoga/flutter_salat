#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BINARY_NAME="jadwal_salat"
BINARY_PATH="$SCRIPT_DIR/$BINARY_NAME"
WRAPPER_PATH="$SCRIPT_DIR/run_app.sh"
ICON_PATH="$SCRIPT_DIR/app_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/com.dedoy.flutter_salat.desktop"

# Remove old desktop file if it exists
rm -f "$HOME/.local/share/applications/flutter_salat.desktop"

# Check if binary exists
if [ ! -f "$BINARY_PATH" ]; then
    # Try common Flutter build locations
    if [ -f "$SCRIPT_DIR/build/linux/x64/release/bundle/$BINARY_NAME" ]; then
        BINARY_PATH="$SCRIPT_DIR/build/linux/x64/release/bundle/$BINARY_NAME"
        WRAPPER_PATH="$SCRIPT_DIR/build/linux/x64/release/bundle/run_app.sh"
        ICON_PATH="$SCRIPT_DIR/assets/app_icon.png"
        [ ! -f "$ICON_PATH" ] && ICON_PATH="$SCRIPT_DIR/build/linux/x64/release/bundle/data/flutter_assets/assets/app_icon.png"
    elif [ -f "$SCRIPT_DIR/build/linux/x64/debug/bundle/$BINARY_NAME" ]; then
        BINARY_PATH="$SCRIPT_DIR/build/linux/x64/debug/bundle/$BINARY_NAME"
        WRAPPER_PATH="$SCRIPT_DIR/build/linux/x64/debug/bundle/run_app.sh"
        ICON_PATH="$SCRIPT_DIR/assets/app_icon.png"
        [ ! -f "$ICON_PATH" ] && ICON_PATH="$SCRIPT_DIR/build/linux/x64/debug/bundle/data/flutter_assets/assets/app_icon.png"
    else
        # Try one level up (in case it's in a subfolder)
        BINARY_PATH="$SCRIPT_DIR/bundle/$BINARY_NAME"
        WRAPPER_PATH="$SCRIPT_DIR/bundle/run_app.sh"
        ICON_PATH="$SCRIPT_DIR/bundle/data/flutter_assets/assets/app_icon.png"
    fi
fi

# Fallback for icon if not set yet or not found
if [ ! -f "$ICON_PATH" ]; then
    if [ -f "$SCRIPT_DIR/assets/app_icon.png" ]; then
        ICON_PATH="$SCRIPT_DIR/assets/app_icon.png"
    elif [ -f "$SCRIPT_DIR/app_icon.png" ]; then
        ICON_PATH="$SCRIPT_DIR/app_icon.png"
    fi
fi

if [ ! -f "$BINARY_PATH" ]; then
    echo "Error: Binary not found. Please ensure you are running this from the extracted app folder."
    exit 1
fi

# Create the wrapper script if it doesn't exist
cat <<EOF > "$WRAPPER_PATH"
#!/bin/bash
SCRIPT_DIR="\$( cd "\$( dirname "\${BASH_SOURCE[0]}" )" && pwd )"
export LD_LIBRARY_PATH="\$SCRIPT_DIR/lib:\$LD_LIBRARY_PATH"
exec "\$SCRIPT_DIR/$BINARY_NAME" "\$@"
EOF
chmod +x "$WRAPPER_PATH"

# Create the .desktop file pointing to the WRAPPER
cat <<EOF > "$DESKTOP_FILE"
[Desktop Entry]
Version=1.0
Type=Application
Name=Jadwal Salat
Comment=Prayer Schedule Application
Exec=$WRAPPER_PATH
Icon=$ICON_PATH
Terminal=false
Categories=Utility;
StartupWMClass=com.dedoy.flutter_salat
EOF

chmod +x "$DESKTOP_FILE"

echo "Desktop entry created successfully at $DESKTOP_FILE"
echo "The app will now use bundled libraries automatically!"
