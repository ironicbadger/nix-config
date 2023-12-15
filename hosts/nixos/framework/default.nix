{ config, pkgs, unstablePkgs, nixos-hardware, ... }:

{
  imports =
    [
    #   "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/framework/13-inch/7040-amd"
      #nixos-hardware.nixosModules.framework-13-7040-amd
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "docker"];
    packages = with pkgs; [
      gnome.gnome-boxes
      audacity
      bitwarden-cli
      firefox
      virt-manager
      kate
      quickemu
      quickgui
      telegram-desktop
    ];
  };

  services.fwupd.enable = true;
  services.tailscale.enable = true;
  services.flatpak.enable = true;

  environment.systemPackages = import ./../../common/common-packages.nix
  {
    pkgs = pkgs; 
    unstablePkgs = unstablePkgs;
  };


  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;
  ## enable printer auto discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };

  services.xserver.enable = true;
  # Enable the KDE Plasma Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  virtualisation.libvirtd.enable = true;
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

  # KDE apps
  programs.partition-manager.enable = true;
  programs.kdeconnect.enable = true;

  # experimental things are configured in common/nixos-common.nix
  system.stateVersion = "23.11";
}
