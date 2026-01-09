# ============================================================================
# ENVIRONMENT AND SHELL OPTIONS
# ============================================================================

# History
export HISTSIZE=10000
export HISTFILESIZE=10000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
export HISTCONTROL=ignoredups:ignorespace
shopt -s histappend
shopt -s globstar
shopt -s checkwinsize

shopt -s nocaseglob

# Disable Ctrl-S and Ctrl-Q
stty -ixon

# Defaults
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS="-R"

# Add local bin to PATH if it exists
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Readline options
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

ff() {
    find . -iname "*$1*" 2>/dev/null
}

fd() {
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
    history | awk '{print $2}' | sort | uniq -c | sort -rn | head -20
}

hgrep() {
    history | grep -i "$1" | tail -20
}

# ============================================================================
# PROMPT/STATUSLINE
# ============================================================================

# Maybe add matching colourscheme later
RED='\[\033[0;31m\]'
GREEN='\[\033[0;32m\]'
YELLOW='\[\033[1;33m\]'
BLUE='\[\033[0;34m\]'
MAGENTA='\[\033[0;35m\]'
CYAN='\[\033[0;36m\]'
WHITE='\[\033[0;37m\]'
RESET='\[\033[0m\]'
BOLD='\[\033[1m\]'
DIM='\[\033[2m\]'

git_info() {
    local branch
    local status

    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ -z "$branch" ]; then
        return # Not in a git repository
    fi

    # Check for uncommitted changes
    if ! git diff --quiet 2>/dev/null || ! git diff --cached --quiet 2>/dev/null; then
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

    local user_host="${BOLD}${USER}${RESET}${DIM}@${RESET}${YELLOW}${HOSTNAME}${RESET}"

    local pwd_prompt="${BLUE}\w${RESET}"

    local git=$(git_info)

    local ssh=$(ssh_info)

    local symbol="${prompt_color}\$${RESET}"

    PS1="${user_host} ${pwd_prompt}${git}${ssh} ${symbol} "
}

# Set PROMPT_COMMAND to run build_prompt before each prompt
PROMPT_COMMAND=build_prompt

# Is secondary prompt really needed?
# PS2="${CYAN}>${RESET} "

# ============================================================================
# ALIASES
# ============================================================================

# Navigation
alias ls='ls -a'
alias ll='ls -lh'
alias la='ls -lAh'
alias l='ls -1'
# Still not sure about this
# alias tree='tree -a'

# Safety
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias mkdir='mkdir -pv'

alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias psgrep='ps aux | grep -i'
