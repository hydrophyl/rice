#
# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[[ -f ~/.welcome_screen ]] && . ~/.welcome_screen

_set_liveuser_PS1() {
	PS1='[\u@\h \W]\$ '
	if [ "$(whoami)" = "liveuser" ]; then
		local iso_version="$(grep ^VERSION= /usr/lib/endeavouros-release 2>/dev/null | cut -d '=' -f 2)"
		if [ -n "$iso_version" ]; then
			local prefix="eos-"
			local iso_info="$prefix$iso_version"
			PS1="[\u@$iso_info \W]\$ "
		fi
	fi
}
_set_liveuser_PS1
unset -f _set_liveuser_PS1

ShowInstallerIsoInfo() {
	local file=/usr/lib/endeavouros-release
	if [ -r $file ]; then
		cat $file
	else
		echo "Sorry, installer ISO info is not available." >&2
	fi
}

alias ls='ls --color=auto'
alias ll='ls -lav --ignore=..' # show long listing of all except ".."
alias l='ls -lav --ignore=.?*' # show long listing but no hidden dotfiles except "."
alias c='clear'
alias br='source ~/.bashrc'
alias aev='source venv/bin/activate'
alias fdev='flask run --debug'
alias frun='flask run'
alias pcfg='nvim ~/.config/polybar/config.ini'

[[ "$(whoami)" = "root" ]] && return

[[ -z "$FUNCNEST" ]] && export FUNCNEST=100 # limits recursive functions, see 'man bash'

## Use the up and down arrow keys for finding a command in history
## (you can write some initial letters of the command first).
bind '"\e[A":history-search-backward'
bind '"\e[B":history-search-forward'

################################################################################
## Some generally useful functions.
## Consider uncommenting aliases below to start using these functions.
##
## October 2021: removed many obsolete functions. If you still need them, please look at
## https://github.com/EndeavourOS-archive/EndeavourOS-archiso/raw/master/airootfs/etc/skel/.bashrc

_open_files_for_editing() {
	# Open any given document file(s) for editing (or just viewing).
	# Note1:
	#    - Do not use for executable files!
	# Note2:
	#    - Uses 'mime' bindings, so you may need to use
	#      e.g. a file manager to make proper file bindings.

	if [ -x /usr/bin/exo-open ]; then
		echo "exo-open $@" >&2
		setsid exo-open "$@" >&/dev/null
		return
	fi
	if [ -x /usr/bin/xdg-open ]; then
		for file in "$@"; do
			echo "xdg-open $file" >&2
			setsid xdg-open "$file" >&/dev/null
		done
		return
	fi

	echo "$FUNCNAME: package 'xdg-utils' or 'exo' is required." >&2
}

#------------------------------------------------------------

## Aliases for the functions above.
## Uncomment an alias if you want to use it.
##

# alias ef='_open_files_for_editing'     # 'ef' opens given file(s) for editing
# alias pacdiff=eos-pacdiff
################################################################################

alias bg="sh ~/Pictures/set_wall.sh"
alias bcfg="nvim /home/min/.bashrc"
alias deleteVimSwap="rm /home/min/.local/state/nvim/swap/*"
function sp_color() {
	# Read user input
	read -p "Enter the color you want for your prompt (bgy, orange, green, lemon, autumn, sand, blue, pink, gray): " color

	if [ "$color" == "bgy" ]; then
		# Blue green yellow
		PS1="\[$(tput setaf 39)\]\u\[$(tput setaf 81)\]@\[$(tput setaf 77)\]\h \[$(tput setaf 226)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "orange" ]; then
		# Fiery orange
		PS1="\[$(tput setaf 196)\]\u\[$(tput setaf 202)\]@\[$(tput setaf 208)\]\h \[$(tput setaf 220)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "green" ]; then
		# Emerald green
		PS1="\[$(tput setaf 34)\]\u\[$(tput setaf 40)\]@\[$(tput setaf 46)\]\h \[$(tput setaf 154)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "lemon" ]; then
		# Lemon line
		PS1="\[$(tput setaf 47)\]\u\[$(tput setaf 156)\]@\[$(tput setaf 227)\]\h \[$(tput setaf 231)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "autumn" ]; then
		# Autumn leaves
		PS1="\[$(tput setaf 216)\]\u\[$(tput setaf 160)\]@\[$(tput setaf 202)\]\h \[$(tput setaf 131)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "sand" ]; then
		# Desert sand
		PS1="\[$(tput setaf 216)\]\u\[$(tput setaf 220)\]@\[$(tput setaf 222)\]\h \[$(tput setaf 229)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "blue" ]; then
		# Ocean blue
		PS1="\[$(tput setaf 39)\]\u\[$(tput setaf 45)\]@\[$(tput setaf 51)\]\h \[$(tput setaf 195)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "pink" ]; then
		# Violet pink
		PS1="\[$(tput setaf 165)\]\u\[$(tput setaf 171)\]@\[$(tput setaf 213)\]\h \[$(tput setaf 219)\]\w \[$(tput sgr0)\]$ "
	elif [ "$color" == "gray" ]; then
		# Monochromatic
		PS1="\[$(tput setaf 243)\]\u\[$(tput setaf 245)\]@\[$(tput setaf 249)\]\h \[$(tput setaf 254)\]\w \[$(tput sgr0)\]$ "
	else
		echo "Invalid color."
	fi
}

# default color
PS1="\[$(tput setaf 216)\]\u\[$(tput setaf 160)\]@\[$(tput setaf 202)\]\h \[$(tput setaf 131)\]\w \[$(tput sgr0)\]$ "
# Bash File List Color
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
#export LS_COLORS='di=1;36:fi=0:ln=1;34:pi=5;37;41:so=5;37;44:bd=5;37;42:cd=5;37;43:or=5;37;41:ex=1;32:*~=1;31:*.md=0;35:'
# Import colorscheme from 'wal' asynchronously
# &   # Run the process in the background.
# ( ) # Hide shell job control messages.
(cat ~/.cache/wal/sequences &)

# Alternative (blocks terminal for 0-3ms)
cat ~/.cache/wal/sequences

# To add support for TTYs this line can be optionally added.
source ~/.cache/wal/colors-tty.sh
sp_color
