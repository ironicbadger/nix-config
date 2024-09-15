{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-nvllama";
  networking.networkmanager.enable = true;
  networking.localCommands = ''
    ip rule add to 10.42.0.0/20 priority 2500 lookup main
  '';

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

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

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # List services that you want to enable:
  services.openssh.enable = true;
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;

  virtualisation = {
    containers.enable = true;
    docker = {
      enable = true;
      package = pkgs.docker_27;
      #enableNvidia = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  fileSystems."/mnt/jbod" = {
    device = "//10.42.1.10/jbod";
    fsType = "cifs";
    options = [ "username=alex" "password=awdpign23" "x-systemd.automount" "noauto" ];
  };

  system.stateVersion = "23.11"; # Did you read the comment?

}