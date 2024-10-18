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

# Colors
CATPPUCCIN_GREEN='#a6da95'
CATPPUCCIN_MAUVE='#c6a0f6'

# Key bindings
COPY_FILE_PATH='ctrl-y:execute(echo -n {1}:{2} | pbcopy)'
KEYS="$COPY_FILE_PATH"

# Function to build FZF command with multi-file selection
get_fzf_command() {
    echo "rg --files --color=always --line-number --no-heading --smart-case |

          fzf --ansi \
            --border \
            --color "hl+:$CATPPUCCIN_GREEN:reverse,hl:$CATPPUCCIN_MAUVE:reverse" \
            --delimiter ':' \
            --height '100%' \
            --multi \
            --print-query --exit-0 \
            --preview "$1" \
            --preview-window 'right,+{2}+3/3,~3' \
            --scrollbar '▍' \
            --bind "$KEYS"
        "
}

# Function to open selected files in Helix (or any other editor)
run_fzf_open() {
    local dir="$1"

    zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash -c "
        selected_files=\$(rg --files --color=always --line-number --no-heading --smart-case |
        fzf --ansi --multi --preview 'bat --style=numbers --color=always {}' |
        while read -r; do printf '%q ' \"\$REPLY\"; done);
        
        if [[ -n \"\$selected_files\" ]]; then
            $(get_zellij_actions ":open \$selected_files")
        else
            zellij action close-pane;
        fi"
}

# Function to handle git blame command and display in FZF window
# Function to handle git blame and display it with FZF
# Function to handle git blame and display it with FZF
run_git_blame() {
    local dir="$1"
    local file="$2"
    run_in_floating_pane "$dir" "git blame \"$file\" | fzf --ansi --preview 'bat --color=always --style=numbers --line-range=:500 {1}' --height '100%' --border" ":open \$selected_file"
}


# Function to handle file renaming using renamer and FZF
run_fzf_renamer() {
    local dir="$1"
    run_in_floating_pane "$dir" "$(get_fzf_command)" ":reload-all"
}

#######################
# Main Logic
#######################

case "$cmd" in
    "lazygit"|"serpl")
        # Run lazygit or serpl (in cwd or basedir) in a floating pane
        dir="${cwd}"
        # [[ "$cmd" == "serpl-cwd" ]] && (dir="${basedir}";cmd="serpl")
        run_in_floating_pane "$dir" "$cmd" ":reload-all"
        ;;
    "serpl-cwd")
        # Run lazygit or serpl (in cwd or basedir) in a floating pane
        dir="${basedir}"
        cmd="serpl"
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
           "git-blame")
        # Run Git blame in a floating pane with FZF
        run_git_blame "$cwd" "$filename"
        ;;
    "fzf-open")
        # Run FZF to open selected files
        run_fzf_open "$cwd"
        ;;
    "fzf-renamer")
        # Run FZF for file selection and renamer execution
        zellij run -f -x 10% -y 10% --width 80% --height 80% -- bash -c "
            paths=\$(rg --files --color=always --line-number --no-heading --smart-case |
            fzf --ansi --multi --preview 'bat --style=numbers --color=always --line-range :500 {}' |
            while read -r; do printf '%q ' \"\$REPLY\"; done);
            if [[ -n \"\$paths\" ]]; then
                renamer \$paths;
                $(get_zellij_actions \":reload-all\")
            else
                zellij action close-pane;
            fi"
        ;;
    *)
        # Error handling for unknown commands
        echo "Unknown command: $cmd"
        exit 1
        ;;
esac

