#!/bin/bash

# Modified by: Stucklabs

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

print_message "$BLUE" "=================================================="
print_message "$GREEN" "🧠 Cloud9 Installation Script - Modified by Stucklabs"
print_message "$BLUE" "=================================================="

print_message "$YELLOW" "🔎 Detecting OS..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  print_message "$RED" "❌ Cannot detect Linux distribution. Exiting..."
  exit 1
fi

print_message "$BLUE" "📦 Detected OS: $OS"

if [[ "$OS" != "ubuntu" && "$OS" != "debian" ]]; then
  print_message "$RED" "❌ Unsupported OS: $OS. Only Ubuntu/Debian supported."
  exit 1
fi

print_message "$YELLOW" "⚙️ Step 1: Updating and upgrading system..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y snapd git curl wget unzip zip software-properties-common lsb-release

print_message "$YELLOW" "🐘 Installing PHP 7.4 + extensions..."
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update -y
sudo apt install -y php7.4 php7.4-cli php7.4-curl php7.4-mbstring php7.4-zip php7.4-xml php7.4-bcmath php7.4-mysql

print_message "$YELLOW" "🟩 Installing Node.js v18..."
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

print_message "$YELLOW" "🐍 Installing Python 2.7..."
sudo apt install -y python2.7

print_message "$YELLOW" "🐳 Step 2: Installing Docker..."
sudo snap install docker

print_message "$YELLOW" "📥 Step 3: Pulling Cloud9 Docker image..."
sudo docker pull lscr.io/linuxserver/cloud9

USERNAME="admin"
PASSWORD="admin"

print_message "$YELLOW" "🚀 Step 4: Running Cloud9 container..."
sudo docker run -d \
  --name=Priv8-Tools \
  -e USERNAME=$USERNAME \
  -e PASSWORD=$PASSWORD \
  -p 8000:8000 \
  lscr.io/linuxserver/cloud9:latest

print_message "$YELLOW" "⏳ Waiting for 1 minute before configuring..."
sleep 60

print_message "$YELLOW" "⚙️ Step 5: Configuring Cloud9 container..."
sudo docker exec Priv8-Tools /bin/bash -c "
  apt update -y && \
  apt upgrade -y && \
  apt install -y curl zip unzip wget php7.4-cli php7.4-curl nodejs python2.7 && \
  cd /c9bins/.c9/ && \
  rm -rf user.settings && \
  wget https://raw.githubusercontent.com/yongkico/cloud9/refs/heads/main/user.settings
"

print_message "$YELLOW" "♻️ Restarting Cloud9 container..."
sudo docker restart Priv8-Tools

print_message "$YELLOW" "🌐 Fetching public IP..."
PUBLIC_IP=$(curl -s ifconfig.me || echo "localhost")

print_message "$BLUE" "=================================================="
print_message "$GREEN" "✅ Cloud9 Setup Completed Successfully by Stucklabs!"
print_message "$BLUE" "=================================================="
print_message "$YELLOW" "🔗 Access Cloud9: http://$PUBLIC_IP:8000"
print_message "$YELLOW" "👤 Username: $USERNAME"
print_message "$YELLOW" "🔑 Password: $PASSWORD"
print_message "$BLUE" "=================================================="

# Optional cleanup
sudo rm -rf install-cloud9.sh c9.sh
