# --- Safety and convenience ---
alias cp='cp -i'               # Prompt before overwrite
alias mv='mv -i'               # Prompt before overwrite
alias rm='rm -i'               # Confirm before deleting

# --- Navigation ---
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
#alias ~='cd ~'
alias c='clear'
alias l='ls -lh'
alias la='ls -la'
alias ll='ls -l'
alias lt='ls -lt'              # Sort by modified time
alias lS='ls -lSr'             # Sort by size

# --- System info ---
alias ip='ipconfig getifaddr en0'
alias macip='ifconfig en0 | grep inet'
alias flushdns='dscacheutil -flushcache; sudo killall -HUP mDNSResponder'
alias battery='pmset -g batt'
alias topmem='top -o rsize'   # Sort top by memory usage

# --- macOS specific ---
alias showhidden='defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder'
alias hidehidden='defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder'
alias finder='open .'
alias o='open .'              # Quick open in Finder

# --- Git ---
alias gst='git status'
alias gco='git checkout'
alias ga='git add .'
alias gb='git branch'
alias gc='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gpl='git pull origin (git rev-parse --abbrev-ref HEAD)'

# --- Development ---
alias python='python3'
alias pip='pip3'
alias serve='python3 -m http.server'
alias ports='lsof -i -P -n | grep LISTEN'

# --- Homebrew ---
# Modified brewup to avoid Git permission errors with Nix
alias brewup='HOMEBREW_NO_AUTO_UPDATE=1 brew upgrade && brew cleanup'
alias brews='brew list'
alias brewc='brew cleanup'

# --- Docker ---
alias d='docker'
alias dps='docker ps'
alias dpa='docker ps -a'
alias dimg='docker images'
alias dstp='docker stop'
alias drm='docker rm'
alias drmi='docker rmi'

# --- Misc ---
alias weather='curl wttr.in'
alias uuid='uuidgen'
