{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Firefox.app"
      "/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "/Applications/Signal.app"
      "/Applications/Discord.app"
      "/Applications/Element.app"
      "/Applications/Ivory.app"
      "/Applications/Slack.app"
      "/Applications/Obsidian.app"
      "/Applications/Fantastical.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Spotify.app"
      "/Applications/Plexamp.app"
      "/Applications/iTerm.app"
    ];
  };
}