# bashrc -- aliases and functions

unalias -a

a() {
	if [[ $1 ]]; then
		alias "$@"
	else
		alias | perl -ne "
			if (@d = /^alias (.+?)='(.+)'\$/) {
				\$d[1] =~ s/'\\\''/'/g;
				\$d[1] =~ s/^(.*)\s$/'\$&'/;
				printf qq(%-10s %s\n), @d;
			}"
	fi
}

editor() { eval command "${EDITOR:-vim}" '"$@"'; }
browser() { eval command "${BROWSER:-lynx}" '"$@"'; }
pager() { eval command "${PAGER:-less}" '"$@"'; }

# It's a mess but /at least/ it's alphasorted
alias bat='acpi -i'
count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias cindex='env TMPDIR=/var/tmp cindex'
alias csearch='csearch -n'
alias cur='cur '
dist/head() {
	echo -e "\e[1m== ~/code\e[m"
	(cd ~/code && git tip)
	echo
	echo -e "\e[1m== ~/lib/dotfiles\e[m"
	(cd ~/lib/dotfiles && git tip)
}
dist/pull() {
	~/code/dist/pull "$@"
	SILENT=y
	. ~/.profile
	unset SILENT
}
alias dnstracer='dnstracer -s .'
alias ed='ed -p:'
entity() { printf '&%s;<br>' "$@" | w3m -dump -T text/html; }
alias findexe='find -type f -executable'
gerp() { egrep -r -I -D skip --exclude-dir='.git' --exclude-dir='.svn' \
	--exclude-dir='.hg' \
	-H -n --color=always "$@"; }
alias facl='getfacl -pt'
alias fattr='getfattr --absolute-names -dm-'
alias fdf='findmnt -o target,size,use%,avail,fstype'
alias gpg-kill-agent='gpg-connect-agent killagent /bye'
gpgsigs() { gpg --edit-key "$1" check quit; }
alias hex='xxd -p'
alias unhex='xxd -p -r'
alias hup='pkill -HUP -x'
alias init='telinit' # for systemd
alias ll='ls -l'
alias logoff='logout'
if [[ $DESKTOP_SESSION ]]; then
	alias logout='~/code/x11/logout'
fi
alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'
alias lsd='ls -d .*'
alias md='mkdir'
mir() { wget -m -np --reject-regex='.*\?C=.;O=.$' "$@"; }
alias nmap='nmap --reason'
alias nosr='pkgfile'
nul() { cat "$@" | tr '\0' '\n'; }
path() { if (( $# )); then which -a "$@"; else echo "${PATH//:/$'\n'}"; fi; }
alias py='python'
alias py2='python2'
alias py3='python3'
alias rd='rmdir'
alias re='SILENT=1 . ~/.bashrc; echo reloaded .bashrc; :'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | head -c "${1:-12}"; echo; }
run() { spawn -c "$@"; }
splitext() { split -dC "${2-32K}" "$1" \
	"${1%.*}-" --additional-suffix=".${1##*.}"; }
alias srs='rsync -avHAX'
alias sudo='sudo ' # for alias expansion in sudo args
alias takeown='sudo chown "${UID}:${GROUPS[0]}"'
alias tidiff='infocmp -Ld'
alias tracert='traceroute'
alias treedu='tree --du -h'
tubemusic() { youtube-dl --title --extract-audio --audio-format mp3 \
	--keep-video "$@"; }
up() { local p= i=${1-1}; while ((i--)); do p+=../; done; cd "$p$2" && pwd; }
alias watch='watch '
vercmp() {
	case $(command vercmp "$@") in
	-1)  echo "$2 is newer than $1";;
	 0)  echo "$1 and $2 are equal";;
	 1)  echo "$1 is newer than $2";;
	esac
}
vimpaste() { vim <(getpaste "$1"); }
visexp() { (echo "; vim: ft=sexp"; echo "; file: $1"; sexp-conv < "$1") \
	| vipe | sexp-conv -s canonical | sponge "$1"; }
alias w3m='w3m -title'
alias weechat='weechat-curses' # sigh
wim() { local w=$(which "$1"); [[ $w ]] && $EDITOR "$w"; }
alias xf='ps xf -O ppid'
alias xx='chmod a+x'
alias '~'='egrep'
alias '~~'='egrep -i'

alias sdate='date "+%Y-%m-%d %H:%M"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'		# mbox
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"'	# RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"'		# ISO 8601

if have xclip; then
	alias psel='xclip -out -selection primary'
	alias gsel='xclip -in -selection primary'
	alias pclip='xclip -out -selection clipboard'
	alias gclip='xclip -in -selection clipboard'
