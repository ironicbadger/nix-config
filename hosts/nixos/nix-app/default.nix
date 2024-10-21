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

  time.timeZone = "America/New_York";

  networking = {
    firewall.enable = false;
    hostName = "nixapp";
    interfaces = {
      ens18 = {
        useDHCP = false;
        ipv4.addresses = [ {
          address = "10.42.1.11";
          prefixLength = 21;
        } ];
      };
    };
    defaultGateway = "10.42.0.254";
    nameservers = [ "10.42.0.253" ];
  localCommands = ''
    ip rule add to 10.42.0.0/21 priority 2500 lookup main
  '';
  };

  # networking.firewall.enable = false;
  # networking.hostName = "nixApp";
  # networking.networkmanager.enable = true;
  # networking.localCommands = ''
  #   ip rule add to 10.42.0.0/21 priority 2500 lookup main
  # '';

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.alex = { imports = [ ./../../../home/alex.nix ]; };
  users.users.alex = {
    isNormalUser = true;
    description = "alex";
    extraGroups = [ "wheel" "docker"];
    packages = with pkgs; [
      home-manager
    ];
  };
  users.defaultUserShell = pkgs.bash;
  programs.bash.interactiveShellInit = "echo \"\" \n figurine -f \"3d.flf\" nixApp";

  environment.systemPackages = with pkgs; [
    figurine
  ];

  services.openssh.enable = true;
  services.openssh.settings.PermitRootLogin = "yes";
  services.qemuGuest.enable = true;
  services.tailscale.enable = true;
}