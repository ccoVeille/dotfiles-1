# bashrc -- aliases and functions

unalias -a

do:() { (PS4=$'\e[32m+\e[m '; set -x; "$@") }

editor() { command ${EDITOR:-vi} "$@"; }
browser() { command ${BROWSER:-lynx} "$@"; }
pager() { command ${PAGER:-more} "$@"; }

alias aa-reload='apparmor_parser -r -T -W'
alias bat='acpi -i'
alias cal='cal -m' # LC_TIME=en_DK.UTF-8
catsexp() { cat "$@" | sexp-conv -w $((COLUMNS-1)); }
alias cindex='env TMPDIR=/var/tmp cindex'
alias cpans='PERL_MM_OPT= PERL_MB_OPT= cpanm --sudo'
count() { sort "$@" | uniq -c | sort -n -r | pager; }
alias demo='PS1="\\n\\$ "'
dist/pull() { ~/code/dist/pull "$@" && SILENT=1 . ~/.profile; }
alias dnstrace='dnstracer -s .'
alias easy-rsa='easyrsa'
alias ed='ed -p:'
entity() { printf '&%s;<br>' "$@" | w3m -dump -T text/html; }
alias ccard-tool='pkcs11-tool --module libccpkip11.so'
alias etoken-tool='pkcs11-tool --module libeTPkcs11.so'
alias gemalto-tool='pkcs11-tool --module /usr/lib/pkcs11/libgclib.so'
alias ykcs11-tool='pkcs11-tool --module libykcs11.so'
alias pwpw-tool='pkcs11-tool --module pwpw-card-pkcs11.so'
alias osc-tool='pkcs11-tool --module opensc-pkcs11.so'
cymruname() { arpaname "$1" | sed 's/\.in-addr\.arpa/.origin/i;
                                   s/\.ip6\.arpa/.origin6/i;
                                   s/$/.asn.cymru.com./'; }
cymrudig() { local n=$(cymruname "$1") && [[ $n ]] && dig +short "$n" TXT; }
alias cymruwhois='whois -h whois.radb.net'
alias facl='getfacl -pt'
fc-fontformat() {
	fc-list -f "%10{fontformat}: %{family}\n" \
	| sed 's/,.*//' | sort -t: -k2 -u
}
fc-file() { fc-query -f "%{file}: %{family} (%{fontversion}, %{fontformat})\n" "$@"; }
alias fanficfare='fanficfare -f html'
alias fiemap='xfs_io -r -c "fiemap -v"'
alias fff='fanficfare -f html'
gerp() { egrep $grepopt -r -I -D skip --exclude-dir={.bzr,.git,.hg,.svn} -H -n "$@"; }
gpgfp() { gpg --with-colons --fingerprint "$1" | awk -F: '/^fpr:/ {print $10}'; }
alias hd='hexdump -C'
alias hex='xxd -p'
alias unhex='xxd -p -r'
hostname.bind() {
	for _s in id.server hostname.bind version.bind; do
		echo "$_s = $(dig +short "${@:2}" "@${1#@}" "$_s." TXT CH)"
	done
}
alias hup='pkill -HUP -x'
alias init='telinit' # for systemd
iwstat() {
	local dev=${1:-wlan0}
	iw $dev info && echo &&
	iw $dev link && echo &&
	iw $dev station dump
}
kernels() {
	cat https://www.kernel.org/finger_banner \
	| sed -r 's/^The latest (.+) version.*:/\1/' \
	| column -t
}
alias kssh='ssh \
	-o PreferredAuthentications=gssapi-keyex,gssapi-with-mic \
	-o GSSAPIAuthentication=yes \
	-o GSSAPIDelegateCredentials=yes'
alias l='~/code/thirdparty/l'
alias ll='ls -l'
alias logoff='logout'
if [[ $DESKTOP_SESSION ]]; then
	alias logout='env logout'
fi
f() { find . \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \); }
ff() { find "$PWD" \( -name .git -prune \) , \( -iname "*$1*" "${@:2}" \) \
	| treeify "$PWD"; }
alias lchown='chown -h'
vildap() { ldapvi -s base -b "$@" '(objectclass=*)' '*' '+'; }
ldapls() {
	ldapsearch -LLL -o ldif-wrap=no "$@" 1.1 | grep ^dn: \
	| perl -MMIME::Base64 -pe 's/^(.+?):: (.+)$/"$1: ".decode_base64($2)/e'
}
ldapshow() { ldapsearch -b "$1" -s base -LLL "${@:2}"; }
ldapstat() { ldapsearch -b "" -s base -LLL "$@" \* +; }
alias ldapvi='ldapvi --bind sasl'
alias lp='sudo netstat -lptu --numeric-hosts'
alias lpt='sudo netstat -lpt --numeric-hosts'
alias lpu='sudo netstat -lpu --numeric-hosts'
alias lsd='ls -d .*'
lsftp() { lftp "sftp://$1"; }
alias lspart='lsblk -o name,partlabel,size,fstype,label,mountpoint'
alias mkcert='mkcsr -x509 -days 3650'
alias mkcsr='openssl req -new -sha256'
mkmaildir() { mkdir -p "${@/%//cur}" "${@/%//new}" "${@/%//tmp}"; }
mtr() { settitle "$HOSTNAME: mtr $*"; command mtr --show-ips "$@"; }
alias mtrr='mtr --report-wide --report-cycles 3 --show-ips --aslookup --mpls'
alias mutagen='mid3v2'
mvln() { mv "$1" "$2" && sym -v "$2" "$1"; }
alias nmap='nmap --reason'
alias nm-con='nmcli -f name,type,autoconnect,state,device con'
alias py='python'
alias py2='python2'
alias py3='python3'
alias qrdecode='zbarimg --quiet --raw'
alias rd='rmdir'
rdu() { (( $# )) || set -- */; du -hsc "$@" | awk '$1 !~ /K/ || $2 == "total"' | sort -h; }
alias re='hash -r && SILENT=1 . ~/.bashrc && echo reloaded .bashrc && :'
alias ere='set -a && . ~/.profile && set +a && echo reloaded .profile && :'
ressh() { ssh -v \
	-o ControlPersist=no \
	-o ControlMaster=no \
	-o ControlPath=none \
	"$@" ":"; }
alias rawhois='do: whois -h whois.ra.net --'
alias riswhois='do: whois -h riswhois.ripe.net --'
alias rot13='tr N-ZA-Mn-za-m A-Za-z'
rpw() { tr -dc "A-Za-z0-9" < /dev/urandom | case $1 in
		"") head -c 20 | sed -r "s/.{5}/-&/g; s/^-//";;
		*) head -c "$1";;
	esac; echo; }
alias run='spawn -c'
alias rsync='rsync -s'
sp() { printf '%s' "$@"; printf '\n'; }
splitext() { split -dC "${2-32K}" "$1" "${1%.*}-" --additional-suffix=".${1##*.}"; }
alias srs='rsync -vshzaHAX'
ssh-addglobal() { ssh -t wolke 'ssh-add ~/.ssh/id_global_*'; }
alias sudo='sudo ' # for alias expansion in sudo args
alias telnets='telnet-ssl -z ssl'
_thiscommand() { history 1 | sed "s/^\s*[0-9]\+\s\+([^)]\+)\s\+$1\s\+//"; }
alias tidiff='infocmp -Ld'
alias todo:='todo "$(_thiscommand todo:)" #'
alias traceroute='traceroute --extensions'
alias tracert='traceroute --icmp'
alias treedu='tree --du -h'
alias try-openconnect='openconnect --verbose --authenticate'
alias try-openvpn='openvpn --verb 3 --dev null --{ifconfig,route}-noexec --client'
up() { local p i=${1-1}; while ((i--)); do p+=../; done; cd "$p$2" && pwd; }
vercmp() {
	case $(command vercmp "$@") in
	-1) echo "$1 < $2";;
	 0) echo "$1 = $2";;
	 1) echo "$1 > $2";;
	esac
}
vimpaste() { vim <(getpaste "$1"); }
alias vinft='sudo -E sh -c "vim /etc/nftables.conf && nft -f /etc/nftables.conf"'
virdf() { vim -c "setf n3" <(rapper -q -o turtle "$@"); }
visexp() { (echo "; vim: ft=sexp"; echo "; file: $1"; sexp-conv < "$1") \
	| vipe | sexp-conv -s canonical | sponge "$1"; }
