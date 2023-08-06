# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, unstablePkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  #boot.supportedFilesystems = [ "zfs" ];
  #boot.zfs.forceImportRoot = false;
  #boot.zfs.extraPools = [ "zfstest" ];
  #services.zfs.autoScrub.enable = true;

  time.timeZone = "America/New_York";

  users.users.alex = 
  {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    hashedPassword = "$6$wW/xsljhhG/vssC3$ujh/4jSZp7APUsbI6FAAUtIkaWVl9ElocFV6FKO7vD4ouoXKiebecrfmtd46NNVJBOFO8blNaEvkOLmOW5X3j.";
  };
  users.users.alex.openssh.authorizedKeys.keyFiles = [
    ./../../authorized_keys
  ];
  users.users.root.openssh.authorizedKeys.keyFiles = [
    ./../../authorized_keys
  ];

  services.openssh = 
  {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.PermitRootLogin = "yes";
  };
  services.vscode-server.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = import ./../../common/common-packages.nix
  { #what is this?
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

  # services = {
  #   xserver = {
  #     enable = true;
  #     displayManager = {
  #       lightdm.enable = true;
  #       defaultSession = "xfce";
  #       #defaultSession = "xfce+bspwm";
  #     };
  #     desktopManager.xfce.enable = true;
  #     windowManager.bspwm.enable = true;
  #   };
  # };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  networking = 
  {
    firewall.enable = false;
    hostName = "testnix";
    hostId = "e5f2dc02";
    interfaces = {
      enp1s0 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "10.42.0.50";
          prefixLength = 20;
        } ];
      };
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
  };

  #system.copySystemConfiguration = true;
  system.stateVersion = "23.05";

}