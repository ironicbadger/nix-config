{ config, pkgs, unstablePkgs, customArgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  #boot.zfs.extraPools = [ "zfstest" ];
  services.zfs.autoScrub.enable = true;

  time.timeZone = "America/New_York";

  users.groups.${customArgs.username} = {};
  users.users.${customArgs.username} = {
    group = customArgs.username;
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.vscode-server.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = import ./../../common/common-packages.nix {
    pkgs = pkgs;
    unstablePkgs = unstablePkgs;
  };

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  system.stateVersion = "23.11";
}