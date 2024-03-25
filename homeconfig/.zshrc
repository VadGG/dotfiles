#!/usr/bin/env zsh
eval $(/opt/homebrew/bin/brew shellenv)
source $(brew --prefix nvm)/nvm.sh

export DOTFILES="$HOME/Development/dotfiles"
export FLUTTER="$HOME/Development/flutter"
export GIT_TOKEN_PATH="$DOTFILES/.git-token"

export PATH="$FLUTTER/bin:$PATH"
export PATH="$HOME/.cargo/bin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$DOTFILES/bin:$PATH"
export PATH="$(go env GOPATH)/bin:$PATH"
export XDG_CONFIG_HOME="$HOME/.config"
export PYENCHANT_LIBRARY_PATH="$(brew --prefix enchant)/lib/libenchant-2.dylib"
export KUBE_EDITOR="hx"

eval $(gdircolors ~/.config/dircolors/dircolors.zenburn)

export PATH="$(pyenv root)/shims:$PATH"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

eval "$(starship init zsh)"

source "$HOME/.config/broot/launcher/bash/br"

if [ -z "$GITHUB_TOKEN" ] && [ -f "$GIT_TOKEN_PATH" ]; then
    export GITHUB_TOKEN=$(cat "$DOTFILES/.git-token")
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniconda3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# alias ls='gls --color=auto'
alias cat='bat'
alias ls='lsd'
alias ll='ls -al'
alias whisperenv='conda activate py310-whisper'

alias yabai-start='yabai --start-service'
alias yabai-stop='yabai --stop-service'
alias yabai-stop='yabai --restart-service'

export PENPOT="$HOME/TerminalApps/penpot"
alias penpotup="docker compose -p penpot -f $PENPOT/docker-compose.yaml up -d"
alias penpotdown="docker compose -p penpot -f $PENPOT/docker-compose.yaml down"

alias mpc="open /Applications/PCoIPClient.app -n"
alias wezterm-new="wezterm cli spawn --new-window; open -a wezterm"
alias wezterm-app="/Applications/WezTerm.app/Contents/MacOS/wezterm"

source "$DOTFILES/Kubernetes/kube.sh"

