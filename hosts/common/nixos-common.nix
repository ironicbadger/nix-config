{ pkgs, unstablePkgs, lib, inputs, stateVersion, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  time.timeZone = "America/New_York";
  system.stateVersion = stateVersion;

  # home-manager = {
  #     useGlobalPkgs = true;
  #     useUserPackages = true;
  #     users.alex = import ../../../home/alex.nix;
  # };

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
    # Automate garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5";
    };
  };

  # environment.systemPackages = with pkgs; [
  #   #
  # ];
}