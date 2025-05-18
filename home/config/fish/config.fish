# Mute greeting
set fish_greeting

# Silence Homebrew
set -g HOMEBREW_NO_ENV_HINTS 1

# Set common defaults
set LC_ALL en_US.UTF-8
set LANG en_US.UTF-8
#set LANG C

if status is-interactive
    # Commands to run in interactive sessions can go here
    # set EDITOR /opt/homebrew/bin/nvim
    # set VISUAL /opt/homebrew/bin/nvim
    set EDITOR /usr/bin/vim
    set VISUAL /usr/bin/vim
    set TERM xterm
end

# >>> conda initialize >>>
#eval "$(/Volumes/Storage/miniforge3/bin/conda shell.fish hook)"
# eval "$(~/miniforge3/bin/conda shell.fish hook)"
# <<< conda initialize <<<

# pnpm
# set PNPM_HOME /Users/gz/Library/pnpm
# set PATH "$PNPM_HOME:$PATH"
# set PATH "$HOME/.cargo/bin:$HOME/.local/bin:$PATH"
# set PATH "/Applications/PyCharm\ CE.app/Contents/MacOS:$PATH"
# pnpm end

#eval "$(ssh-agent)"
#if test -z (pgrep ssh-agent)
#    eval (ssh-agent -c)
#    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#    set -Ux SSH_AGENT_PID $SSH_AGENT_PID
#    set -Ux SSH_AUTH_SOCK $SSH_AUTH_SOCK
#end

test -e {$HOME}/.config/fish/functions/aliases.fish ; and source {$HOME}/.config/fish/functions/aliases.fish

# thefuck
thefuck --alias | source

# fzf
fzf --fish | source

# Pyenv init
set -Ux PYENV_ROOT $HOME/.pyenv
set -Ux fish_user_paths $PYENV_ROOT/bin $fish_user_paths
pyenv init - | source

# Ruby
  set -gx LDFLAGS "-L/opt/homebrew/opt/ruby/lib"
  set -gx CPPFLAGS "-I/opt/homebrew/opt/ruby/include"

set PATH "$HOME/scripts:/opt/homebrew/opt/ruby/bin:$PATH"

### Functions
# Bang-bang function (does not work in Vi mode)
function __history_previous_command
  switch (commandline -t)
	case "!"
		commandline -t $history[1]; commandline -f repaint
	case "*"
		commandline -i !
	end
end
## !$ Function
function __history_previous_command_arguments
  switch (commandline -t)
	case "!"
		commandline -t ""
		commandline -f history-token-search-backward
	case "*"
		commandline -i '$'
	end
end
# Keybindings for !! and !$
bind ! __history_previous_command
bind '$' __history_previous_command_arguments

# Rename dirs (capitalize and convert dashes to spaces)
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

# iterm2 shell integration
test -e {$HOME}/.iterm2_shell_integration.fish ; and source {$HOME}/.iterm2_shell_integration.fish

set FLAGS_GETOPT_CMD /Applications/Sourcetree.app/Contents/Resources/bin/getopt

# bun
set --export BUN_INSTALL "$HOME/Library/Application Support/reflex/bun"
set --export PATH $BUN_INSTALL/bin $PATH
status --is-interactive; and rbenv init - fish | source

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /Users/gz/.lmstudio/bin

# Add Docker bin directory to PATH
if test -d $HOME/.docker/bin
    fish_add_path $HOME/.docker/bin
end
