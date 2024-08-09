#!/bin/bash
 
if [[ $1 == 'grep' ]]; then
    selected_file=$(live-grep)
else
    selected_file=$(live-fzf)
fi

selected_file=$(for entry in "${selected_file[@]}"; do
    # echo "${entry%%:*}"
    echo $(echo "$entry" | cut -d ":" -f 1)
done | tr ' ' '\n' | sort -u | tr '\n' ' ')


top_pane_id=$(wezterm cli get-pane-direction Up)
if [ -z "$selected_file" ]; then
    if [ -n "${top_pane_id}" ]; then
        wezterm cli activate-pane-direction --pane-id $top_pane_id Up
        # wezterm cli toggle-pane-zoom-state
    fi
    exit 0
fi

if [ -z "${top_pane_id}" ]; then
    top_pane_id=$(wezterm cli split-pane --top)
fi

wezterm cli activate-pane-direction --pane-id $top_pane_id Up

send_to_top_pane="wezterm cli send-text --pane-id $top_pane_id --no-paste"

program=$(wezterm cli list | awk -v pane_id="$top_pane_id" '$3==pane_id { print $6 }')
if [ "$program" = "hx" ]; then
    # echo ":open $selected_file" | $send_to_top_pane
    wezterm cli send-text --pane-id "$top_pane_id" --no-paste ":"
    wezterm cli send-text --pane-id "$top_pane_id" "open ${selected_file}"
    # echo "\r" | wezterm cli send-text --pane-id "$top_pane_id" --no-paste
else
    echo "hx $selected_file" | $send_to_top_pane
fi

# wezterm cli toggle-pane-zoom-state

