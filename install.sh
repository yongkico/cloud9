#!/bin/bash

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

# Header
print_message "$BLUE" "=========================================================="
print_message "$GREEN" "🧠 Cloud9 Installer — Modified by Stucklabs ⚙️"
print_message "$BLUE" "=========================================================="

# OS detection
print_message "$YELLOW" "🔍 Checking your Linux distribution..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  print_message "$RED" "❌ Could not detect OS. Aborting..."
  exit 1
fi

print_message "$BLUE" "📦 Detected OS: $OS"
if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
  print_message "$RED" "🚫 Unsupported OS: $OS — Only Ubuntu/Debian allowed."
  exit 1
fi

# Step 1: Update system
print_message "$YELLOW" "🔧 Step 1: Updating your system..."
sudo apt update -y && sudo apt upgrade -y && sudo apt install snapd git -y
sleep 5
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ System updated successfully."
else
  print_message "$RED" "❌ Failed to update system."
  exit 1
fi

# Step 2: Install Docker
print_message "$YELLOW" "🐳 Step 2: Installing Docker..."
sudo snap install docker
sleep 5
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ Docker installed."
else
  print_message "$RED" "❌ Docker installation failed."
  exit 1
fi

# Step 3: Pull Cloud9 image
print_message "$YELLOW" "📦 Step 3: Pulling Cloud9 image..."
sudo docker pull lscr.io/linuxserver/cloud9
sleep 5
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ Cloud9 image pulled."
else
  print_message "$RED" "❌ Failed to pull Cloud9 image."
  exit 1
fi

# Generate random 8-char password
USERNAME="admin"
PASSWORD=$(< /dev/urandom tr -dc A-Za-z0-9 | head -c8)

# Step 4: Run Cloud9 container
print_message "$YELLOW" "🚀 Step 4: Starting Cloud9 container..."
sudo docker run -d \
  --name=Stucklabs-Cloud9 \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -p 8000:8000 \
  lscr.io/linuxserver/cloud9:latest

if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ Cloud9 container is now running."
else
  print_message "$RED" "❌ Failed to run container."
  exit 1
fi

# Step 5: Configure Cloud9
print_message "$YELLOW" "🛠️ Step 5: Configuring Cloud9 container (wait 60s)..."
sleep 60

sudo docker exec Stucklabs-Cloud9 /bin/bash -c "
  apt update -y && \
  apt upgrade -y && \
  apt install wget -y && \
  apt install php-cli -y && \
  apt install php-curl -y && \
  cd /c9bins/.c9/ && \
  rm -rf user.settings && \
  wget https://raw.githubusercontent.com/yongkico/cloud9/refs/heads/main/user.settings
"
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ Configuration complete."
else
  print_message "$RED" "❌ Configuration failed."
  exit 1
fi

# Restart container
print_message "$YELLOW" "🔄 Restarting Cloud9 container..."
sudo docker restart Stucklabs-Cloud9
if [ $? -eq 0 ]; then
  print_message "$GREEN" "✅ Restarted successfully."
else
  print_message "$RED" "❌ Restart failed."
  exit 1
fi

# Show access info
print_message "$YELLOW" "🌐 Finalizing setup — Fetching public IP..."
PUBLIC_IP=$(curl -s ifconfig.me)
if [ $? -ne 0 ]; then
  PUBLIC_IP="localhost"
fi

print_message "$BLUE" "====================================================="
print_message "$GREEN" "🎉 Cloud9 is ready to use! — Stucklabs Dev Edition 🎉"
print_message "$BLUE" "====================================================="
print_message "$YELLOW" "🔗 Access URL  : http://$PUBLIC_IP:8000"
print_message "$YELLOW" "👤 Username    : $USERNAME"
print_message "$YELLOW" "🔐 Password    : $PASSWORD"
print_message "$YELLOW" "====================================================="

# Cleanup
sudo rm -rf install-cloud9.sh c9.sh