elif have xsel; then
	alias psel='xsel -o -p'
	alias gsel='xsel -i -p'
	alias pclip='xsel -o -b'
	alias gclip='xsel -i -b'
fi

## OS-dependent aliases

lsopt="-F -h"
if (( UID == 0 )); then
	lsopt="$lsopt -a"
fi
case $OSTYPE in
	linux-gnu|cygwin)
		lsopt="$lsopt --group-directories-first"
		if (( havecolor )); then
			lsopt="$lsopt -v --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors)
		fi
		alias df='df -Th'
		alias dff='df -xtmpfs -xdevtmpfs -xrootfs -xecryptfs'
		alias w='PROCPS_USERLEN=16 w -u -s -h'
		;;
	freebsd*)
		lsopt+=" -G"
		alias df='df -h'
		alias w='w -h'
		;;
	gnu)
		lsopt="$lsopt --group-directories-first"
		if (( havecolor )); then
			lsopt="$lsopt -v --color=auto"
			eval $(dircolors ~/lib/dotfiles/dircolors)
		fi
		alias w='w -h'
		;;
	netbsd)
		alias df='df -h'
		alias w='w -h'
		;;
	*)
		alias df='df -h'
		;;
esac
alias ls="ls $lsopt"
unset lsopt

## misc functions

if have xdg-open; then
	open() { run xdg-open "$@"; }
fi

abs() {
	local pkg=$1
	if [[ $pkg != */* ]]; then
		local repo=$(pacman -Si "$pkg" \
			| sed -rn '/^Repository *: *(.+)$/{s//\1/p;q}')
		[[ $repo ]] || return 1
		pkg="$repo/$pkg"
	fi
	echo "Downloading $pkg"
	command abs "$pkg" && cd "$ABSROOT/$pkg"
}

escape_addr() {
	[[ $1 == *:* ]] &&
		set -- "[$1]"
	echo "$1"
}

catlog() {
	local prefix=$1
	printf '%s\n' "$prefix" "$prefix".* \
	| sort -rn | while read -r file; do
		case $file in
		*.gz)	zcat "$file";;
		*)	cat "$file";;
		esac
	done
}

cpans() {
	PERL_MM_OPT= PERL_MB_OPT= cpanm --sudo "$@"
}

ldapsetconf() {
	if [[ $1 ]]; then
		export LDAPCONF=$1
	else
		unset LDAPCONF
	fi
}

cat() {
	if [[ $1 == *://* ]]; then
		curl -Ls "$1"
	else
		command cat "$@"
	fi
}
man() {
	if [[ $1 == *://* ]]; then
		curl -Ls "$1" | command man /dev/stdin
	else
		command man "$@"
	fi
}

ppid() {
	local k v
	while read -r k v; do
		if [[ $k == 'PPid:' ]]; then
			echo $v
			return
		fi
	done < "/proc/$1/status"
	false
}

sshfp() {
	local key=$(mktemp)
	ssh-keyscan -t rsa,dsa,ecdsa "$@" > "$key"
	ssh-keygen -lf "$key"
	rm -f "$key"
}

sslcert() {
	if have gnutls-cli; then
		gnutls-cli "$1" -p "$2" --insecure --print-cert </dev/null | openssl x509
	elif have openssl; then
		openssl s_client -no_ign_eof -connect "$(escape_addr "$1"):$2" \
			</dev/null 2>/dev/null | openssl x509
	fi
}

pem2der() { openssl x509 -inform pem -outform der; }
der2pem() { openssl x509 -inform der -outform pem; }

tcp() {
	local host=$1 port=$2
	[[ $host = *:* ]] && host="[$host]"
	socat stdio tcp:"$host":"$port"
}

x509() {
	local file=${1:-/dev/stdin}
	if have certtool; then
		certtool -i <"$file" |
		sed -r '/^-----BEGIN/,/^-----END/d;
			/^\t*([0-9a-f][0-9a-f]:)+[0-9a-f][0-9a-f]$/d'
	else
		openssl x509 -noout -text -certopt no_pubkey,no_sigdump <"$file"
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -noout -fingerprint -sha1 -in "$file" |
		sed 's/^.*=//; y/ABCDEF/abcdef/'
}

## web sites

google() {
	browser "http://www.google.com/search?q=$(urlencode "$*")"
}

rfc() {
	browser "http://tools.ietf.org/html/rfc$1"
}

wiki() {
	browser "http://en.wikipedia.org/w/index.php?search=$(urlencode "$*")"
}

## package management

# I don't actually use `getpkg`, it remains here as documentation.
getpkg() {
	if [[ -f $1 ]]; then
		if have dpkg;		then sudo dpkg -i "$@"
		elif have pacman;	then sudo pacman -U "$@"
		elif have rpm;		then sudo rpm -U "$@"
		elif have pkg_add;	then sudo pkg_add "$@"
		else echo "no package manager" >&2; return 1; fi
	else
		if have aptitude;	then sudo aptitude install "$@"
		elif have apt-cyg;	then sudo apt-cyg install "$@"
		elif have apt-get;	then sudo apt-get install "$@" \
			--no-install-recommends
		elif have pacman;	then sudo pacman -S "$@"
		elif have yum;		then sudo yum install "$@"
		elif have pkg_add;	then sudo pkg_add "$@"
		elif have mingw-get;	then mingw-get install "$@"
		else echo "no package manager" >&2; return 1; fi
	fi
}

lspkgs() {
	if have dpkg;		then dpkg -l | awk '/^i/ {print $2}'
	elif have pacman;	then pacman -Qq
	elif have pkg_info;	then pkg_info
	elif have apt-cyg;	then apt-cyg show
	else echo "no package manager" >&2; return 1; fi
}

lspkg() {
	if [[ -z $1 ]]
	then echo "$FUNCNAME: package not specified" >&2; return 2
	elif have dpkg;		then dpkg -L "$@"
	elif have pacman;	then pacman -Qql "$@"
	elif have rpm;		then rpm -ql "$@"
	elif have pkg;		then pkg -l "$@"
	elif have pkg_info;	then pkg_info -Lq "$@"
	else echo "no package manager" >&2; return 1
	fi | sort
}

lcpkg() {
	lspkg "$@" | xargs -d '\n' ls -d --color=always 2>&1 | pager
}

llpkg() {
	lspkg "$@" | xargs -d '\n' ls -ldh --color=always 2>&1 | pager
}

lscruft() {
	if have dpkg;		then dpkg -l | awk '/^r/ {print $2}'
	elif have pacman;	then find /etc -name '*.pacsave'
	else echo "no package manager or configs not tracked" >&2; return 1; fi
}

owns() {
	local file=$1
	if [[ $file != */* ]] && have "$file"; then
		file=$(which "$file")
	fi
	file=$(readlink -f "$file")
	if have dpkg;		then dpkg -S "$file"
	elif have pacman;	then pacman -Qo "$file"
	elif have rpm;		then rpm -q --whatprovides "$file"
	elif have pkg;		then pkg which "$file"
	elif have apt-cyg;	then apt-cyg packageof "$file"
	else echo "no package manager" >&2; return 1; fi
}

