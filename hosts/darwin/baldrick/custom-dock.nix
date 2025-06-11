{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "/Applications/Slack.app"
      "/Applications/Obsidian.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/OBS.app"
      "/Applications/Ghostty.app"
    ];
  };
}