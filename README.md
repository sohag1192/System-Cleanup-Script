# System-Cleanup-Space-Optimization
🧼 Script by Sohag — System Cleanup &amp; Space Optimization


Your GitHub repository [System-Cleanup-Space-Optimization](https://github.com/sohag1192/System-Cleanup-Space-Optimization) contains two key scripts:

---

### 🧼 `clean.sh` — Full System Cleanup Script
This script performs a comprehensive cleanup of your Ubuntu server:

- **Truncates NGINX and RTMP logs**
- **Displays APT cache size**
- **Truncates all log files under `/var/log`**
- **Removes partial and orphaned packages**
- **Cleans APT cache and unnecessary packages**
- **Deletes user and root trash**
- **Removes manual pages**
- **Deletes rotated and compressed logs**
- **Prints final confirmation**

🔗 [View `clean.sh` on GitHub](https://github.com/sohag1192/System-Cleanup-Space-Optimization/blob/main/clean.sh)

---

### 🧹 `log_cleanup.sh` — Log-Focused Cleanup Script
This script is specialized for log management:

- **Truncates all logs except `wtmp` and `btmp`**
- **Deletes rotated logs and `.gz` files**
- **Vacuum systemd journal logs**
- **Cleans NGINX/RTMP logs**
- **Removes trash and manual pages**
- **Performs APT cleanup and orphan removal**
- **Displays disk usage after cleanup**

🔗 [View `log_cleanup.sh` on GitHub](https://github.com/sohag1192/System-Cleanup-Space-Optimization/blob/main/log_cleanup.sh)

---

Both scripts are modular, safe for production, and reflect your precision in system hygiene. You can run them with:

```bash
chmod +x clean.sh log_cleanup.sh
sudo ./clean.sh
sudo ./log_cleanup.sh
```

Let me know if you want to combine both into a single unified script or schedule them via cron for automated cleanup.
