#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Temperature Monitor - CPU/GPU Temperature Alerts #

temp=(
  lm_sensors
  libnotify
)


## WARNING: DO NOT EDIT BEYOND THIS LINE IF YOU DON'T KNOW WHAT YOU ARE DOING! ##
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Change the working directory to the parent directory of the script
PARENT_DIR="$SCRIPT_DIR/.."
cd "$PARENT_DIR" || { echo "${ERROR} Failed to change directory to $PARENT_DIR"; exit 1; }

# Source the global functions script
if ! source "$(dirname "$(readlink -f "$0")")/Global_functions.sh"; then
  echo "Failed to source Global_functions.sh"
  exit 1
fi

# Set the name of the log file to include the current date and time
LOG="Install-Logs/install-$(date +%d-%H%M%S)_temp-monitor.log"

# Temperature Monitor
printf "${NOTE} Installing ${SKY_BLUE}Temperature Monitor${RESET} Packages...\n"
for TEMP in "${temp[@]}"; do
  install_package "$TEMP" "$LOG"
done

# Detect sensors
printf "${NOTE} Detecting ${YELLOW}hardware sensors${RESET}...\n"
sudo sensors-detect --auto 2>&1 | tee -a "$LOG"

# Create temperature monitoring script
printf "${NOTE} Creating ${YELLOW}temperature monitoring${RESET} script...\n"

TEMP_SCRIPT="$HOME/.config/hypr/scripts/temp-monitor.sh"
mkdir -p "$HOME/.config/hypr/scripts"

cat > "$TEMP_SCRIPT" << 'EOF'
#!/bin/bash
# Temperature Monitoring Script
# Monitors CPU and GPU temperatures and sends alerts

# Configuration
CPU_TEMP_WARNING=75
CPU_TEMP_CRITICAL=85
GPU_TEMP_WARNING=75
GPU_TEMP_CRITICAL=85
CHECK_INTERVAL=30  # Check every 30 seconds

# Track notification state
NOTIFIED_CPU_WARN=false
NOTIFIED_CPU_CRIT=false
NOTIFIED_GPU_WARN=false
NOTIFIED_GPU_CRIT=false

while true; do
    # Get CPU temperature (average of all cores)
    CPU_TEMP=$(sensors | grep -i 'Package id 0:\|Tdie:' | awk '{print $4}' | sed 's/+//;s/°C//' | head -1)
    
    # If Package id not found, try other methods
    if [ -z "$CPU_TEMP" ]; then
        CPU_TEMP=$(sensors | grep -i 'Core 0:' | awk '{print $3}' | sed 's/+//;s/°C//' | head -1)
    fi
    
    # Get GPU temperature (if available)
    GPU_TEMP=$(sensors | grep -i 'edge:\|temp1:' | awk '{print $2}' | sed 's/+//;s/°C//' | head -1)
    
    # Check CPU temperature
    if [ -n "$CPU_TEMP" ]; then
        CPU_TEMP_INT=${CPU_TEMP%.*}
        
        if [ "$CPU_TEMP_INT" -ge "$CPU_TEMP_CRITICAL" ]; then
            if [ "$NOTIFIED_CPU_CRIT" = false ]; then
                notify-send -u critical -i temperature-high "Critical CPU Temperature" "CPU temperature is ${CPU_TEMP}°C! System may throttle or shutdown."
                NOTIFIED_CPU_CRIT=true
                NOTIFIED_CPU_WARN=true
            fi
        elif [ "$CPU_TEMP_INT" -ge "$CPU_TEMP_WARNING" ]; then
            if [ "$NOTIFIED_CPU_WARN" = false ]; then
                notify-send -u normal -i temperature-normal "High CPU Temperature" "CPU temperature is ${CPU_TEMP}°C"
                NOTIFIED_CPU_WARN=true
            fi
        else
            NOTIFIED_CPU_WARN=false
            NOTIFIED_CPU_CRIT=false
        fi
    fi
    
    # Check GPU temperature
    if [ -n "$GPU_TEMP" ]; then
        GPU_TEMP_INT=${GPU_TEMP%.*}
        
        if [ "$GPU_TEMP_INT" -ge "$GPU_TEMP_CRITICAL" ]; then
            if [ "$NOTIFIED_GPU_CRIT" = false ]; then
                notify-send -u critical -i temperature-high "Critical GPU Temperature" "GPU temperature is ${GPU_TEMP}°C!"
                NOTIFIED_GPU_CRIT=true
                NOTIFIED_GPU_WARN=true
            fi
        elif [ "$GPU_TEMP_INT" -ge "$GPU_TEMP_WARNING" ]; then
            if [ "$NOTIFIED_GPU_WARN" = false ]; then
                notify-send -u normal -i temperature-normal "High GPU Temperature" "GPU temperature is ${GPU_TEMP}°C"
                NOTIFIED_GPU_WARN=true
            fi
        else
            NOTIFIED_GPU_WARN=false
            NOTIFIED_GPU_CRIT=false
        fi
    fi
    
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$TEMP_SCRIPT"

printf "${OK} Temperature monitoring script created at ${YELLOW}$TEMP_SCRIPT${RESET}\n"

# Create systemd user service
printf "${NOTE} Creating ${YELLOW}systemd user service${RESET} for temperature monitoring...\n"

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/temp-monitor.service" << EOF
[Unit]
Description=Temperature Monitor
After=graphical-session.target

[Service]
Type=simple
ExecStart=$TEMP_SCRIPT
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

printf "${OK} Systemd service created\n"

# Enable and start the service
printf "${NOTE} Enabling and starting ${YELLOW}temp-monitor${RESET} service...\n"
systemctl --user daemon-reload
systemctl --user enable temp-monitor.service 2>&1 | tee -a "$LOG"
systemctl --user start temp-monitor.service 2>&1 | tee -a "$LOG"

printf "${OK} Temperature monitor service is now running!\n"
printf "${INFO} You can check status with: ${YELLOW}systemctl --user status temp-monitor${RESET}\n"
printf "${INFO} View temperatures: ${YELLOW}sensors${RESET}\n"

printf "\n%.0s" {1..2}
