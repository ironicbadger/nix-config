{ lib, modulesPath, pkgs, stateVersion, ... }:

let
  infra = import ../../../data/proxmox-builder.nix;
  proxmoxTemplate = infra.template;
  goldenTemplate = proxmoxTemplate.golden;
in

{
  imports = [
    (modulesPath + "/virtualisation/proxmox-image.nix")
    ./../../common/nixos-common.nix
  ];

  proxmox = {
    cloudInit = {
      enable = true;
      defaultStorage = proxmoxTemplate.destinationStorage;
    };
    filenameSuffix = "${toString goldenTemplate.vmid}-${goldenTemplate.name}";
    qemuConf = {
      name = goldenTemplate.name;
      boot = "order=virtio0";
      cores = 2;
      memory = 2048;
      net0 = "virtio=00:00:00:00:00:00,bridge=vmbr0,firewall=1";
      virtio0 = "${proxmoxTemplate.destinationStorage}:vm-${toString goldenTemplate.vmid}-disk-0";
    };
  };

  virtualisation.diskSize = 20 * 1024;

  boot.loader.limine = {
    enable = true;
    efiSupport = false;
    biosSupport = true;
    biosDevice = "/dev/vda";
  };

  boot.kernelParams = [
    "console=tty0"
    "console=ttyS0,115200n8"
  ];

  networking = {
    useDHCP = lib.mkDefault true;
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

  nix.settings.trusted-users = [ "alex" ];

  security.sudo.wheelNeedsPassword = false;

  services.cloud-init = {
    enable = true;
    network.enable = true;
    settings = {
      ssh_deletekeys = false;
      ssh_genkeytypes = [ ];
      cloud_final_modules = [
        "rightscale_userdata"
        "scripts-vendor"
        "scripts-per-once"
        "scripts-per-boot"
        "scripts-per-instance"
        "scripts-user"
        "ssh-authkey-fingerprints"
        "phone-home"
        "final-message"
        "power-state-change"
      ];
    };
  };

  users.users.alex = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = infra.breakglass.alexPasswordHash;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/1OeveuCOTtrUkcuQwEzR2w+qY95jstpZYNSJZ0x5e alex@nauvis"
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA/1OeveuCOTtrUkcuQwEzR2w+qY95jstpZYNSJZ0x5e alex@nauvis"
  ];

  environment.systemPackages = with pkgs; [
    btop
    cloud-init
    curl
    git
    htop
    jq
    just
    ripgrep
    tmux
    vim
  ];

  system.stateVersion = stateVersion;
}
