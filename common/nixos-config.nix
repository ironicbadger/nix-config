{
  config,
  pkgs,
  name,
  ...
}:

{
  time.timeZone = "America/New_York";
  system.stateVersion = "23.11";

  services.openssh.enable = true;

  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  nix = {
    settings = {
        experimental-features = [ "nix-command" "flakes" ];
        warn-dirty = false;
    };
  };

  ## DEPLOYMENT
  deployment.targetHost = name;
  deployment = {
    targetUser = "root";
    buildOnTarget = true;
  };
}
