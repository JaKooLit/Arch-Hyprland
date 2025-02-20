# Refer https://misc.flogisoft.com/bash/tip_colors_and_formatting for the ANSI/VT100 control sequences

local user_color=026
local dir_color=130
local git_branch_color=010
local input_color=220

# Uncomment the following line to hide the virtual environment name.
# export VIRTUAL_ENV_DISABLE_PROMPT=1

# User details in green, bold
local user='%B$FG[${user_color}]%}%n@%m%{$reset_color%}'
# Directory details in cyan, bold
local dir='%B$FG[${dir_color}]%~%{$reset_color%}'
# git branch details in green
local git_branch='$FG[${git_branch_color}]$(git_prompt_info)%{$reset_color%}'

# Error message on command returning non-zero exit code
error_msg="\e[0;31mCommand failed"

PROMPT="${user}:${dir}:${git_branch}
$ $FG[${input_color}]"

# Resetting color to default white.
preexec()
{
  echo -ne "\e[0m"
}

# Printing error message if command failed.
precmd()
{
  # Command failed
  if [ $? -ne 0 ];
  then
    echo "${error_msg}"
  fi
}
