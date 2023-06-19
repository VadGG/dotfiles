# dotfiles


# Theme

Zenburn 256 color scheme for the color GNU ls utility.
-------------------------------------------------

Install MacOS
--------------

-Ensure Coreutils is installed for **gls**
```
brew install coreutils
```

Setup:


	Add the following to ~/.bash_profile
	
	# ~/.dircolors/themefile
	eval $(gdircolors ~/.config/dircolors/dircolors.zenburn)

	# Aliases
	alias ls='gls --color=auto'
	alias ll='ls -al'

Notes:

-Please check out solarized dircolors here https://github.com/seebi/dircolors-solarized

Install Linux
--------------

1. Copy or link `dircolors` file to `~/.config/dircolors`
2. Put something like this in your shell resource file: `eval $( dircolors -b $HOME/.config/dircolors/dircolor.zenburn )`
3. To use the colors add the `--color` switch to the invocation of LS or DIR.

Example
--------------

Add the following three lines to your `~/.bashrc` or `~/.zshrc` file:

    eval $( dircolors -b $HOME/.config/dircolors/dircolor.zenburn )
    alias dir='dir --color'
    alias ls='ls --color'
