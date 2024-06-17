# .bashrc
# use bash -l in shell to reload changes made in this file

# If not running interactively, don't do anything
case $- in
    *i*) ;;
        *) return;;
esac

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# Timestamps for history
export HISTTIMEFORMAT="%m/%d/%Y %H:%M:%S"

# Check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Enable ** glob pattern
shopt -s globstar

# Prevent Ctrl-D (EOF) from exiting shell
set -o ignoreeof

export VISUAL='emacs'
export EDITOR='emacs'
export FCEDIT='emacs'

#Used to prevent prompt from being overridden in certain scripts
export PRESERVE_PROMPT=true

# Show verbose prompt, reduce tabs, handle escape chars, case insensitive
# search, exit if output fits on a single screen
export LESS='--LONG-PROMPT --tabs=4 --RAW-CONTROL-CHARS --ignore-case --quit-if-one-screen'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# Check for colour
if type tput &> /dev/null; then
    color_prompt='yes'
else
    color_prompt=
fi

# Number of trailing directory components to retain when expanding \w in PS1.
PROMPT_DIRTRIM=3

# store colors
BLUE="\[\033[01;34m\]"
GREEN="\[\033[01;32m\]"
RED="\[\033[31m\]"
WHITE="\[\033[00m\]"
GRAY='\[\033[1;30m\]'

function color_my_prompt {
    local __date="$GRAY[\D{$HISTTIMEFORMAT}] "
    local __user_and_host="$GREEN\u@\h:"
    local __cur_location="${BLUE}\w"
    local __git_branch_color="$RED"
    local __git_branch='$(__git_ps1 " <%s>")';
    local __prompt_tail='$( if [ $? -eq 0 ]; then echo " \[\e[0;32m\]$"; else echo " \[\e[0;31m\]$"; fi )'
    local __user_input_color="$WHITE"

    # Build the PS1 (Prompt String)
    PS1="$__date$__user_and_host $__cur_location$__git_branch_color$__git_branch$__prompt_tail$__user_input_color "
}

# Set custom prompt if present
if [[ $color_prompt == 'yes' ]]; then
    # configure PROMPT_COMMAND which is executed each time before PS1
    export PROMPT_COMMAND=color_my_prompt
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if [[ -r $HOME/.config/.dircolors ]]; then
	    eval "$(dircolors -b "$HOME/.config/.dircolors")"
	else
        eval "$(dircolors -b)"
	fi
  
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
      . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
      . /etc/bash_completion
    fi
fi

# if .git-prompt.sh exists, set options and execute it
if ! shopt -oq posix; then
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_HIDE_IF_PWD_IGNORED=true

    if [ -f /usr/local/share/git-core/contrib/completion/git-prompt.sh ]; then
      . /usr/local/share/git-core/contrib/completion/git-prompt.sh
    elif [ -f ~/.config/git/.git-prompt.sh ]; then
      # This will only exist if you needed to downloaded it
      . ~/.config/git/.git-prompt.sh
    fi
fi

# enable git completion features
if ! shopt -oq posix; then
    if [ -f /usr/local/share/git-core/contrib/completion/git-completion.bash ]; then
        . /usr/local/share/git-core/contrib/completion/git-completion.bash
    elif [ -f ~/.config/git/.git-completion.bash ]; then
        # This will only exist if you needed to downloaded it
        . ~/.config/git/.git-completion.bash
    fi
fi