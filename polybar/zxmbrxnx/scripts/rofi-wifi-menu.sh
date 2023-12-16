#!/usr/bin/env bash

#dunstify "WIFI" "Getting list of available Wi-Fi networks..."
# Get a list of available wifi connections and morph it into a nice-looking list
wifi_list=$(nmcli --fields "SECURITY,SSID" device wifi list | sed 1d | sed 's/  */ /g' | sed -E "s/WPA*.?\S/ /g" | sed "s/^--/ /g" | sed "s/  //g" | sed "/--/d")
dir="~/.config/polybar/zxmbrxnx/scripts/rofi"

connected=$(nmcli -fields WIFI g)
echo $connected
if [[ "$connected" =~ "desactivado" ]]; then
	toggle="󰖩  Enable Wi-Fi"
elif [[ "$connected" =~ "activado" ]]; then
	toggle="󰖪  Disable Wi-Fi"
fi

# Use rofi to select wifi network
chosen_network=$(echo -e "$toggle\n$wifi_list" | uniq -u | rofi -dmenu -i -selected-row 1 -p "Wi-Fi SSID: " -theme $dir/wifi-menu.rasi)
# Get name of connection
chosen_id=$(echo "${chosen_network:3}" | xargs)
echo $chosen_id
if [ "$chosen_network" = "" ]; then
	exit
elif [ "$chosen_network" = "󰖩  Enable Wi-Fi" ]; then
	nmcli radio wifi on
elif [ "$chosen_network" = "󰖪  Disable Wi-Fi" ]; then
	nmcli radio wifi off
else
	# Message to show when connection is activated successfully
	success_message="You are now connected to the Wi-Fi network \"$chosen_id\"."
	# Get saved connections
	saved_connections=$(nmcli -g NAME connection)
	if [[ $(echo "$saved_connections" | grep -v "Zambrano 5G" | grep -w "$chosen_id") = "$chosen_id" ]]; then
		#nmcli connection up id "$chosen_id" | grep "Conexión activada con éxito" && notify-send "Connection Established" "$success_message"
		if nmcli connection up id "$chosen_id" | grep -q "Conexión activada con éxito"; then
			notify-send "Connection Established" "$success_message"
		else
		 	nmcli connection delete "$chosen_id"
			wifi_password=$(rofi -dmenu -p "Password for: $chosen_id" -theme $dir/wifi-menu-pass.rasi)
			nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
		fi

	else
		if [[ "$chosen_network" =~ "" ]]; then
			wifi_password=$(rofi -dmenu -p "Password for: $chosen_id" -theme $dir/wifi-menu-pass.rasi)
		fi
		nmcli device wifi connect "$chosen_id" password "$wifi_password" | grep "successfully" && notify-send "Connection Established" "$success_message"
	fi
fi
