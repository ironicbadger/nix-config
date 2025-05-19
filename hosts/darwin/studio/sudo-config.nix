{ config, pkgs, lib, ... }:

{
  # Add passwordless sudo for user 'gz'
  # Note: We need to use a different approach for nix-darwin
  # This will create a file in /etc/sudoers.d/ during activation
  system.activationScripts.extraActivation.text = ''
    echo "Creating sudo configuration for passwordless access..."
    echo "gz ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/10-gz-nopasswd
    sudo chmod 0440 /etc/sudoers.d/10-gz-nopasswd
  '';
}
