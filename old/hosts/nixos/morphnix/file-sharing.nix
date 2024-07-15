{ config, ... }:
{
  services.samba-wsdd.enable = true; # make shares visible for windows 10 clients
  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = morphnix
      netbios name = morphnix
      security = user
      guest ok = yes
      guest account = nobody
      map to guest = bad user
      load printers = no
    '';
    shares = {
      jbod = {
        path = "/mnt/jbod";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "alex";
        "force group" = "users";
      };
      downloads = {
        path = "/mnt/downloads";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "alex";
        "force group" = "users";
       };
    };
  };
}