{ pkgs, unstablePkgs, lib, inputs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  time.timeZone = "America/New_York";

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };
  nix.distributedBuilds = true;
  # Speeds things up by downloading dependencies remotely:
  nix.extraOptions = ''
    builders-use-substitutes = true
  '';

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-24.8.6"
  ];

  environment.systemPackages = with pkgs; [
    # intel-gpu-tools
    # libva-utils
    # intel-media-driver
    # jellyfin-ffmpeg
    # hddtemp
    # synergy
  ];

  ## pins to stable as unstable updates very often
  # nix.registry.nixpkgs.flake = inputs.nixpkgs;
  # nix.registry = {
  #   n.to = {
  #     type = "path";
  #     path = inputs.nixpkgs;
  #   };
  #   u.to = {
  #     type = "path";
  #     path = inputs.nixpkgs-unstable;
  #   };
  # };
}