{ config, pkgs, lib, ... }:

{
  # Fix for Homebrew Git permission issues on Intel Mac
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = lib.mkForce false;  # Override the common configuration
      cleanup = "zap";
    };
  };
}
