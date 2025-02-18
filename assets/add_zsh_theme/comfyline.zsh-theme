##########################################
###    Comfyline - theme for zsh       ###
# Original Author: not pua ( imnotpua )  #
# email: atp@tutamail.com                #
##########################################


# make prompt work without oh-my-zsh
setopt PROMPT_SUBST
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# default segment seperators
if [[ $COMFYLINE_SEGSEP == "" ]]; then
    COMFYLINE_SEGSEP='\ue0b4'
fi

if [[ $COMFYLINE_SEGSEP_REVERSE == "" ]]; then
    COMFYLINE_SEGSEP_REVERSE='\ue0b6'
fi

# date and time formats
if [[ $COMFYLINE_DATE_FORMAT == "" ]]; then
    COMFYLINE_DATE_FORMAT="%A, %e %B %Y"
fi

if [[ $COMFYLINE_TIME_FORMAT == "" ]]; then
    COMFYLINE_TIME_FORMAT="%l:%M %p"
fi

# default light theme
if [[ $RETVAL_RANK == "" ]]; then
    RETVAL_RANK=1
fi
if [[ $HOST_RANK == "" ]]; then
    HOST_RANK=2
fi
if [[ $USER_RANK == "" ]] then
    USER_RANK=3
fi
if [[ $DIR_RANK == "" ]]; then
    DIR_RANK=4
fi
if [[ $GIT_RANK == "" ]] then
    GIT_RANK=5
fi
if [[ $VENV_RANK = "" ]]; then
    VENV_RANK=6
fi
if [[ $BAT_RANK == "" ]] then
    BAT_RANK=-3
fi
if [[ $DATE_RANK == "" ]]; then
    DATE_RANK=-2
fi
if [[ $TIME_RANK == "" ]]; then
    TIME_RANK=-1
fi

# default colors
if [[  $RETVAL_b == "" ]]; then
    RETVAL_b="#8a8bd8"
fi
if [[  $RETVAL_f == "" ]]; then
    RETVAL_f="#61355c"
fi
if [[  $HOST_b == "" ]]; then
    HOST_b="#b3b5fb"
fi
if [[  $HOST_f == "" ]]; then
    HOST_f="#4a4b87"
fi
if [[  $USER_b == "" ]]; then
    USER_b="#f8bbe5"
fi
if [[  $USER_f == "" ]]; then
    USER_f="#874c80"
fi
if [[  $GIT_b == "" ]]; then
    GIT_b="#f6b3b3"
fi
if [[  $GIT_f == "" ]]; then
    GIT_f="#d95353"
fi
if [[  $GIT_CLEAN_b == "" ]]; then
    GIT_CLEAN_b="#b3f58c"
fi
if [[  $GIT_CLEAN_f == "" ]]; then
    GIT_CLEAN_f="#568459"
fi
if [[  $DIR_b == "" ]]; then
    DIR_b="#e1bff2"
fi
if [[  $DIR_f == "" ]]; then
    DIR_f="#844189"
fi
if [[  $VENV_b == "" ]]; then
    VENV_b="#a8ddf9"
fi
if [[  $VENV_f == "" ]]; then
    VENV_f="#0066a4"
fi
if [[  $BAT_b == "" ]]; then
    BAT_b="#b3b5fb"
fi
if [[  $BAT_f == "" ]]; then
    BAT_f="#4a4b87"
fi
if [[  $DATE_b == "" ]]; then
    DATE_b="#f8bbe5"
fi
if [[  $DATE_f == "" ]]; then
    DATE_f="#874c80"
fi
if [[  $TIME_b == "" ]]; then
    TIME_b="#e1bff2"
fi
if [[  $TIME_f == "" ]]; then
    TIME_f="#844189"
fi

# basic functions

