#!/usr/bin/env bash

echo "[INFO] Starting MPV and Seanime environment installation..."

# 1. Download clean mpv-anime-build
echo "[INFO] Step 1/4: Downloading mpv-anime-build repository..."
rm -rf ~/.config/mpv
git clone https://github.com/Chinna95P/mpv-anime-build.git ~/.config/mpv

# 2. Install custom scripts
echo "[INFO] Step 2/4: Installing Ryoku synchronization and RPi5 scripts..."
mkdir -p ~/.local/bin
cp bin/update-colors.sh ~/.local/bin/
cp bin/rpivnc ~/.local/bin/
chmod +x ~/.local/bin/update-colors.sh ~/.local/bin/rpivnc

# 3. Install and activate systemd services
echo "[INFO] Step 3/4: Configuring systemd background automation..."
mkdir -p ~/.config/systemd/user
# Copy ALL service files (mpv-colors and seanime)
cp systemd/* ~/.config/systemd/user/
systemctl --user daemon-reload
systemctl --user enable --now mpv-colors.path
# Enable and start Seanime service
systemctl --user enable --now seanime.service

# 4. Trigger the first run
echo "[INFO] Step 4/4: Applying initial color synchronization..."
~/.local/bin/update-colors.sh

echo "[SUCCESS] Environment is fully installed and synchronized."