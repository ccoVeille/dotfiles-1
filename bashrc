#!bash

[[ $DEBUG ]] && echo "++ bashrc [self=$0 prefix=$PREFIX]"

have() { command -v "$1" >&/dev/null; }

### Environment

[[ $PREFIX ]] || . ~/lib/dotfiles/environ

export GPG_TTY=$(tty)

export SUDO_PROMPT=$(printf 'sudo: Password for %%u@\e[30;43m%%h\e[m: ')

### Interactive options

[[ $- != *i* ]] && return

[[ $DEBUG ]] && echo ".. bashrc [interactive=$-]"

shopt -os physical		# resolve symlinks when 'cd'ing
shopt -s checkjobs 2> /dev/null	# print job status on exit
shopt -s checkwinsize		# update $ROWS/$COLUMNS after command
shopt -s no_empty_cmd_completion

shopt -s cmdhist		# store multi-line commands as single history entry
shopt -s histappend		# append to $HISTFILE on exit
shopt -s histreedit		# allow re-editing failed history subst

HISTFILE=~/.cache/bash.history
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth

### Completion

HOSTFILE=~/.hosts

complete -A directory cd

### Terminal capabilities

case $TERM in
	xterm)
		havecolor=8
		if [[ -z $COLORTERM ]] && [[ -f /proc/$PPID/cmdline ]]; then
			read -r -d '' comm </proc/$PPID/cmdline
			comm=${comm##*/}
			case $comm in
				gnome-terminal|konsole|xterm|yakuake)
					COLORTERM=$comm
					;;
				kdeinit4:*konsole*)
					COLORTERM=konsole
					;;
			esac
			unset comm
		fi
		if [[ $COLORTERM ]]; then
			TERM="$TERM-256color"
			havecolor=256
		fi
		;;
	vt100|vt220|vt320)
		havecolor=8
		;;
	'')
		havecolor=0
		;;
	*)
		havecolor=$(have tput && tput colors 2>/dev/null)
		;;
esac

### Prompt and window title

. ~/lib/dotfiles/bashrc.prompt

### Aliases

. ~/lib/dotfiles/bashrc.aliases

if have pklist; then
	. ~/code/kerberos/kc.bash
fi

### More environment

export GREP_OPTIONS='--color=auto'

if [[ -f ~/lib/dotfiles/bashrc-$HOSTNAME ]]; then
	. ~/lib/dotfiles/bashrc-$HOSTNAME
elif [[ -f ~/.bashrc-$HOSTNAME ]]; then
	. ~/.bashrc-$HOSTNAME
fi

### Todo list

if [[ ! "$SUDO_USER" ]]; then
	have todo && todo
fi

true