## service management

if have systemctl; then
	start()   { sudo systemctl start "$@"; systemctl status -a "$@"; }
	stop()    { sudo systemctl stop "$@"; systemctl status -a "$@"; }
	restart() { sudo systemctl restart "$@"; systemctl status -a "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias status='systemctl status -a'
	alias list='systemctl list-units -t path,service,socket --no-legend'
	alias userctl='systemctl --user'
	alias u='userctl'
	ustart()   { userctl start "$@"; userctl status -a "$@"; }
	ustop()    { userctl stop "$@"; userctl status -a "$@"; }
	urestart() { userctl restart "$@"; userctl status -a "$@"; }
	alias ulist='userctl list-units -t path,service,socket --no-legend'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
	alias tsd='tree /etc/systemd/system'
	cgls() { SYSTEMD_PAGER=cat systemd-cgls "$@"; }
	usls() { cgls "/user/$UID.user/$*"; }
	psls() { cgls "/user/$UID.user/$XDG_SESSION_ID.session"; }
	if have _systemctl; then
		complete -F _systemctl enable disable status start stop restart
	fi
elif have start && have stop; then
	# Upstart
	start()   { sudo start "$@"; }
	stop()    { sudo stop "$@"; }
	restart() { sudo restart "$@"; }
elif have service; then
	# Debian
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
elif have rc.d; then
	# Arch
	start()   { sudo rc.d start "$@"; }
	stop()    { sudo rc.d stop "$@"; }
	restart() { sudo rc.d restart "$@"; }
elif have invoke-rc.d; then
	# Debian
	start()   { for _s; do sudo invoke-rc.d "$_s" start; done; }
	stop()    { for _s; do sudo invoke-rc.d "$_s" stop; done; }
	restart() { for _s; do sudo invoke-rc.d "$_s" restart; done; }
fi