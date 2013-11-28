#! /bin/bash
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
##TODO
# different color for nonwritable directories
# truncate to ~30 chars for dirnames.

#############################
#.BASHRC PROPER
##############################

# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# enable color support of ls and also add handy aliases
if [ "$TERM" != "dumb" ]; then
    eval "`dircolors -b`"
fi

#set the titlebar to be useful
case "$TERM" in 
	xterm*|rxvt*) TITLEBAR="\u@\h: \w" ; TITLEBAR="\e]2;${TITLEBAR}\a" ;;
esac


#Useful for setting distro-specific commands
case $(grep [a-z] /etc/issue) in
	Ubuntu*	)	export DISTRO=ubuntu ;export UBUNTU=true;;
	Arch*	)	export DISTRO=arch ;export ARCH=true;;
	*	)	DISTRO=unknown;;
esac
		

#############################
#COLOR DEFINITIONS
##############################
function font { echo  -en "\e[$1m";} # has problems with long ones wrapping on top of the current line
# Control Characters
RESET=`font 0`
NC=$RESET
NCBG=`font 49` #resets the background only
NCFG=`font 39` #resets only the foreground
BLINK=`font 5` #makes a colorless blinking text
INVERT=`font 7` #inverts foreground and background fonts.user $COLOR $INVERT to set background
UNDERLINE=`font 4`
BOLD=`font 1`
CONCEAL=`font 8`
#Primary pallete
RED=`font 31`
GREEN=`font 32`
BLUE=`font 34`
BROWN=`font 33`
PURPLE=`font 35`
CYAN=`font 36` 
LGRAY=`font 37`

#alternate pallete
GRAY=`	font "1;30"`
YELLOW=`font "1;33"`
LBLUE=`	font "1;34"`
LCYAN=`	font "1;36"`
LPURPLE=`font "1;35"`
LRED=`	font "1;31"`
LGREEN=`font "1;32"`
WHITE=`	font "1;37"`
#Because some of them are ambiguous
GOLD=$BROWN
ORANGE=$BROWN
SILVER=$LGRAY

#Set Hostcolor
case $HOSTNAME in 
  tetra		) HOSTCOLOR=$LBLUE	;;
  ciela		) HOSTCOLOR=$LBLUE	;;
  eris		) HOSTCOLOR=$RED	;;
  midna		) HOSTCOLOR=$PURPLE	;;
  chao		) HOSTCOLOR=$GOLD	;;
  kallasti	) HOSTCOLOR=$GOLD	;;
  balthezar	) HOSTCOLOR=$LBLUE	;;
  aveil		) HOSTCOLOR=$LRED	;;
  violet	) HOSTCOLOR=$PURPLE	;;
  *		) HOSTCOLOR=$SILVER	;;
 esac
  
case $USER in
  dan)	USERCOLOR=$PURPLE ;;
  tekdemo)USERCOLOR=$LBLUE;;
  root)	USERCOLOR=$RED ;;	
  *)	USERCOLOR=$SILVER;;
esac	

# color the @ in PS1 
ATCOLOR=$NC$SILVER
GITCOLOR=$NC$BROWN
#############################
# PROMPT TWEAKS
##############################
function prompt-command {
	#Sync up shells by forcing a write to history
	history -a #write out history
	history -n #pull in history

	### Set what to print for the last return value
	if [[ $? == 0 ]] ; then EXIT="";else EXIT="!$?";fi

	### Perform battery calculations
	### Not functional on some newer systems that don't have acpi commands.
# 	BATTERY=$(acpi -b|awk 'sub(/%,/,"") {print $4};/ charging/ {print "+"}'|xargs echo)
# 	case $BATTERY in 
# 		"") return ;;
# 		100|[5-9][0-9]) BATTCOLOR=$LGREEN;;
# 		[2-5][0-9]*)	BATTCOLOR=$ORANGE;;
# 		*) 		BATTCOLOR=$RED;;
# 	esac
# 	#Adjust the battery value printout
# 	BATTERY=:$BATTERY

	### Get GIT working directory     
	if [ -x /usr/bin/git ] ; then 
		if git branch |grep "*"  ;then
			#GITPATH=\<$(git branch |grep '*'|cut -d\  -f2)
			GITPATH=$(__git_ps1)
		else unset GITPATH;
		fi
	fi
	
        #get the status from the currently selected OSH Park panel
        #Not particularly useful for anyone.
        if [ -f output/.percentfull ];then
                export PERCENTFULL=$(grep -o  '^[0-9]*' output/.percentfull);
        else export PERCENTFULL="";
        fi
	}

# special string executed at every prompt
PROMPT_COMMAND='prompt-command &>/dev/null'
#Enable GIT's special PS1 information
export GIT_PS1_SHOWDIRTYSTATE=0

