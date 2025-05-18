# ==============================
# Fish Shell Configuration
# ==============================

# ---- Basic Settings ----
# Mute greeting
set fish_greeting

# Set locale
set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

# ---- Interactive Session Settings ----
if status is-interactive
    # Editor settings
    set -gx EDITOR /usr/bin/vim
    set -gx VISUAL /usr/bin/vim
    set -gx TERM xterm
    
    # Silence Homebrew
    set -g HOMEBREW_NO_ENV_HINTS 1
    
    # Load aliases if they exist
    test -e {$HOME}/.config/fish/functions/aliases.fish ; and source {$HOME}/.config/fish/functions/aliases.fish
    
    # iTerm2 shell integration
    test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish
    
    # Initialize command helpers
    command -q thefuck; and thefuck --alias | source
    command -q fzf; and fzf --fish | source
    
    # Initialize rbenv if interactive
    command -q rbenv; and rbenv init - fish | source
end

# ---- Path Configuration ----
# Development tools
fish_add_path $HOME/scripts
fish_add_path $HOME/.docker/bin

# Programming languages
# Python - pyenv
set -Ux PYENV_ROOT $HOME/.pyenv
set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths
command -q pyenv; and pyenv init - | source

# Ruby
fish_add_path /opt/homebrew/opt/ruby/bin
set -gx LDFLAGS "-L/opt/homebrew/opt/ruby/lib"
set -gx CPPFLAGS "-I/opt/homebrew/opt/ruby/include"

# Bun
set --export BUN_INSTALL "$HOME/Library/Application Support/reflex/bun"
fish_add_path $BUN_INSTALL/bin

# LM Studio CLI
fish_add_path /Users/gz/.lmstudio/bin

# ---- External Tools ----
# Sourcetree
set FLAGS_GETOPT_CMD /Applications/Sourcetree.app/Contents/Resources/bin/getopt

# ---- Custom Functions ----
# Bang-bang (!!) function for history
function __history_previous_command
    switch (commandline -t)
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

# !$ Function for last argument
function __history_previous_command_arguments
    switch (commandline -t)
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

# Rename directories (capitalize and convert dashes to spaces)
function rename_directories
    for dir in (find . -maxdepth 1 -type d -not -name '.*' -not -name '#*' -not -name '@*' -print | sed 's|^\./||')
        # Skip the current directory
        if test "$dir" = "."; continue; end

        # Replace hyphens with spaces and capitalize each word
        set new_dir (echo $dir | string replace -a '-' ' ' | string titlecase)

        # Rename directory if the new name is different from the current name
        if test "$dir" != "$new_dir"
            echo "Renaming '$dir' to '$new_dir'"
            mv "$dir" "$new_dir"
        end
    end
end

# ---- Key Bindings ----
# Keybindings for !! and !$
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# ---- Commented Out Configurations (Preserved) ----
# >>> conda initialize >>>
#eval "$(/Volumes/Storage/miniforge3/bin/conda shell.fish hook)"
# eval "$(~/miniforge3/bin/conda shell.fish hook)"
# <<< conda initialize <<<

# pnpm
# set PNPM_HOME /Users/gz/Library/pnpm
# set PATH "$PNPM_HOME:$PATH"
# set PATH "$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
# set PATH "/Applications/PyCharm\ CE.app/Contents/MacOS:$PATH"

# SSH Agent
#eval "$(ssh-agent)"
#if test -z (pgrep ssh-agent)
#    eval (ssh-agent -c)
#    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#end
