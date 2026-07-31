#/usr/bin/env bash

outputs=$(niri msg --json outputs)
choosen_output=$(echo $outputs | jq -r  '.[] | ."name" + " • " + ."make" | tostring' | fuzzel --dmenu --minimal-lines)
names=$(echo $outputs | jq -r  '.[] | ."name" | tostring' )
choosen_name=$(echo $choosen_output | sed 's/ •.*//g')

# if [ -n $(echo $choosen_output | grep [a-z]* ) ]; then
#    exit
# fi

current_mode_index=$(echo $outputs | jq -r --arg name $choosen_name '.[$name].current_mode')
current_mode=$(echo $outputs | jq --argjson index $current_mode_index --arg name $choosen_name '.[$name].modes[0]| [.width,"x",.height,"@",.refresh_rate] |map_values(tostring)|add')
current_vrr=$(niri msg --json outputs | jq --arg name $choosen_name -r '.[$name].vrr_supported')
current_pos=$(niri msg --json outputs | jq --arg name $choosen_name -r '.[$name].logical | [.x, ",",.y]|map(tostring)|add')
current_scale=$(niri msg --json outputs | jq --arg name $choosen_name -r '.[$name].logical.scale')

setting_choice=$(echo -e "󰲎 :$current_mode\n󱥼 :$current_vrr\n󰓱 :$current_pos\n󰩨 :$current_scale"| fuzzel --dmenu --minimal-lines )

case $setting_choice in
  󰲎*)
    modes=$(niri msg --json outputs | jq -r --arg name $choosen_name '.[$name]."modes"[] |  [ .width,"x",.height,"@",.refresh_rate]|map_values(tostring)|add')
    new_mod=$(printf '%s\n' "$modes"| fuzzel --dmenu --minimal-lines) # thanks chat :((
    niri msg output $choosen_name mode $new_mod
    ;;
  󱥼*)
    #should do some check to ensure vrr is avaible
    # do some check
    # i dont use vrr so aha
  ;;
  󰓱*)
    new_scale=$(fuzzel --dmenu --prompt-only "new position")
    # do some check..
    niri msg output $choosen_name scale $new_scale ;;
  󰩨*)
    new_scale=$(fuzzel --dmenu --prompt-only "new scale")
    # do some check..
    niri msg output $choosen_name scale $new_scale ;;
esac