#function takes 4 arguments, background, foreground, text and rank (for edge cases)
function create_segment(){
    if [[ $4 -lt $RIGHTMOST_RANK ]]; then
        local segment="%F{$1}$COMFYLINE_SEGSEP_REVERSE"
        echo -n "$segment%K{$1}%F{$2} $3 "
    elif [[ $4 -gt $LEFTMOST_RANK ]]; then
        local segment="%K{$1}$COMFYLINE_SEGSEP "
        echo -n "$segment%F{$2}$3%F{$1} "
    elif [[ $4 -eq $RIGHTMOST_RANK ]]; then
	if [[ $COMFYLINE_NO_START -eq 1 ]]; then
	    local segment="%F{$1}$COMFYLINE_SEGSEP_REVERSE"
	    echo -n "$segment%K{$1}%F{$2} $3"
	else
	    local segment="%F{$1}$COMFYLINE_SEGSEP_REVERSE"
	    echo -n "$segment%K{$1}%F{$2} $3 %k%F{$1}$COMFYLINE_SEGSEP"
	fi
    elif [[ $4 -eq $LEFTMOST_RANK ]]; then
	if [[ $COMFYLINE_NO_START -eq 1 ]]; then
	    local segment="%K{$1} "
            echo -n "$segment%F{$2}$3%F{$1} "
	else
	    local segment="%F{$1}$COMFYLINE_SEGSEP_REVERSE%K{$1} "
	    echo -n "$segment%F{$2}$3%F{$1} "
	fi
    fi

}
###  explanation: creates segment seperator with new bg but fg as old bg.
###               then prints contents in new fg and prepares for next fg as current bg

# segment functions
function retval(){
    if [[ $COMFYLINE_RETVAL_NUMBER -eq 2 ]]; then
        symbol="%(?..✘ %?)"
    elif [[ $COMFYLINE_RETVAL_NUMBER -eq 1 ]]; then
        symbol="%?"
    else
        symbol="%(?..✘)"
    fi
    create_segment $RETVAL_b $RETVAL_f $symbol $RETVAL_RANK
}

function hostname(){
    if [[ $COMFYLINE_FULL_HOSTNAME -eq 1 ]]; then
        create_segment $HOST_b $HOST_f "%M" $HOST_RANK
    else
        create_segment $HOST_b $HOST_f "%m" $HOST_RANK
    fi
}

function username(){
    create_segment $USER_b $USER_f "%n" $USER_RANK
}

function dir(){
    if [[ $COMFYLINE_FULL_DIR -eq 1 ]]; then
        symbol="%d"
    else
        symbol="%~"
    fi
    create_segment $DIR_b $DIR_f $symbol $DIR_RANK
}

# variables to set git_prompt info and status
ZSH_THEME_GIT_PROMPT_PREFIX=" \ue0a0 "
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=""
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_ADDED=" ✚"
ZSH_THEME_GIT_PROMPT_MODIFIED=" ±"
ZSH_THEME_GIT_PROMPT_DELETED=" \u2796"
ZSH_THEME_GIT_PROMPT_UNTRACKED=" !"
ZSH_THEME_GIT_PROMPT_RENAMED=" \u21b7"
ZSH_THEME_GIT_PROMPT_UNMERGED=" \u21e1"
ZSH_THEME_GIT_PROMPT_AHEAD=" \u21c5"
ZSH_THEME_GIT_PROMPT_BEHIND=" \u21b1"
ZSH_THEME_GIT_PROMPT_DIVERGED=" \u21b0"

function gitrepo(){
	if [ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]; then
		if [[ $(git status --porcelain) == "" ]]; then
            if [[ $(command -v git_prompt_info 2> /dev/null) ]]; then
    	        create_segment $GIT_CLEAN_b $GIT_CLEAN_f "$(git_prompt_info)$(git_prompt_status)" $GIT_RANK
            else
    	        create_segment $GIT_CLEAN_b $GIT_CLEAN_f "$ZSH_THEME_GIT_PROMPT_PREFIX$(git rev-parse --abbrev-ref HEAD)" $GIT_RANK
            fi
    	else
            if [[ $(command -v git_prompt_info 2> /dev/null) ]]; then
    	        create_segment $GIT_b $GIT_f "$(git_prompt_info)$(git_prompt_status)" $GIT_RANK
            else
    	        create_segment $GIT_b $GIT_f "$ZSH_THEME_GIT_PROMPT_PREFIX$(git rev-parse --abbrev-ref HEAD)" $GIT_RANK
            fi
    	fi
	fi
}

