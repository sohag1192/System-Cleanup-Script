#!/bin/sh
# Proxmox Cache & Log Cleanup Script
# Author: Md. Sohag Rana (adapted for Proxmox)

echo "=== Starting Proxmox cleanup ==="

# Clear Nginx/RTMP logs if present
[ -d /usr/local/nginx/logs ] && {
  : > /usr/local/nginx/logs/access.log
  : > /usr/local/nginx/logs/error.log
  : > /usr/local/nginx/logs/rtmp_error.log
}

# Show disk usage of apt cache before cleaning
[ -d /var/cache/apt/archives ] && du -sh /var/cache/apt/archives 2>/dev/null

# Clean system logs
find /var/log -type f -exec sh -c ': > "$1"' _ {} \;

# Clean apt caches and partial packages
apt-get clean
apt-get autoclean
apt-get autoremove -y

# Remove orphaned packages (requires deborphan)
if command -v deborphan >/dev/null 2>&1; then
  deborphan | xargs --no-run-if-empty apt-get -y remove --purge
fi

# Remove Trash
rm -rf /home/*/.local/share/Trash/*/** 2>/dev/null
rm -rf /root/.local/share/Trash/*/** 2>/dev/null

# Keep manual pages untouched (cleaned only logs and cache)
# rm -rf /usr/share/man/?? 2>/dev/null
# rm -rf /usr/share/man/??_* 2>/dev/null

# Delete rotated and compressed logs
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete


echo "=== Proxmox cleanup completed ==="
