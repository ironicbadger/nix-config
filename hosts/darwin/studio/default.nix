{ config, pkgs, ... }:

{
  imports = [
    ./custom-dock.nix
    ./packages.nix
  ];

  # Add any studio-specific configuration here
  networking.hostName = "studio";
}
