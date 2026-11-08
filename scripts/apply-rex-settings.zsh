#!/bin/zsh

# Copy the ghostty package's look and behavior into Rex. Rex keeps these in
# its macOS preferences rather than in init.lua, so Stow can't link them.

set -eu

DOMAIN=com.superlogical.rex

typeset -a settings=(
	# font-family, font-size, adjust-cell-height
	terminalFontName          -string "JetBrainsMono Nerd Font"
	terminalFontPointSize     -float  14
	terminalCellHeightPercent -int    20

	# cursor-style = underline
	terminalCursorStyle       -string underline

	# window-padding-x, window-padding-y, window-padding-color
	terminalPaddingX          -int    12
	terminalPaddingY          -int    0
	terminalPaddingColor      -string extendAlways

	# window-colorspace = display-p3
	terminalUsesDisplayP3     -bool   true

	# copy-on-select, focus-follows-mouse, macos-option-as-alt = left
	terminalCopyOnSelect      -bool   true
	focusFollowsMouse         -bool   false
	terminalOptionKeyBehavior -string leftActsAsAlt
)

for key type value in $settings; do
	defaults write $DOMAIN "Workspace.$key" $type "$value"
done

print "Rex settings written. Restart Rex if they don't show up."

# theme = "light:Modus Operandi,dark:Catppuccin Mocha". Rex has neither built
# in, so the first run imports them from Ghostty through the running app. That
# needs Remote Control on (Settings > Rex Server). Later runs reselect them.

GHOSTTY_THEMES=/Applications/Ghostty.app/Contents/Resources/ghostty/themes
typeset -A themes=(light "Modus Operandi" dark "Catppuccin Mocha")
typeset -a rex=(${commands[rex]-} /Applications/Rex*.app/Contents/Helpers/*/Contents/MacOS/rex(N))

# The ID of an imported theme, by name; empty if it isn't imported yet.
custom_theme_id() {
	local plist=$(mktemp)
	defaults export $DOMAIN $plist
	/usr/libexec/PlistBuddy -c 'Print :Workspace.customThemes' $plist 2>/dev/null |
		jq -r --arg name $1 'first(.[] | select(.name == $name) | .id) // empty' || true
	rm -f $plist
}

app_client() {
	(( $#rex )) || return 0
	$rex[1] client ls --json 2>/dev/null |
		jq -r 'first(.clients[] | select(.info.kind == "app") | .client_id) // empty' || true
}

for appearance name in ${(kv)themes}; do
	id=$(custom_theme_id $name)
	if [[ -n $id ]]; then
		defaults write $DOMAIN "Workspace.${appearance}ThemeID" -string $id
		print "Rex $appearance theme: $name"
		continue
	fi

	# Importing selects the theme for its own appearance.
	client=$(app_client)
	if [[ -n $client ]] &&
		$rex[1] -C $client do client.theme.import path="$GHOSTTY_THEMES/$name" >/dev/null; then
		print "Rex $appearance theme: $name (imported)"
	else
		print -u2 "Couldn't import $name. Open Rex, turn on Remote Control in"
		print -u2 "  Settings > Rex Server, and run this again, or import it from"
		print -u2 "  $GHOSTTY_THEMES in Settings > Theme > Import."
	fi
done
