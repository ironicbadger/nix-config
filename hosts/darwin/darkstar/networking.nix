{ config, pkgs, lib, ... }:

{
  # Networking configuration
  
  # Set hostname
  networking.hostName = "darkstar";
  
  # DNS configuration
  networking.dns = [
    "1.1.1.1"  # Cloudflare DNS
    "8.8.8.8"  # Google DNS
  ];
  
  # Enable mDNS for local network discovery
  networking.localHostName = "darkstar";
  networking.knownNetworkServices = [ "Wi-Fi" "Ethernet" ];
  
  # Firewall configuration
  networking.firewall = {
    enable = true;
    allowPing = true;
    # Add specific allowed incoming connections if needed
    # allowedTCPPorts = [ 22 80 443 ];
    # allowedUDPPorts = [ 53 ];
  };
}
