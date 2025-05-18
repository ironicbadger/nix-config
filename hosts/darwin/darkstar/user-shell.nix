{ config, pkgs, lib, ... }:

{
  # Set Fish as the default shell for the gz user
  users.users.gz.shell = pkgs.fish;
  
  # Ensure Fish is available in /etc/shells
  environment.shells = [ pkgs.bash pkgs.zsh pkgs.fish ];
}
