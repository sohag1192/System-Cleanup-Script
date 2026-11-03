<div align="center">

# 🧹 System Cleanup & Space Optimization Script

**Production-grade, automated Linux & Proxmox disk cleanup and log optimization tools.**

[![Views (Today / Total)](https://hits.sh/github.com/sohag1192/System-Cleanup-Script.svg?view=today-total&style=for-the-badge&label=Views+(Today+/+Total)&color=22c55e&labelColor=1f2937)](https://hits.sh/github.com/sohag1192/System-Cleanup-Script/)
[![Live Web Docs](https://img.shields.io/badge/Web%20Portal-Live%20Site-10b981?style=for-the-badge&logo=google-chrome&logoColor=white)](https://sohag1192.github.io/System-Cleanup-Script/)
[![GitHub Stars](https://img.shields.io/github/stars/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=gold)](https://github.com/sohag1192/System-Cleanup-Script/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=blue)](https://github.com/sohag1192/System-Cleanup-Script/network/members)
[![License](https://img.shields.io/github/license/sohag1192/System-Cleanup-Script?style=for-the-badge&color=green)](LICENSE)
[![Repo Size](https://img.shields.io/github/repo-size/sohag1192/System-Cleanup-Script?style=for-the-badge&color=orange)](https://github.com/sohag1192/System-Cleanup-Script)
[![Last Commit](https://img.shields.io/github/last-commit/sohag1192/System-Cleanup-Script?style=for-the-badge&color=purple)](https://github.com/sohag1192/System-Cleanup-Script/commits/main)

<br/>

<p align="center">
  <a href="https://sohag1192.github.io/System-Cleanup-Script/">🌐 <b>Live Web Portal</b></a> •
  <a href="README.md"><b>English</b></a> •
  <a href="README.bn.md"><b>বাংলা (Bengali)</b></a>
</p>

</div>

---

## 📖 Overview

Over time, Linux and Proxmox servers accumulate gigabytes of disk bloat: systemd journals, rotated log files (`.gz`, `.1`), APT package archives, and trash. If left unchecked, root partitions fill up, leading to crashed databases and stalled services.

This repository provides **battle-tested shell scripts** organized into separate folders for **Ubuntu / Debian** and **Proxmox VE**. Every script safely truncates log files instead of removing them, preventing broken service file descriptors.

---

## 🏆 Which Script is the Best? (Recommended)

| Platform / Service | Best Script | Why It's the Best? |
| :--- | :--- | :--- |
| **Ubuntu / Debian** | [`ubuntu/log_cleanup.sh`](ubuntu/log_cleanup.sh) | 🌟 **Most balanced & safe**: Cleans systemd journal logs (`journalctl`), protects security logs (`wtmp`/`btmp`), truncates without crashing services, and does not remove essential system tools. |
| **Proxmox VE** | [`proxmox/proxmox-cleanup.sh`](proxmox/proxmox-cleanup.sh) | 🌟 **100% Storage Safe**: Vacuums journals, truncates logs and APT caches while strictly protecting **Backups (`/var/lib/vz/dump/`)**, **ISO Images (`/var/lib/vz/template/iso/`)**, and **CT Templates (`/var/lib/vz/template/cache/`)**. |
| **Docker Engine** | [`docker/Docker_log.sh`](docker/Docker_log.sh) | 🐳 **Zero-downtime log cleaner**: Safely truncates container JSON logs without stopping containers, prunes dangling images, build cache, and stopped containers while preserving data volumes. |

---

## 📁 Repository Structure

```plaintext
System-Cleanup-Script/
├── ubuntu/                      # Ubuntu & Debian Server Cleanup Scripts
│   ├── log_cleanup.sh           # ⭐ [BEST] Safe Ubuntu log & journal cleaner with disk report
│   ├── cleaning.sh              # Multi-service cleaner (Nginx, Apache, MySQL, Flussonic)
│   ├── clean_logs.sh            # Standard log and APT cache cleaner
│   ├── clean-logs.sh            # POSIX sh cache & log cleanup
│   └── clean_up.sh              # General cleanup with Nginx RTMP support
├── proxmox/                     # Proxmox VE Cleanup Scripts
│   ├── proxmox-cleanup.sh       # ⭐ [BEST] Storage-safe Proxmox log & cache cleaner
│   └── proxmox_clean.sh         # Lightweight Proxmox cleanup
├── docker/                      # Docker Optimization & Cleanup
│   └── Docker_log.sh            # 🐳 Truncates container JSON logs & prunes cache/images
├── upload.bat                   # Windows batch script for automated git commit & push
├── .gitattributes               # Enforces Unix LF line endings for shell scripts
├── LICENSE                      # MIT License
├── README.md                    # English Documentation
└── README.bn.md                 # বাংলা ডকুমেন্টেশন (Bengali Documentation)
```

---

## ⚡ Quick One-Liner Installation & Execution

### 1. For Ubuntu / Debian (Recommended: `log_cleanup.sh`)

**Direct Run (One-liner):**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh | sudo bash
```

**Download to `/root/` & Run:**
```bash
sudo wget -O /root/log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh
sudo chmod +x /root/log_cleanup.sh
sudo /root/log_cleanup.sh
```

---

### 2. For Proxmox VE (Recommended: `proxmox-cleanup.sh`)

**Direct Run (One-liner):**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh | sudo bash
```

**Download to `/root/` & Run:**
```bash
sudo wget -O /root/proxmox-cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh
sudo chmod +x /root/proxmox-cleanup.sh
sudo /root/proxmox-cleanup.sh
```

> [!IMPORTANT]
> **Proxmox Storage Safety**: `proxmox/proxmox-cleanup.sh` strictly protects your **Backups**, **ISO Images**, and **Container (CT) Templates**. Not a single VM or container image is removed!

---

### 3. For Docker Environment (`Docker_log.sh`)

**Direct Run (One-liner):**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/docker/Docker_log.sh | sudo bash
```

**Download to `/root/` & Run:**
```bash
sudo wget -O /root/Docker_log.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/docker/Docker_log.sh
sudo chmod +x /root/Docker_log.sh
sudo /root/Docker_log.sh
```

---

## 📊 Comprehensive Feature Comparison

| Feature | `ubuntu/log_cleanup.sh` ⭐ | `docker/Docker_log.sh` 🐳 | `proxmox/proxmox-cleanup.sh` ⭐ | `ubuntu/cleaning.sh` |
| :--- | :---: | :---: | :---: | :---: |
| **System Log Truncation** | ✅ (`truncate -s 0`) | ❌ (Docker logs only) | ✅ (`truncate -s 0`) | ✅ (`truncate -s 0`) |
| **Container JSON Log Truncation** | ✅ (Automatic) | ✅ (`*-json.log`) | ❌ | ❌ |
| **Dangling Images & Build Cache Prune** | ❌ | ✅ (`docker prune`) | ❌ | ❌ |
| **Systemd Journal Vacuum** | ✅ (`--vacuum-time=7d`) | ❌ | ✅ (`--vacuum-time=7d`) | ❌ |
| **`wtmp` / `btmp` Login Safe** | ✅ (Protected) | N/A | ✅ (Protected) | ❌ |
| **Old Compressed Logs (`.gz`, `.[0-9]`)** | ✅ Deleted | ❌ | ✅ Deleted | ✅ Deleted |
| **APT Cache & Autoclean** | ✅ | ❌ | ✅ | ✅ |
| **Orphaned Packages (`deborphan`)** | ✅ Safe | ❌ | ✅ Safe | ✅ |
| **Trash Folder Cleanup** | ✅ | ❌ | ✅ | ✅ |
| **Protects Backups & ISO Images** | N/A | N/A | ✅ **100% Untouched** | N/A |
| **Displays Disk Report** | ✅ (`df -h`) | ✅ (`docker system df`) | ❌ | ❌ |

---

## ⏰ Automate with Cron (One-Liner Setup & Management)

You can automate cleanup without manually opening or editing crontab files by first downloading the script to `/root/` and then running the one-liner command:

### ⚡ Option 1: Instant One-Liner (No editor required - Recommended)

**For Ubuntu / Debian (Daily at 3:00 AM):**
```bash
# 1. Download to /root/log_cleanup.sh
sudo wget -O /root/log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh && sudo chmod +x /root/log_cleanup.sh

# 2. Add to crontab in one command
(sudo crontab -l 2>/dev/null | grep -v "log_cleanup.sh"; echo "0 3 * * * /root/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1") | sudo crontab -
```

**For Proxmox VE (Daily at 3:00 AM):**
```bash
# 1. Download to /root/proxmox-cleanup.sh
sudo wget -O /root/proxmox-cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh && sudo chmod +x /root/proxmox-cleanup.sh

# 2. Add to crontab in one command
(sudo crontab -l 2>/dev/null | grep -v "proxmox-cleanup.sh"; echo "0 3 * * * /root/proxmox-cleanup.sh >> /var/log/cleanup_cron.log 2>&1") | sudo crontab -
```

**For Docker Host (Weekly on Sunday at 3:30 AM):**
```bash
# 1. Download to /root/Docker_log.sh
sudo wget -O /root/Docker_log.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/docker/Docker_log.sh && sudo chmod +x /root/Docker_log.sh

# 2. Add to crontab in one command
(sudo crontab -l 2>/dev/null | grep -v "Docker_log.sh"; echo "30 3 * * 0 /root/Docker_log.sh >> /var/log/docker_cleanup_cron.log 2>&1") | sudo crontab -
```

**Alternative: System-wide Cron (`/etc/cron.d/`):**
```bash
echo "0 3 * * * root /root/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1" | sudo tee /etc/cron.d/system_cleanup
```

---

### 🗑️ Remove from Cron (One-liner using `sed`)

To remove or disable the scheduled cleanup job instantly without opening an editor:
```bash
# Remove from root crontab using sed:
sudo crontab -l | sed '/cleanup.*\.sh/d' | sudo crontab -

# Or remove /etc/cron.d file if created:
sudo rm -f /etc/cron.d/system_cleanup
```

---

### 📝 Option 2: Manual Crontab Setup

If you prefer editing crontab manually:
```bash
sudo crontab -e
```
Add one of the following lines:
* **Daily at 3:00 AM (Recommended for active servers):**
  ```cron
  0 3 * * * /root/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
  ```
* **Weekly on Sunday at 2:00 AM:**
  ```cron
  0 2 * * 0 /root/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
  ```
* **Monthly on the 1st day at 4:00 AM:**
  ```cron
  0 4 1 * * /root/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
  ```

---

### 🔍 Verify Cron Status
```bash
# View active cron jobs:
sudo crontab -l

# Ensure cron daemon is running:
sudo systemctl enable --now cron
```

---

## 🔧 Troubleshooting (`$'\r': command not found`)

If running a downloaded script throws:
```plaintext
syntax error near unexpected token $'\r'
cleaning.sh: line 9: $'\r': command not found
```
This is caused by Windows CRLF (`\r\n`) line endings. Fix it immediately with:

```bash
# Method 1: Using dos2unix
sudo apt-get install -y dos2unix
dos2unix *.sh

# Method 2: Using sed
sed -i 's/\r$//' *.sh
```

---

## 📈 Star History

[![Star History Chart](https://api.star-history.com/svg?repos=sohag1192/System-Cleanup-Script&type=Date)](https://star-history.com/#sohag1192/System-Cleanup-Script&Date)

---

## 👤 Author & Maintainer

**Md. Sohag Rana**  
Network & IT Infrastructure Specialist  
* **GitHub:** [@sohag1192](https://github.com/sohag1192)  
* **Email:** [sohag1192@gmail.com](mailto:sohag1192@gmail.com)  
* **Telegram:** [@Md_Sohag_Rana](https://t.me/Md_Sohag_Rana)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
