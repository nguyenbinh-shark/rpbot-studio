#!/usr/bin/env bash
# Install RPBot Studio for the current user (no sudo needed).
#   ./install.sh              copy the app to ~/.local/share/rpbot-studio and add it to the app menu
#   ./install.sh --uninstall  remove the app and its menu entry
set -euo pipefail
src="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
data="${XDG_DATA_HOME:-$HOME/.local/share}"
dest="$data/rpbot-studio"
entry="$data/applications/rpbot-studio.desktop"

if [ "${1:-}" = --uninstall ]; then
    rm -rf "$dest" "$entry"
    echo "Removed RPBot Studio. Settings and logs stay in ~/.local/state/RPBotConsole."
    exit 0
fi

mkdir -p "$dest" "$(dirname "$entry")"
install -m 755 "$src/RPBotStudio" "$dest/"
install -m 644 "$src/rpbot-studio.png" "$dest/"
cat > "$entry" <<EOF
[Desktop Entry]
Type=Application
Name=RPBot Studio
Comment=Mapping, Navigation and diagnostics for RPBot
Exec="$dest/RPBotStudio"
Icon=$dest/rpbot-studio.png
Terminal=false
Categories=Development;Engineering;
StartupWMClass=RPBotStudio
EOF
command -v update-desktop-database >/dev/null && update-desktop-database "$(dirname "$entry")" || true

[ -f /opt/ros/jazzy/setup.bash ] || echo "Note: RPBot Studio needs ROS 2 Jazzy with RViz: sudo apt install ros-jazzy-desktop"
command -v ssh >/dev/null || echo "Note: RPBot Studio needs ssh: sudo apt install openssh-client"
echo "Installed in $dest. Open RPBot Studio from the app menu."
