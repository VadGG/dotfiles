#!/bin/sh

set -x

cmd=$1
cwd=$2
filename=$3
line_number=$4

basedir=$(dirname "$filename")
basename=$(basename "$filename")

abspath="$filename"
if [[ "$abspath" =~ ^~(/|$) ]]; then
    abspath="${HOME}${abspath:1}"
fi

case "$1" in
  "blame")
    split_pane_down
    echo "cd $basedir;hx-git-blame $filename +$line_number" | $send_to_bottom_pane
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
      echo ":focusabs $(dirname $abspath) $(basename $abspath)" | wezterm cli send-text --pane-id $left_pane_id --no-paste
    fi

    wezterm cli activate-pane-direction left
    ;;
  "file-replace")
    split_pane_down
    program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
    if [ "$program" = "serpl" ]; then
        wezterm cli activate-pane-direction down
    else
        echo "cd $basedir; serpl" | $send_to_bottom_pane
    fi
    ;;
  "file-replace-cwd")
    split_pane_down
    program=$(wezterm cli list | awk -v pane_id="$pane_id" '$3==pane_id { print $6 }')
    if [ "$program" = "serpl" ]; then
        wezterm cli activate-pane-direction down
    else
        echo "cd $cwd; serpl" | $send_to_bottom_pane
    fi
    ;;
  "file-search")
    split_pane_down
    echo "cd $basedir; hx-fzf.sh" | $send_to_bottom_pane
    ;;
  "file-search-cwd")
    split_pane_down
    echo "cd $cwd; hx-fzf.sh" | $send_to_bottom_pane
    ;;
  "file-grep")
    split_pane_down
    echo "cd $basedir; hx-fzf.sh grep" | $send_to_bottom_pane
    ;;
  "file-grep-cwd")
    split_pane_down
    echo "cd $cwd; hx-fzf.sh grep" | $send_to_bottom_pane
    ;;
  "file-renamer")
    split_pane_down
    echo "cd $basedir; fzf-rename" | $send_to_bottom_pane
    ;;
  "file-renamer-cwd")
    split_pane_down
    echo "cd $cwd; fzf-rename" | $send_to_bottom_pane
    ;;
  "file-renamer-grep")
    split_pane_down
    echo "cd $basedir; rg-rename" | $send_to_bottom_pane
    ;;
  "file-renamer-grep-cwd")
    split_pane_down
    echo "cd $cwd; rg-rename" | $send_to_bottom_pane
    ;;
  "lazygit")
    lazygit
    zellij action toggle-floating-panes
    zellij action write 27 # send <Escape> key
    zellij action write-chars ":reload-all"
    zellij action write 13 # send <Enter> key
    zellij action toggle-floating-panes
    zellij action close-pane
    ;;
esac
