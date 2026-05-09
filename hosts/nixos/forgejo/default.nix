{ lib, pkgs, stateVersion, ... }:

let
  infra = import ../../../data/proxmox-builder.nix;
  vms = import ../../../data/vms.nix;
  vm = vms.vms.forgejo;
  publicKey = infra.ssh.publicKey;
  hostName = "forgejo";
  domain = "git.home.ktz.me";
  httpPort = 3000;
  sshPort = 2222;
  ipv4Address = "10.42.1.101";
  ipv4PrefixLength = 21;
  ipv4Gateway = "10.42.0.254";
in
{
  imports = [
    ./../../common/nixos-common.nix
  ];

  boot = {
    growPartition = true;
    initrd.availableKernelModules = [
      "ata_piix"
      "sr_mod"
      "uas"
      "uhci_hcd"
      "usbhid"
      "virtio_blk"
      "virtio_pci"
      "xhci_pci"
    ];
    kernelParams = [
      "console=tty0"
      "console=ttyS0,115200n8"
    ];
    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    autoResize = true;
    fsType = "ext4";
  };

  networking = {
    hostName = hostName;
    useDHCP = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = ipv4Address;
        prefixLength = ipv4PrefixLength;
      }
    ];
    defaultGateway = ipv4Gateway;
    nameservers = [ infra.network.nameserver ];
    firewall.allowedTCPPorts = [
      22
      httpPort
      sshPort
    ];
  };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  services.qemuGuest.enable = true;
  services.fstrim.enable = true;
  services.tailscale.enable = true;

  nix.settings.trusted-users = [ "alex" ];

  security.sudo.wheelNeedsPassword = false;

  services.postgresql.package = pkgs.postgresql_17;

  services.forgejo = {
    enable = true;
    package = pkgs.forgejo;
    lfs.enable = true;

    database = {
      type = "postgres";
      name = "forgejo";
      user = "forgejo";
      createDatabase = true;
    };

    settings = {
      DEFAULT = {
        APP_NAME = "Forgejo";
      };

      server = {
        DOMAIN = domain;
        ROOT_URL = "http://${domain}:${toString httpPort}/";
        HTTP_PORT = httpPort;
        SSH_DOMAIN = domain;
        SSH_PORT = sshPort;
        START_SSH_SERVER = true;
        SSH_LISTEN_PORT = sshPort;
        BUILTIN_SSH_SERVER_USER = "forgejo";
        DISABLE_SSH = false;
      };

      service = {
        DISABLE_REGISTRATION = true;
        REQUIRE_SIGNIN_VIEW = false;
      };

      openid = {
        ENABLE_OPENID_SIGNUP = false;
      };
    };
  };

  virtualisation.docker = {
    enable = lib.mkForce false;
    autoPrune.enable = lib.mkForce false;
  };

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "wheel" ];
    hashedPassword = infra.breakglass.alexPasswordHash;
    openssh.authorizedKeys.keys = [ publicKey ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ publicKey ];

  environment.systemPackages = with pkgs; [
    btop
    curl
    git
    htop
    jq
    nix-output-monitor
    postgresql
    ripgrep
    tmux
    vim
  ];

  system.stateVersion = stateVersion;

  system.nixos.tags = [
    "forgejo"
    "vmid-${toString vm.vmid}"
  ];
}
