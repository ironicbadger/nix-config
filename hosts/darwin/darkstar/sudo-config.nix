{ config, pkgs, lib, ... }:

{
  # Add passwordless sudo for user 'gz'
  security.sudo.extraRules = [
    {
      users = [ "gz" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];
}
