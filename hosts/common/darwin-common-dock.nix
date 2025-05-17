{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Safari.app"
      "/Applications/Telegram.app"
      "/Applications/Pro Tools.app"
      "/Applications/Samply.app"
    ];
  };
}
