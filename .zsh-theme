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
  local context=''

  [[ "$user" != "$DEFAULT_USER" ]] && context="$user"
  [[ "$HOST" != "$DEFAULT_HOST" ]] && context="${context}@$HOST"
  [[ -n "$context" ]] && prompt_segment $GRAY $WHITE "$context"
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty
  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    dirty=$(parse_git_dirty)
    ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"
    if [[ -n $dirty ]]; then
      prompt_segment $YELLOW $GRAY
    else
      prompt_segment $GREEN $GRAY
    fi

    setopt promptsubst
    autoload -Uz vcs_info

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:*' get-revision true
    zstyle ':vcs_info:*' check-for-changes true
    zstyle ':vcs_info:*' stagedstr '✚'
    zstyle ':vcs_info:git:*' unstagedstr '●'
    zstyle ':vcs_info:*' formats ' %u%c'
    zstyle ':vcs_info:*' actionformats '%u%c'
    vcs_info
    echo -n "${ref/refs\/heads\// }${vcs_info_msg_0_}"
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
  prompt_hg
  prompt_status
  prompt_end
}

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
	PROMPT='%{%f%b%k%}$(build_prompt) '
fi
PS2='$BG[$GRAY]  $FX[reset]$FG[$GRAY]$FX[reset] '
RPROMPT='$(git_prompt_info)$FX[reset]'

ZSH_THEME_GIT_PROMPT_PREFIX="$FX[BOLD]$FG[$YELLOW]$BG[$YELLOW]$FX[BOLD]$FG[$GRAY]  "
ZSH_THEME_GIT_PROMPT_SUFFIX="  $FG[$GRAY]$FX[reset]"
ZSH_THEME_GIT_PROMPT_UNTRACKED="$FX[BOLD]$FG[$GRAY]$FX[BOLD]●"
ZSH_THEME_GIT_PROMPT_CLEAN="$FX[BOLD]$FG[$GREEN] ✔"
ZSH_THEME_GIT_PROMPT_DIRTY="$FX[BOLD]$FG[$RED] ✗"
ZSH_THEME_GIT_PROMPT_MIDDLE="%{$FG[101]%} "
