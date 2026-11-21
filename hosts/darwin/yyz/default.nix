{ config, lib, ... }:
{
  imports = [ ../../common/darwin-common-dock.nix ];

  # Accessibility > Touch > Ignore Touch Gestures also affects Sidecar.
  system.activationScripts.userDefaults.text = lib.mkAfter ''
    touch_user=${lib.escapeShellArg config.system.primaryUser}
    if ! launchctl asuser "$(id -u "$touch_user")" sudo -u "$touch_user" --set-home \
      /usr/bin/defaults write com.apple.universalaccess SidecarTouchInputDisabled -bool true; then
      echo "warning: could not disable touch gestures; run the rebuild from a terminal with Full Disk Access" >&2
    fi
  '';

  # Use Apple's root defaults command for the PROLED XDR lid logo.
  system.activationScripts.defaults.text = lib.mkAfter ''
    /usr/bin/defaults write com.apple.CoreBrightness LEBacklightMode -int 0
  '';
}
