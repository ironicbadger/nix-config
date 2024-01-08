{ config, pkgs, unstablePkgs, stablePkgs, ... }:

{
  environment.systemPackages = import ./../../common/common-packages.nix
    {
      # pkgs = pkgs;
      unstablePkgs = unstablePkgs;
      stablePkgs = stablePkgs;
    };
}
