
###
### You can re-define the following variables in your .zshrc file
### in order to customize the appearance of the prompt
###

# The indentation of the rprompt
ZLE_RPROMPT_INDENT=${ZLE_RPROMPT_INDENT:-0}

# Whether to use oh-my-zsh's git-prompt plugin
# or the builtin logic written in this file
ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT=""

# Whether to gather additional details about the git status
# This option only applies when using the builtin logic
# Usefull when dealing with huge repositories to speed things up
ZSH_ANTARES_USE_LIGHT_GIT_MODE=""

# The colors to use for the various elements of the prompt
ZSH_ANTARES_FG_EXECTIME="#dd00ff"
ZSH_ANTARES_FG_ERRVAL="#c31a1a"
ZSH_ANTARES_FG_DECO="#ffffff"
ZSH_ANTARES_FG_PWD_OK="#ffffff"
ZSH_ANTARES_BG_PWD_OK="#0055ff"
ZSH_ANTARES_FG_PWD_ERR="#ffffff"
ZSH_ANTARES_BG_PWD_ERR="#c31a1a"
ZSH_ANTARES_FG_GIT_INIT="#000000"
ZSH_ANTARES_BG_GIT_INIT="#b5f3a1"
ZSH_ANTARES_FG_GIT_BARE="#000000"
ZSH_ANTARES_BG_GIT_BARE="#b07a4e"
ZSH_ANTARES_FG_GIT_BRANCH="#000000"
ZSH_ANTARES_BG_GIT_BRANCH="#47cc2b"
ZSH_ANTARES_FG_GIT_DETACH="#000000"
ZSH_ANTARES_BG_GIT_DETACH="#eeaa22"
ZSH_ANTARES_FG_GIT_CONFLICT="#000000"
ZSH_ANTARES_BG_GIT_CONFLICT="#c31a1a"
ZSH_ANTARES_FG_GIT_AHEAD="#cfcfcf"
ZSH_ANTARES_FG_GIT_BEHIND="#9f9f9f"
ZSH_ANTARES_FG_GIT_STAGED="#6cc6ee"
ZSH_ANTARES_FG_GIT_ADDED="#04c304"
ZSH_ANTARES_FG_GIT_DELETED="#e7165a"
ZSH_ANTARES_FG_GIT_CHANGED="#ee9931"
ZSH_ANTARES_FG_GIT_CONFLICTS="#ff0000"
ZSH_ANTARES_FG_GIT_UNTRACKED="#bbffff"
ZSH_ANTARES_FG_GIT_STASHED="#eaa0ff"
ZSH_ANTARES_FG_GIT_TAG="#ffffff"
ZSH_ANTARES_FG_JOBS="#9f9f9f"
ZSH_ANTARES_FG_PRIVILEDGES="#ffdd44"

# The characters (or strings, by will) to use for some of the elements
ZSH_ANTARES_STR_GIT_BARE="⛁"
ZSH_ANTARES_STR_GIT_AHEAD="￪"
ZSH_ANTARES_STR_GIT_BEHIND="￬"
ZSH_ANTARES_STR_GIT_STAGED="●"
ZSH_ANTARES_STR_GIT_ADDED="✚"
ZSH_ANTARES_STR_GIT_DELETED="━"
ZSH_ANTARES_STR_GIT_CHANGED="✱"
ZSH_ANTARES_STR_GIT_CONFLICTS="✖"
ZSH_ANTARES_STR_GIT_UNTRACKED="❍"
ZSH_ANTARES_STR_GIT_STASHED="⚑"
ZSH_ANTARES_STR_GIT_TAG="🏲"
ZSH_ANTARES_STR_JOBS="⚙"
ZSH_ANTARES_STR_ROOT="#"
ZSH_ANTARES_STR_USER="$"

# The path expansion to use to display the pwd
ZSH_ANTARES_PATHVAR='%~'

# The minimum amount of time (in seconds) a command shall take to complete
# in order to display the execution time in the prompt
ZSH_ANTARES_MIN_EXEC_TIME=0

# The control character used to insert a new line
# You shouldn't edit this variable, but if you really want to...
ZSH_ANTARES_LINEFEED=$'\n'

###
### End of the re-definable section
###


