# ============================================================================
# ENVIRONMENT AND SHELL OPTIONS
# ============================================================================

# Exit early if not interactive
[[ $- == *i* ]] || return

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

# Disable Ctrl-S and Ctrl-Q
stty -ixon

# Defaults
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS="-R -F -X"

# Add local bin to PATH if it exists (guard prevents duplication in nested shells)
[[ ":$PATH:" != *":$HOME/.local/bin:"* ]] && [ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Readline options
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

ff() {
    find . -iname "*$1*" 2>/dev/null
}

# Renamed from fd() to avoid shadowing the fd-find CLI tool
fdir() {
    find . -type d -iname "*$1*" 2>/dev/null
}

mkcd() {
    mkdir -pv "$1" && cd "$1"
}

backup() {
    if [ -f "$1" ]; then
        cp "$1" "$1.bak"
        echo "Backup created: $1.bak"
    else
        echo "File not found: $1"
    fi
}

history_stats() {
    local field=2
    [ -n "$HISTTIMEFORMAT" ] && field=4
    history | awk -v f="$field" '{
        cmd = $f
        if (NF > f && (cmd == "git" || cmd == "docker" || cmd == "sudo" || \
                       cmd == "npm" || cmd == "cargo" || cmd == "make" || \
                       cmd == "kubectl" || cmd == "systemctl"))
            cmd = cmd " " $(f+1)
        print cmd
    }' | sort | uniq -c | sort -rn | head -20
}

hgrep() {
    history | grep -i "$1"
}

# ============================================================================
# PROMPT/STATUSLINE
# ============================================================================

RED=$'\001\033[0;31m\002'
GREEN=$'\001\033[0;32m\002'
YELLOW=$'\001\033[1;33m\002'
BLUE=$'\001\033[0;34m\002'
MAGENTA=$'\001\033[0;35m\002'
CYAN=$'\001\033[0;36m\002'
WHITE=$'\001\033[0;37m\002'
RESET=$'\001\033[0m\002'
BOLD=$'\001\033[1m\002'
DIM=$'\001\033[2m\002'

git_info() {
    local raw
    raw=$(GIT_OPTIONAL_LOCKS=0 timeout 0.5 git status --porcelain -b 2>/dev/null) || return
    [ -z "$raw" ] && return

    local first_line="${raw%%$'\n'*}"
    local branch="${first_line#'## '}"
    branch="${branch%%'...'*}"
    branch="${branch#'No commits yet on '}"

    local status
    if [[ "$raw" == *$'\n'?* ]]; then
        status="${RED}✗${RESET}"
    else
        status="${GREEN}✓${RESET}"
    fi

    echo " ${CYAN}(${BOLD}${branch}${RESET}${CYAN})${status}"
}

ssh_info() {
    if [ -n "$SSH_CONNECTION" ]; then
        echo " ${MAGENTA}[SSH]${RESET}"
    fi
}

build_prompt() {
    local exit_code=$?
    local prompt_color=$GREEN

    if [ $exit_code -ne 0 ]; then
        prompt_color=$RED
    fi

    local user_host="${BOLD}${USER}${RESET}${DIM}@${RESET}${YELLOW}\h${RESET}"
    local pwd_prompt="${BLUE}\w${RESET}"
    local git=$(git_info)
    local ssh=$(ssh_info)
    local symbol="${prompt_color}\$${RESET}"

    PS1="${user_host} ${pwd_prompt}${git}${ssh} ${symbol} "
}

# Set PROMPT_COMMAND to run build_prompt before each prompt
PROMPT_COMMAND=build_prompt

# ============================================================================
# ALIASES
# ============================================================================

# Navigation
alias ls='\ls --color=auto'
alias ll='\ls --color=auto -lh'
alias la='\ls --color=auto -lAh'
alias l='\ls --color=auto -1'
# Still not sure about this
# alias tree='tree -a'

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias psgrep='ps aux | grep -i'

alias mkdir='mkdir -p'