function venv(){
    if [ -n "$VIRTUAL_ENV" ]; then
        create_segment $VENV_b $VENV_f ${VIRTUAL_ENV:t:gs/%/%%} $VENV_RANK
    fi
}

# battery function

# variables

if [[ $COMFYLINE_BATTERY_LOW == "" ]]; then
    COMFYLINE_BATTERY_LOW=15
fi
if [[ $COMFYLINE_BATTERY_HIGH == "" ]]; then
    COMFYLINE_BATTERY_HIGH=90
fi
if [[ $COMFYLINE_CHARGING_ICON == "" ]];  then
    COMFYLINE_CHARGING_ICON="⚡️"
fi
if [[ $COMFYLINE_HIGHCHARGE_ICON == "" ]]; then
    COMFYLINE_HIGHCHARGE_ICON="󰁹"
fi
if [[ $COMFYLINE_MIDCHARGE_ICON == "" ]]; then
    COMFYLINE_MIDCHARGE_ICON="󰁽"
fi
if [[ $COMFYLINE_LOWCHARGE_ICON == "" ]]; then
    COMFYLINE_LOWCHARGE_ICON="󰂃"
fi

function calcbat(){
    BAT=""
    if [[ $(uname) == "Linux" ]]; then
        number=$(ls /sys/class/power_supply/ | grep 'BAT' | wc -l )
        if [[ $number -eq 0 ]]; then
            return 0
        fi
        for ((i=0;i<$number;i++));do
            capacity=$(cat /sys/class/power_supply/BAT${i}/capacity)
            stats=$(cat /sys/class/power_supply/BAT${i}/status)
            if [[ $stats == "Charging" ]]; then
                stats="$COMFYLINE_CHARGING_ICON"
            elif [[ $stats == "Discharging" ]]; then
                if [ $capacity -gt $COMFYLINE_BATTERY_HIGH ]; then
                    stats="$COMFYLINE_HIGHCHARGE_ICON"
                elif  [ $capacity -lt $COMFYLINE_BATTERY_LOW ]; then
                    stats="$COMFYLINE_LOWCHARGE_ICON"
                else
                    stats="$COMFYLINE_MIDCHARGE_ICON"
                fi
            elif [[ $stats == "Not charging" ]]; then
                stats="$COMFYLINE_HIGHCHARGE_ICON"
            fi
            BAT="$BAT$capacity%% $stats "
        done

    elif [[ $(uname) == "Darwin" ]]; then
        battery_details = $(pmset -g batt)
	charged=$(echo "$battery_details" | grep -w 'charged')
	charging=$(echo "$battery_details" | grep -w 'AC Power')
	discharging=$(echo "$battery_details" | grep -w 'Battery Power')
	capacity=$(echo "$battery_details" | grep -o "([0-9]*)"%)

        if [ -n "$charging" ]; then
            stats="$COMFYLINE_CHARGING_ICON"
        elif [[ -n "$discharging" ]]; then
            if [ $capacity -gt $COMFYLINE_BATTERY_HIGH ]; then
                stats="$COMFYLINE_HIGHCHARGE_ICON"
            elif  [ $capacity -lt $COMFYLINE_BATTERY_LOW ]; then
                stats="$COMFYLINE_LOWCHARGE_ICON"
            else
                stats="$COMFYLINE_MIDCHARGE_ICON"
            fi
        fi
        BAT="$capacity%% $stats"

    elif [[ $(uname) == "FreeBSD" || $(uname) == "OpenBSD" ]]; then
    	capacity=$(apm -l)
    	stats=$(apm -b)
    	if [ $stats -eq 3 ]; then
            stats="$COMFYLINE_CHARGING_ICON"
        else
            if [[ $capacity -gt $COMFYLINE_BATTERY_HIGH ]]; then
                stats="$COMFYLINE_HIGHCHARGE_ICON"
            elif  [[ $capacity -lt $COMFYLINE_BATTERY_LOW ]]; then
                stats="$COMFYLINE_LOWCHARGE_ICON"
            else
                stats="$COMFYLINE_MIDCHARGE_ICON"
            fi
    	fi
        BAT="$capacity%% $stats"
    fi
}

