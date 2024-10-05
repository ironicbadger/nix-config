{ config, pkgs, modulesPath, ... }: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect
    ../../common/nixos-config.nix
  ];

  boot.tmp.cleanOnBoot = true;
  boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.extraPools = [ "ktz-cloud" ];
  services.zfs.autoScrub.enable = true;
  zramSwap.enable = true;

  networking.hostName = "ktz-cloud-nix";
  networking.domain = "";

  users.users.root.openssh.authorizedKeys.keys = [''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM7aI+bMjxTx7L9FRzJlk4UFCyYPzHs9Xs+vAhvPEYtk'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILkK1tv8BNtQJFt+n5yOJf6TQ/Ms9WkRi56MpyZOlWIk'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA2bSgQvelWzGLh4v1nv+OYx8YNijAikvVq4E9qXDWYN'' ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+F3XpAIh4l8GfPgwoTqWQj0OdZRnnG9Ak4Z0wu0Upj'' ];
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "figurine -f \"3d.flf\" ktz-cloud-nix";

  environment.systemPackages = with pkgs; [
    htop
    tmux
    inxi
    figurine
    vim
    wget
    pciutils
    ansible
    python3
  ];

  services.tailscale.enable = true;
  services.tailscale.useRoutingFeatures = "server";


}