<div align="center">

# 🧹 System Cleanup & Space Optimization Script

**Production-grade, automated Linux & Proxmox disk cleanup and log optimization tools.**

[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fsohag1192%2FSystem-Cleanup-Script&count_bg=%2322c55e&title_bg=%231f2937&icon=&icon_color=%23ffffff&title=Total%20%7C%20Today%20Views&edge_flat=false)](https://hits.seeyoufarm.com)
[![GitHub Stars](https://img.shields.io/github/stars/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=gold)](https://github.com/sohag1192/System-Cleanup-Script/stargazers)
[![GitHub Forks](https://img.shields.io/github/forks/sohag1192/System-Cleanup-Script?style=for-the-badge&logo=github&color=blue)](https://github.com/sohag1192/System-Cleanup-Script/network/members)
[![License](https://img.shields.io/github/license/sohag1192/System-Cleanup-Script?style=for-the-badge&color=green)](LICENSE)
[![Repo Size](https://img.shields.io/github/repo-size/sohag1192/System-Cleanup-Script?style=for-the-badge&color=orange)](https://github.com/sohag1192/System-Cleanup-Script)
[![Last Commit](https://img.shields.io/github/last-commit/sohag1192/System-Cleanup-Script?style=for-the-badge&color=purple)](https://github.com/sohag1192/System-Cleanup-Script/commits/main)

<br/>

<p align="center">
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

| Platform | Best Script | Why It's the Best? |
| :--- | :--- | :--- |
| **Ubuntu / Debian** | [`ubuntu/log_cleanup.sh`](ubuntu/log_cleanup.sh) | 🌟 **Most balanced & safe**: Cleans systemd journal logs (`journalctl`), protects security logs (`wtmp`/`btmp`), truncates without crashing services, and does not remove essential system tools. |
| **Proxmox VE** | [`proxmox/proxmox-cleanup.sh`](proxmox/proxmox-cleanup.sh) | 🌟 **100% Storage Safe**: Vacuums journals, truncates logs and APT caches while strictly protecting **Backups (`/var/lib/vz/dump/`)**, **ISO Images (`/var/lib/vz/template/iso/`)**, and **CT Templates (`/var/lib/vz/template/cache/`)**. |

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

**Manual Download & Run:**
```bash
wget -O log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/ubuntu/log_cleanup.sh
chmod +x log_cleanup.sh
sudo ./log_cleanup.sh
```

---

### 2. For Proxmox VE (Recommended: `proxmox-cleanup.sh`)

**Direct Run (One-liner):**
```bash
curl -sSL https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh | sudo bash
```

**Manual Download & Run:**
```bash
wget -O proxmox-cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox/proxmox-cleanup.sh
chmod +x proxmox-cleanup.sh
sudo ./proxmox-cleanup.sh
```

> [!IMPORTANT]
> **Proxmox Storage Safety**: `proxmox/proxmox-cleanup.sh` strictly protects your **Backups**, **ISO Images**, and **Container (CT) Templates**. Not a single VM or container image is removed!

---

## 📊 Comprehensive Feature Comparison

| Feature | `ubuntu/log_cleanup.sh` ⭐ | `ubuntu/cleaning.sh` | `ubuntu/clean_logs.sh` | `proxmox/proxmox-cleanup.sh` ⭐ |
| :--- | :---: | :---: | :---: | :---: |
| **System Log Truncation** | ✅ (`truncate -s 0`) | ✅ (`truncate -s 0`) | ✅ (`: >`) | ✅ (`truncate -s 0`) |
| **Systemd Journal Vacuum** | ✅ (`--vacuum-time=7d`) | ❌ | ❌ | ✅ (`--vacuum-time=7d`) |
| **`wtmp` / `btmp` Login Safe** | ✅ (Protected) | ❌ | ❌ | ✅ (Protected) |
| **Old Compressed Logs (`.gz`, `.[0-9]`)** | ✅ Deleted | ✅ Deleted | ✅ Deleted | ✅ Deleted |
| **APT Cache & Autoclean** | ✅ | ✅ | ✅ | ✅ |
| **Orphaned Packages (`deborphan`)** | ✅ Safe | ✅ | ✅ | ✅ Safe |
| **Trash Folder Cleanup** | ✅ | ✅ | ✅ | ✅ |
| **Nginx / Web Server Logs** | ✅ | ✅ (Apache, MySQL, Flussonic) | ✅ | ✅ |
| **Protects Backups & ISO Images** | N/A | N/A | N/A | ✅ **100% Untouched** |
| **Displays Disk Report (`df -h`)** | ✅ | ❌ | ❌ | ❌ |

---

## ⏰ Automate with Cron (Scheduled Maintenance)

To keep your servers clean automatically without manual intervention:

1. Open root crontab:
   ```bash
   sudo crontab -e
   ```

2. Add one of the following schedules (replace with your desired script path):

   * **Daily at 3:00 AM (Recommended for high-traffic servers):**
     ```cron
     0 3 * * * /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

   * **Weekly on Sunday at 2:00 AM:**
     ```cron
     0 2 * * 0 /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

   * **Monthly on the 1st day at 4:00 AM:**
     ```cron
     0 4 1 * * /usr/local/bin/log_cleanup.sh >> /var/log/cleanup_cron.log 2>&1
     ```

3. Ensure cron service is running:
   ```bash
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
* **Telegram:** [@sohag1192](https://t.me/sohag1192)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
