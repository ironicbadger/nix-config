{ config, pkgs, lib, ... }:

{
  # Script to uninstall Transmit app
  system.activationScripts.uninstallTransmit.text = ''
    echo "Checking if Transmit is installed..."
    if [ -d "/Applications/Transmit.app" ]; then
      echo "Uninstalling Transmit..."
      rm -rf "/Applications/Transmit.app"
      echo "Transmit has been uninstalled."
    else
      echo "Transmit is not installed."
    fi
  '';
}
