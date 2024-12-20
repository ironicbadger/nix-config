{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Firefox.app"
      "/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "/Applications/Obsidian.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/OBS.app"
      "/Applications/Ghostty.app"
      "/Applications/iTerm.app"
    ];
  };
}