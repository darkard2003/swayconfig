#!/bin/bash

# Constants
PICTURES_DIR="$(xdg-user-dir PICTURES)"

# Helper Functions
openScreenshot(){
    kitty --app-id="user-dialog" --config="/dev/null" -e bash -c "kitten icat '$1'; read -p 'press enter to close...'" 
}

copy_file(){
    # Read the image file and copy its contents to clipboard
    cat "$1" | wl-copy --type image/png
}

notify_actions() {
    if [ ! -f "$1" ]; then
      notify-send "Screenshot" "Failed to take screenshot"
      exit 1
    fi
    copy_file "$1"
    local filepath="$1"
    action=$(notify-send -A "open=Open" "Screenshot" "Screenshot saved to $filepath")
    if [ "$action" = "open" ]; then
        openScreenshot "$filepath"
    fi
}

take_screenshot() {
    local mode="$1"
    local filepath="${PICTURES_DIR}/Screenshots"
    local filename="$filepath/screenshot_$(date +%Y-%m-%d_%H-%M-%S)_grim.png"

    if [ ! -d "$filepath" ]; then
      mkdir -p "$filepath"
    fi
    
    if [ "$mode" = "full" ]; then
        grim "$filename"
    else
        grim -g "$(slurp)" "$filename"
    fi

    notify_actions "$filename"
}

# Main
if [ "$1" = "full" ]; then
    take_screenshot "full"
else
    take_screenshot "partial"
fi
