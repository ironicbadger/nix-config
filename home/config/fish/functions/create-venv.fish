# Function to create and activate a Python virtual environment
function create-venv --description "Create and activate a Python virtual environment"
    set -l venv_dir ".venv"
    set -l requirements_file "requirements.txt"
    
    # Parse arguments
    argparse 'n/name=' 'r/requirements' 'h/help' -- $argv
    or return 1
    
    # Display help if requested
    if set -q _flag_help
        echo "Usage: create-venv [OPTIONS]"
        echo ""
        echo "Create and activate a Python virtual environment in the current directory"
        echo ""
        echo "Options:"
        echo "  -n, --name NAME          Specify a custom name for the virtual environment (default: .venv)"
        echo "  -r, --requirements       Install packages from requirements.txt if it exists"
        echo "  -h, --help               Show this help message"
        return 0
    end
    
    # Use custom name if provided
    if set -q _flag_name
        set venv_dir $_flag_name
    end
    
    # Check if venv directory already exists
    if test -d $venv_dir
        echo "Virtual environment '$venv_dir' already exists."
        echo "Do you want to activate it? (y/N)"
        read -l confirm
        
        if test "$confirm" = "y" -o "$confirm" = "Y"
            source $venv_dir/bin/activate.fish
            echo "Virtual environment '$venv_dir' activated."
            return 0
        else
            echo "Operation cancelled."
            return 1
        end
    end
    
    # Create the virtual environment
    echo "Creating virtual environment in '$venv_dir' directory..."
    python -m venv $venv_dir
    
    # Check if creation was successful
    if test $status -ne 0
        echo "Error: Failed to create virtual environment."
        return 1
    end
    
    # Activate the virtual environment
    source $venv_dir/bin/activate.fish
    
    # Install requirements if flag is set and file exists
    if set -q _flag_requirements; and test -f $requirements_file
        echo "Installing packages from $requirements_file..."
        pip install -r $requirements_file
    end
    
    # Notify user
    echo "Python virtual environment '$venv_dir' created and activated."
    echo "Use 'pip install' to install packages."
    echo "To deactivate, run 'deactivate'."
    
    # Add venv directory to .gitignore if it doesn't already exist
    if test -d .git; and not grep -q "^$venv_dir/$" .gitignore 2>/dev/null
        echo "Adding $venv_dir to .gitignore..."
        echo "$venv_dir/" >> .gitignore
    end
end
