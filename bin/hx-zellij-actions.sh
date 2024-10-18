#!/usr/bin/env bash
# zellij-helper.sh

set -e

cmd=$1
cwd=$2
filename=$3
line_number=$4

# Function to run a command in a floating pane
run_floating_command() {
    local command="$1"
    shift
    zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash -c "$command; hx-zellij-actions-close.sh"
}

# Get the base directory
basedir=$(dirname "$filename")
basename=$(basename "$filename")

# Resolve absolute path
abspath="$filename"
if [[ "$abspath" =~ ^~(/|$) ]]; then
    abspath="${HOME}${abspath:1}"
fi

case "$cmd" in
    "lazygit")
        run_floating_command "cd $cwd && lazygit"
        ;;
    "serpl")
        run_floating_command "cd $cwd && serpl"
        ;;
    "fzf")
        run_floating_command "cd $cwd && rg --color=always --line-number --no-heading --smart-case |
            fzf --ansi \
                --border \
                --color \"hl+:$CATPPUCCIN_GREEN:reverse,hl:$CATPPUCCIN_MAUVE:reverse\" \
                --delimiter ':' \
                --height '100%' \
                --multi \
                --print-query --exit-0 \
                --preview \"bat {1} --highlight-line {2}\" \
                --preview-window 'right,+{2}+3/3,~3' \
                --scrollbar '▍' \
                --bind \"$KEYS\""
        ;;
    "serpl-file")
        run_floating_command "cd $basedir && serpl"
        ;;
    "fzf-file")
        run_floating_command "cd $basedir && rg --color=always --line-number --no-heading --smart-case |
            fzf --ansi \
                --border \
                --color \"hl+:$CATPPUCCIN_GREEN:reverse,hl:$CATPPUCCIN_MAUVE:reverse\" \
                --delimiter ':' \
                --height '100%' \
                --multi \
                --print-query --exit-0 \
                --preview \"bat {1} --highlight-line {2}\" \
                --preview-window 'right,+{2}+3/3,~3' \
                --scrollbar '▍' \
                --bind \"$KEYS\""
        ;;
    *)
        echo "Unknown command: $cmd"
        exit 1
        ;;
esac
