ip_victim=$(tail ~/.config/polybar/scripts/victima.txt | tr -d '\n' | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+')
echo "$ip_victim" | xclip -sel clip