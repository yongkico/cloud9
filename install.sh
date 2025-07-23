#!/bin/bash
#
# 📦 Cloud9 Installation Script — modified by Stucklabs
#    (original base: Priv8 Tools)
#

print_message() {
  local COLOR=$1
  local MESSAGE=$2
  local RESET="\033[0m"
  echo -e "${COLOR}${MESSAGE}${RESET}"
}

GREEN="\033[1;32m"
BLUE="\033[1;34m"
YELLOW="\033[1;33m"
RED="\033[1;31m"

print_message "$BLUE"  "══════════════════════════════════════════════════"
print_message "$GREEN" "🚀  Cloud9 Installation Script — Stucklabs Edition ⚒️"
print_message "$BLUE"  "══════════════════════════════════════════════════"

print_message "$YELLOW" "🔎  Detecting Linux distribution…"
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  print_message "$RED"  "❌  Unable to detect Linux distribution. Exiting…"
  exit 1
fi

print_message "$BLUE"  "🖥️  Detected OS: $OS"

if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
  print_message "$RED"  "❌  Unsupported OS: $OS  (only Ubuntu & Debian). Exiting…"
  exit 1
fi

print_message "$YELLOW" "🔧  Step 1/6 — Updating system…"
sudo apt update -y && sudo apt upgrade -y && sudo apt install -y snapd git
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  System updated successfully."
else
  print_message "$RED"  "❌  System update failed."
  exit 1
fi

print_message "$YELLOW" "🐳  Step 2/6 — Installing Docker (Snap)…"
sudo snap install docker
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  Docker installed."
else
  print_message "$RED"  "❌  Docker installation failed."
  exit 1
fi

print_message "$YELLOW" "📥  Step 3/6 — Pulling Cloud9 image…"
sudo docker pull lscr.io/linuxserver/cloud9
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  Cloud9 image pulled."
else
  print_message "$RED"  "❌  Image pull failed."
  exit 1
fi

USERNAME="admin"
PASSWORD="admin"

print_message "$YELLOW" "🚀  Step 4/6 — Running Cloud9 container…"
sudo docker run -d \
  --name=stucklabs-c9 \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -p 8000:8000 \
  lscr.io/linuxserver/cloud9:latest
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  Cloud9 container running."
else
  print_message "$RED"  "❌  Failed to start Cloud9 container."
  exit 1
fi

print_message "$YELLOW" "⏳  Waiting 60 s before configuration…"
sleep 60

print_message "$YELLOW" "⚙️  Step 5/6 — Configuring container + dev tools…"
sudo docker exec stucklabs-c9 /bin/bash -c "
  set -e
  apt update -y && apt upgrade -y

  # — Basic utilities
  apt install -y wget curl gnupg lsb-release software-properties-common

  # — PHP extensions (retain original)
  apt install -y php-cli php-curl

  # — Node.js v18 (via NodeSource)
  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
  apt install -y nodejs

  # — Python 2.7 (legacy support)
  apt install -y python2

  # — Restore Cloud9 user.settings
  cd /c9bins/.c9/ && \
  rm -f user.settings && \
  wget -q https://raw.githubusercontent.com/yongkico/cloud9/refs/heads/main/user.settings
"
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  Container configured (Node v18 + Python 2.7 installed)."
else
  print_message "$RED"  "❌  Container configuration failed."
  exit 1
fi

print_message "$YELLOW" "🔄  Restarting container…"
sudo docker restart stucklabs-c9
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅  Container restarted."
else
  print_message "$RED"  "❌  Restart failed."
  exit 1
fi

print_message "$YELLOW" "🌐  Step 6/6 — Fetching public IP…"
PUBLIC_IP=$(curl -s ifconfig.me || echo "localhost")

print_message "$BLUE"  "══════════════════════════════════════════════════"
print_message "$GREEN" "🎉  Cloud9 (Stucklabs Edition) is ready!"
print_message "$BLUE"  "══════════════════════════════════════════════════"
print_message "$YELLOW" "🔗  Access:   http://$PUBLIC_IP:8000"
print_message "$YELLOW" "👤  Username: $USERNAME"
print_message "$YELLOW" "🔒  Password: $PASSWORD"
print_message "$BLUE"  "══════════════════════════════════════════════════"

# Optional cleanup of installer
sudo rm -f install-cloud9.sh c9.sh
