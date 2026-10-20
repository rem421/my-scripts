#!/usr/bin/env bash

echo "[INFO] Starting MPV environment installation..."

# 1. Download clean mpv-anime-build
echo "[INFO] Step 1/4: Downloading mpv-anime-build repository..."
rm -rf ~/.config/mpv
git clone https://github.com/Chinna95P/mpv-anime-build.git ~/.config/mpv

# 2. Install custom scripts
echo "[INFO] Step 2/4: Installing Ryoku synchronization scripts..."
mkdir -p ~/.local/bin
cp bin/update-colors.sh ~/.local/bin/
chmod +x ~/.local/bin/update-colors.sh

# 3. Install and activate systemd services
echo "[INFO] Step 3/4: Configuring systemd background automation..."
mkdir -p ~/.config/systemd/user
cp systemd/mpv-colors.* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now mpv-colors.path

# 4. Trigger the first run
echo "[INFO] Step 4/4: Applying initial color synchronization..."
~/.local/bin/update-colors.sh

echo "[SUCCESS] MPV environment is fully installed and synchronized."