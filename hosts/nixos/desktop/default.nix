{ config, lib, pkgs, ... }:
{
  imports =
    [
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
    ];

  ## DEPLOYMENT
  deployment = {
    targetHost = "desktop";
    targetUser = "root";
    buildOnTarget = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/New_York";

  networking = {
    firewall.enable = false;
    hostName = "desktop";
    interfaces = {
      enp2s0 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "10.42.1.15";
          prefixLength = 21;
        } ];
      };
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
  localCommands = ''
    ip rule add to 10.42.0.0/21 priority 2500 lookup main
  '';
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.alex = { imports = [ ./../../../home/alex.nix ]; };
  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "wheel" "docker"];
    packages = with pkgs; [
      home-manager
      steam
    ];
  };

  environment.systemPackages = with pkgs; [
    ansible
    fastfetch
    htop
    inxi
    ripgrep
    colmena
    pciutils
    python3
    tmux
    wget
    vim
  ];

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
  };
  services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
  };
  services.desktopManager.plasma6.enable = true;

  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.powerManagement.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation = {
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

  nixpkgs.config.allowUnfree = true;
  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.tailscale.enable = true;  

#   system.copySystemConfiguration = true;
#   nix = {
#     settings = {
#         experimental-features = [ "nix-command" "flakes" ];
#         warn-dirty = false;
#     };
#     # Automate garbage collection
#     gc = {
#       automatic = true;
#       dates = "weekly";
#       options = "--delete-older-than 5";
#     };
#   };

  system.stateVersion = "24.05"; # Did you read the comment?

}
