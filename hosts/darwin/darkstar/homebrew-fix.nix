{ config, pkgs, lib, ... }:

{
  # Enhanced Homebrew configuration for better Nix integration
  homebrew = {
    enable = true;
    
    # Prevent automatic updates during builds to avoid Git permission issues
    onActivation = {
      autoUpdate = lib.mkForce false;
      cleanup = "zap";
      upgrade = true;
    };
    
    # Global environment variables to improve Homebrew/Nix coexistence
    global = {
      brewfile = true;
      lockfiles = false;  # Don't create Brewfile.lock.json
    };
  };
  
  # Add Homebrew environment variables to improve Nix compatibility
  environment.variables = {
    HOMEBREW_PREFIX = "/opt/homebrew";
    HOMEBREW_NO_ANALYTICS = "1";
    HOMEBREW_NO_AUTO_UPDATE = "1";
    HOMEBREW_NO_INSTALL_CLEANUP = "1";
  };
  
  # Add a shell script to help manage Homebrew and Nix conflicts
  environment.etc."brew-nix-helper.sh" = {
    text = ''
      #!/bin/bash
      # Helper script for managing Homebrew and Nix interactions
      
      function brew-update-safe() {
        # Safely update Homebrew without Git permission issues
        HOMEBREW_NO_AUTO_UPDATE=1 HOMEBREW_NO_INSTALL_FROM_API=1 brew update
        brew upgrade
        brew cleanup
      }
      
      function brew-doctor-nix() {
        # Run brew doctor while ignoring Nix-related warnings
        HOMEBREW_NO_AUTO_UPDATE=1 brew doctor --verbose | grep -v "nix\|Nix"
      }
    '';
    mode = "0755";
  };
}