antares_update_git_status()
{
	ZSH_ANTARES_GIT_STATUS=""
	ZSH_ANTARES_GIT_IN_WORKING_TREE=0
	ZSH_ANTARES_GIT_IS_INIT_REPO=0
	ZSH_ANTARES_GIT_IS_BARE_REPO=0
	ZSH_ANTARES_GIT_IS_DETACHED_HEAD=0
	ZSH_ANTARES_GIT_HAS_CONFLICTS=0
	ZSH_ANTARES_GIT_HAS_TAGS=0
	ZSH_ANTARES_GIT_TAG=""
	
	if ( $(git rev-parse --is-inside-work-tree 1>/dev/null 2>/dev/null) )
	then
		ZSH_ANTARES_GIT_IN_WORKING_TREE=1
		private branch_name="$(git branch --show-current)"
		if [ -n "$branch_name" ]
		then
			if [ -z "$ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT" ]
			then
				GIT_BRANCH="$branch_name"
			fi
			if ( ! $(git rev-parse --verify HEAD 1>/dev/null 2>/dev/null) )
			then
				ZSH_ANTARES_GIT_IS_INIT_REPO=1
			fi
			if [ $(git rev-parse --is-bare-repository) = "true" ]
			then
				ZSH_ANTARES_GIT_IS_BARE_REPO=1
				GIT_BRANCH="$ZSH_ANTARES_STR_GIT_BARE"
			fi
		else
			ZSH_ANTARES_GIT_IS_DETACHED_HEAD=1
			if [ -z "$ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT" ]
			then
				GIT_BRANCH="$(git rev-parse --short HEAD)"
				if [ -z "$ZSH_ANTARES_USE_LIGHT_GIT_MODE" ]
				then
					private git_tag="$(git tag --points-at=HEAD)"
					if [ -n "$git_tag" ]
					then
						ZSH_ANTARES_GIT_HAS_TAGS=1
						private n_tags="$(echo "$git_tag" | wc -l)"
						if (( n_tags == 1 ))
						then
							ZSH_ANTARES_GIT_TAG=" $ZSH_ANTARES_STR_GIT_TAG $git_tag"
						elif (( n_tags > 1 ))
						then
							ZSH_ANTARES_GIT_TAG=" $ZSH_ANTARES_STR_GIT_TAG $n_tags"
						else
						fi
					fi
				fi
			fi
		fi
	else
		antares_reset_git_info
		return
	fi
	
	if (( ZSH_ANTARES_GIT_IS_BARE_REPO ))
	then
		antares_reset_git_counts
		GIT_AHEAD=$(git rev-list --left-only HEAD..FETCH_HEAD --count)
		GIT_BEHIND=$(git rev-list --right-only HEAD..FETCH_HEAD --count)
		return
	fi
	
	if [ -n "$ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT" ]
	then
		GIT_ADDED=0
	elif [ -n "$ZSH_ANTARES_USE_LIGHT_GIT_MODE" ]
	then
		antares_reset_git_counts
		return
	else
		private git_status="$(git status -sb)"
		if [ -n "$git_status" ]
		then
			GIT_STAGED=$(echo $git_status | grep '^[AMD]. ' | wc -l)
			GIT_ADDED=$(echo $git_status | grep '^A  ' | wc -l)
			GIT_DELETED=$(echo $git_status | grep -E '^(D |.D) ' | wc -l)
			GIT_CHANGED=$(echo $git_status | grep -E '^(M |.M) ' | wc -l)
			GIT_CONFLICTS=$(echo $git_status | grep '^U. ' | wc -l)
			GIT_UNTRACKED=$(echo $git_status | grep '^?? ' | wc -l)
			GIT_STASHED=$(git stash list | wc -l)
			if (( ZSH_ANTARES_GIT_IS_DETACHED_HEAD ))
			then
				GIT_AHEAD=0
				GIT_BEHIND=0
			elif (( ! ZSH_ANTARES_GIT_IS_INIT_REPO ))
			then
				private left_right=$(echo $git_status | grep '^## ' | cut -d" " -f2)
				GIT_AHEAD=$(git rev-list --left-only $left_right --count)
				GIT_BEHIND=$(git rev-list --right-only $left_right --count)
			fi
		fi
	fi
	
	ZSH_ANTARES_GIT_HAS_CONFLICTS=$(( GIT_CONFLICTS > 0 ))
}

antares_reset_git_info()
{
	if [ -z "$ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT" ]
	then
		GIT_BRANCH=""
	fi
	antares_reset_git_counts
}
antares_reset_git_counts()
{
	if [ -n "$ZSH_ANTARES_USE_OHMYZSH_GIT_PROMPT" ]
	then
		GIT_ADDED=0
	else
		GIT_AHEAD=0
		GIT_BEHIND=0
		GIT_STAGED=0
		GIT_ADDED=0
		GIT_DELETED=0
		GIT_CHANGED=0
		GIT_CONFLICTS=0
		GIT_UNTRACKED=0
		GIT_STASHED=0
	fi
}

