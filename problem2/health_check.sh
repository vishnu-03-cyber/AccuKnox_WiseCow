#!/bin/bash
# LOG FILE FOR DAILY HEALTH CHECK
LOG_FILE="./health_check.log"

# CURRENT DATE AND TIME
DATE=$(date "+%Y-%m-%d %H:%M:%S")

# THRESHOLDS
CPU_THRESHOLD=80      # PERCENT
MEM_THRESHOLD=80      # PERCENT
DISK_THRESHOLD=80     # PERCENT

# CPU USAGE
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print int($2 + $4)}')

# MEMORY USAGE
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_USAGE=$(free | awk '/Mem:/ {printf("%d", $3/$2 * 100)}')

# DISK USAGE
DISK_USAGE=$(df / | awk 'NR==2 {print int($5)}')

# TOP 5 PROCESSES BY MEMORY USAGE
TOP_PROCESSES=$(ps aux --sort=-%mem | awk 'NR<=5 {print $0}')

# LOG SYSTEM HEALTH
{
  echo "---------- HEALTH CHECK REPORT: $DATE ----------"
  echo "CPU Usage: $CPU_USAGE%"
  echo "Memory Usage: Total=${MEM_TOTAL}MB, Used=${MEM_USED}MB (${MEM_USAGE}%)"
  echo "Disk Usage: $DISK_USAGE%"
  echo "Top 5 Memory-Consuming Processes:"
  echo "$TOP_PROCESSES"

  # ALERTS
  [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ] && echo "ALERT: CPU USAGE ABOVE ${CPU_THRESHOLD}%"
  [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ] && echo "ALERT: MEMORY USAGE ABOVE ${MEM_THRESHOLD}%"
  [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ] && echo "ALERT: DISK USAGE ABOVE ${DISK_THRESHOLD}%"

  echo "-------------------------------------------------"
} >> $LOG_FILE
