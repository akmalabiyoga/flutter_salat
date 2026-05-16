#!/bin/bash

# Get the directory where the script is located
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BINARY_NAME="flutter_salat"
BINARY_PATH="$SCRIPT_DIR/$BINARY_NAME"
WRAPPER_PATH="$SCRIPT_DIR/run_app.sh"
ICON_PATH="$SCRIPT_DIR/app_icon.png"
DESKTOP_FILE="$HOME/.local/share/applications/flutter_salat.desktop"

# Check if binary exists
if [ ! -f "$BINARY_PATH" ]; then
    # Try one level up (in case it's in a subfolder)
    BINARY_PATH="$SCRIPT_DIR/bundle/$BINARY_NAME"
    WRAPPER_PATH="$SCRIPT_DIR/bundle/run_app.sh"
    ICON_PATH="$SCRIPT_DIR/bundle/app_icon.png"
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
Name=Flutter Salat
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