antares_update_prompt()
{
	ZSH_ANTARES_RETURN=""
	if [ -n "$ZSH_ANTARES_EXEC_FLAG" ]
	then
		if (( ZSH_ANTARES_MIN_EXEC_TIME >= 0 ))
		then
			private exec_time=$(( SECONDS - ZSH_ANTARES_EXEC_START ))
			if (( exec_time >= ZSH_ANTARES_MIN_EXEC_TIME ))
			then
				ZSH_ANTARES_RETURN+="%F{$ZSH_ANTARES_FG_EXECTIME}%B⤷%b $exec_time%f"
			fi
		fi
		if [[ "$ZSH_ANTARES_ERR_CODE" != "0" ]]
		then
			if [ -z "$ZSH_ANTARES_RETURN" ]
			then
				ZSH_ANTARES_RETURN+="%F{$ZSH_ANTARES_FG_ERRVAL}%B⤷%b%f"
			fi
			ZSH_ANTARES_RETURN+=" %F{$ZSH_ANTARES_FG_ERRVAL}✘%B${ZSH_ANTARES_ERR_CODE}%b%f"
		fi
		[ -n "$ZSH_ANTARES_RETURN" ] && ZSH_ANTARES_RETURN+="$ZSH_ANTARES_LINEFEED"
	fi
	
	ZSH_ANTARES_FILLER=""
	private fillchar=" "

	private width=$(( COLUMNS - ${ZLE_RPROMPT_INDENT:-1} ))

	private decosize=7
	private pwdsize=${#${(%):-$ZSH_ANTARES_PATHVAR}}
	private pwdcut=""
	private gitsize=${#${(%):-$GIT_BRANCH$ZSH_ANTARES_GIT_TAG}}
	private gitcut=""

	if (( pwdsize + gitsize + (decosize * 2) > width )); then
		private half_width=$(( width / 2 ))
		private pwd_over_half=$(( (pwdsize + decosize) > half_width ))
		private git_over_half=$(( (gitsize + decosize) > half_width ))
		if (( pwd_over_half > 0 )) && (( git_over_half > 0 ))
		then
			(( pwdcut = half_width - decosize ))
			(( gitcut = half_width - decosize ))
		elif (( pwd_over_half > 0 ))
		then
			(( pwdcut = width - gitsize - (decosize * 2) ))
			ZSH_ANTARES_FILLER="\${(l:$(( width - pwdcut - gitsize - (decosize * 2) ))::$fillchar:)}"
		elif (( git_over_half > 0 ))
		then
			(( gitcut = width - pwdsize - (decosize * 2) ))
			ZSH_ANTARES_FILLER="\${(l:$(( width - pwdsize - gitcut - (decosize * 2) ))::$fillchar:)}"
		else
			ZSH_ANTARES_FILLER="\${(l:$(( width - pwdsize - gitsize - (decosize * 2) ))::$fillchar:)}"
		fi
	else
		ZSH_ANTARES_FILLER="\${(l:$(( width - pwdsize - gitsize - (decosize * 2) ))::$fillchar:)}"
	fi
	
	if [ -n "$ZSH_ANTARES_EXEC_FLAG" ]
	then
		private pwd_fg_color="%(?.${ZSH_ANTARES_FG_PWD_OK}.${ZSH_ANTARES_FG_PWD_ERR})"
		private pwd_bg_color="%(?.${ZSH_ANTARES_BG_PWD_OK}.${ZSH_ANTARES_BG_PWD_ERR})"
	else
		private pwd_fg_color="$ZSH_ANTARES_FG_PWD_OK"
		private pwd_bg_color="$ZSH_ANTARES_BG_PWD_OK"
	fi
	ZSH_ANTARES_PWD="%K{$pwd_bg_color}%F{$pwd_fg_color} %${pwdcut}<...<${ZSH_ANTARES_PATHVAR}%<< %f%k%F{$pwd_bg_color}▓▒░%f"
	
	ZSH_ANTARES_GIT_BRANCH=""
	if (( ZSH_ANTARES_GIT_IN_WORKING_TREE ))
	then
		if (( ZSH_ANTARES_GIT_HAS_CONFLICTS ))
		then
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_BG_GIT_CONFLICT}░▒▓%f%K{$ZSH_ANTARES_BG_GIT_CONFLICT}%F{$ZSH_ANTARES_FG_GIT_CONFLICT}"
		elif (( ZSH_ANTARES_GIT_IS_DETACHED_HEAD ))
		then
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_BG_GIT_DETACH}░▒▓%f%K{$ZSH_ANTARES_BG_GIT_DETACH}%F{$ZSH_ANTARES_FG_GIT_DETACH}"
			if (( ZSH_ANTARES_GIT_HAS_TAGS ))
			then
				GIT_BRANCH+="%F{$ZSH_ANTARES_FG_GIT_TAG}${ZSH_ANTARES_GIT_TAG}%f"
			fi
		elif (( ZSH_ANTARES_GIT_IS_BARE_REPO ))
		then
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_BG_GIT_BARE}░▒▓%f%K{$ZSH_ANTARES_BG_GIT_BARE}%F{$ZSH_ANTARES_FG_GIT_BARE}"
		elif (( ZSH_ANTARES_GIT_IS_INIT_REPO ))
		then
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_BG_GIT_INIT}░▒▓%f%K{$ZSH_ANTARES_BG_GIT_INIT}%F{$ZSH_ANTARES_FG_GIT_INIT}"
		else
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_BG_GIT_BRANCH}░▒▓%f%K{$ZSH_ANTARES_BG_GIT_BRANCH}%F{$ZSH_ANTARES_FG_GIT_BRANCH}"
		fi
		ZSH_ANTARES_GIT_BRANCH+=" %${gitcut}>...>$GIT_BRANCH%>> %f%k"
		if [ -n "$ZSH_ANTARES_USE_LIGHT_GIT_MODE" ]
		then
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_FG_DECO}├╼%f"
		else
			ZSH_ANTARES_GIT_BRANCH+="%F{$ZSH_ANTARES_FG_DECO}├╮%f"
		fi
	fi
	
	ZSH_ANTARES_JOBS="%(1j.%F{$ZSH_ANTARES_FG_JOBS}${ZSH_ANTARES_STR_JOBS}%j%f .)"
	
	ZSH_ANTARES_PRIVILEDGES="%F{$ZSH_ANTARES_FG_PRIVILEDGES}%B%(!.${ZSH_ANTARES_STR_ROOT}.${ZSH_ANTARES_STR_USER})%b%f"
}

