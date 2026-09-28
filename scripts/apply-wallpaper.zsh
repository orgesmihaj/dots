#!/bin/zsh

set -eu

WALLPAPER_PATH="$HOME/.local/share/wallpapers/Theth - A Day in the Albanian Alps.heic"

if [[ ! -f "$WALLPAPER_PATH" ]]; then
	print -u2 "Wallpaper not found: $WALLPAPER_PATH"
	print -u2 "Run 'stow wallpaper' from the repository root first."
	exit 1
fi

osascript \
	-e 'on run argv' \
	-e 'set wallpaper_file to POSIX file (item 1 of argv)' \
	-e 'tell application "System Events" to set picture of every desktop to wallpaper_file' \
	-e 'end run' \
	"$WALLPAPER_PATH"
