#!/bin/bash
# Script by Sohag — System Cleanup & Space Optimization

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "⚠️  Please run this script as root (e.g. sudo bash clean_up.sh)"
  exit 1
fi

echo "Starting cleanup process..."

# 1. Clear NGINX & RTMP logs
if [ -d "/usr/local/nginx/logs" ]; then
  : > /usr/local/nginx/logs/access.log 2>/dev/null || true
  : > /usr/local/nginx/logs/error.log 2>/dev/null || true
  : > /usr/local/nginx/logs/rtmp_error.log 2>/dev/null || true
fi
if [ -d "/var/log/nginx" ]; then
  find /var/log/nginx -type f -exec truncate -s 0 {} \; 2>/dev/null || true
fi

# 2. Show APT cache usage
echo "APT cache size:"
if [ -d "/var/cache/apt/archives" ]; then
  du -sh /var/cache/apt/archives 2>/dev/null || true
else
  echo "APT cache directory not found."
fi

# 3. Truncate all log files except system binaries
find /var/log -type f ! -name 'wtmp' ! -name 'btmp' -exec truncate -s 0 {} \; 2>/dev/null || true

# 4. Clean APT cache and remove unused packages
if command -v apt-get >/dev/null 2>&1; then
  apt-get clean
  apt-get autoclean
  apt-get autoremove -y
fi

# 5. Remove orphaned packages (if deborphan is installed)
if command -v deborphan >/dev/null 2>&1; then
  deborphan | xargs --no-run-if-empty apt-get -y remove --purge
fi

# 6. Clear user and root trash
rm -rf /home/*/.local/share/Trash/*/** 2>/dev/null
rm -rf /root/.local/share/Trash/*/** 2>/dev/null

# 7. Remove manual pages
rm -rf /usr/share/man/?? /usr/share/man/??_* 2>/dev/null

# 8. Delete compressed and rotated logs
find /var/log -type f -name "*.gz" -delete 2>/dev/null || true
find /var/log -type f -regex ".*\.[0-9]$" -delete 2>/dev/null || true

# 9. Show final disk usage
echo "Disk usage after cleanup:"
df -h /

echo "✅ Cleanup completed successfully — Script by Sohag"
