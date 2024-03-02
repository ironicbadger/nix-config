{ inputs, unstablePkgs, ... }:
{
  disabledModules = [ "services/x11/desktop-managers/plasma5.nix" ];

  imports = [
    "${unstablePkgs}/nixos/modules/services/x11/desktop-managers/plasma6.nix"
  ];
}