🧠 Cloud9 Docker Installer — by Stucklabs

[![Cloud9](https://img.shields.io/badge/Cloud9-Docker-blue?logo=docker&style=flat-square)](https://hub.docker.com/r/linuxserver/cloud9)
[![Platform](https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-orange?style=flat-square)](#)
[![License](https://img.shields.io/badge/License-MIT-green?style=flat-square)](#)

🚀 One-command setup for running Cloud9 IDE in Docker, pre-installed with PHP and custom theme.

---

📦 Requirements

- ✅ Ubuntu / Debian
- ✅ `snapd` and `docker`
- ✅ Internet connection

---

🚀 How to Install

1. Clone this repository:

       git clone https://github.com/YOUR_USERNAME/cloud9.git && cd cloud9

2. Make the script executable:

       chmod +x install.sh

3. Run the installer:

       ./install.sh

4. Done! Cloud9 will be available at:

       http://<your-ip>:8000

---

🔐 Default Login

| Username | Password (Random) |
|----------|-------------------|
|   admin  | Generated & shown after install |

⚠️ Password will only appear once — make sure to copy it.

---

📁 File Overview

| File            | Description                            |
|-----------------|----------------------------------------|
|  install.sh     | Main Cloud9 + Docker setup script      |
|  user.settings  | Cloud9 theme and preferences config    |

---

🤝 Credits

- Docker image: [linuxserver/cloud9](https://hub.docker.com/r/linuxserver/cloud9)
- Modified and maintained by Stucklabs

---

📝 License

MIT License — free for personal & commercial use.
