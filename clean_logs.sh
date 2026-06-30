#!/bin/bash

# Clear system logs
find /var/log -type f -exec sh -c ': > "$1"' _ {} \;

# Delete rotated and compressed logs
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# Clear apt cache
apt-get clean
apt-get autoclean
apt-get autoremove -y

# Remove orphaned packages (if deborphan is installed)
if command -v deborphan >/dev/null 2>&1; then
    deborphan | xargs apt-get -y remove --purge
fi

# Clear user trash
rm -rf /home/*/.local/share/Trash/*
rm -rf /root/.local/share/Trash/*

# Clear Apache2 logs (if installed)
: > /var/log/apache2/access.log 2>/dev/null
: > /var/log/apache2/error.log 2>/dev/null

# Clear Nginx logs (if installed)
: > /var/log/nginx/access.log 2>/dev/null
: > /var/log/nginx/error.log 2>/dev/null

# Clear Flussonic logs (if installed)
if [ -d /var/log/flussonic ]; then
    find /var/log/flussonic -type f -exec sh -c ': > "$1"' _ {} \;
fi

echo "✅ Ubuntu log cleanup completed"
