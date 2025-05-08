#!/bin/sh

# Check if pactl exists
if ! command -v pactl > /dev/null; then
    echo "Error: pactl command not found. Is pulseaudio installed and running?" >&2
    exit 1
fi

# Get mute status for the default sink
mute_status=$(pactl get-sink-mute @DEFAULT_SINK@)
if [[ $? -ne 0 ]]; then
    echo "Error: Failed to get mute status. Is pulseaudio running?" >&2
    exit 1
fi

# Check if muted
if echo "$mute_status" | grep -q 'yes'; then
    printf " \n"
else
    # Get volume for the default sink
    volume_line=$(pactl get-sink-volume @DEFAULT_SINK@)
     if [[ $? -ne 0 ]]; then
        echo "Error: Failed to get volume. Is pulseaudio running?" >&2
        exit 1
    fi
    # Extract the first percentage value
    # Using awk to get the 5th field (e.g., "75%")
    volume_percent=$(echo "$volume_line" | awk '{ print $5 }' | sed 's/%//')
    # Basic validation if volume_percent is a number
    if [[ "$volume_percent" =~ ^[0-9]+$ ]]; then
	printf "  %s%%\n" "$volume_percent"
    else
        echo "Error: Could not parse volume percentage from pactl output:" >&2
        echo "$volume_line" >&2
        exit 1
    fi
fi

exit 0
