{ lib, ... }: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking.hostId = "7f8ded37";
  networking = {
    nameservers = [ "1.1.1.1" ];
    defaultGateway = "172.31.1.1";
    defaultGateway6 = {
      address = "";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv4.addresses = [
          { address="5.161.220.163"; prefixLength=32; }
        ];
        ipv4.routes = [ { address = "172.31.1.1"; prefixLength = 32; } ];
      };

    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:03:c0:e2:ea", NAME="eth0"

  '';
}