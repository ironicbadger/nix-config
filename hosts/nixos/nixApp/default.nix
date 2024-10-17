{ config, inputs, pkgs, name, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
    ];

  ## DEPLOYMENT
  deployment = {
    targetHost = name;
    targetUser = "root";
    buildOnTarget = true;
    tags = [ "nix-nvllama" ];
  };
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixApp";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  environment.systemPackages = with pkgs; [
    vim
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.qemuGuest.enable = true;
}