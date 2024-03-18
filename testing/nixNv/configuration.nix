{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixNv";
  networking.networkmanager.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    layout = "us";
    xkbVariant = "";
    videoDrivers = [ "nvidia" ];
  };

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
  };

  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    htop
    tmux
    inxi
    vim
    wget
    pciutils

    # ansible
    (python3.withPackages(ps: [
         ps.ansible ps.pip ps.requests
         ]))
  ];

  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.powerManagement.enable = true;

  # List services that you want to enable:
  services.openssh.enable = true;
  services.qemuGuest.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      enableNvidia = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}