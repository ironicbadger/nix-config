{ config, pkgs, lib, ... }:

{
  # System services configuration
  
  # Configure nix-daemon service
  services.nix-daemon.enable = true;
  services.activate-system.enable = true;
  
  # Configure automatic garbage collection for Nix store
  nix.gc = {
    automatic = true;
    interval = { 
      Weekday = 0;  # Sunday
      Hour = 2;     # 2 AM
      Minute = 0;
    };
    options = "--delete-older-than 30d";  # Delete generations older than 30 days
  };
  
  # Configure Nix store optimization
  nix.optimise = {
    automatic = true;
    interval = { 
      Weekday = 0;  # Sunday
      Hour = 3;     # 3 AM
      Minute = 0;
    };
  };
  
  # Enable Nix flakes and other experimental features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Configure Nix build users
  nix.settings.trusted-users = [ "root" "gz" ];
  
  # Increase the number of builders
  nix.settings.max-jobs = lib.mkDefault 8;
  nix.settings.cores = lib.mkDefault 0;  # 0 means use all available cores
}
