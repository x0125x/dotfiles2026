echo $(($(hyprctl monitors -j | jq '.[0].height') - 40))px
