#!/bin/bash

# Configuration
CPU_THRESHOLD=70
MEM_THRESHOLD=80
DISK_THRESHOLD=90
LOG_FILE="finalOutput.log"
TIMESTAMP=$(date)

# -------- CPU USAGE (Unix standard) --------
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | sed 's/.*, *\([0-9.]*\)%* id.*/\1/' | awk '{print int($1)}')
CPU=$((100 - CPU_IDLE))

echo "CPU Usage: $CPU%"

# -------- MEMORY USAGE (based on usage/total) --------
MEM=$(free | awk '/Mem:/ {printf "%.2f", ($3/$2)*100}')

# -------- DISK USAGE (%) --------
DISK=$(df -h / | awk 'NR==2 {gsub("%",""); print $5}')

# -------- Logging --------
echo "[$TIMESTAMP] CPU: $CPU%, MEM: $MEM%, DISK: $DISK%" >> "$LOG_FILE"

if (( $(echo "$CPU > $CPU_THRESHOLD" | bc -l) )) || 
   (( $(echo "$MEM > $MEM_THRESHOLD" | bc -l) )) || 
   (( $(echo "$DISK > $DISK_THRESHOLD" | bc -l) )); then
    echo "[$TIMESTAMP] [ALERT] High resource usage detected" >> "$LOG_FILE"
fi
