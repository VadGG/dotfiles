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
export HELIX_RUNTIME=/Users/vadimgagarin/Development/HelixBuilders/helix/runtime


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
# alias n='nnn -d'

alias yabai-start='yabai --start-service'
alias yabai-stop='yabai --stop-service'
alias yabai-stop='yabai --restart-service'

export PENPOT="$HOME/TerminalApps/penpot"
alias penpotup="docker compose -p penpot -f $PENPOT/docker-compose.yaml up -d"
alias penpotdown="docker compose -p penpot -f $PENPOT/docker-compose.yaml down"

alias mpc="open /Applications/PCoIPClient.app -n"
alias wezterm-new="wezterm cli spawn --new-window; open -a wezterm"
alias wezterm-app="/Applications/WezTerm.app/Contents/MacOS/wezterm"
alias helm-images-find="helm template . | yq '..|.image? | select(.)' | sort -u"

export EDITOR=hx

source "$DOTFILES/Kubernetes/kube.sh"

source "$DOTFILES/nnn_config.sh"


# https://umaranis.com/2023/09/07/setup-nnn-terminal-file-manager-on-macos/
n()
{
    # Block nesting of nnn in subshells
    [ "${NNNLVL:-0}" -eq 0 ] || {
        echo "nnn is already running"
        return
    }

    # The behaviour is set to cd on quit (nnn checks if NNN_TMPFILE is set)
    # If NNN_TMPFILE is set to a custom path, it must be exported for nnn to
    # see. To cd on quit only on ^G, remove the "export" and make sure not to
    # use a custom path, i.e. set NNN_TMPFILE *exactly* as follows:
    #      NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    # The command builtin allows one to alias nnn to n, if desired, without
    # making an infinitely recursive alias
    command nnn "$@"

    [ ! -f "$NNN_TMPFILE" ] || {
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    }
}


# pnpm
export PNPM_HOME="/Users/vadimgagarin/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
[[ "$PATH" == *"$HOME/bin:"* ]] || export PATH="$HOME/bin:$PATH"
! { which werf | grep -qsE "^/Users/vadimgagarin/.trdl/"; } && [[ -x "$HOME/bin/trdl" ]] && source $("$HOME/bin/trdl" use werf "2" "stable")

function c() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
