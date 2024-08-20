#!/usr/bin/env bash

FMT_BOLD="\e[1m"
FMT_RESET="\e[0m"
FMT_UNBOLD="\e[21m"
FG_BLACK="\e[30m"
FG_BLUE="\e[34m"
FG_CYAN="\e[36m"
FG_GREEN="\e[32m"
FG_MAGENTA="\e[35m"
FG_RED="\e[31m"
FG_WHITE="\e[97m"
FG_GRAY="\e[37m"
BG_BLUE="\e[44m"
BG_GREEN="\e[42m"
BG_MAGENTA="\e[45m"
BG_RED="\e[41m"
BG_YELLOW="\e[43m"
BG_CYAN="\e[46m"
BG_GRAY="\e[47m"
BG_WHITE="\e[107m"

BG_SLATE="\e[48;2;127;150;166m"
FG_SLATE="\e[38;2;127;150;166m"

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

export PS1=\
"\n\[${BG_GRAY}\] \[${FG_BLUE}\] DOCKER  \[${FG_RED}\] [] \[${FG_BLACK}\]\u@\h \[${FG_GRAY}${BG_SLATE}\] "\
"\[${FG_BLACK}\]\w \[${FMT_RESET}${FG_SLATE}\]"\
'$(__git_ps1 "\[${BG_MAGENTA}\] \[${FG_WHITE}\] %s \[${FMT_RESET}${FG_MAGENTA}\]")'\
"\n \[${FG_GREEN}\]╰ \[${FG_CYAN}\]\$ \[${FMT_RESET}\]"
