{ config, inputs, pkgs, name, ... }:

{
  imports =
    [
      inputs.sops-nix.nixosModules.sops
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

  sops = {
    defaultSopsFile = ./../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    age.keyFile = "/root/.config/sops/age/keys.txt";
  };
  sops.secrets = {
    morphnix-smb-user = { };
    morphnix-smb-pass = { };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nix-nvllama";
  networking.networkmanager.enable = true;
  networking.localCommands = ''
    ip rule add to 10.42.0.0/21 priority 2500 lookup main
  '';

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = false;
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
    ansible
    htop
    inxi
    pciutils
    python3
    tmux
    vim
    wget
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
    #containers.enable = true;
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

#   fileSystems."/mnt/jbod" = {
#     device = "//10.42.1.10/jbod";
#     fsType = "cifs";
#     options = [ "username=abc" "password=123" "x-systemd.automount" "noauto" ];
#   };

  fileSystems."/mnt/jbod" = {
    device = "//10.42.1.10/jbod";
    fsType = "cifs";
    options = [ "username=${config.sops.secrets.morphnix-smb-user.path}" "password=${config.sops.secrets.morphnix-smb-pass.path}" "x-systemd.automount" "noauto" ];
  };

}