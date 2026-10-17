#!/usr/bin/env bash
# Build the Linux package of RPBot Studio on Ubuntu 24.04 (native or WSL).
# Needs: sudo apt install python3-tk python3-venv binutils
# Output: dist/linux/RPBotStudio-Linux-<arch>.tar.gz (install with ./install.sh inside it).
# The binary needs glibc 2.39 or newer, i.e. Ubuntu 24.04 or later.
set -euo pipefail
here="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
repo="$(cd -- "$here/../.." && pwd)"
venv="${RPBOT_BUILD_VENV:-$HOME/.cache/rpbot-build-venv}"
# Build and stage on the Linux file system so tar keeps real file modes (not /mnt/<drive>).
work="$(mktemp -d "${TMPDIR:-/tmp}/rpbot-studio-build.XXXXXX")"
trap 'rm -rf "$work"' EXIT
name="RPBotStudio-Linux-$(uname -m)"
stage="$work/$name"

python3 -c 'import tkinter' 2>/dev/null || {
    echo 'Missing Tk: sudo apt install python3-tk python3-venv' >&2; exit 1; }
if [ ! -x "$venv/bin/pyinstaller" ]; then
    python3 -m venv "$venv"
    "$venv/bin/pip" install -q -r "$repo/requirements-build.txt"
fi

mkdir -p "$stage"
"$venv/bin/python" -B -m PyInstaller --noconfirm --log-level WARN \
    --distpath "$stage" --workpath "$work/pyinstaller" "$repo/RPBotStudio.spec"
install -m 644 "$repo/assets/rpbot-studio-256.png" "$stage/rpbot-studio.png"
install -m 644 "$here/README.txt" "$stage/"
install -m 755 "$here/install.sh" "$stage/"

mkdir -p "$repo/dist/linux"
tar -C "$work" -czf "$work/$name.tar.gz" "$name"
cp "$work/$name.tar.gz" "$repo/dist/linux/"
ls -l "$stage"
sha256sum "$repo/dist/linux/$name.tar.gz"
