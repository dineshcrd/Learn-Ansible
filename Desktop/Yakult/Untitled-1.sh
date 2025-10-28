#!/bin/bash

# linux system health check script
# This script checks CPU usage, memory usage, disk space, and system load average.
# It outputs the results to the console.

# Function to check CPU usage
check_cpu_usage() {
    echo "Checking CPU Usage..."
    CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
    CPU_USAGE=$((100 - CPU_IDLE))
    echo "CPU Usage: $CPU_USAGE%"
    if [ "$CPU_USAGE" -gt 80 ]; then
        echo "Warning: High CPU usage detected!"
    fi
    echo ""
}       

# Function to check memory usage
check_memory_usage() {
    echo "Checking Memory Usage..."
    MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
    MEM_USED=$(free -m | awk '/^Mem:/{print $3}')
    MEM_USAGE=$((MEM_USED * 100 / MEM_TOTAL))
    echo "Memory Usage: $MEM_USAGE%"
    if [ "$MEM_USAGE" -gt 80 ]; then
        echo "Warning: High Memory usage detected!"
    fi
    echo ""
}   
# Function to check disk space
check_disk_space() {
    echo "Checking Disk Space..."
    df -h | awk 'NR>1 {print $1 ": " $5 " used"}'
    DISK_USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [ "$DISK_USAGE" -gt 80 ]; then
        echo "Warning: High Disk usage detected!"
    fi
    echo ""
}   
# Function to check system load average
check_load_average() {
    echo "Checking System Load Average..."
    LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | cut -d',' -f1 | tr -d ' ')
    echo "Load Average (1 min): $LOAD_AVG"
    LOAD_THRESHOLD=4.0      
    LOAD_COMPARE=$(echo "$LOAD_AVG > $LOAD_THRESHOLD" | bc)
    if [ "$LOAD_COMPARE" -eq 1 ]; then
        echo "Warning: High Load Average detected!"
    fi
    echo ""
}   
# Main function to run all checks
main() {
    echo "Starting System Health Check..."
    echo "-----------------------------------"
    check_cpu_usage
    check_memory_usage
    check_disk_space
    check_load_average
    echo "System Health Check Completed."
}   
# Run the main function
main    

