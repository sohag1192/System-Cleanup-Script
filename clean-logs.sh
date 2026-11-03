#!/bin/sh
# Apache2, Nginx, and Ubuntu Cache Log Cleanup
# Author: Md. Sohag Rana

echo "=== Starting cleanup ==="

# --- Apache2 logs ---
if [ -d /var/log/apache2 ]; then
  echo "Cleaning Apache2 logs..."
  find /var/log/apache2 -type f -exec sh -c ': > "$1"' _ {} \;
fi

# --- Nginx logs ---
if [ -d /var/log/nginx ]; then
  echo "Cleaning Nginx logs..."
  find /var/log/nginx -type f -exec sh -c ': > "$1"' _ {} \;
fi

# --- Ubuntu system logs ---
echo "Cleaning system logs..."
find /var/log -type f -exec sh -c ': > "$1"' _ {} \;

# --- Clear rotated/compressed logs ---
echo "Removing rotated/compressed logs..."
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# --- Apt cache cleanup ---
echo "Cleaning apt cache..."
[ -d /var/cache/apt/archives ] && du -sh /var/cache/apt/archives 2>/dev/null
apt-get clean
apt-get autoclean
apt-get autoremove -y

# --- Remove orphaned packages ---
if command -v deborphan >/dev/null 2>&1; then
  echo "Removing orphaned packages..."
  deborphan | xargs --no-run-if-empty apt-get -y remove --purge
fi

# --- Trash cleanup ---
echo "Cleaning user trash..."
rm -rf /home/*/.local/share/Trash/*/** 2>/dev/null
rm -rf /root/.local/share/Trash/*/** 2>/dev/null

echo "=== Cleanup completed ==="
