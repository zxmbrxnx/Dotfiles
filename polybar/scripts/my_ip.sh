echo $(ifconfig | grep inet | head -n 1 | awk '{print $2}') | tr -d '\n' | xclip -sel clip