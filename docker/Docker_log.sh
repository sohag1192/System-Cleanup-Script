#!/bin/bash
#===========================================================
# Docker Log & Disk Space Optimization Script
# Author: Md. Sohag Rana (Sarker Net)
# Purpose: Safely truncate container JSON logs without stopping
#          containers, prune dangling images, build cache, and
#          stopped containers.
#===========================================================

echo "=== 🐳 Starting Docker Cleanup & Optimization ==="

# Check if Docker is installed
if ! command -v docker >/dev/null 2>&1; then
  echo "[-] Docker is not installed on this system. Exiting."
  exit 0
fi

# Check if Docker daemon is running
if ! docker info >/dev/null 2>&1; then
  echo "[-] Docker daemon is not running or current user lacks permissions. Exiting."
  exit 1
fi

# 1. Show Docker disk usage before cleanup
echo ""
echo "📊 Docker disk usage before cleanup:"
docker system df
echo "---------------------------------------------------"

# 2. Truncate container JSON logs safely without stopping containers
echo "[INFO] Truncating container JSON log files..."
if [ -d "/var/lib/docker/containers" ]; then
  log_count=$(find /var/lib/docker/containers/ -name "*-json.log" 2>/dev/null | wc -l)
  if [ "$log_count" -gt 0 ]; then
    find /var/lib/docker/containers/ -name "*-json.log" -exec truncate -s 0 {} \; 2>/dev/null
    echo "[OK] Successfully truncated $log_count container log file(s)."
  else
    echo "[OK] No active container log files found."
  fi
else
  echo "[INFO] /var/lib/docker/containers not found or inaccessible."
fi

# 3. Remove stopped containers
echo "[INFO] Pruning stopped containers..."
docker container prune -f

# 4. Remove dangling images (untagged layers)
echo "[INFO] Pruning dangling images..."
docker image prune -f

# 5. Remove unused build cache
echo "[INFO] Pruning Docker build cache..."
docker builder prune -f 2>/dev/null || docker buildx prune -f 2>/dev/null || true

# 6. Remove unused Docker networks
echo "[INFO] Pruning unused custom networks..."
docker network prune -f

# NOTE: Persistent volumes are intentionally left untouched to prevent data loss!
# If you want to delete unused volumes as well, run manually: docker volume prune -f

echo "---------------------------------------------------"
# 7. Show Docker disk usage after cleanup
echo "📊 Docker disk usage after cleanup:"
docker system df
echo ""
echo "=== ✅ Docker cleanup completed successfully ==="
