{ config, pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = import ./../../common/common-packages.nix
    {
      pkgs = pkgs; 
      unstablePkgs = unstablePkgs; 
    };
}