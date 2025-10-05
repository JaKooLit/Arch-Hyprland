#!/bin/bash
# 💫 https://github.com/JaKooLit 💫 #
# Battery Monitor and Low Battery Notification #

battery=(
  acpi
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
LOG="Install-Logs/install-$(date +%d-%H%M%S)_battery-monitor.log"

# Battery Monitor
printf "${NOTE} Installing ${SKY_BLUE}Battery Monitor${RESET} Packages...\n"
for BAT in "${battery[@]}"; do
  install_package "$BAT" "$LOG"
done

# Create battery monitoring script
printf "${NOTE} Creating ${YELLOW}battery monitoring${RESET} script...\n"

BATTERY_SCRIPT="$HOME/.config/hypr/scripts/battery-monitor.sh"
mkdir -p "$HOME/.config/hypr/scripts"

cat > "$BATTERY_SCRIPT" << 'EOF'
#!/bin/bash
# Low Battery Notification Script
# Monitors battery level and sends notifications

# Configuration
LOW_BATTERY_THRESHOLD=20
CRITICAL_BATTERY_THRESHOLD=10
CHECK_INTERVAL=60  # Check every 60 seconds

# Track notification state to avoid spam
NOTIFIED_LOW=false
NOTIFIED_CRITICAL=false

while true; do
    # Get battery percentage
    BATTERY_LEVEL=$(acpi -b | grep -P -o '[0-9]+(?=%)')
    BATTERY_STATUS=$(acpi -b | grep -o 'Discharging\|Charging\|Full')
    
    # Only send notifications when discharging
    if [ "$BATTERY_STATUS" = "Discharging" ]; then
        if [ "$BATTERY_LEVEL" -le "$CRITICAL_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_CRITICAL" = false ]; then
            notify-send -u critical -i battery-caution "Critical Battery" "Battery level is at ${BATTERY_LEVEL}%! Please plug in your charger immediately."
            NOTIFIED_CRITICAL=true
            NOTIFIED_LOW=true
        elif [ "$BATTERY_LEVEL" -le "$LOW_BATTERY_THRESHOLD" ] && [ "$NOTIFIED_LOW" = false ]; then
            notify-send -u normal -i battery-low "Low Battery" "Battery level is at ${BATTERY_LEVEL}%. Consider plugging in your charger."
            NOTIFIED_LOW=true
        fi
    else
        # Reset notification flags when charging or full
        NOTIFIED_LOW=false
        NOTIFIED_CRITICAL=false
    fi
    
    sleep "$CHECK_INTERVAL"
done
EOF

chmod +x "$BATTERY_SCRIPT"

printf "${OK} Battery monitoring script created at ${YELLOW}$BATTERY_SCRIPT${RESET}\n"

# Create systemd user service
printf "${NOTE} Creating ${YELLOW}systemd user service${RESET} for battery monitoring...\n"

SYSTEMD_DIR="$HOME/.config/systemd/user"
mkdir -p "$SYSTEMD_DIR"

cat > "$SYSTEMD_DIR/battery-monitor.service" << EOF
[Unit]
Description=Battery Level Monitor
After=graphical-session.target

[Service]
Type=simple
ExecStart=$BATTERY_SCRIPT
Restart=on-failure
RestartSec=10

[Install]
WantedBy=default.target
EOF

printf "${OK} Systemd service created\n"

# Enable and start the service
printf "${NOTE} Enabling and starting ${YELLOW}battery-monitor${RESET} service...\n"
systemctl --user daemon-reload
systemctl --user enable battery-monitor.service 2>&1 | tee -a "$LOG"
systemctl --user start battery-monitor.service 2>&1 | tee -a "$LOG"

printf "${OK} Battery monitor service is now running!\n"
printf "${INFO} You can check status with: ${YELLOW}systemctl --user status battery-monitor${RESET}\n"
printf "${INFO} To stop: ${YELLOW}systemctl --user stop battery-monitor${RESET}\n"
printf "${INFO} To disable: ${YELLOW}systemctl --user disable battery-monitor${RESET}\n"

printf "\n%.0s" {1..2}
