#!/bin/bash

# Linux CPU Monitoring Script
# Shows overall usage, per-core usage, load average, and top CPU processes
# Press Ctrl+C to exit

echo "=== Linux CPU Monitor ==="
echo "Refresh every 2 seconds. Ctrl+C to quit."

while true; do
    clear
    
    # Overall CPU usage (using /proc/stat for calculation)
    echo "CPU Usage Summary:"
    echo "-----------------"
    # Get CPU stats twice with a small delay for delta calculation
    CPU1=$(cat /proc/stat | grep '^cpu ')
    sleep 0.2
    CPU2=$(cat /proc/stat | grep '^cpu ')
    
    # Parse idle and total
    IDLE1=$(echo $CPU1 | awk '{print $5}')
    TOTAL1=$(echo $CPU1 | awk '{print $2+$3+$4+$5+$6+$7+$8}')
    IDLE2=$(echo $CPU2 | awk '{print $5}')
    TOTAL2=$(echo $CPU2 | awk '{print $2+$3+$4+$5+$6+$7+$8}')
    
    DIFF_IDLE=$((IDLE2 - IDLE1))
    DIFF_TOTAL=$((TOTAL2 - TOTAL1))
    CPU_USAGE=$(awk "BEGIN {print 100 - ($DIFF_IDLE * 100 / $DIFF_TOTAL)}" | cut -d. -f1)
    
    echo "Overall CPU Usage: ${CPU_USAGE}%"
    
    # Load average
    LOAD=$(uptime | awk -F'load average: ' '{print $2}' | cut -d, -f1-3)
    echo "Load Average (1/5/15 min): $LOAD"
    
    # Per-core usage (using mpstat if available, fallback to top)
    echo -e "\nPer-Core Usage:"
    if command -v mpstat >/dev/null 2>&1; then
        mpstat -P ALL 1 1 | tail -n +4 | head -n -1 | awk '{print "Core " $2 ": " 100-$12 "%"}'
    else
        top -bn1 | grep '^%Cpu' -A $(nproc) | tail -n +2 | awk '{print "Core " NR-1 ": ~" (100-$8) "%"}' 2>/dev/null || echo "Install sysstat for better per-core stats: sudo apt install sysstat"
    fi
    
    # Top 10 CPU-consuming processes
    echo -e "\nTop 10 CPU Processes:"
    ps -eo pid,comm,%cpu,%mem --sort=-%cpu | head -n 11
    
    echo -e "\n(Refreshing in 2 seconds...)"
    sleep 2
done
