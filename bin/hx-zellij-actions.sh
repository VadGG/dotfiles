#!/usr/bin/env bash
# zellij-helper.sh
# A script to interact with Zellij floating panes for various commands (lazygit, serpl, fzf, yazi)

set -e

cmd=$1          # Command to execute (e.g., lazygit, serpl, fzf, yazi)
cwd=$2          # Current working directory
filename=$3     # File name
line_number=$4  # Line number (optional)

# Paths and directories
basedir=$(dirname "$filename")
basename=$(basename "$filename")
abspath="$filename"

# Resolve tilde (~) to HOME directory for absolute path
if [[ "$abspath" =~ ^~(/|$) ]]; then
    abspath="${HOME}${abspath:1}"
fi

#######################
# Helper Functions
#######################

# Function to define common Zellij actions (toggle panes, send commands, etc.)
get_zellij_actions() {
    local helix_command="$1"
    echo "
        zellij action toggle-floating-panes;
        zellij action write 27;  # Send <Escape> key
        zellij action write-chars \"$helix_command\";
        zellij action write 13;  # Send <Enter> key
        zellij action toggle-floating-panes;
        zellij action close-pane;"
}

# Function to run a command in a floating Zellij pane with optional directory change
run_in_floating_pane() {
    local dir="$1"
    local command="$2"
    local helix_command="$3"
    
    zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash -c "
        ${dir:+cd $dir &&} $command;
        $(get_zellij_actions "$helix_command")"
}

# Function to handle running the yazi command
run_yazi() {
    zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash -c "
        paths=\$(yazi \"$filename\" --chooser-file=/dev/stdout | while read -r; do printf '%q ' \"\$REPLY\"; done);
        if [[ -n \"\$paths\" ]]; then
            $(get_zellij_actions ":open \$paths")
        else
            zellij action close-pane;
        fi"
}

# Function to build FZF command with common configuration
get_fzf_command() {
    echo "rg --color=always --line-number --no-heading --smart-case |
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
}

#######################
# Main Logic
#######################

case "$cmd" in
    "lazygit"|"serpl"|"serpl-file")
        # Run lazygit or serpl (in cwd or basedir) in a floating pane
        dir="${cwd}"
        [[ "$cmd" == "serpl-file" ]] && dir="${basedir}"
        run_in_floating_pane "$dir" "$cmd" ":reload-all"
        ;;
    "fzf"|"fzf-file")
        # Run FZF (in cwd or basedir) in a floating pane
        dir="${cwd}"
        [[ "$cmd" == "fzf-file" ]] && dir="${basedir}"
        run_in_floating_pane "$dir" "$(get_fzf_command)" ":reload-all"
        ;;
    "yazi")
        # Handle the yazi command separately
        run_yazi
        ;;
    *)
        # Error handling for unknown commands
        echo "Unknown command: $cmd"
        exit 1
        ;;
esac

