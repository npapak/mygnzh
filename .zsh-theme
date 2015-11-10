# vim:ft=zsh ts=2 sw=2 sts=2
#
# agnoster's Theme - https://gist.github.com/3712874
# A Powerline-inspired theme for ZSH
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
#
# In addition, I recommend the
# [Solarized theme](https://github.com/altercation/solarized/) and, if you're
# using it on Mac OS X, [iTerm 2](http://www.iterm2.com/) over Terminal.app -
# it has significantly better color fidelity.
#
# # Goals
#
# The aim of this theme is to only show you *relevant* information. Like most
# prompts, it will only show git information when in a git working directory.
# However, it goes a step further: everything from the current user and
# hostname to whether the last call exited with an error to whether background
# jobs are running in this shell will all be displayed automatically when
# appropriate.

### Colors
BLUE='111'
GREEN='113'
RED='173'
LGREEN='192'
YELLOW='228'
ORANGE='208'
GRAY='236'
WHITE='252'

### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`
  local context='%n@%m'

  #[[ "$user" != "$DEFAULT_USER" ]] && context="$user"
  #[[ "$HOST" != "$DEFAULT_HOST" ]] && context="${context}@$HOST"
  [[ -n "$context" ]] && prompt_segment $GRAY $WHITE "$context"
}

__GIT_PROMPT_DIR="${0:A:h}"

## Hook function definitions
function chpwd_update_git_vars() {
    update_current_git_vars
}

function preexec_update_git_vars() {
    case "$2" in
        git*|hub*|gh*|stg*)
        __EXECUTED_GIT_COMMAND=1
        ;;
    esac
}

function precmd_update_git_vars() {
    if [ -n "$__EXECUTED_GIT_COMMAND" ] || [ ! -n "$ZSH_THEME_GIT_PROMPT_CACHE" ]; then
        update_current_git_vars
        unset __EXECUTED_GIT_COMMAND
    fi
}

chpwd_functions+=(chpwd_update_git_vars)
precmd_functions+=(precmd_update_git_vars)
preexec_functions+=(preexec_update_git_vars)


## Function definitions
function update_current_git_vars() {
    unset __CURRENT_GIT_STATUS

    local gitstatus="$__GIT_PROMPT_DIR/gitstatus.py"
    _GIT_STATUS=$(python ${gitstatus} 2>/dev/null)
     __CURRENT_GIT_STATUS=("${(@s: :)_GIT_STATUS}")
    GIT_BRANCH=$__CURRENT_GIT_STATUS[1]
    GIT_AHEAD=$__CURRENT_GIT_STATUS[2]
    GIT_BEHIND=$__CURRENT_GIT_STATUS[3]
    GIT_STAGED=$__CURRENT_GIT_STATUS[4]
    GIT_CONFLICTS=$__CURRENT_GIT_STATUS[5]
    GIT_CHANGED=$__CURRENT_GIT_STATUS[6]
    GIT_UNTRACKED=$__CURRENT_GIT_STATUS[7]
}

