{ config, pkgs, ... }:

{
  imports =
    [
      "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/framework/13-inch/7040-amd"
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  services.tailscale.enable = true;

  environment.systemPackages = import ./../../common/common-packages.nix
  {
    pkgs = pkgs; 
    unstablePkgs = unstablePkgs; 
  };

  virtualisation = 
  {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # experimental things are configured in common/nixos-common.nix
  system.stateVersion = "23.11";
}