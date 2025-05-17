{ config, pkgs, ... }:

{
  # Fix for Homebrew Git permission issues on Intel Mac
  homebrew.global = {
    brewPrefix = "/usr/local/bin";  # Intel Mac location
    autoUpdate = false;  # Disable auto-updates to prevent Git access issues
  };
}