git_super_status() {
    precmd_update_git_vars
    if [ -n "$__CURRENT_GIT_STATUS" ]; then
      STATUS="$ZSH_THEME_GIT_PROMPT_PREFIX$ZSH_THEME_GIT_PROMPT_BRANCH$GIT_BRANCH"
      if [ "$GIT_BEHIND" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND$GIT_BEHIND"
      fi
      if [ "$GIT_AHEAD" -ne "0" ]; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD$GIT_AHEAD"
      fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SEPARATOR"
      if [ "$GIT_CHANGED" -eq "0" ] && [ "$GIT_CONFLICTS" -eq "0" ] && [ "$GIT_STAGED" -eq "0" ] ; then
          STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CLEAN"
			else
				if [ "$GIT_CHANGED" -ne "0" ]; then
					STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CHANGED$GIT_CHANGED  "
				fi
				if [ "$GIT_STAGED" -ne "0" ]; then
					STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED$GIT_STAGED "
				fi
				if [ "$GIT_CONFLICTS" -ne "0" ]; then
					STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_CONFLICTS$GIT_CONFLICTS  "
				fi
      fi
			if [ "$GIT_UNTRACKED" -ne "0" ]; then
				STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
			fi
      STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
      echo "$STATUS"
    fi
}

prompt_hg() {
	local rev status
	if $(hg id >/dev/null 2>&1); then
		if $(hg prompt >/dev/null 2>&1); then
			if [[ $(hg prompt "{status|unknown}") = "?" ]]; then
				# if files are not added
				prompt_segment $RED $WHITE
				st='±'
			elif [[ -n $(hg prompt "{status|modified}") ]]; then
				# if any modification
				prompt_segment $YELLOW $GRAY
				st='±'
			else
				# if working copy is clean
				prompt_segment $GREEN $GRAY
			fi
			echo -n $(hg prompt " {rev}@{branch}") $st
		else
			st=""
			rev=$(hg id -n 2>/dev/null | sed 's/[^-0-9]//g')
			branch=$(hg id -b 2>/dev/null)
			if `hg st | grep -Eq "^\?"`; then
				prompt_segment $RED $GRAY
				st='±'
			elif `hg st | grep -Eq "^(M|A)"`; then
				prompt_segment $YELLOW $GRAY
				st='±'
			else
				prompt_segment $GREEN $GRAY
			fi
			echo -n " $rev@$branch" $st
		fi
	fi
}

# Dir: current working directory
prompt_dir() {
  DIR=$(pwd | sed -e "s,^$HOME,~,")
  while [[ $(grep -o "/" <<<"$DIR" | wc -l) -gt 2 ]] ; do
    if [[ "$DIR" == /* ]] ; then
      echo "DEBUG: starting with /">&2
      [[ $(grep -o "/" <<<"$DIR" | wc -l) -eq 3 ]] && break;
      # remove leading slash
      DIR=${DIR#*/}
    fi
    DIR=${DIR#*/}
  done
  prompt_segment $BLUE $GRAY "$DIR"
}

# Virtualenv: current working virtualenv
prompt_virtualenv() {
  local virtualenv_path="$VIRTUAL_ENV"
  if [[ -n $virtualenv_path ]]; then
    prompt_segment $BLUE $GRAY "(`basename $virtualenv_path`)"
  fi
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{$RED}%}✘"
  [[ $UID -eq 0 ]] && symbols+="%{%F{$YELLOW}%}⚡"
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{$LGREEN}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment $GRAY default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_virtualenv
  prompt_context
  prompt_dir
  prompt_status
  prompt_end
}

case "$TERM" in
	"dumb")
		PROMPT="> "
		RPROMPT=""
		;;
	xterm*|rxvt*|eterm*|screen*)
		~/Dropbox/scripts/stats
		sshhost='whale'
		# Check if we are on SSH or not
		if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT"  || -n "$SSY_TTY" ]]; then
			if [[  $HOSTNAME == $sshhost ]]; then
				if which tmux 2>&1 >/dev/null; then
					#if not inside a tmux session, and if no session is started, start a new
					test -z "$TMUX" && (tmux attach || tmux new-session)
				fi
			fi
			PROMPT='$BG[$GRAY]$FG[$RED]SSH:%{%f%b%k%}$(build_prompt) '
		else
			if [[  $HOSTNAME == $sshhost ]]; then
				#If not running interactively, do not do anything
				[[ $- != *i* ]] && return
				[[ -z "$TMUX" ]] && exec tmux
			fi
			PROMPT='$BG[$GRAY]%{%f%b%k%}$(build_prompt) '
		fi
		PS2='$BG[$GRAY]  $FX[reset]$FG[$GRAY]$SEGMENT_SEPARATOR$FX[reset] '
		#ZLE_RPROMPT_INDENT=0  # Remove space after RPROMPT; BUG
		RPROMPT='$(prompt_hg)$(git_super_status)'
		# PS1="my fancy multi-line prompt > "
		;;
	*)
		PROMPT="> "
		RPROMPT=""
esac

# Default values for the appearance of the prompt.
ZSH_THEME_GIT_PROMPT_PREFIX="$FX[BOLD]$FG[$YELLOW]$BG[$YELLOW]$FX[BOLD]$FG[$GRAY] "
ZSH_THEME_GIT_PROMPT_BRANCH="$FX[BOLD]$FG[$GRAY]"
ZSH_THEME_GIT_PROMPT_BEHIND="$FX[BOLD]$FG[$GRAY]↓"
ZSH_THEME_GIT_PROMPT_AHEAD="$FX[BOLD]$FG[$GRAY]↑"
ZSH_THEME_GIT_PROMPT_SEPARATOR="$FX[BOLD]$FG[$GRAY]|"
ZSH_THEME_GIT_PROMPT_CLEAN="$FX[BOLD]$FG[$GREEN]✔"
ZSH_THEME_GIT_PROMPT_CHANGED="$FX[BOLD]$FG[$ORANGE]⚡"
ZSH_THEME_GIT_PROMPT_STAGED="$FG[RED]●"
ZSH_THEME_GIT_PROMPT_CONFLICTS="$FG[RED]✖"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$FX[BOLD]$FG[$GRAY]…"
ZSH_THEME_GIT_PROMPT_SUFFIX="  $FX[reset]"
