#!/bin/bash
# LOG FILE FOR DAILY HEALTH CHECK
LOG_FILE="./health_check.log"

# CURRENT DATE AND TIME
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# THRESHOLDS
CPU_THRESHOLD=5      # PERCENT
MEM_THRESHOLD=5      # PERCENT
DISK_THRESHOLD=5     # PERCENT

# CPU USAGE (user + system)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')

# MEMORY USAGE
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(free | awk '/Mem:/ {printf("%d", $3/$2 * 100)}')

# DISK USAGE
DISK_USAGE=$(df / | awk 'NR==2 {print int($5)}')

# TOP 5 PROCESSES BY MEMORY (clean format)
TOP_PROCESSES=$(ps -eo pid,comm,%mem,%cpu --sort=-%mem | head -n 6)

# LOG SYSTEM HEALTH
{
  echo "---------- HEALTH CHECK REPORT: $DATE ----------"
  echo "CPU Usage: ${CPU_USAGE}% (Threshold: ${CPU_THRESHOLD}%)"
  echo "Memory Usage: Total=${MEM_TOTAL}MB, Used=${MEM_USED}MB (${MEM_USAGE}%) (Threshold: ${MEM_THRESHOLD}%)"
  echo "Disk Usage: ${DISK_USAGE}% (Threshold: ${DISK_THRESHOLD}%)"
  echo "Top 5 Memory-Consuming Processes (PID | Command | %MEM | %CPU):"
  echo "$TOP_PROCESSES"

  # ALERTS
  [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ] && echo "ALERT: CPU USAGE ABOVE ${CPU_THRESHOLD}%"
  [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ] && echo "ALERT: MEMORY USAGE ABOVE ${MEM_THRESHOLD}%"
  [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ] && echo "ALERT: DISK USAGE ABOVE ${DISK_THRESHOLD}%"

  echo "-------------------------------------------------"
} >> $LOG_FILE

