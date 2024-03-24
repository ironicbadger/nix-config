{ config, pkgs, unstablePkgs, customArgs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      ./../../common/common-packages.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
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