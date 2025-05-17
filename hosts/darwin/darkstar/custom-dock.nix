{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Launchpad.app"
      "/Applications/Safari.app"
      "/Applications/Pro Tools.app"
      "/Applications/System Settings.app"
      "/Applications/Notes.app"
      "/Applications/iTerm.app"
      "/Applications/Utilities/Activity Monitor.app"
      "/Applications/ID.app"
    ];
  };
}
