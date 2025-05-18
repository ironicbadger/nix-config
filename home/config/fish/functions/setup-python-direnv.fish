# Function to set up direnv for Python projects
function setup-python-direnv --description "Set up direnv for Python projects"
    set -l template_path "$HOME/.config/direnv/python_venv_template.envrc"
    set -l nix_template_path "$HOME/.config/direnv/python_nix_template.envrc"
    
    # Check if templates exist
    if not test -f $template_path; or not test -f $nix_template_path
        echo "Error: Template files not found. Setting up templates..."
        mkdir -p $HOME/.config/direnv
        
        # Create basic Python venv template
        echo "# Python virtual environment auto-activation with direnv
# Place this file as .envrc in your Python project directories

# Check if .venv directory exists, if not create it
if [ ! -d \".venv\" ]; then
    echo \"Creating virtual environment in .venv directory...\"
    python -m venv .venv
fi

# Activate the virtual environment
source .venv/bin/activate

# Export PATH to include the virtual environment's bin directory
PATH_add .venv/bin

# Notify user
echo \"Python virtual environment activated. Use 'pip install' to install packages.\"" > $template_path
        
        # Create advanced Python+Nix template
        echo "# Advanced Python development environment with direnv
# This template supports both Python venvs and Nix development environments
# Place this file as .envrc in your Python project directories

# Check if we're using a Nix environment (shell.nix or flake.nix exists)
if [ -f \"shell.nix\" ] || [ -f \"flake.nix\" ]; then
    echo \"Nix environment detected, using use_nix\"
    use_nix
elif [ -f \"default.nix\" ]; then
    echo \"Nix environment detected, using use_nix\"
    use_nix
else
    # If no Nix environment, use Python venv
    # Check if .venv directory exists, if not create it
    if [ ! -d \".venv\" ]; then
        echo \"Creating Python virtual environment in .venv directory...\"
        python -m venv .venv
    fi

    # Activate the virtual environment
    source .venv/bin/activate

    # Export PATH to include the virtual environment's bin directory
    PATH_add .venv/bin

    echo \"Python virtual environment activated. Use 'pip install' to install packages.\"
fi

# Add any project-specific environment variables below
# export PYTHONPATH=\$PWD:\$PYTHONPATH
# export FLASK_APP=app.py
# export FLASK_ENV=development" > $nix_template_path
        
        echo "Template files created."
    end
    
    # Check if .envrc already exists
    if test -f .envrc
        echo "Warning: .envrc already exists in this directory."
        echo "Do you want to overwrite it? (y/N)"
        read -l confirm
        
        if test "$confirm" != "y" -a "$confirm" != "Y"
            echo "Operation cancelled."
            return 1
        end
    end
    
    # Ask which template to use
    echo "Which template would you like to use?"
    echo "1) Basic Python venv template"
    echo "2) Advanced Python+Nix template"
    read -l choice
    
    switch $choice
        case 1
            cp $template_path .envrc
            echo "Basic Python venv template copied to .envrc"
        case 2
            cp $nix_template_path .envrc
            echo "Advanced Python+Nix template copied to .envrc"
        case '*'
            echo "Invalid choice. Operation cancelled."
            return 1
    end
    
    # Allow direnv
    direnv allow
    
    echo "direnv setup complete. The Python environment will be activated automatically when you enter this directory."
end
