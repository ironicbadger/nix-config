# modules/beszel-agent.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.beszel-agent;
in {
  options.services.beszel-agent = {
    enable = mkEnableOption "Beszel agent service";

    package = mkOption {
      type = types.package;
      default = pkgs.beszel;
      description = "The beszel package to use.";
    };

    port = mkOption {
      type = types.port;
      default = 45876;
      description = "Port number for the beszel agent to listen on.";
    };

    key = mkOption {
      type = types.str;
      default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFIkr64nTWbuhU7l+VrLO7lPDRgh2LVqTtrIberNge1j";
      description = "SSH key for the beszel agent.";
    };

    extraFilesystems = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "List of additional filesystems to monitor.";
    };

    user = mkOption {
      type = types.str;
      default = "beszel";
      description = "User account under which the service runs.";
    };

    group = mkOption {
      type = types.str;
      default = "beszel";
      description = "Group under which the service runs.";
    };

    restartSec = mkOption {
      type = types.int;
      default = 5;
      description = "Time to wait before restarting the service.";
    };
  };

  config = mkIf cfg.enable {
    users.users.${cfg.user} = {
      isSystemUser = true;
      group = cfg.group;
      description = "Beszel Agent service user";
    };

    users.groups.${cfg.group} = {};

    systemd.services.beszel-agent = {
      description = "Beszel Agent Service";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Environment = [
          "PORT=${toString cfg.port}"
          "KEY=${cfg.key}"
          "EXTRA_FILESYSTEMS=${concatStringsSep "," cfg.extraFilesystems}"
        ];
        ExecStart = "/run/current-system/sw/bin/beszel-agent";
        User = cfg.user;
        Group = cfg.group;
        Restart = "always";
        RestartSec = cfg.restartSec;
      };
    };
  };
}