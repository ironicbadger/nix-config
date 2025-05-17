{ ... }:
{
  imports = [
    ./backup-fix.nix
    ./homebrew-fix.nix
    ./custom-dock.nix
    ./sudo-config.nix
    ./system-preferences.nix
    ./networking.nix
    ./system-services.nix
    ./shell-environment.nix
    ./uninstall-transmit.nix
  ];
}
