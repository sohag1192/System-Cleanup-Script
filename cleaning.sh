#!/bin/bash
# ============================================
# System Cleanup Script
# Author: Sohag1192
# Purpose: Free up disk space by cleaning cache,
#          logs, orphaned packages, trash,
#          Nginx logs, Flussonic logs, Apache2 logs, and more.
# ============================================

echo ">>> Starting system cleanup..."

# --- Clear Nginx Logs ---
echo "Clearing Nginx logs..."
: > /usr/local/nginx/logs/access.log
: > /usr/local/nginx/logs/error.log
: > /usr/local/nginx/logs/rtmp_error.log

# --- Clear Apache2 Logs ---
echo "Clearing Apache2 logs..."
if [ -d "/var/log/apache2" ]; then
  find /var/log/apache2 -type f -exec truncate -s 0 {} \;
  find /var/log/apache2 -type f -regex ".*\.gz$" -delete
  find /var/log/apache2 -type f -regex ".*\.[0-9]$" -delete
  echo "Apache2 logs cleaned."
else
  echo "Apache2 log directory not found."
fi

# --- Clear Flussonic Logs ---
echo "Clearing Flussonic logs..."
if [ -d "/var/log/flussonic" ]; then
  find /var/log/flussonic -type f -exec truncate -s 0 {} \;
  find /var/log/flussonic -type f -regex ".*\.gz$" -delete
  find /var/log/flussonic -type f -regex ".*\.[0-9]$" -delete
  echo "Flussonic logs cleaned."
else
  echo "Flussonic log directory not found."
fi

# --- Clear MySQL/MariaDB Logs ---
echo "Clearing MySQL/MariaDB logs..."
if [ -d "/var/log/mysql" ]; then
  find /var/log/mysql -type f -exec truncate -s 0 {} \;
  find /var/log/mysql -type f -regex ".*\.gz$" -delete
  find /var/log/mysql -type f -regex ".*\.[0-9]$" -delete
  echo "MySQL logs cleaned."
else
  echo "MySQL log directory not found."
fi

# --- Show Cache Size Before Cleanup ---
echo "Cache size before cleanup:"
du -sh /var/cache/apt/archives

# --- Clear System Logs ---
echo "Clearing system logs..."
find /var/log -type f -exec truncate -s 0 {} \;

# --- Remove Rotated & Compressed Logs ---
echo "Removing rotated and compressed logs..."
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# --- Clean APT Cache ---
echo "Cleaning APT cache..."
apt-get clean
apt-get autoclean

# --- Remove Unnecessary Packages ---
echo "Removing unused packages..."
apt-get autoremove -y
apt-get remove --purge -y software-properties-common

# --- Remove Orphaned Packages ---
echo "Removing orphaned packages..."
if command -v deborphan >/dev/null 2>&1; then
  deborphan | xargs sudo apt-get -y remove --purge
fi

# --- Clear Trash ---
echo "Clearing user trash..."
rm -rf /home/*/.local/share/Trash/*/** 2>/dev/null
rm -rf /root/.local/share/Trash/*/** 2>/dev/null

# --- Remove Man Pages ---
echo "Removing manual pages..."
rm -rf /usr/share/man/?? 2>/dev/null
rm -rf /usr/share/man/??_* 2>/dev/null

# --- Show Cache Size After Cleanup ---
echo "Cache size after cleanup:"
du -sh /var/cache/apt/archives

echo ">>> Cleaning is completed!"
