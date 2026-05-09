{ pkgs, ... }:
let
  builder = import ../../../data/proxmox-builder.nix;
  inherit (builder.ssh) publicKey;
in
{
  imports = [
    ./disko.nix
    ./hardware-configuration.nix
    ./../../common/nixos-common.nix
  ];

  boot.loader.grub = {
    enable = true;
    useOSProber = false;
  };

  networking = {
    useDHCP = false;
    usePredictableInterfaceNames = false;
    interfaces.eth0.ipv4.addresses = [
      {
        address = builder.network.address;
        prefixLength = builder.network.prefixLength;
      }
    ];
    defaultGateway = builder.network.gateway;
    nameservers = [ builder.network.nameserver ];
    firewall.allowedTCPPorts = [ 22 ];
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

  nix.settings.trusted-users = [
    "root"
    "alex"
  ];

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [
      "wheel"
      "docker"
    ];
    openssh.authorizedKeys.keys = [ publicKey ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ publicKey ];

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    jq
    just
    nix-output-monitor
    ripgrep
    tmux
    vim
    zstd
  ];
}
