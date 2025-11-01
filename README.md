# System-Cleanup-Space-Optimization
🧼 Script by Sohag — System Cleanup &amp; Space Optimization


---

### 🧼 Summary of `log_cleanup.sh`
- **Truncates all log files** under `/var/log` except `wtmp` and `btmp`
- **Deletes rotated logs** (`*.gz`, `*.1`, etc.)
- **Vacuum systemd journal logs** older than 7 days
- **Clears NGINX and RTMP logs**
- **Cleans APT cache and removes orphaned packages**
- **Deletes trash and manual pages**
- **Shows disk usage after cleanup**

---

### 🚀 Automate with `wget` + `cron`

#### 1. Download the script:
```bash
wget -O log_cleanup.sh https://raw.githubusercontent.com/sohag1192/System-Cleanup-Space-Optimization/main/log_cleanup.sh
chmod +x log_cleanup.sh
```

#### 2. Schedule it with cron:
```bash
crontab -e
```

Add this line to run daily at 3:00 AM:
```bash
0 3 * * * /usr/local/bin/log_cleanup.sh >> /var/log/sohag_log_cleanup.log 2>&1
```

---
