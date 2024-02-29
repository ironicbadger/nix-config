{ inputs, ... }:
{
  disabledModules = [ "services/x11/desktop-managers/plasma5.nix" ];

  imports = [
    "${inputs.nixpkgs-unstable}/nixos/modules/services/x11/desktop-managers/plasma6.nix"
  ];
}