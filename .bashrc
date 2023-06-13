####################################################################################################
# Aliases
# Custom
alias vim="nvim"
alias bcfg="nvim ~/.bashrc"
alias vcfg="nvim ~/AppData/Local/nvim/init.lua"
alias dw="cd ~/Downloads"
alias d="cd ~/Documents"
alias ba="cd ~/Desktop/bachelorthesis"
alias sa="cd ~/Documents/sapiencia/markdown/"
alias grs="cd /c/Users/forev/Dropbox/grs-batterien"
alias notes="cd /c/Users/forev/Dropbox/knowledgeequalspower"
alias ci="conda info --envs"
alias cb="conda activate bachelor"
alias o="start ."
alias td="nvim ~/Documents/todo.md"
alias pdf="md2pdf"
alias l="ls -lart"
alias c='clear'
alias trm='rm *.log *.pdf'
alias s='SumatraPDF.exe '
alias br='source ~/.bashrc'
alias ca='rm *.txt *.zip *.json *.rar'
alias gt='git status'
alias gp='git push'
alias gc='git commit -m '
alias ga='git add .'
alias ttc="code ~/Documents/ttc-meditationcentre"

# Custom functions
function md2pdf() {
	input_file="$1"
	font="$2"
	output_file="${input_file%.md}.pdf"
	if [ -n "$font" ] && fc-list : family | grep -qi "^$font\$"; then
		echo "$font is available"
		pandoc "$input_file" -o "$output_file" --pdf-engine=context -V mainfont="$font"
	else
		echo "$font is not available"
		pandoc "$input_file" -o "$output_file" --pdf-engine=context
	fi
}

# Bash Prompt Color
# bash-prompt-generator
# https://robotmoon.com/bash-prompt-generator/

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
PS1="\[$(tput setaf 243)\]\u\[$(tput setaf 245)\]@\[$(tput setaf 249)\]\h \[$(tput setaf 254)\]\w \[$(tput sgr0)\]$ "
# Bash File List Color
# export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export LS_COLORS='di=1;36:fi=0:ln=1;34:pi=5;37;41:so=5;37;44:bd=5;37;42:cd=5;37;43:or=5;37;41:ex=1;32:*~=1;31:*.md=0;35:'