#Colorize the prompt!
#PS1="\[$TITLEBAR${NC}${USERCOLOR}\]\u\[${ATCOLOR}\]@\[${NC}${HOSTCOLOR}\]\h\[${NC}\]\[\${BATTCOLOR}\]\${BATTERY}\[$NC\]\[${LBLUE}\] \w \${EXIT}\$\[${NC}\] "
#This one works for most systems
PS1="\[$TITLEBAR${NC}${USERCOLOR}\]\u\[${ATCOLOR}\]@\[${NC}${HOSTCOLOR}\]\h\[${NC}\]\[\${BATTCOLOR}\]\${BATTERY}\[$NC\]\[${LBLUE}\] \w\[${GITCOLOR}\]\${GITPATH}\[$NC$LRED\]\${EXIT} \[$BLUE\]\$\[${NC}\] "

#Extra bits for OSH Park
PS1="\[$TITLEBAR${NC}${USERCOLOR}\]\u\[${ATCOLOR}\]@\[${NC}${HOSTCOLOR}\]\h\[${NC}\]\[\${BATTCOLOR}\]\${BATTERY}\[$NC\]\[${LBLUE}\] \w\[${GITCOLOR}\]\${GITPATH}\[$NC$LRED\]\${EXIT} \[$BLUE\]\${PERCENTFULL} \$ \[${NC}\] "

PS2="\[${LBLUE}\]>\[${NC}\]" # used for "if" statements and the like
PS4="\[${RED}\]PS4++\[${NC}\]" #not sure.


#####################################
# FUNCTION DEFINITIONS
#####################################

#Shorthand for the find command
function ff { find . -iname $@ -print; }

#I don't know why this is still useful, as ubuntu inclues the service command which does just this
function daemon { 
	[ -d /etc/init.d ] && sudo /etc/init.d/$1 $2 ;
	[ -d /etc/rc.d ] && sudo /etc/init.d/$1 $2 
	}
	
#makes a directory and then goes there	
function mkcd () { mkdir $1;cd $1 ; }

# function fork { $@ &>/dev/null& }
mkdir /tmp/fork 2>/dev/null 

#Fork a process into the background, but logs the output in a new tempfile
[ $UBUNTU ] && function fork { 
    tempfile=$(tempfile -d /tmp/fork -p $1.)
    echo -n "output logged to $tempfile     "
    $@ &>$tempfile& }
    
#Forks a process into the background and logs it's output, but still prints it in the terminal
#Good for debugging if you're prone to hitting ^C when you switch to terminal
function protect { fork $@ |awk '{print $4}'|xargs tail -f ; }


function lan { 
	nmap 192.168.1.0-255 -sP -oG -|sed -nre's/Host: ([0-9\.]+) +\(([a-zA-Z]*)\).*/\1 \2/p'|column -t
	}
function clearmem { sync; echo 3 |sudo tee /proc/sys/vm/drop_caches ;} #clears disk cache
function extract () { #universal extractor
     if [ -f $1 ] ; then
	#remove extension, create dir, and move to it.
	nf=$(echo $1 |sed -e 's/(\.tar\.bz2\|\.tar\.gz\|\.bz2\|\.rar\|\.gz\|\.tar\|\.tbz2\|\.tgz\|\.zip\|\.Z\|\.7z)//')
        mkdir $nf;
	cd $nf;
	pwd
	 case $1 in
             *.tar.bz2)   tar xjf ../$1        ;;
             *.tar.gz)    tar xzf ../$1     ;;
             *.bz2)       bunzip2 ../$1       ;;
             *.rar)       rar x ../$1     ;;
             *.gz)        gunzip ../$1     ;;
             *.tar)       tar xf ../$1        ;;
             *.tbz2)      tar xjf ../$1      ;;
             *.tgz)       tar xzf ../$1       ;;
             *.zip)       unzip ../$1     ;;
             *.Z)         uncompress ../$1  ;;
             *.7z)        7z x ../$1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
} 
function bak () {
    for f in $@;do
	f=$(basename $f)
	cp -r $f $f.$(date +"%Y%m%H%M%S").bak || sudo cp -r  $f $f.$(date +"%Y%m%H%M%S").bak
    done
    }
function annoyatron () { #make random annoying sounds using the system beep. Great for servers, if they have piezos!
	MIN=20; MAX=60;
	MOD=$(($MAX-$MIN)); 
	while sleep $(( $RANDOM % $MOD + $MIN));do $1 beep --debug -f $(($RANDOM % 19960 + 40)) -l $(($RANDOM%600 ));done
	}
function webshare () {
	case $1 in
	[0-9]+ )port=$1;;
	*)	port=8080;;
	esac
	python -m SimpleHTTPServer $1	
	}	
function erishddtemp () {
	nc eris 7634|awk '{ gsub(/\|\|/,"\n"); print }'|grep /dev/sd|column -ts\|
	}
function packagesize () {
	dpkg-query --show --showformat='${Package;-30}\t${Installed-Size}\t${Status}\t${Description}\n' | sort -k 2 -n |grep -v deinstall
	}
