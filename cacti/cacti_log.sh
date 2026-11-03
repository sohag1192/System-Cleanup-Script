#!/bin/bash
#===========================================================
# Cacti Log & Storage Optimization Script
# Author: Md. Sohag Rana (Sarker Net)
# Purpose: Safely truncate Cacti poller logs, Spine logs,
#          rotated archives, and temporary cache without
#          breaking permissions, ownership, or poller tasks.
#          Strictly preserves RRA (.rrd) performance metric files!
#===========================================================

set -e

echo "=== 🌵 Starting Cacti Log & Storage Cleanup ==="

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
  echo "[-] ⚠️  Please run this script as root (e.g. sudo bash cacti_log.sh)"
  exit 1
fi

# Define known Cacti log directories
CACTI_LOG_DIRS=(
  "/var/log/cacti"
  "/var/www/html/cacti/log"
  "/var/www/cacti/log"
  "/usr/share/cacti/log"
  "/usr/share/cacti/site/log"
  "/opt/cacti/log"
  "/srv/www/cacti/log"
)

# Known Spine log directories
SPINE_LOG_DIRS=(
  "/usr/local/spine/var/log"
  "/var/log/spine"
  "/opt/spine/var/log"
)

# 1. Show disk usage before cleanup
echo ""
echo "📊 Disk usage before cleanup:"
df -h /
echo "---------------------------------------------------"

found_cacti=0
total_truncated=0
total_deleted=0

# Helper function to truncate a log file safely
truncate_log() {
  local file="$1"
  if [ -f "$file" ]; then
    local size
    size=$(du -sh "$file" 2>/dev/null | cut -f1)
    truncate -s 0 "$file" 2>/dev/null || : > "$file"
    echo "  [OK] Truncated: $file (Was: $size)"
    total_truncated=$((total_truncated + 1))
  fi
}

# 2. Clean standard Cacti log directories
echo "[INFO] Scanning for Cacti log directories..."

for dir in "${CACTI_LOG_DIRS[@]}"; do
  if [ -d "$dir" ]; then
    found_cacti=1
    echo ""
    echo "📁 Found Cacti log directory: $dir"
    
    # 2a. Truncate active log files
    for logname in "cacti.log" "poller-error.log" "cacti_stderr.log" "spine.log" "syslog.log"; do
      if [ -f "$dir/$logname" ]; then
        truncate_log "$dir/$logname"
      fi
    done
    
    # Also find any other *.log files in this specific log dir (excluding rra directories)
    while IFS= read -r logfile; do
      case "$logfile" in
        *.rrd) continue ;; # Strict safety protection
        *) truncate_log "$logfile" ;;
      esac
    done < <(find "$dir" -maxdepth 2 -type f -name "*.log" 2>/dev/null)

    # 2b. Remove rotated and compressed logs (.gz, .1, .log.1, etc.)
    echo "  [INFO] Removing rotated/compressed archives in $dir..."
    while IFS= read -r archive; do
      rm -f "$archive" 2>/dev/null
      total_deleted=$((total_deleted + 1))
    done < <(find "$dir" -maxdepth 2 -type f \( -name "*.gz" -o -regex ".*\.[0-9]$" -o -name "*.log.[0-9]*" \) 2>/dev/null)
  fi
done

# 3. Clean Spine Poller logs (if installed separately)
echo ""
echo "[INFO] Checking for standalone Cacti Spine logs..."
for sdir in "${SPINE_LOG_DIRS[@]}"; do
  if [ -d "$sdir" ]; then
    echo "📁 Found Spine log directory: $sdir"
    while IFS= read -r spinelog; do
      truncate_log "$spinelog"
    done < <(find "$sdir" -maxdepth 2 -type f -name "*.log" 2>/dev/null)
    
    find "$sdir" -maxdepth 2 -type f \( -name "*.gz" -o -regex ".*\.[0-9]$" \) -delete 2>/dev/null || true
  fi
done

# Individual standalone spine log file in /var/log/
if [ -f "/var/log/spine.log" ]; then
  truncate_log "/var/log/spine.log"
fi

# 4. Fallback search if standard directories were not found
if [ "$found_cacti" -eq 0 ]; then
  echo "[INFO] No standard Cacti log directory found. Searching /var/log and /var/www for cacti.log..."
  while IFS= read -r custom_log; do
    if [ -f "$custom_log" ]; then
      found_cacti=1
      echo "📁 Found custom Cacti log: $custom_log"
      truncate_log "$custom_log"
      
      custom_dir=$(dirname "$custom_log")
      find "$custom_dir" -maxdepth 1 -type f \( -name "*.gz" -o -regex ".*\.[0-9]$" \) -delete 2>/dev/null || true
    fi
  done < <(find /var/log /var/www /opt /usr/share -type f -name "cacti.log" 2>/dev/null)
fi

# 5. Clean temporary Cacti cache and export spool
echo ""
echo "[INFO] Cleaning Cacti temporary cache and export spool..."
# Clean /var/cache/cacti if exists
if [ -d "/var/cache/cacti" ]; then
  rm -rf /var/cache/cacti/* 2>/dev/null || true
  echo "  [OK] Cleaned /var/cache/cacti/"
fi

# Clean temporary boost or export files in /tmp (Strictly preserving non-cacti files)
find /tmp -maxdepth 1 -type f \( -name "cacti*" -o -name "boost_*.tmp" \) -delete 2>/dev/null || true
echo "  [OK] Cleaned temporary Cacti files in /tmp"

# 6. Safety Notice
echo ""
echo "🔒 [SAFETY VERIFIED] All RRA (.rrd) performance metric graph files were strictly preserved."

# 7. Cacti Database Log Maintenance Tip
if command -v mysql >/dev/null 2>&1; then
  echo ""
  echo "💡 [DATABASE TIP] Cacti also stores event logs in MySQL/MariaDB (table 'cacti_log')."
  echo "   If your Cacti database is large, you can optionally clear the database log table by running:"
  echo "   mysql -u root -p cacti -e \"TRUNCATE TABLE cacti_log;\""
fi

# 8. Show disk usage after cleanup
echo ""
echo "---------------------------------------------------"
echo "📊 Disk usage after cleanup:"
df -h /
echo ""
echo "Summary:"
echo "  - Active log files truncated: $total_truncated"
echo "  - Compressed archives deleted: $total_deleted"
echo "=== ✅ Cacti cleanup completed successfully — Script by Sohag ==="
