{ pkgs, lib, ... }:
{
  # Nix configuration ------------------------------------------------------------------------------

  nix.binaryCaches = [
    "https://cache.nixos.org/"
  ];
  nix.binaryCachePublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.trustedUsers = [
    "@admin"
  ];
  users.nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
#   nix.extraOptions = ''
#     auto-optimise-store = true
#     experimental-features = nix-command flakes
#   '' + lib.optionalString (pkgs.system == "aarch64-darwin") ''
#     extra-platforms = x86_64-darwin aarch64-darwin
#   '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    #kitty
    terminal-notifier
  ];

  # https://github.com/nix-community/home-manager/issues/423
#   environment.variables = {
#     TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
#   };
  programs.nix-index.enable = true;

  # Fonts
  fonts.enableFontDir = true;
  fonts.fonts = with pkgs; [
     recursive
     (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
   ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

}