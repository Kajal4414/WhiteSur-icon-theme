#!/usr/bin/env bash

# WhiteSur Icon Theme - Cinnamon Desktop Fix
# This script creates xsi- prefixed symlinks for Cinnamon panel icons
# Required for Linux Mint 22.3+ with Cinnamon 6.6+

set -eo pipefail

ROOT_UID=0
ICON_DIR=

# Determine icon directory
if [ "$UID" -eq "$ROOT_UID" ]; then
  ICON_DIR="/usr/share/icons"
else
  ICON_DIR="$HOME/.local/share/icons"
fi

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  WhiteSur Icon Theme - Cinnamon Panel Fix"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

create_xsi_symlinks() {
  local theme_dir=${1}
  local symbolic_dir="${theme_dir}/status/symbolic"

  if [[ ! -d "${symbolic_dir}" ]]; then
    echo "⚠ Warning: ${symbolic_dir} not found, skipping..."
    return
  fi

  echo "Creating Cinnamon-specific icon symlinks in: ${theme_dir##*/}"

  cd "${symbolic_dir}"

  # Audio/Volume icons
  if [[ -f "audio-volume-muted-symbolic.svg" ]]; then
    ln -sf audio-volume-muted-symbolic.svg xsi-audio-volume-muted-symbolic.svg
    ln -sf audio-volume-low-symbolic.svg xsi-audio-volume-low-symbolic.svg
    ln -sf audio-volume-medium-symbolic.svg xsi-audio-volume-medium-symbolic.svg
    ln -sf audio-volume-high-symbolic.svg xsi-audio-volume-high-symbolic.svg
    echo "  ✓ Audio icons linked"
  fi

  # Microphone icons
  if [[ -f "audio-input-microphone-muted-symbolic.svg" ]]; then
    ln -sf audio-input-microphone-muted-symbolic.svg xsi-microphone-sensitivity-muted-symbolic.svg
    ln -sf audio-input-microphone-low-symbolic.svg xsi-microphone-sensitivity-low-symbolic.svg
    ln -sf audio-input-microphone-medium-symbolic.svg xsi-microphone-sensitivity-medium-symbolic.svg
    ln -sf audio-input-microphone-high-symbolic.svg xsi-microphone-sensitivity-high-symbolic.svg
    echo "  ✓ Microphone icons linked"
  fi

  # Battery icons
  if [[ -f "battery-missing-symbolic.svg" ]]; then
    ln -sf battery-missing-symbolic.svg xsi-battery-missing-symbolic.svg
    for level in 0 10 20 30 40 50 60 70 80 90 100; do
      [[ -f "battery-level-${level}-symbolic.svg" ]] && \
        ln -sf battery-level-${level}-symbolic.svg xsi-battery-level-${level}-symbolic.svg
      [[ -f "battery-level-${level}-charging-symbolic.svg" ]] && \
        ln -sf battery-level-${level}-charging-symbolic.svg xsi-battery-level-${level}-charging-symbolic.svg
    done
    echo "  ✓ Battery icons linked"
  fi

  # Network/WiFi icons
  if [[ -f "network-wireless-signal-excellent-symbolic.svg" ]]; then
    ln -sf network-transmit-symbolic.svg xsi-network-transmit-receive-symbolic.svg 2>/dev/null || true
    ln -sf network-vpn-symbolic.svg xsi-network-vpn-symbolic.svg 2>/dev/null || true

    for signal in none ok low good excellent; do
      [[ -f "network-wireless-signal-${signal}-symbolic.svg" ]] && {
        ln -sf network-wireless-signal-${signal}-symbolic.svg xsi-network-wireless-signal-${signal}-symbolic.svg
        ln -sf network-wireless-signal-${signal}-symbolic.svg xsi-network-wireless-signal-${signal}-secure-symbolic.svg
      }
    done
    echo "  ✓ Network/WiFi icons linked"
  fi

  cd - > /dev/null

  # Removable drive icons (devices/symbolic)
  local devices_dir="${theme_dir}/devices/symbolic"
  if [[ -d "${devices_dir}" ]]; then
    cd "${devices_dir}"
    [[ -f "drive-removable-media-symbolic.svg" ]] && {
      ln -sf drive-removable-media-symbolic.svg xsi-drive-removable-media-symbolic.svg
      echo "  ✓ Removable drive icons linked"
    }
    cd - > /dev/null
  fi
}

update_icon_cache() {
  local theme_dir=${1}

  if command -v gtk-update-icon-cache >/dev/null 2>&1; then
    echo "Updating icon cache for: ${theme_dir##*/}"
    gtk-update-icon-cache -f -t "${theme_dir}" 2>/dev/null || true
  fi
}

# Process all WhiteSur theme variants
for theme in WhiteSur WhiteSur-dark WhiteSur-light; do
  theme_path="${ICON_DIR}/${theme}"

  if [[ -d "${theme_path}" ]]; then
    echo ""
    create_xsi_symlinks "${theme_path}"
    update_icon_cache "${theme_path}"
  fi
done

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✓ Cinnamon panel icon fix complete!"
echo ""
echo "To apply changes:"
echo "  • Press Alt+F2, type 'r' and press Enter"
echo "  • Or restart Cinnamon: killall cinnamon && cinnamon &"
echo "  • Or logout and login again"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
