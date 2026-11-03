---

# 🧹 System Cleanup & Space Optimization

## 📖 Overview
This repository contains shell scripts to automate **system cleanup** and **disk space optimization**.  
It helps free up space by cleaning logs, caches, orphaned packages, and temporary files across Ubuntu/Proxmox servers.


---

## ✨ Features 1
- Clear **Apache2**, **Nginx**, and **Flussonic** logs
- Truncate all log files in `/var/log`
- Remove rotated and compressed logs (`.gz`, `.1`, `.2`, etc.)
- Clean **APT cache** and partial packages
- Remove orphaned packages (if `deborphan` is installed)
- Clear user trash (`~/.local/share/Trash`)
- Safe truncation (`: > file.log`) instead of deletion, so services don’t break

---

## 📥 Installation
Download the script and make it executable:
```bash
wget https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/refs/heads/main/clean_logs.sh
chmod +x clean_logs.sh 
./clean_logs.sh 
```
---

## ⏰ Automate with Cron
To schedule automatic cleanup:

1. Edit root’s cron jobs:
   ```bash
   sudo crontab -e
   ```

2. Add one of these schedules:
   - **Daily at midnight**
     ```
     0 0 * * * /usr/local/bin/log_cleanup.sh
     ```
   - **Weekly (Sunday at 2 AM)**
     ```
     0 2 * * 0 /usr/local/bin/log_cleanup.sh
     ```
   - **Monthly (1st day at 3 AM)**
     ```
     0 3 1 * * /usr/local/bin/log_cleanup.sh
     ```

3. Ensure cron is running:
   ```bash
   sudo systemctl enable --now cron
   ```

---


## ⚙️ Features 2
- **[Truncate all log files](guide://action?prefill=Tell%20me%20more%20about%3A%20Truncate%20all%20log%20files)** under `/var/log` (excluding `wtmp` and `btmp`).
- **[Delete rotated/compressed logs](guide://action?prefill=Tell%20me%20more%20about%3A%20Delete%20rotated%2Fcompressed%20logs)** (`*.gz`, `*.1`, etc.).
- **[Vacuum systemd journal logs](guide://action?prefill=Tell%20me%20more%20about%3A%20Vacuum%20systemd%20journal%20logs)** older than 7 days.
- **[Clear Nginx and RTMP logs](guide://action?prefill=Tell%20me%20more%20about%3A%20Clear%20Nginx%20and%20RTMP%20logs)**.
- **[Clean APT cache](guide://action?prefill=Tell%20me%20more%20about%3A%20Clean%20APT%20cache)** and remove orphaned packages.
- **[Delete trash and manual pages](guide://action?prefill=Tell%20me%20more%20about%3A%20Delete%20trash%20and%20manual%20pages)**.
- **[Show disk usage after cleanup](guide://action?prefill=Tell%20me%20more%20about%3A%20Show%20disk%20usage%20after%20cleanup)**.

---



## 🚀 Usage
### 1. Download the script
```bash
wget -O log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/log_cleanup.sh
chmod +x log_cleanup.sh
```

### 2. Run manually
```bash
sudo ./log_cleanup.sh
```

### 3. Automate with cron
Edit crontab:
```bash
crontab -e
```
Add this line to run daily at 3:00 AM:
```bash
0 3 * * * /root/log_cleanup.sh >> /root/log_cleanup.log 2>&1
```

---

## 📂 Scripts Included
- **[cleaning.sh](cleaning.sh)** – Comprehensive system & log cleanup (Nginx, Apache2, Flussonic, MySQL, logs, APT cache, trash).
- **[clean-logs.sh](clean-logs.sh)** – Apache2, Nginx, and Ubuntu cache cleanup.  
- **[clean_up.sh](clean_up.sh)** – General cleanup script.  
- **[log_cleanup.sh](log_cleanup.sh)** – Advanced Ubuntu log cleaner with disk usage report.
- **[proxmox-cleanup.sh](proxmox-cleanup.sh)** – Proxmox-specific cleanup with cache/log removal.  
- **[proxmox_clean.sh](proxmox_clean.sh)** – Alternate Proxmox cleanup script.  

---

## 🛡️ Notes
- Safe for production servers, but always review before deploying.  
- Run periodically to maintain optimal performance.  
- Requires `deborphan` for orphaned package removal.

---



```bash
# Comprehensive System Cleanup
wget -O cleaning.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/cleaning.sh

# Ubuntu Log Cleaner
wget -O log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/log_cleanup.sh

# Apache2/Nginx + Ubuntu cache cleanup
wget -O clean-logs.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/clean-logs.sh

# General cleanup script
wget -O clean_up.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/clean_up.sh

# Proxmox cleanup script
wget -O proxmox-cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox-cleanup.sh

# Alternate Proxmox cleanup script
wget -O proxmox_clean.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Script/main/proxmox_clean.sh
```

---

### 📂 Scripts included
- **[cleaning.sh](cleaning.sh)** – Comprehensive system & log cleanup (Nginx, Apache2, Flussonic, MySQL, logs, APT cache, trash)  
- **[log_cleanup.sh](log_cleanup.sh)** – Advanced Ubuntu log cleaner with disk usage report  
- **[clean-logs.sh](clean-logs.sh)** – Apache2, Nginx, and Ubuntu cache cleanup  
- **[clean_up.sh](clean_up.sh)** – General cleanup script (renamed from `clean.sh`)  
- **[proxmox-cleanup.sh](proxmox-cleanup.sh)** – Proxmox‑specific cleanup with cache/log removal  
- **[proxmox_clean.sh](proxmox_clean.sh)** – Alternate Proxmox cleanup script  

---

### ⚡ Quick usage
1. Run `chmod +x scriptname.sh` after download.  
2. Execute with `sudo ./scriptname.sh` (or `sudo bash scriptname.sh`).  
3. (Optional) Add to cron for scheduled cleanup.  

This way you’ll have **all log cleanup scripts** locally, ready to run or customize.

---

## 🔧 Troubleshooting (Script Not Working / `$'\r': command not found`)

If running a script produces errors such as:
- `cleaning.sh: line 9: $'\r': command not found`
- `: No such file or directorylocal/nginx/logs/...`
- `cleaning.sh: line 95: syntax error: unexpected end of file`

This is caused by Windows CRLF (`\r\n`) line endings. Fix it by converting the file to Unix format with `dos2unix`:

```bash
# 1. Install dos2unix
sudo apt-get install -y dos2unix

# 2. Convert cleaning.sh to Unix line endings
dos2unix cleaning.sh

# (Optional) Fix all shell scripts in the folder at once
dos2unix *.sh
```

*(Alternative fix without installing `dos2unix`)*:
```bash
sed -i 's/\r$//' cleaning.sh
```

---

## 👤 Maintainer
**Md. Sohag Rana**  
Network & IT Infrastructure Manager, Sarker Net  
📧 Email: sohag1192@gmail.com  
💬 Telegram: [sohag1192  ](https://t.me/sohag1192)

---
