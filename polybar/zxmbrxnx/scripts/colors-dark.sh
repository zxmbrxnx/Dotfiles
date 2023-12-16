#!/usr/bin/env bash

# Color files
PFILE="$HOME/.config/polybar/zxmbrxnx/colors.ini"
RFILE="$HOME/.config/polybar/zxmbrxnx/scripts/rofi/colors.rasi"


# Función para hacer el color más claro
lighten_color() {
  background_color="$1"
	background_color=${background_color#"#"}
  # Aumenta el valor de cada componente de color en hexadecimal
  r=$((16#${background_color:0:2}))
  g=$((16#${background_color:2:2}))
  b=$((16#${background_color:4:2}))

  # Ajusta el valor de cada componente (puedes cambiar el valor según tus preferencias)
  r=$((r + 0x15))
  g=$((g + 0x15))
  b=$((b + 0x15))

  # Asegura que los valores no superen el límite máximo (0xFF)
  r=$(printf "%02X" $((r > 255 ? 255 : r)))
  g=$(printf "%02X" $((g > 255 ? 255 : g)))
  b=$(printf "%02X" $((b > 255 ? 255 : b)))

  echo "#$r$g$b"
}

# Change colors
change_color() {
	# polybar
	sed -i -e "s/background = #.*/background = ${bg}/g" "${PFILE}"
	sed -i -e "s/foreground = #.*/foreground = ${fg}/g" "${PFILE}"
	sed -i -e "s/foreground-alt = #.*/foreground-alt = ${fgalt}/g" "${PFILE}"
	
	# Factor para hacer el color más claro (en porcentaje)
	lighten_factor=10

	# Obtener el color más claro
	lightened_color=$(lighten_color "$bg")
	sed -i -e "s/glyph = #.*/glyph = ${lightened_color}/g" "${PFILE}"

	# rofi
	cat > $RFILE <<- EOF
	/* colors */

	* {
	  al:    #00000000;
	  bg:    ${bg}FF;
	  bga:   ${lightened_color}FF;
	  fga:   #d3c6aaFF;
	  fg:    #FFFFFFFF;
	  ac:    #FFFFFFFF;
	}
	EOF
	
	polybar-msg cmd restart
}

if  [[ $1 = "--dark" ]]; then
	bg="#000000"	fg="#ffffff"	fgalt="#d3c6aa"	
	change_color
elif  [[ $1 = "--everforest" ]]; then
	bg="#2b3339"	fg="#ffffff"	fgalt="#d3c6aa"	
	change_color
elif  [[ $1 = "--catppucin-mocha" ]]; then
	bg="#11111b"	fg="#cdd6f4"	fgalt="#b4befe"	
	change_color
else
	cat <<- _EOF_
	No option specified, Available options:
	--dark		--everforest	--catppucin-mocha
	_EOF_
fi
