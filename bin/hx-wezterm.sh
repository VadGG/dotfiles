#!/bin/sh

set -x

hx_pane_id=$(echo $WEZTERM_PANE)
send_to_hx_pane="wezterm cli send-text --pane-id $hx_pane_id --no-paste"
switch_to_hx_pane_and_zoom="if [ \$status = 0 ]; wezterm cli activate-pane-direction up; wezterm cli zoom-pane --pane-id $hx_pane_id --zoom; end"

status_line=$(wezterm cli get-text | rg -e "(?:NORMAL|INSERT|SELECT)\s+[\x{2800}-\x{28FF}]*\s+(\S*)\s[^│]* (\d+):*.*" -o --replace '$1 $2')
filename=$(echo $status_line | awk '{ print $1}')
line_number=$(echo $status_line | awk '{ print $2}')

split_pane_down() {
  bottom_pane_id=$(wezterm cli get-pane-direction down)
  if [ -z "${bottom_pane_id}" ]; then
    bottom_pane_id=$(wezterm cli split-pane)
  fi

  wezterm cli activate-pane-direction --pane-id $bottom_pane_id down

  send_to_bottom_pane="wezterm cli send-text --pane-id $bottom_pane_id --no-paste"
  program=$(wezterm cli list | awk -v pane_id="$bottom_pane_id" '$3==pane_id { print $6 }')
  if [ "$program" = "lazygit" ]; then
    echo "q" | $send_to_bottom_pane
  fi
}

pwd=$(PWD)
basedir=$(dirname "$filename")
basename=$(basename "$filename")
basename_without_extension="${basename%.*}"
extension="${filename##*.}"

abspath="$filename"
if [[ "$abspath" =~ ^~(/|$) ]]; then
    abspath="${HOME}${abspath:1}"
fi

if [[ "$abspath" == /* ]]; then
    abspath="${basedir}/${basename}"
else
    abspath="${pwd}/${basename}"
fi    

case "$1" in
  "blame")
    split_pane_down
    echo "hx-git-blame $filename +$line_number" | $send_to_bottom_pane
    ;;
  "explorer")
    wezterm cli activate-pane-direction up

    left_pane_id=$(wezterm cli get-pane-direction left)
    if [ -z "${left_pane_id}" ]; then
      left_pane_id=$(wezterm cli split-pane --left --percent 20)
    fi

    left_program=$(wezterm cli list | awk -v pane_id="$left_pane_id" '$3==pane_id { print $6 }')
    if [ "$left_program" != "broot" ]; then
      echo "br" | wezterm cli send-text --pane-id $left_pane_id --no-paste
    else
      echo ":focusabs $(dirname $abspath) $(basename $abspath)\r" | wezterm cli send-text --pane-id $left_pane_id --no-paste
    fi

    wezterm cli activate-pane-direction left
    ;;
  "file-search")
    split_pane_down
    echo "cd $pwd; hx-fzf.sh" | $send_to_bottom_pane
    ;;
  "file-grep")
    split_pane_down
    echo "cd $pwd; hx-fzf.sh grep" | $send_to_bottom_pane
    ;;
  "file-renamer")
    split_pane_down
    echo "cd $pwd; live-renamer" | $send_to_bottom_pane
    ;;
  "file-renamer-grep")
    split_pane_down
    echo "cd $pwd; live-renamer" | $send_to_bottom_pane
    ;;
  "lazygit")
    split_pane_down
    program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
    if [ "$program" = "lazygit" ]; then
        wezterm cli activate-pane-direction down
    else
        echo "lazygit" | $send_to_bottom_pane
    fi
    ;;
esac
