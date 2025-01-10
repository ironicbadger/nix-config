{ config, inputs, pkgs, name, ... }:

{
  imports =
    [
      inputs.sops-nix.nixosModules.sops
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
      ./../../common/common-packages.nix
      #./beszel.nix
      ./../../../modules/beszel-agent.nix
    ];

  ## DEPLOYMENT
  deployment = {
    targetHost = name;
    targetUser = "root";
    buildOnTarget = true;
    allowLocalDeployment = true;
    tags = [ "nix-nvllama" ];
  };

  # Secrets management configuration
  sops = {
    defaultSopsFile = ./../../../secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/root/.config/sops/age/keys.txt";
    };
    secrets = {
      morphnix-smb-user = { };
      morphnix-smb-pass = { };
    };
  };

  # Boot configuration
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  # Network configuration
  networking = {
    firewall.enable = false;
    hostName = "nix-nvllama";
    interfaces.ens18 = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "10.42.1.12";
        prefixLength = 21;
      }];
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
    # Add custom routing rule for local network
    localCommands = ''
      ip rule add to 10.42.0.0/21 priority 2500 lookup main
    '';
  };

  # System localization
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.beszel-agent = {
    enable = true;
    #groups = ["beszel" "video"];
    gpu = true;
  };

  services.xserver = {
    enable = false;
    videoDrivers = [ "nvidia" ];
  };

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [ home-manager ];
  };

  # System packages configuration
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ansible
    colmena
    htop
    inxi
    just
    ripgrep
    pciutils
    python3
    tmux
    wget
  ];

  # Hardware configuration
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      modesetting.enable = true;
      open = false;
      nvidiaSettings = true;
      powerManagement.enable = true;
    };
    nvidia-container-toolkit.enable = true;
  };

  # Virtualisation configuration
  virtualisation.docker = {
    enable = true;
    autoPrune = {
      enable = true;
      dates = "weekly";
    };
  };

  # Filesystem mounts
  fileSystems."/mnt/jbod" = {
    device = "//10.42.1.10/jbod";
    fsType = "cifs";
    options = [
      "username=${config.sops.secrets.morphnix-smb-user.path}"
      "password=${config.sops.secrets.morphnix-smb-pass.path}"
      "x-systemd.automount"
      "noauto"
    ];
  };

}
