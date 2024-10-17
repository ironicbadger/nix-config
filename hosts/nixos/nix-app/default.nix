{ config, inputs, pkgs, name, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./../../common/nixos-common.nix
    ];

  ## DEPLOYMENT
  deployment = {
    targetHost = "nixapp";
    targetUser = "root";
    buildOnTarget = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixApp";
  networking.networkmanager.enable = true;
  networking.localCommands = ''
    ip rule add to 10.42.0.0/21 priority 2500 lookup main
  '';
  time.timeZone = "America/New_York";

  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "figurine -f \"3d.flf\" nixApp";

  environment.systemPackages = with pkgs; [
    figurine
    vim
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;
}