{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    hashedPassword = "$6$wW/xsljhhG/vssC3$ujh/4jSZp7APUsbI6FAAUtIkaWVl9ElocFV6FKO7vD4ouoXKiebecrfmtd46NNVJBOFO8blNaEvkOLmOW5X3j.";
  };

  networking = {
    hostName = "nixos";
  };

  environment.systemPackages = with pkgs; [
    docker-compose
    git
    htop
    lm_sensors
    mc
    ncdu
    nvme-cli
    tdns-cli
    tmux
    tree
    vim
    wget
  ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
    settings.PermitRootLogin = "yes";
  };
  services.tailscale.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # services = {
  #   xserver = {
  #     enable = true;
  #     displayManager = {
  #       lightdm.enable = true;
  #       defaultSession = "xfce";
  #     };
  #     desktopManager.xfce.enable = true;
  #     windowManager.bspwm.enable = true;
  #   };
  # };

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
  };

  system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

}