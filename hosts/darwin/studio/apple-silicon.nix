{ config, pkgs, lib, ... }:

{
  # Apple Silicon (M2) specific optimizations for Mac Studio
  
  # Enable Rosetta 2 for x86_64 compatibility
  system.rosetta.enable = false;
  
  # Configure system for Apple Silicon architecture
  nixpkgs.hostPlatform = "aarch64-darwin";
  
  # Set up binary caches optimized for Apple Silicon
  nix = {
    # Use binary cache for Apple Silicon when available
    settings = {
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
  
  # Optimize power management for M2 chip
  system.defaults.NSGlobalDomain.NSAppSleepDisabled = false;
  
  # Configure GPU acceleration
  environment.variables = {
    # Enable Metal API for GPU acceleration
    MTL_DEBUG_LAYER = "0";
    # Enable hardware acceleration for compatible apps
    METAL_DEVICE_WRAPPER_TYPE = "1";
  };
  
  # Optimize system for M2 Mac Studio hardware
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    echo "Applying M2 Mac Studio optimizations..."
    # Set energy saver preferences for better performance
    pmset -a standbydelay 86400
    # Disable hibernation (improves wake performance)
    pmset -a hibernatemode 0
  '';
}
