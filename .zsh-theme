# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on gnzh theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

################################################################################
# A script to make using 256 colors in zsh less painful.
# P.C. Shyamshankar <sykora@lucentbeing.com>
#
# Spectrum accepts an optional argument, indicating the number of
# colors the terminal actually supports. This allows it to gracefully
# degrade, so that you don't have to write more than version of the
# same thing. By default, this argument is assumed to be 256, which
# maintains backwards compatibility.
#
# TODO: Degrade gracefully through approximation?

# We define three associative arrays, for effects, foreground colors
# and background colors.
typeset -Ag FX FG BG

FX=(
    reset     "%{[00m%}"
    bold      "%{[01m%}" no-bold      "%{[22m%}"
    italic    "%{[03m%}" no-italic    "%{[23m%}"
    underline "%{[04m%}" no-underline "%{[24m%}"
    blink     "%{[05m%}" no-blink     "%{[25m%}"
    reverse   "%{[07m%}" no-reverse   "%{[27m%}"
)

local SUPPORT

# Optionally handle impoverished terminals.
if (( $# == 0 )); then
    SUPPORT=256
else
    SUPPORT=$1
fi

# Fill the color maps.
for color in {000..$SUPPORT}; do
    FG[$color]="%{[38;5;${color}m%}"
    BG[$color]="%{[48;5;${color}m%}"
done

################################################################################

# make some aliases for the colours: (coud use normal escap.seq's too)

for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
  eval PR_USER='$FX[reset]$FG[049]%n$PR_NO_COLOR'
  eval PR_USER_OP='${PR_GREEN}%#$PR_NO_COLOR'
  local PR_PROMPT='$FX[BOLD]$FG[081]➤ $PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='$PR_RED%n$PR_NO_COLOR'
  eval PR_USER_OP='$PR_RED%#$PR_NO_COLOR'
  local PR_PROMPT='$PR_RED➤ $PR_NO_COLOR'
fi


local return_code="%(?..$PR_RED%? ↵$PR_NO_COLOR)"

local user_host='$PR_USER$FX[reset]$FG[050]@$PR_HOST$FX[BOLD]$FG[081]'
local current_dir='$FX[reset]$FG[245]%1~$FX[BOLD]$FG[081]'
local rvm_ruby=''
if which rvm-prompt &> /dev/null; then
  rvm_ruby='$PR_RED‹$(rvm-prompt i v g s)›$PR_NO_COLOR'
else
  if which rbenv &> /dev/null; then
    rvm_ruby='$PR_RED‹$(rbenv version | sed -e "s/ (set.*$//")›$PR_NO_COLOR'
  fi
fi
local git_branch='$(git_prompt_info)'
local time='$PR_NO_COLOR%*$FX[BOLD]$FG[081]'

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT"  || -n "$SSY_TTY" ]]; then
if [ -e "$HOSTNAME" "whale" ]; then
	if which tmux 2>&1 >/dev/null; then
		#if not inside a tmux session, and if no session is started, start a new
		test -z "$TMUX" && (tmux attach || tmux new-session)
	fi
fi
	PROMPT="$FG[087]╭⏤⏤$FX[bold](%/)$FX[reset]⏤$FX[bold]$FG[196](SSH)$FX[reset]$FG[087]⏤$FX[bold]$FG[046](%n@%m)$FX[reset]
$FG[087]╰▸$FX[reset] "
else
if [ -e "$HOSTNAME" "whale" ]; then
	#If not running interactively, do not do anything
	[[ $- != *i* ]] && return
	[[ -z "$TMUX" ]] && exec tmux
fi
	PROMPT="$FG[087]╭⏤⏤$FX[bold](%/)$FX[reset]$FG[087]⏤$FX[bold]$FG[046](%n@%m)$FX[reset]
$FG[087]╰▸$FX[reset] "
fi
PS2="$FG[087]╰▸$FX[reset] "
#RPROMPT=$'\e[A'"${git_branch}"
RPROMPT="${git_branch}"

ZSH_THEME_GIT_PROMPT_PREFIX="$FX[reset]$FG[226]("
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[226])$FX[reset]"
ZSH_THEME_GIT_PROMPT_DIRTY="$FX[BOLD]$PR_RED"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$FX[BOLD]$PR_GREEN"
ZSH_THEME_GIT_PROMPT_CLEAN="$FX[BOLD]$FG[081]"
