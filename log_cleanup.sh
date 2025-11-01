#!/bin/bash
# Ubuntu Log Cleaner by Sohag

echo "🧹 Starting full log cleanup..."

# 1. Truncate all log files except system binaries
find /var/log -type f ! -name 'wtmp' ! -name 'btmp' -exec truncate -s 0 {} \;

# 2. Remove rotated and compressed logs
find /var/log -type f -name "*.gz" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# 3. Clear journal logs (systemd)
journalctl --vacuum-time=7d

# 4. Clear NGINX and RTMP logs if applicable
: > /usr/local/nginx/logs/access.log 2>/dev/null
: > /usr/local/nginx/logs/error.log 2>/dev/null
: > /usr/local/nginx/logs/rtmp_error.log 2>/dev/null

# 5. Clear APT cache and orphaned packages
apt-get clean
apt-get autoclean
apt-get autoremove -y
command -v deborphan >/dev/null && deborphan | xargs apt-get -y remove --purge

# 6. Remove user and root trash
rm -rf /home/*/.local/share/Trash/*/** 2>/dev/null
rm -rf /root/.local/share/Trash/*/** 2>/dev/null

# 7. Remove manual pages
rm -rf /usr/share/man/?? /usr/share/man/??_* 2>/dev/null

# 8. Show final disk usage
echo "📊 Disk usage after cleanup:"
df -h /

echo "✅ Log cleanup completed — Ubuntu Log Cleaner by Sohag"
