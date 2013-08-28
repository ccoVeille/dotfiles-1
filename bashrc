#!/usr/bin/env bash

have() { command -v "$1" >&/dev/null; }

### Environment

[[ $PREFIX ]] || . ~/lib/dotfiles/environ

# this cannot be in environ.sh because gdm sources profile early;
# Xsession and gnome-session override $LANG later
case $LANG in *.utf8)
	# make `tree` work correctly
	export LANG=${LANG/%.utf8/.UTF-8}
esac

# this is needed for non-interactive mode as well; for example,
# in my git-url-handler script
case $TERM in
	xterm)
		TERM='xterm-256color';
		havecolor=256;;
	*-256color|xterm-termite)
		havecolor=256;;
	""|9term)
		havecolor=0;;
	*)
		havecolor=8;;
esac

if [[ $COLORTERM == xfce* ]]; then
	# I guess I'm not supposed to run a terminal from another terminal,
	# but either way, this fixes such cases like running xfce4-terminal
	# from within gnome-terminal/termite.
	unset VTE_VERSION
fi

export GPG_TTY=$(tty)

export SUDO_PROMPT=$(printf 'sudo: Password for %%p@\e[30;43m%%h\e[m: ')

### Interactive options

[[ $- != *i* ]] && return

set -o physical			# resolve symlinks when 'cd'ing
shopt -s autocd 2>/dev/null	# assume 'cd' when trying to exec a directory
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

set +o histexpand		# do not use !foo history expansions
shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTFILE="$XDG_CACHE_HOME/bash.history"
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth

complete -A directory cd

. ~/lib/dotfiles/bash/prompt.sh

. ~/lib/dotfiles/bash/aliases.sh

if have pklist; then
	. ~/code/kerberos/kc.sh
fi

# TODO: this belongs to aliases.sh
export GREP_OPTIONS='--color=auto'

if [[ -f ~/lib/dotfiles/bashrc-$HOSTNAME ]]; then
	. ~/lib/dotfiles/bashrc-$HOSTNAME
elif [[ -f ~/.bashrc-$HOSTNAME ]]; then
	. ~/.bashrc-$HOSTNAME
fi

if [[ ! $SILENT && ! $SUDO_USER ]]; then
	have todo && todo
fi

true
