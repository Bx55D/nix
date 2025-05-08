#!/bin/sh

# --- Configuration ---
# Set your battery device name here (check /sys/class/power_supply/)
BATTERY="BAT1"

# Icons (ensure your font supports these glyphs, e.g., Nerd Fonts)
ICON_CHG="⚡" # Bolt for charging
ICON_DIS="" # Battery for discharging/static

# --- Script Logic ---
BATTERY_PATH="/sys/class/power_supply/${BATTERY}"

# Check if battery exists
if [ ! -d "$BATTERY_PATH" ]; then
    echo "ERR" # Or "?" or ""
    exit 1
fi

# Read status and capacity
STATUS=$(cat "${BATTERY_PATH}/status")
CAPACITY=$(cat "${BATTERY_PATH}/capacity") # Uncomment if you want percentage later

# Determine icon based on status
case "$STATUS" in
    "Charging")
        OUTPUT="$ICON_CHG"
        ;;
    "Discharging")
        OUTPUT="$ICON_DIS"
        ;;
    "Full" | "Not charging")
        # Decide what to show when plugged in but full/not charging
        # Option 1: Show charging icon (since it's plugged in)
        # OUTPUT="$ICON_CHG"
        # Option 2: Show battery icon (since it's not actively charging)
        OUTPUT="$ICON_DIS"
        # Option 3: Show a specific 'full' icon (if defined above)
        # OUTPUT="$ICON_FULL"
        ;;
    *)
        # Unknown status, default to discharging icon or an error indicator
        OUTPUT="$ICON_DIS" # Or "?"
        ;;
esac

# Print the final output for dwmblocks
# If you want percentage: printf "%s %s%%\n" "$OUTPUT" "$CAPACITY"
printf "%s %s%%\n" "$OUTPUT" "$CAPACITY"
