{ config, pkgs, ... }:
{
  imports = [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "drivetemp" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernelParams = ["i915.fastboot=1" "drm.edid_firmware=edid/1280x1024.bin"];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "nvme-appdata" "ssd4tb" "bigrust18" ];
  services.zfs.autoScrub.enable = true;

  time.timeZone = "America/New_York";

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
  };
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "figurine -f \"3d.flf\" morphnix";

  environment.systemPackages = with pkgs; [
    devbox
    gcc
    dig
    figurine
    git
    gptfdisk
    htop
    hddtemp
    intel-gpu-tools
    inxi
    iotop
    lm_sensors
    mergerfs
    mc
    ncdu
    nmap
    nvme-cli
    snapraid
    tdns-cli
    tmux
    tree
    vim
    wget
    xfsprogs
    smartmontools
    e2fsprogs # badblocks

    # sanoid
    sanoid
    lzop
    mbuffer

    # ansible
    (python3.withPackages(ps: [
         ps.ansible ps.pip ps.requests
         ]))
  ];

  networking = {
    firewall.enable = false;
    hostName = "morphnix";
    interfaces = {
      eno1 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "10.42.1.10";
          prefixLength = 20;
        } ];
      };
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
  };

  services.fwupd.enable = true;
  services.openssh = {
    enable = true;
    # just for testing, do not panic.
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

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
  };
  system.copySystemConfiguration = true;
  system.stateVersion = "23.11";
}
