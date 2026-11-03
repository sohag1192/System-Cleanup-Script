#!/bin/bash
#===========================================================
# Proxmox Cleanup Script
# Author: Md. Sohag Rana (Sarker Net)
# Purpose: Free disk space by cleaning ONLY logs and caches
#          (Safe: Keeps Backups, ISO Images, and CT Templates untouched)
#===========================================================

echo "=== Starting Proxmox logs & cache cleanup ==="

# 1. Clear Nginx/RTMP logs (if present)
echo "[INFO] Clearing Nginx/RTMP logs..."
for f in /var/log/nginx/*.log /var/log/rtmp*.log /usr/local/nginx/logs/*.log; do
  [ -f "$f" ] && : > "$f" && echo "[OK] $f truncated"
done

# 2. Check apt cache size before cleaning
echo "[INFO] Checking apt cache size before cleaning..."
[ -d /var/cache/apt/archives ] && du -sh /var/cache/apt/archives 2>/dev/null

# 3. Clean system logs (truncate to 0 bytes safely without deleting files)
echo "[INFO] Truncating active system logs..."
find /var/log -type f -name "*.log" ! -name 'wtmp' ! -name 'btmp' -exec truncate -s 0 {} \;

# 4. Clean systemd journal logs (keep last 7 days of logs)
if command -v journalctl >/dev/null 2>&1; then
  echo "[INFO] Vacuuming systemd journal logs..."
  journalctl --vacuum-time=7d
fi

# 5. Delete rotated and compressed old logs (.gz, .1, .2, etc.)
echo "[INFO] Deleting rotated/compressed logs..."
rm -f /var/log/*.gz /var/log/*.[0-9]

# 6. APT cache and package cleanup
echo "[INFO] Cleaning APT cache and orphaned packages..."
if command -v apt-get >/dev/null 2>&1; then
  apt-get clean
  apt-get autoclean
  apt-get autoremove -y
fi
if command -v deborphan >/dev/null 2>&1; then
  deborphan | xargs --no-run-if-empty apt-get -y remove --purge
fi

# 7. Remove Trash directories (User & Root Trash cache)
echo "[INFO] Cleaning Trash directories..."
rm -rf /home/*/.local/share/Trash/* 2>/dev/null
rm -rf /root/.local/share/Trash/* 2>/dev/null

# ==========================================================
# Proxmox Storage Protection:
# The following directories are completely safe and untouched:
# - Backups:      /var/lib/vz/dump/
# - ISO Images:   /var/lib/vz/template/iso/
# - CT Templates: /var/lib/vz/template/cache/
# ==========================================================

echo "=== Proxmox cleanup completed successfully ==="