###################
# ALIASES
###################
#Alias some graphical programs to fork automatically
#for prog in amarok firefox kate konqueror smb4k kget kopete ktorrent;do
[ $UBUNTU ] && { 
	for prog in firefox kate konqueror smb4k kget kopete ktorrent;do
	alias $prog="fork $prog"
	done
	}
alias grep='grep --color=auto '
alias igrep='grep -i '
alias apt='sudo aptitude '
alias ls='ls -p --color=auto '
alias column='column -t '
alias weather='weather -c vancouver -s washington -i KVUO'
alias open='mimeopen '
alias open='kde-open '
[ -f /usr/bin/pinfo ] && {
	alias man='pinfo '
	alias info='pinfo '
	}
alias rot13="tr '[A-Za-z]' '[N-ZA-Mn-za-m]'"
alias sshfs='sshfs -o ControlMaster=no ' # this prevents sshfs from sharing connections with ssh

#fix Ubuntu not shipping vim by default
[ -x /usr/bin/vim ] || {
	alias vim='vim.tiny '
	export EDITOR=vim.tiny 
	}

alias octave="octave -q " 

alias avrdude="avrdude -c usbtiny -p m328au "


###################
# SHELL OPTIONS
###################
shopt -s cdspell #auto spell checker!
export HISTCONTROL=ignoredups #avoid duplicate lines
export HISTCONTROL=ignoreboth #avoid successive entries
[ $UBUNTU ] && export EDITOR=vim
[ $ARCH ] && export EDITOR=vi
shopt -s checkwinsize # check the window size after each command
shopt -s histappend	#don't erase history with each shell
shopt -s nocaseglob 	#ignore case on completion

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# CD 

#Force exit with ctrl-d twice
export IGNOREEOF=1
#Tweak .inputrc for more options
[ -f ~/.inputrc ] ||echo '
$if Bash
set completion-ignore-case on
#Shows items on tab completion to indicate dir,symlink.
set visible-stats on
set mark-symlinked-directories on
#allows changing through a list of tab completions. Not working
set show-all-if-ambiguous on
"\M-s": menu-complete
#searches history for partially typed commands
"\e[A": history-search-backward
"\e[B": history-search-forward
"\e[C": forward-char
"\e[D": backward-char
$endif
'>~/.inputrc

# Ensure that SSH will always read this file
if [ ! -f ~/.bash_profile ] ;then ln -s ~/.bashrc ~/.bash_profile ;fi


###################
# ARCH STUFF
###################
if [ $ARCH ];then 
alias pacs="pacsearch"
pacsearch() {
	echo -e "$(pacman -Ss "$@" | sed \
		-e 's#^core/.*#\\033[1;31m&\\033[0;37m#g' \
		-e 's#^extra/.*#\\033[0;32m&\\033[0;37m#g' \
		-e 's#^community/.*#\\033[1;35m&\\033[0;37m#g' \
		-e 's#^.*/.* [0-9].*#\\033[0;36m&\\033[0;37m#g' ) \
		\033[0m"
	}
alias pac="sudo pacman -S"
alias pacupdate="sudo pacman -Syu"
alias aur='yaourt '
fi

##################
## Interactivity patch  (requires /etc/rc.local)
## http://www.webupd8.org/2010/11/alternative-to-200-lines-kernel-patch.html
#if grep "cgroup /etc/rc.local" ;then 
#	if [ "$PS1" ] ; then 
#		mkdir -m 0700 /dev/cgroup/cpu/user/$$
#		echo $$ > /dev/cgroup/cpu/user/$$/tasks
#	fi
#fi


##################
# System Path Tweaks
###################
#Default System Path	
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
#Add user bin
PATH=$HOME/bin:$PATH
#Add Android SDK
PATH=$PATH:/home/tekdemo/bin/android-sdk-linux_x86/{bin,tools}
#Add Ruby Gems
#PATH=$PATH:/var/lib/gems/1.8/bin/
#Arduino!
#PATH=/home/tekdemo/bin/arduino/:$PATH
export PATH
alias sudo='sudo env PATH=$PATH'	#to fix sudo changing the environment path in Ubuntu

#Chrome
if [ -e /opt/google/chrome/chrome ]; then
	PATH=$PATH:/opt/google/chrome/
fi

##################
# VISIBLE COMMANDS
###################
date
ddate
[ $HOSTNAME = eris ] && erishddtemp #Print hard drive temperatures of my server



# Initiate stderred to highlight standard error output
#https://github.com/sickill/stderred
if [ -e "/home/tekdemo/bin/stderred/build/libstderred.so" ] ;then
	#echo "Importing stderred"
	export STDERRED_ESC_CODE=$LRED
	export LD_PRELOAD="/home/tekdemo/bin/stderred/build/libstderred.so${LD_PRELOAD:+:$LD_PRELOAD}";
fi

export PYTHONPATH=/usr/lib/x86_64-linux-gnu:/usr/lib/x86_64-linux-gnu/
