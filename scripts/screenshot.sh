#!/bin/bash

# Constants
PICTURES_DIR="$(xdg-user-dir PICTURES)"

# Helper Functions
openScreenshot(){
    kitty --app-id="user-dialog" --config="/dev/null" -e bash -c "kitten icat '$1'; read -p 'press enter to close...'" 
}

notify_and_open() {
    local filepath="$1"
    xclip "$filepath"
    action=$(notify-send -A "open=Open" "Screenshot" "Screenshot saved to $filepath")
    if [ "$action" = "open" ]; then
        openScreenshot "$filepath"
    fi
}

take_screenshot() {
    local mode="$1"
    local filepath="${PICTURES_DIR}/Screenshots/$(date -Iseconds)_grim.png"
    
    if [ "$mode" = "full" ]; then
        grim "$filepath"
    else
        grim -g "$(slurp)" "$filepath"
    fi

    if [ -f "$filepath" ]; then
        notify_and_open "$filepath"
    else
        notify-send "Screenshot failed"
        return 1
    fi
}

# Main
if [ "$1" = "full" ]; then
    take_screenshot "full"
else
    take_screenshot "partial"
fi
