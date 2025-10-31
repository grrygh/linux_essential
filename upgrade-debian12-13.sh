#!/bin/bash
# ==========================================
# Docker-safe Debian 12 -> 13 (Trixie) upgrade
# ==========================================
set -e

echo "========================================="
echo "⚠️  Make sure you have rolled back your snapshot and taken a fresh backup"
echo "========================================="

# Step 0: Confirm user wants to proceed
read -p "Are you sure you want to proceed with the upgrade? (yes/NO): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Aborted."
    exit 1
fi

# Step 1: Update current Debian 12 system
echo "🔄 Updating current Debian 12 system..."
sudo apt update
sudo apt upgrade -y
sudo apt full-upgrade -y
sudo apt autoremove --purge -y

# Step 2: Remove conflicting Docker Compose
if dpkg -l | grep -q docker-compose; then
    echo "🧹 Removing legacy docker-compose..."
    sudo apt remove docker-compose -y
fi

# Step 3: Hold docker-buildx package to prevent conflicts
echo "✋ Holding docker-buildx to avoid plugin conflicts..."
sudo apt-mark hold docker-buildx || true

# Step 4: Update APT sources to Debian 13 (Trixie)
echo "📦 Updating APT sources to Debian 13 (trixie)..."
sudo sed -i 's/bookworm/trixie/g' /etc/apt/sources.list

# Update Docker repo if exists
DOCKER_LIST="/etc/apt/sources.list.d/docker.list"
if [[ -f "$DOCKER_LIST" ]]; then
    echo "🔧 Updating Docker repo to trixie..."
    sudo sed -i 's/bookworm/trixie/g' "$DOCKER_LIST"
fi

# Step 5: Update package index and upgrade
echo "🔄 Updating package index..."
sudo apt update

echo "⚡ Upgrading packages..."
sudo apt upgrade --without-new-pkgs -y
sudo apt full-upgrade -y

# Step 6: Reinstall Docker Compose plugin if missing
if ! docker compose version >/dev/null 2>&1; then
    echo "🐳 Installing docker-compose-plugin..."
    sudo apt install docker-compose-plugin -y
fi

# Step 7: Cleanup
echo "🧹 Cleaning up..."
sudo apt autoremove --purge -y
sudo apt clean

# Step 8: Verify
echo "✅ Upgrade complete. Verifying..."
lsb_release -a
docker version
docker compose version
docker buildx version
docker ps -a

echo "🎉 Debian 12 → 13 upgrade finished successfully!"
echo "You may reboot the container to ensure everything works properly."
