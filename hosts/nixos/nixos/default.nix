{ config, pkgs, unstablePkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
      ./../../common/common-packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  users.users.alex = {
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

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = { enable = true; dates = "weekly"; };
    };
  };

  #system.copySystemConfiguration = true;
  system.stateVersion = "23.11";

}