#/usr/bin/env bash

menu() { fuzzel --dmenu --minimal-lines; }
prompt() { fuzzel --dmenu --prompt-only $1; }

outputs=$(niri msg --json outputs)

nirijq() {
  # apply a filter to niri ipc outputs output
  local name=$1
  local filter=$2
  index=0
  if [ "${3+x}" = "x" ]; then
    index=$3
  fi
  jq -r --arg name "$name" --argjson index $index "$filter" <<<"$outputs"
}

names=$(nirijq  "" '.[] | ."name" | tostring'  )

choosen_output=$(nirijq ""  '.[] | ."name" + " • " + ."make" | tostring'  | menu)

choosen_name=$(echo $choosen_output | sed 's/ •.*//g')

# if [ -n $(echo $choosen_output | grep [a-z]* ) ]; then
#    exit
# fi

current_mode_index=$(nirijq $choosen_name '.[$name].current_mode')
current_mode=$(nirijq $choosen_name '.[$name].modes[$index]| [.width,"x",.height,"@",.refresh_rate] |map_values(tostring)|add' $current_mode_index)
vrr_on_current=$(nirijq $choosen_name '.[$name].vrr_supported')
current_pos=$(nirijq $choosen_name '.[$name].logical | [.x, ",",.y]|map(tostring)|add')
current_scale=$(nirijq $choosen_name '.[$name].logical.scale')
current_trans=$(nirijq $choosen_name '.[$name].logical.transform')

setting_choice=$(echo -e "󰲎 :$current_mode\n󱥼 :$current_vrr\n󰓱 :$current_pos\n󰩨 :$current_scale"| fuzzel --dmenu --minimal-lines )


case $setting_choice in
  󰲎*)
    modes=$(nirijq $choosen_name '.[$name]."modes"[] |  [ .width,"x",.height,"@",.refresh_rate / 1000]|map_values(tostring)|add')
    new_mod=$(printf '%s\n' "$modes"| menu ) # thanks chat :((
    niri msg output $choosen_name mode $new_mod
    ;;
  󱥼*)
    if [[ $current_vrr = "false" ]]; then
      niri msg output $choosen_name vrr on
    else 
      niri msg output $choosen_name vrr off
    fi
  ;;
  󰓱*)
    new_pos=$(prompt "new position")
    echo $new_pos
    if [[ $new_pos =~ [0-9],[0-9] ]]; then
      niri msg output $choosen_name scale $new_pos
    else
      echo error | menu
    fi
    ;;
  󰩨*)
    new_scale=$(prompt "new scale")
    if [[ $new_scale =~ [0-9]+\.?[0-9]* ]]; then
      niri msg output $choosen_name scale $new_scale
    else
      echo error | menu
    fi;;
  *)
    new_trans=$(echo -e "normal\n90\n180\n270\nflipped\nflipped-90\nflipped-180\nflipped-270"|menu)
      niri msg output $choosen_name transform $new_trans
    # if [[ $new_trans =~ (^normal$)?(flipped-)?[0-9][0-9]+ ]]; then
    # else
    #   echo error | menu
    # fi
  ;;
esac
