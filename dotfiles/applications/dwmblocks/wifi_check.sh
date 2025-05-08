#!/bin/sh

# --- Configuration ---
WIFI_ICON=""
PLANE_ICON=""
CHECK_URL="http://captive.apple.com/hotspot-detect.html" # A lightweight URL often used for captive portal checks (alternatives: http://google.com, http://gstatic.com/generate_204)
CONNECT_TIMEOUT=2 # Max seconds to wait for connection establishment

# --- Logic ---
# --silent / -s: Don't show progress meter or error messages
# --head / -I: Fetch headers only, not the full content (faster)
# --fail / -f: Return an error code on server errors (like 404), not just connection failures
# --connect-timeout $CONNECT_TIMEOUT: Max time allowed for connection
# > /dev/null: Redirect standard output (headers) to null
if curl --silent --head --fail --connect-timeout $CONNECT_TIMEOUT "$CHECK_URL" > /dev/null; then
  # If curl succeeds (exit code 0), print the wifi icon
  printf "%s " "$WIFI_ICON"
else
  # If curl fails (non-zero exit code), print the plane icon
  printf "%s " "$PLANE_ICON"
fi
