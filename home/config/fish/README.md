# Fish Shell Configuration

This document provides an overview of the Fish shell configuration, including keybindings and aliases.

## Table of Contents

- [Overview](#overview)
- [Key Features](#key-features)
- [Keybindings Cheatsheet](#keybindings-cheatsheet)
- [Aliases Cheatsheet](#aliases-cheatsheet)
- [Custom Functions](#custom-functions)
- [Homebrew-Nix Integration](#homebrew-nix-integration)
- [Environment Variables](#environment-variables)

## Overview

This Fish shell configuration is designed to enhance productivity with sensible defaults, useful keybindings, and helpful aliases. It's organized into logical sections for easy maintenance and customization.

## Key Features

- Organized configuration with clear section headers
- Sensible keybindings for efficient navigation and editing
- Comprehensive aliases for common tasks
- Custom functions for enhanced workflow
- Proper PATH management with `fish_add_path`
- Conditional loading of tools and plugins

## Keybindings Cheatsheet

### History Navigation

| Keybinding | Description |
|------------|-------------|
| `!!` | Expand to the last command |
| `!$` | Expand to the last argument of the previous command |
| `Ctrl+Up` | Search history backward matching current token |
| `Ctrl+Down` | Search history forward matching current token |
| `Alt+.` | Insert last argument of previous command |

### Cursor Movement

| Keybinding | Description |
|------------|-------------|
| `Ctrl+Left` | Move cursor backward one word |
| `Ctrl+Right` | Move cursor forward one word |

### Text Editing

| Keybinding | Description |
|------------|-------------|
| `Ctrl+E` | Edit command in external editor |
| `Ctrl+H` | Delete word backward |
| `Ctrl+K` | Delete from cursor to end of line |
| `Ctrl+U` | Delete from cursor to beginning of line |
| `Ctrl+T` | Paginate current command output |

### Directory Navigation

| Keybinding | Description |
|------------|-------------|
| `Alt+P` | Go to previous directory in history |
| `Alt+N` | Go to next directory in history |

### Process Control

| Keybinding | Description |
|------------|-------------|
| `Ctrl+Z` | Toggle between foreground/background for processes |

## Aliases Cheatsheet

### Safety and Convenience

| Alias | Command | Description |
|-------|---------|-------------|
| `cp` | `cp -i` | Prompt before overwrite |
| `mv` | `mv -i` | Prompt before overwrite |
| `rm` | `rm -i` | Confirm before deleting |

### Navigation

| Alias | Command | Description |
|-------|---------|-------------|
| `..` | `cd ..` | Go up one directory |
| `...` | `cd ../..` | Go up two directories |
| `....` | `cd ../../..` | Go up three directories |
| `c` | `clear` | Clear terminal screen |
| `l` | `ls -lh` | List files with human-readable sizes |
| `la` | `ls -la` | List all files including hidden ones |
| `ll` | `ls -l` | List files in long format |
| `lt` | `ls -lt` | Sort files by modification time |
| `lS` | `ls -lSr` | Sort files by size |

### System Information

| Alias | Command | Description |
|-------|---------|-------------|
| `ip` | `ipconfig getifaddr en0` | Show IP address |
| `macip` | `ifconfig en0 \| grep inet` | Show detailed IP info |
| `flushdns` | `dscacheutil -flushcache; sudo killall -HUP mDNSResponder` | Flush DNS cache |
| `battery` | `pmset -g batt` | Show battery status |
| `topmem` | `top -o rsize` | Sort top by memory usage |

### macOS Specific

| Alias | Command | Description |
|-------|---------|-------------|
| `showhidden` | `defaults write com.apple.finder AppleShowAllFiles -bool true; killall Finder` | Show hidden files |
| `hidehidden` | `defaults write com.apple.finder AppleShowAllFiles -bool false; killall Finder` | Hide hidden files |
| `finder` | `open .` | Open current directory in Finder |
| `o` | `open .` | Quick open in Finder |

### Git

| Alias | Command | Description |
|-------|---------|-------------|
| `gst` | `git status` | Show git status |
| `gco` | `git checkout` | Checkout branch or files |
| `ga` | `git add .` | Add all files |
| `gb` | `git branch` | List branches |
| `gc` | `git commit -m` | Commit with message |
| `gp` | `git push` | Push changes |
| `gl` | `git pull` | Pull changes |
| `gd` | `git diff` | Show differences |
| `gpl` | `git pull origin (current branch)` | Pull from origin for current branch |

### Development

| Alias | Command | Description |
|-------|---------|-------------|
| `python` | `python3` | Use Python 3 |
| `pip` | `pip3` | Use pip for Python 3 |
| `serve` | `python3 -m http.server` | Start a simple HTTP server |
| `ports` | `lsof -i -P -n \| grep LISTEN` | Show listening ports |

### Homebrew

| Alias | Command | Description |
|-------|---------|-------------|
| `brewup` | `brew update && brew upgrade && brew cleanup` | Update and upgrade Homebrew packages |
| `brews` | `brew list` | List installed Homebrew packages |
| `brewc` | `brew cleanup` | Clean up Homebrew cache |

### Docker

| Alias | Command | Description |
|-------|---------|-------------|
| `d` | `docker` | Docker shorthand |
| `dps` | `docker ps` | List running containers |
| `dpa` | `docker ps -a` | List all containers |
| `dimg` | `docker images` | List images |
| `dstp` | `docker stop` | Stop container |
| `drm` | `docker rm` | Remove container |
| `drmi` | `docker rmi` | Remove image |

### Miscellaneous

| Alias | Command | Description |
|-------|---------|-------------|
| `weather` | `curl wttr.in` | Show weather forecast |
| `uuid` | `uuidgen` | Generate UUID |

## Custom Functions

### Command Editing

- `edit_command_buffer`: Edit current command in external editor (bound to Ctrl+E)
- `__history_previous_command`: Implementation for !! history expansion
- `__history_previous_command_arguments`: Implementation for !$ history expansion

### File Management

- `rename_directories`: Rename directories by replacing hyphens with spaces and capitalizing words

### Python Development

- `python_venv`: Automatically activates Python virtual environments when entering directories with a `.venv` folder and deactivates them when leaving
- `setup-python-direnv`: Sets up direnv for Python projects with automatic virtual environment activation (recommended approach)

## Python Development with direnv

This configuration includes support for automatically activating Python virtual environments using direnv, which is more robust than the Fish-specific `python_venv` function.

### Using direnv for Python Projects

To set up a Python project with automatic virtual environment activation:

1. Navigate to your Python project directory
2. Run the `setup-python-direnv` function
3. Choose the template that best fits your needs:
   - **Basic Python venv template**: Simple virtual environment activation
   - **Advanced Python+Nix template**: Supports both Python venvs and Nix development environments

### Available Templates

#### Basic Python venv Template

This template automatically creates and activates a Python virtual environment in the `.venv` directory:

```bash
# Check if .venv directory exists, if not create it
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment in .venv directory..."
    python -m venv .venv
fi

# Activate the virtual environment
source .venv/bin/activate

# Export PATH to include the virtual environment's bin directory
PATH_add .venv/bin
```

#### Advanced Python+Nix Template

This template detects whether to use a Nix environment or a Python virtual environment:

```bash
# Check if we're using a Nix environment (shell.nix or flake.nix exists)
if [ -f "shell.nix" ] || [ -f "flake.nix" ]; then
    echo "Nix environment detected, using use_nix"
    use_nix
else
    # If no Nix environment, use Python venv
    # ... virtual environment setup ...
fi
```

### Benefits of Using direnv

- **Shell-agnostic**: Works with any shell, not just Fish
- **Project-specific**: Environment variables are scoped to the project directory
- **Automatic activation/deactivation**: Environments are loaded when entering the directory and unloaded when leaving
- **Security**: Each `.envrc` file must be explicitly allowed for security
- **Nix integration**: Seamlessly works with Nix development environments

## Homebrew-Nix Integration

This configuration includes special tools to help Homebrew and Nix work together harmoniously.

### Homebrew-Nix Helper Functions

| Function | Description |
|----------|-------------|
| `brew-update-safe` | Safely update Homebrew without Git permission issues |
| `brew-doctor-nix` | Run brew doctor while ignoring Nix-related warnings |
| `brew-nix-info` | Display information about Homebrew and Nix installations |
| `brew-nix-fix` | Fix common Homebrew/Nix integration issues |

### Using the Homebrew-Nix Integration

1. **Safe Updates**: Instead of using the standard `brew update`, use `brew-update-safe` to avoid Git permission issues with Nix

   ```fish
   brew-update-safe
   ```

2. **System Information**: Get detailed information about your Homebrew and Nix setup

   ```fish
   brew-nix-info
   ```

3. **Fix Integration Issues**: If you encounter problems with Homebrew and Nix

   ```fish
   brew-nix-fix
   ```

4. **Clean Diagnostics**: Run Homebrew diagnostics without Nix-related warnings

   ```fish
   brew-doctor-nix
   ```

### Nix Configuration

The system's Nix configuration includes special settings in `homebrew-fix.nix` to improve Homebrew compatibility:

- Prevents automatic updates during builds
- Sets recommended environment variables
- Provides helper scripts for common operations

## Environment Variables

| Variable | Value | Description |
|----------|-------|-------------|
| `EDITOR` | `/usr/bin/vim` | Default text editor |
| `VISUAL` | `/usr/bin/vim` | Visual editor |
| `TERM` | `xterm` | Terminal type |
| `LC_ALL` | `en_US.UTF-8` | Locale setting |
| `LANG` | `en_US.UTF-8` | Language setting |
| `PYENV_ROOT` | `$HOME/.pyenv` | Pyenv installation directory |
| `BUN_INSTALL` | `$HOME/Library/Application Support/reflex/bun` | Bun installation directory |

## Path Configuration

The following directories are added to PATH:

- `$HOME/scripts`
- `$HOME/.docker/bin`
- `$PYENV_ROOT/bin`
- `/opt/homebrew/opt/ruby/bin`
- `$BUN_INSTALL/bin`
- `/Users/gz/.lmstudio/bin`
