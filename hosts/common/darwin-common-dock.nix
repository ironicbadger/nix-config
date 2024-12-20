{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Safari.app"
      "/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "/Applications/Signal.app"
      "/Applications/Discord.app"
      "/Applications/Slack.app"
      "/Applications/Ivory.app"
      "/Applications/Obsidian.app"
      "/Applications/Fantastical.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Spotify.app"
      "/Applications/Plexamp.app"
      "/Applications/Ghostty.app"
      "/Applications/iTerm.app"
    ];
  };
}