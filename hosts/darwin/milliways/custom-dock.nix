{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Google Chrome.app"
      "/Applications/Firefox.app"
      "/Applications/Telegram.app"
      "/Applications/Signal.app"
      "/Applications/Discord.app"
      "/Applications/Spotify.app"
      "/Applications/Obsidian.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/ChatGPT.app"
      "/Applications/Asana.app"
      "/Applications/Linear.app"
      "/Applications/Roam.app"
      "/Applications/Ghostty.app"
    ];
  };
}
