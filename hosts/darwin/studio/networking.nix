{ config, pkgs, lib, ... }:

{
  # Networking configuration
  
  # Set hostname
  networking.hostName = "studio";
  
  # DNS configuration
  # networking.dns = [
  #   "1.1.1.1"  # Cloudflare DNS
  #   "8.8.8.8"  # Google DNS
  # ];
  
  # Enable mDNS for local network discovery
  networking.localHostName = "studio";
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet" ];
  
  # Note: macOS has its own built-in firewall that can be configured through System Preferences
  # The NixOS networking.firewall option is not available in nix-darwin
}