antares_update_rprompt()
{
	ZSH_ANTARES_GIT_STATUS=""
	
	[ -n "$ZSH_ANTARES_USE_LIGHT_GIT_MODE" ] && return
	
	(( ZSH_ANTARES_GIT_IN_WORKING_TREE )) || return
	
	if (( GIT_CONFLICTS > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_CONFLICTS}${ZSH_ANTARES_STR_GIT_CONFLICTS}${GIT_CONFLICTS}%f"
	fi
	if (( GIT_STAGED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_STAGED}${ZSH_ANTARES_STR_GIT_STAGED}${GIT_STAGED}%f"
	fi
	if (( GIT_DELETED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_DELETED}${ZSH_ANTARES_STR_GIT_DELETED}${GIT_DELETED}%f"
	fi
	if (( GIT_CHANGED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_CHANGED}${ZSH_ANTARES_STR_GIT_CHANGED}${GIT_CHANGED}%f"
	fi
	if (( GIT_ADDED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_ADDED}${ZSH_ANTARES_STR_GIT_ADDED}${GIT_ADDED}%f"
	fi
	if (( GIT_UNTRACKED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_UNTRACKED}${ZSH_ANTARES_STR_GIT_UNTRACKED}${GIT_UNTRACKED}%f"
	fi
	if (( GIT_STASHED > 0 ))
	then
		ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_GIT_STASHED}${ZSH_ANTARES_STR_GIT_STASHED}${GIT_STASHED}%f"
	fi
	if (( ! ZSH_ANTARES_GIT_IS_DETACHED_HEAD ))
	then
		private ahead_behind=""
		if (( GIT_AHEAD > 0 ))
		then
			ahead_behind+="%F{$ZSH_ANTARES_FG_GIT_AHEAD}${ZSH_ANTARES_STR_GIT_AHEAD}${GIT_AHEAD}%f"
		fi
		if (( GIT_BEHIND > 0 ))
		then
			ahead_behind+="%F{$ZSH_ANTARES_FG_GIT_BEHIND}${ZSH_ANTARES_STR_GIT_BEHIND}${GIT_BEHIND}%f"
		fi
		if [ -n "$ahead_behind" ]
		then
			ZSH_ANTARES_GIT_STATUS+=" $ahead_behind"
		fi
	fi
	ZSH_ANTARES_GIT_STATUS+=" %F{$ZSH_ANTARES_FG_DECO}╾─╯%f"
}

antares_precmd()
{
	ZSH_ANTARES_ERR_CODE="$?"
	antares_update_git_status
	antares_update_prompt
	antares_update_rprompt
	ZSH_ANTARES_EXEC_FLAG=""
}

antares_preexec()
{
	ZSH_ANTARES_EXEC_FLAG="+"
	ZSH_ANTARES_EXEC_START=$SECONDS
}

autoload -U add-zsh-hook
add-zsh-hook precmd antares_precmd
add-zsh-hook preexec antares_preexec

PROMPT='${ZSH_ANTARES_RETURN}\
%F{$ZSH_ANTARES_FG_DECO}╭┤%f${ZSH_ANTARES_PWD}${(e)ZSH_ANTARES_FILLER}${ZSH_ANTARES_GIT_BRANCH}
%F{$ZSH_ANTARES_FG_DECO}╰─╼%f ${ZSH_ANTARES_JOBS}${ZSH_ANTARES_PRIVILEDGES} '

RPROMPT='${ZSH_ANTARES_GIT_STATUS}'