alias w3m='w3m -title'
wim() { local file=$(which "$1") && [[ $file ]] && editor "$file" "${@:2}"; }
alias unpickle='python -m pickletools'
alias unwine='printf "\e[?1l \e>"'
xar() { xargs -r -d '\n' "$@"; }
alias xf='ps xf -O ppid'
alias xx='chmod a+rx'
alias zt1='zerotier-cli'
alias '~'='egrep'
alias '~~'='egrep -i'
-() { cd -; }
,() {
	for _a in "${@:-.}"; do
		if [[ $_a == *://* || -e $_a ]]
			then run xdg-open "$_a"
			else (. lib.bash; err "path '$_a' not found"); return
		fi
	done
}
alias open=,

# dates

alias ssdate='date "+%Y%m%d"'
alias sdate='date "+%Y-%m-%d"'
alias mmdate='date "+%Y-%m-%d %H:%M"'
alias mdate='date "+%Y-%m-%d %H:%M:%S %z"'
alias ldate='date "+%A, %B %-d, %Y %H:%M"'
alias mboxdate='date "+%a %b %_d %H:%M:%S %Y"'
alias mimedate='date "+%a, %d %b %Y %H:%M:%S %z"' # RFC 2822
alias isodate='date "+%Y-%m-%dT%H:%M:%S%z"' # ISO 8601

# git bisect

alias good='git bisect good'
alias bad='git bisect bad'

# conditional aliases

if ! have annex; then
	alias annex='git annex'
fi

if have mpv; then
	alias mplayer='mpv'
fi

# X11 clipboard

if have xclip; then
	alias psel='xclip -out -selection primary'
	alias gsel='xclip -in -selection primary'
	alias pclip='xclip -out -selection clipboard'
	alias gclip='xclip -in -selection clipboard'
	alias lssel='psel -target TARGETS'
	alias lsclip='pclip -target TARGETS'
elif have xsel; then
	alias psel='xsel -o -p -l /dev/null'
	alias gsel='xsel -i -p -l /dev/null'
	alias pclip='xsel -o -b -l /dev/null'
	alias gclip='xsel -i -b -l /dev/null'
fi

clip() {
	if (( $# )); then
		echo -n "$*" | gclip
	elif [[ ! -t 0 ]]; then
		gclip
	else
		pclip
	fi
}

sel() {
	if (( $# )); then
		echo -n "$*" | gsel
	elif [[ ! -t 0 ]]; then
		gsel
	else
		psel
	fi
}

# OS-dependent aliases

grepopt="--color=auto"
alias grep='grep $grepopt'
alias egrep='egrep $grepopt'
alias fgrep='fgrep $grepopt'

lsopt="-F -h"
treeopt="--dirsfirst"
if (( UID == 0 )); then
	lsopt="$lsopt -a"
	treeopt="$treeopt -a"
fi
case $OSTYPE in
	linux-gnu*|cygwin)
		lsopt="$lsopt --color=auto"
		# fix unnecessary filename quoting
		# (coreutils 8.25 commit 109b9220cead6e979d22d16327c4d9f8350431cc)
		lsopt="$lsopt -N"
		eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
		alias df='df -Th'
		alias dff='df -xtmpfs -xdevtmpfs -xrootfs -xecryptfs'
		alias lsd='ls -a --ignore="[^.]*"'
		;;
	freebsd*)
		lsopt="$lsopt -G"
		alias df='df -h'
		;;
	gnu)
		lsopt="$lsopt --color=auto"
		eval $(dircolors ~/lib/dotfiles/dircolors 2>/dev/null)
		alias lsd='ls -a --ignore="[^.]*"'
		;;
	netbsd|openbsd*)
		alias df='df -h'
		;;
	*)
		alias df='df -h'
		;;
esac
alias ls="ls $lsopt"
unset lsopt
alias tree="tree $treeopt"
unset treeopt

alias who='who -HT'

# misc functions

catlog() {
	printf '%s\n' "$1" "$1".* | natsort | tac | while read -r file; do
		case $file in
		    *.gz) zcat "$file";;
		    *)    cat "$file";;
		esac
	done
}

