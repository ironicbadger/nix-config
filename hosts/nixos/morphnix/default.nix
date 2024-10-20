{ config, inputs, pkgs, name, ... }:
{
  imports = [
      ./hardware-configuration.nix
      (builtins.fetchTarball {
        url = "https://github.com/nix-community/nixos-vscode-server/tarball/master";
        sha256 = "1rq8mrlmbzpcbv9ys0x88alw30ks70jlmvnfr2j8v830yy5wvw7h";
      })
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
    ];

  ## DEPLOYMENT
  deployment = {
    targetHost = name;
    targetUser = "root";
    buildOnTarget = true;
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "drivetemp" ];
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.kernelParams = ["i915.fastboot=1"];

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "nvme-appdata" "ssd4tb" "bigrust18" ];
  services.zfs.autoScrub.enable = true;

  time.timeZone = "America/New_York";

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  #home-manager.backupFileExtension = "bak";
  home-manager.users.alex = { imports = [ ./../../../home/alex.nix ]; };
  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    packages = with pkgs; [
      home-manager
    ];
  };
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "echo \"\" \n figurine -f \"3d.flf\" morphnix";

  environment.systemPackages = with pkgs; [
    ansible
    bc
    devbox
    dig
    e2fsprogs # badblocks
    figurine
    git
    gptfdisk
    hddtemp
    htop
    intel-gpu-tools
    inxi
    iotop
    jq
    lm_sensors
    mc
    mergerfs
    molly-guard
    ncdu
    nmap
    nvme-cli
    powertop
    python3
    smartmontools
    snapraid
    tmux
    tree
    vim
    wget
    xfsprogs

    # zfs send/rec with sanoid/syncoid
    sanoid
    lzop
    mbuffer
    pv
    zstd
  ];

  networking = {
    firewall.enable = false;
    hostName = "morphnix";
    interfaces = {
      enp13s0 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "10.42.1.10";
          prefixLength = 20;
        } ];
      };
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
  localCommands = ''
    ip rule add to 10.42.0.0/20 priority 2500 lookup main
  '';
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

  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.openssh.enable = true;
  services.tailscale.enable = true;

  services.sanoid = {
    enable = true;
    interval = "hourly";
    # backupmedia
    templates.backupmedia = {
      daily = 3;
      monthly = 3;
      autoprune = true;
      autosnap = true;
    };
    datasets."bigrust18/media" = {
      useTemplate = [ "backupmedia" ];
      recursive = true;
    };
    extraArgs = [ "--debug" ];
  };

  services.syncoid = {
    enable = true;
    user = "root";
    interval = "hourly";
    commands = {
      "bigrust18/media" = {
        target = "root@deepthought:bigrust20/media";
        extraArgs = [ "--sshoption=StrictHostKeyChecking=off" ];
        recursive = true;
      };
    };
    commonArgs = [ "--debug"];
  };

  services.vscode-server.enable = true;

  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = morphnix
      netbios name = morphnix
      security = user
      guest ok = yes
      guest account = nobody
      map to guest = bad user
      load printers = no
    '';
    shares = let
      mkShare = path: {
        path = path;
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "alex";
        "force group" = "users";
      };
    in {
      jbod = mkShare "/mnt/jbod";
      bigrust18 = mkShare "/mnt/bigrust18";
      downloads = mkShare "/mnt/downloads";
    };
  };

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
  };
}