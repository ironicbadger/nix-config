{ config, pkgs, lib, ... }:

{
  # Enable Fish shell at the system level
  programs.fish.enable = true;
  
  # Set Fish as the default shell for the gz user
  users.users.gz.shell = pkgs.fish;
  users.users.test.shell = pkgs.fish;
  
  # Ensure Fish is available in /etc/shells
  environment.shells = [ pkgs.bash pkgs.zsh pkgs.fish ];
}
