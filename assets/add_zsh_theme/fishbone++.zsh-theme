
local username="%n"
local path_prefix="%{$fg[yellow]%}["
local path_string="%{$fg[blue]%}%~"
local path_postfix="%{$fg[yellow]%}]"
local prompt_string="❯❯ "
local local_time="%T"
local newline=$'\n'
local line_mode=$'\n'

# customize user settings
# prompt symbol
if [ ! -z "$FISHBONEPP_PROMPT" ]; then
	prompt_string="$FISHBONEPP_PROMPT"
fi
# username
if [ ! -z "$FISHBONEPP_USER" ]; then
	username="$FISHBONEPP_USER"
fi
# time mode
if [ "$FISHBONEPP_TIME" = "12HR" ]; then
	local_time="%t"
elif [ "$FISHBONEPP_TIME" = "FULL" ]; then
	local_time="%*"
else
	local_time="%T"
fi
# new line on start
if [ "$FISHBONEPP_NEWLINE" = false ]; then
	newline=''
fi
# line mode
if [ "$FISHBONEPP_LINE_MODE" = "singleline" ]; then
	line_mode=''
fi

local host_name="%{$fg[blue]%}${username}"
local time_string="%{$fg[blue]%}${local_time}"
# Make prompt_string red if the previous command failed.
local return_status="%(?:%{$fg[cyan]%}$prompt_string:%{$fg[red]%}$prompt_string%}"


# set the git_prompt_info text
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg[blue](%{$reset_color%}%{$fg[yellow]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%{$fg[blue])%}"
ZSH_THEME_GIT_PROMPT_DIRTY="⚡"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT='${newline}\
${host_name}${hosr}%{$reset_color%}@${time_string} ${line_mode}\
${path_prefix}${path_string}${path_postfix}$(git_prompt_info)$(git_prompt_status) \
${return_status} %{$reset_color%}'


ZSH_THEME_GIT_PROMPT_ADDED="➕"
ZSH_THEME_GIT_PROMPT_MODIFIED="✒️ "
ZSH_THEME_GIT_PROMPT_DELETED="➖"
ZSH_THEME_GIT_PROMPT_RENAMED="⁉️ "
ZSH_THEME_GIT_PROMPT_UNMERGED="🥺"
ZSH_THEME_GIT_PROMPT_UNTRACKED="🚝"
