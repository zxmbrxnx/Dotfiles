#!/usr/bin/env bash

SDIR="$HOME/.config/polybar/zxmbrxnx/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme $SDIR/rofi/styles.rasi \
<<< "♥ dark|♥ everforest|♥ catppucin-mocha")"
            case "$MENU" in
				## Light Colors
				*dark) "$SDIR"/colors-dark.sh --dark ;;				
				*everforest) "$SDIR"/colors-dark.sh --everforest ;;				
				*catppucin-mocha) "$SDIR"/colors-dark.sh --catppucin-mocha				
            esac
