{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Google Chrome.app"
      "/Applications/Firefox.app"
      "/Applications/Telegram.app"
      "/Applications/Discord.app"
      "/Applications/Slack.app"
      "/Applications/Obsidian.app"
      "/Applications/Spotify.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Codex.app"
      "/Applications/Ghostty.app"
    ];
  };
}
