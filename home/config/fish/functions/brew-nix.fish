# Functions to help Homebrew and Nix coexist peacefully

function brew-update-safe --description "Safely update Homebrew without Git permission issues"
    set -lx HOMEBREW_NO_AUTO_UPDATE 1
    set -lx HOMEBREW_NO_INSTALL_FROM_API 1
    echo "🍺 Safely updating Homebrew formulae..."
    brew update
    echo "🍺 Upgrading outdated packages..."
    brew upgrade
    echo "🍺 Cleaning up..."
    brew cleanup
    echo "✅ Homebrew update completed safely!"
end

function brew-doctor-nix --description "Run brew doctor while ignoring Nix-related warnings"
    set -lx HOMEBREW_NO_AUTO_UPDATE 1
    echo "🔍 Running Homebrew doctor (ignoring Nix warnings)..."
    brew doctor --verbose 2>&1 | grep -v "nix\|Nix"
    echo "✅ Homebrew doctor check completed!"
end

function brew-nix-info --description "Show information about Homebrew and Nix installation"
    echo "🍺 Homebrew Information:"
    echo "   Path: "(which brew)
    echo "   Version: "(brew --version | head -1)
    echo "   Prefix: "(brew --prefix)
    echo "   Cellar: "(brew --cellar)
    echo ""
    echo "❄️ Nix Information:"
    echo "   Path: "(which nix 2>/dev/null || echo "   Not found in PATH")
    if type -q nix
        echo "   Version: "(nix --version 2>/dev/null)
        echo "   Store: /nix/store"
    end
    echo ""
    echo "🔍 PATH Analysis:"
    echo "   Homebrew bin in PATH: "(contains -- (brew --prefix)"/bin" $PATH && echo "✅ Yes" || echo "❌ No")
    echo "   Nix bin in PATH: "(contains -- "/nix/var/nix/profiles/default/bin" $PATH && echo "✅ Yes" || echo "❌ No")
    echo ""
    echo "📊 Package Counts:"
    echo "   Homebrew packages: "(brew list | wc -l | string trim)
    if type -q nix-env
        echo "   Nix packages: "(nix-env -q | wc -l | string trim)
    end
end

function brew-nix-fix --description "Fix common Homebrew/Nix integration issues"
    echo "🔧 Fixing Homebrew/Nix integration issues..."
    
    # Fix permissions for Homebrew directories
    echo "📂 Checking Homebrew directory permissions..."
    if test -d (brew --prefix)
        sudo chown -R (whoami) (brew --prefix)/*
        echo "✅ Homebrew directory permissions fixed."
    end
    
    # Ensure Homebrew environment variables are set
    echo "🔧 Setting recommended Homebrew environment variables..."
    set -Ux HOMEBREW_NO_ANALYTICS 1
    set -Ux HOMEBREW_NO_INSTALL_CLEANUP 1
    echo "✅ Environment variables set."
    
    echo "🔄 Run 'brew update-safe' now to safely update Homebrew."
end
