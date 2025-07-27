<h1 align="center">🧠 Cloud9 Installer for Docker</h1>
<p align="center">
  <b>Zero-effort Cloud IDE powered by Docker & Stucklabs.</b><br>
  Instant dev environment with PHP & custom Jet theme.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Cloud9-Docker-blue?logo=docker&style=flat-square">
  <img src="https://img.shields.io/badge/Platform-Ubuntu%20%7C%20Debian-orange?style=flat-square">
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square">
  <img src="https://img.shields.io/badge/Maintained-Yes-success?style=flat-square">
</p>

---

## 🚀 Overview

This script provides a **plug-and-play setup** of Cloud9 IDE in a Docker container with the following features:

- ✅ Automatic installation on Ubuntu/Debian
- 🔐 Randomly generated secure password
- 🧰 Preinstalled PHP CLI, PHP CURL, and Wget
- 🎨 Auto-loaded Jet Theme (`user.settings`)
- 🌍 Exposed via browser on port `8000`

---

## 📦 Requirements

- Ubuntu 20.04+ / Debian 11+
- `snapd`, `git`, `docker`
- Internet access

---

## ⚙️ Installation

### 1. Clone the repository

    git clone https://github.com/yongkico/cloud9.git && cd cloud9

### 2. Make the script executable

    chmod +x install.sh

### 3. Run the installer

    ./install.sh

### 4. Done!

Cloud9 will be accessible at:

    http://<your-public-ip>:8000

> ✅ You will receive your login credentials (admin + random password) after setup.

---

## 🔐 Access Credentials

| Key      | Value                            |
|----------|----------------------------------|
| Username | `admin`                          |
| Password | Generated (shown after install)  |

> ℹ️ The password is only shown once. Save it securely.

---

## 📁 File Structure

| File            | Purpose                                   |
|-----------------|-------------------------------------------|
| `install.sh`    | Main setup script (Docker + Cloud9 + PHP) |
| `user.settings` | Theme configuration (Jet theme)           |

---

## 📌 Notes

- The container uses image: `lscr.io/linuxserver/cloud9`
- Port `8000` is default; change `-p 8000:8000` in `install.sh` if needed
- Restartable via: `docker restart Stucklabs-Cloud9`

---

## 🤝 Credits

Built on top of [LinuxServer.io's Cloud9 image](https://hub.docker.com/r/linuxserver/cloud9)  
Customized & maintained by **Stucklabs**

---

## 📝 License

This project is licensed under the [MIT License](LICENSE).

> Made with 💡 by Stucklabs — Simplifying dev environments.
