#/usr/bin/env bash

menu() { fuzzel --dmenu --minimal-lines; }
prompt() { fuzzel --dmenu --prompt-only $1; }

mode=󰲎 # 🖼️ picture ⛶
pos=󰓱  # 🔝table𝄜⊞
sca=󰩨  # 🔎glass⌕
tra=  # 🔃arrow⟳
vrr=󱥼  # 👁️eye𖦹
inf=  # ℹ️info🛈𝐢
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

if ! echo $choosen_output | grep [a-z] ; then
   exit 130
fi

current_mode_index=$(nirijq $choosen_name '.[$name].current_mode')
current_mode=$(nirijq $choosen_name '.[$name].modes[$index]| [.width,"x",.height,"@",.refresh_rate] |map_values(tostring)|add' $current_mode_index)
vrr_on_current=$(nirijq $choosen_name '.[$name].vrr_supported')
current_pos=$(nirijq $choosen_name '.[$name].logical | [.x, ",",.y]|map(tostring)|add')
current_scale=$(nirijq $choosen_name '.[$name].logical.scale')
current_trans=$(nirijq $choosen_name '.[$name].logical.transform')


choices="$mode :$current_mode\n$pos :$current_pos\n$sca :$current_scale\n$tra :$current_trans\n$inf\n"
if [[ $vrr_on_current = "true" ]]; then
  current_vrr=$(nirijq $choosen_name '.[$name].vrr_enabled')
  choices=$choices"$vrr :$current_vrr\n"
else
  choices=$choices"No variable fresh rate"
fi

setting_choice=$(echo -e $choices| fuzzel --dmenu --minimal-lines )

case $setting_choice in
  $mode*)
    modes=$(nirijq $choosen_name '.[$name]."modes"[] |  [ .width,"x",.height,"@",.refresh_rate / 1000]|map_values(tostring)|add')
    new_mod=$(printf '%s\n' "$modes"| menu ) # thanks chat :((
    if [[ $new_mod =~ [0-9][0-9]+.[0-9]+ ]]; then
      niri msg output $choosen_name mode $new_mod
    else
      echo error | menu
    fi
    ;;
  $vrr*)
    if [[ $current_vrr = "false" ]]; then
      niri msg output $choosen_name vrr on
    else 
      niri msg output $choosen_name vrr off
    fi
  ;;
  $pos*)
    new_pos=$(prompt "new position"|sed 's/,/\ /g')
    if [[ $new_pos =~ [0-9]\ [0-9] ]]; then
      niri msg output $choosen_name position set $new_pos
    else
      echo error | menu
    fi
    ;;
  $sca*)
    new_scale=$(prompt "new scale")
    if [[ $new_scale =~ [0-9]+\.?[0-9]* ]]; then
      niri msg output $choosen_name scale $new_scale
    else
      echo error | menu
    fi;;
  $tra*)
    new_trans=$(echo -e "normal\n90\n180\n270\nflipped\nflipped-90\nflipped-180\nflipped-270"|menu)
      niri msg output $choosen_name transform $new_trans
    # if [[ $new_trans =~ (^normal$)?(flipped-)?[0-9][0-9]+ ]]; then
    # else
    #   echo error | menu
    # fi
  ;;
esac
