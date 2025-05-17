{ pkgs ? import <nixpkgs> {} }:

{
  custom-apps = pkgs.callPackage ./custom-apps.nix {};
}