# function to call battery calculation
function currbat(){
    if [[ $COMFYLINE_BATTERY_PLUGIN -eq 1 ]]; then
        create_segment $BAT_b $BAT_f "$(battery_pct_prompt)" $BAT_RANK
    else
    	calcbat
        create_segment $BAT_b $BAT_f "$BAT" $BAT_RANK
    fi
}

function currdate(){
    info="%D{$COMFYLINE_DATE_FORMAT}"
    create_segment $DATE_b $DATE_f $info $DATE_RANK
}

function currtime(){
    info="%D{$COMFYLINE_TIME_FORMAT}"
    create_segment $TIME_b $TIME_f $info $TIME_RANK
}

function endleft(){
    echo -n "%k$COMFYLINE_SEGSEP%f"
}

# parse variables

segments=("retval" "hostname" "username" "dir" "gitrepo" "venv" "currbat" "currtime" "currdate")
segment_ranks=($RETVAL_RANK $HOST_RANK $USER_RANK $DIR_RANK $GIT_RANK $VENV_RANK $BAT_RANK $TIME_RANK $DATE_RANK)

# split into left and right

left_prompt=()
right_prompt=()
left_ranks=()
right_ranks=()
for ((i=1;i<=${#segments[@]};i++)); do
    if [[ segment_ranks[$i] -gt 0 ]]; then
        left_prompt+=(${segments[$i]})
        left_ranks+=(${segment_ranks[$i]})
    elif [[ segment_ranks[$i] -lt 0 ]]; then
        right_prompt+=(${segments[$i]})
        right_ranks+=(${segment_ranks[$i]#-})
    fi
done

# sort the prompts according to ranks and find the leftmost and rightmost
# I use the traditional iterative method to find max/min and using count-sort for sorting

LEFTMOST_RANK=100
declare -A sorted_left
for ((i=1;i<=${#left_prompt[@]};i++)); do
    if [[ $left_ranks[$i] -lt $LEFTMOST_RANK ]]; then LEFTMOST_RANK=$left_ranks[$i] fi
    sorted_left[$left_ranks[$i]]="$left_prompt[$i]"
done

RIGHTMOST_RANK=100
declare -A sorted_right
for ((i=1;i<=${#right_prompt[@]};i++)); do
    if [[ $right_ranks[$i] -lt $RIGHTMOST_RANK ]]; then RIGHTMOST_RANK=$right_ranks[$i] fi
    sorted_right[$right_ranks[$i]]="$right_prompt[$i]"
done
((RIGHTMOST_RANK*=-1))


# finally make_prompt which makes prompts
make_left_prompt(){
    for ((j = 1; j <= ${#left_prompt[@]}; j++)); do
        type $sorted_left[$j] &>/dev/null && $sorted_left[$j]
    done
}

make_right_prompt(){
    for ((j = ${#right_prompt[@]}; j>0; j--)); do
        type $sorted_right[$j] &>/dev/null && $sorted_right[$j]
    done
}

export PROMPT='%{%f%b%k%}$(make_left_prompt)$(endleft) '
export RPROMPT='      %{%f%b%k%}$(make_right_prompt)'    # spaces left so that hiding is triggered

if [[ $COMFYLINE_NEXT_LINE_CHAR == "" ]]; then
    COMFYLINE_NEXT_LINE_CHAR='➟'
fi

if [[ $COMFYLINE_NEXT_LINE_CHAR_COLOR == "" ]]; then
    COMFYLINE_NEXT_LINE_CHAR_COLOR="grey"
fi

next_line_maker(){
    echo -n "%F{$COMFYLINE_NEXT_LINE_CHAR_COLOR}$COMFYLINE_NEXT_LINE_CHAR %f"
}

# setting up typing area
if [[ COMFYLINE_START_NEXT_LINE -eq 2 ]]; then

PROMPT=$PROMPT'
'$(next_line_maker)


elif [[ COMFYLINE_NO_GAP_LINE -eq 1 ]]; then
else

    PROMPT='
'$PROMPT

fi
