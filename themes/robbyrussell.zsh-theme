# Track the start time before each command
preexec() { timer=$EPOCHREALTIME }

# Calculate and display execution time in seconds if it exceeds 2 seconds
precmd() {
    if [[ -n $timer ]]; then
        local elapsed=$(( EPOCHREALTIME - timer ))
        if (( elapsed >= 2 )); then
            exec_time="[%{$fg[magenta]%}${elapsed}s%{$reset_color%}]"
        else
            exec_time=""
        fi
        unset timer
    fi
}

# Function to display path as "/root/.../last_folder"
shorten_path() {
    local full_path="${PWD/#$HOME/~}"  # Replace home directory with ~
    local root="${full_path%%/*/*}"    # Get the root (first two folders)
    local last="${full_path##*/}"      # Get the last folder name
    echo "$root/.../$last"             # Format as "root/.../last_folder"
}

# Set up prompt with execution time, full path, exit status, and virtual environment
PROMPT='%{$fg[cyan]%}$(shorten_path)%{$reset_color%} '  # Use shortened path
PROMPT+='$(git_prompt_info)'
PROMPT+='%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$reset_color%}'
PROMPT+='%{$fg[magenta]%}[%D{%H:%M}]%{$reset_color%} '  # Time of command start

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}(git:%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%})"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

# Explicitly unset RPROMPT to remove any right-aligned display
RPROMPT='${exec_time} '