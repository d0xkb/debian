#if not running interactively, don't do anything
[ -z "$PS1" ] && return

#endless history size
HISTSIZE=
#endless history file size
HISTFILESIZE=
#display and log timestamp
HISTTIMEFORMAT="[%F %T] "

#locale setup
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

#few aliases
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias agu='apt-get update'
alias acs='apt-cache search'

#fix resize terminal
shopt -s checkwinsize
