# $IRBRC - irb startup script
# vim: ft=ruby

require 'irb/completion'
require 'irb/ext/save-history'
require 'pp'

Proc.new{
	cache_dir = ENV["XDG_CACHE_HOME"] || ENV["HOME"] + "/.cache"

	IRB.conf[:SAVE_HISTORY] = 5000
	IRB.conf[:HISTORY_FILE] = "#{cache_dir}/irb.history"

	def _rl_fmt(fmt, text)
		"\001#{fmt}\002#{text}\001\e[m\002"
	end

	def _prompt(prefmt, charfmt, char)
		_rl_fmt(prefmt, "%N") + " " + _rl_fmt(charfmt, char) + " "
	end

	IRB.conf[:PROMPT][:my] = {
		PROMPT_I: _prompt("\e[m\e[38;5;2m", "\e[;1m\e[38;5;10m", ">"),
		PROMPT_N: _prompt("\e[m\e[38;5;8m", "\e[;1m\e[38;5;10m", "·"),
		PROMPT_S: _prompt("\e[m\e[38;5;8m", "\e[;0m\e[38;5;14m", "%l"),
		PROMPT_C: _prompt("\e[m\e[38;5;2m", "\e[;1m\e[38;5;10m", "c"),
		RETURN: "\e[38;5;11m" + "=>" + "\e[m" + " %s\n",
	}
	IRB.conf[:PROMPT_MODE] = :my
}.call
