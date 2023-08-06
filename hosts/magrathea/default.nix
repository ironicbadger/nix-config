{ config, pkgs, unstablePkgs, ... }:

{
  environment.systemPackages = import ./../../common-packages.nix 
    {
      pkgs = pkgs; 
      unstablePkgs = unstablePkgs; 
    };
}