cat() {
	if [[ $1 == *://* ]]; then
		curl -LsfS "$1"
	else
		command cat "$@"
	fi
}

imv() {
	local old new
	if (( ! $# )); then
		echo "imv: no files" >&2
		return 1
	fi
	for old; do
		new=$old; read -p "rename to: " -e -i "$old" new
		[[ "$old" == "$new" ]] || command mv -v "$old" "$new"
	done
}

mksrcinfo() {
	if have mksrcinfo; then
		command mksrcinfo
	else
		makepkg --printsrcinfo > .SRCINFO || rm -f .SRCINFO
	fi
}

man() {
	if [[ $1 == *://* ]]; then
		curl -LsfS "$1" | command man /dev/stdin
	elif [[ $1 == *.[0-9]* && $1 != */* && ! $2 && -f $1 ]]; then
		command man "./$1"
	elif [[ $1 == annex ]]; then
		command man git-annex "${@:2}"
	else
		command man "$@"
	fi
}

alias tlsc='tlsg'

tlsg() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	gnutls-cli "$host" -p "$port" "${@:3}"
}

tlso() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	case $host in
	    *:*) local addr="[$host]";;
	    *)   local addr="$host";;
	esac
	openssl s_client -connect "$addr:$port" -servername "$host" \
		-verify_hostname "$host" -status -no_ign_eof -nocommands "${@:3}"
}

tlsb() {
	if [[ $2 == -p ]]; then
		set -- "$1" "--port=$3" "${@:4}"
	fi
	botan tls_client "$@"
}

tlscert() {
	if [[ $2 == -p ]]; then
		set -- "$1" "${@:3}"
	fi
	local host=$1 port=${2:-443}
	if have gnutls-cli; then
		tlsg "$host" "$port" --insecure --print-cert
	elif have openssl; then
		tlso "$host" "$port" -showcerts
	fi < /dev/null
}

alias sslcert='tlscert'

lspkcs12() {
	if [[ $1 == -g ]]; then
		certtool --p12-info --inder "${@:2}"
	elif [[ $1 == -n ]]; then
		pk12util -l "${@:2}"
	elif [[ $1 == -o ]]; then
		openssl pkcs12 -info -nokeys -in "${@:2}"
	fi
}

x509fp() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -fingerprint -sha1 | sed 's/.*=//' | tr A-F a-f
}

x509subj() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -subject -nameopt RFC2253 | sed 's/^subject=//'
}

x509subject() {
	local file=${1:-/dev/stdin}
	openssl x509 -in "$file" -noout -subject -issuer -nameopt multiline,dn_rev
}

# package management

lsflatpak() { (cd "$(flatpak info --show-location "$1")/files" && find); }
lcflatpak() { (cd "$(flatpak info --show-location "$1")/files" && find | xargs -d '\n' ls -d --color=always 2>&1 | pager); }
treeflatpak() { tree "$(flatpak info --show-location "$1")/files"; }

if have dpkg && [[ -e /etc/apt/sources.list ]]; then
	lspkgs() { dpkg -l | awk '/^i/ {print $2}'; }
	lscruft() { dpkg -l | awk '/^r/ {print $2}'; }
	lspkg() { dpkg -L "$@"; }
	_pkg_owns() { dpkg -S "$@"; }
elif have pacman; then
	lspkgs() { pacman -Qq; }
	lscruft() { find /etc -name '*.pacsave'; }
	lspkg() { pacman -Qql "$@"; }
	_pkg_owns() { pacman -Qo "$@"; }
	alias nosr='pkgfile'
elif have rpm; then
	lspkgs() { rpm -qa --qf '%{NAME}\n'; }
	lspkg() { rpm -ql "$@"; }
	_pkg_owns() { rpm -q --whatprovides "$@"; }
elif [[ $OSTYPE == FreeBSD ]] && have pkg; then
	lspkgs() { pkg info -q; }
	lspkg() { pkg query '%Fp' "$@"; }
	_pkg_owns() { pkg which "$@"; }
fi

if have lspkg; then
	lcpkg() { lspkg "$@" | xargs -d '\n' ls -d --color=always 2>&1 | pager; }
	llpkg() { lspkg "$@" | xargs -d '\n' ls -ldh --color=always 2>&1 | pager; }
fi

if have _pkg_owns; then
	owns() {
		local file=$1
		if [[ $file != */* ]] && have "$file"; then
			file=$(which "$file")
		fi
		_pkg_owns "$(readlink -f "$file")"
	}
fi

# service management

if have systemctl && [[ -d /run/systemd/system ]]; then
	start()   { sudo systemctl start "$@";   _status "$@"; }
	stop()    { sudo systemctl stop "$@";    _status "$@"; }
	restart() { sudo systemctl restart "$@"; _status "$@"; }
	reload()  { sudo systemctl reload "$@";  _status "$@"; }
	status()  { SYSTEMD_PAGER='cat' systemctl status -a "$@"; }
	_status() { sudo SYSTEMD_PAGER='cat' systemctl status -a -n0 "$@"; }
	alias enable='sudo systemctl enable'
	alias disable='sudo systemctl disable'
	alias list='systemctl list-units -t path,service,socket --no-legend'
	alias userctl='systemctl --user'
	alias u='systemctl --user'
	alias y='systemctl'
	ustart()   { userctl start "$@";   userctl status -a "$@"; }
	ustop()    { userctl stop "$@";    userctl status -a "$@"; }
	urestart() { userctl restart "$@"; userctl status -a "$@"; }
	ureload()  { userctl reload "$@";  userctl status -a "$@"; }
	alias ulist='userctl list-units -t path,service,socket --no-legend'
	alias lcstatus='loginctl session-status $XDG_SESSION_ID'
	alias tsd='tree /etc/systemd/system'
	cgls() { SYSTEMD_PAGER='cat' systemd-cgls "$@"; }
	usls() { cgls "/user.slice/user-$UID.slice/$*"; }
elif have service; then
	# Debian, other LSB
	start()   { for _s; do sudo service "$_s" start; done; }
	stop()    { for _s; do sudo service "$_s" stop; done; }
	restart() { for _s; do sudo service "$_s" restart; done; }
	status()  { for _s; do sudo service "$_s" status; done; }
	enable()  { for _s; do sudo update-rc.d "$_s" enable; done; }
	disable() { for _s; do sudo update-rc.d "$_s" disable; done; }
fi
