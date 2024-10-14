{ config, ... }:
{
  system.defaults.dock = {
    persistent-apps = [
      "/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "/Applications/Discord.app"
      "/Applications/Visual Studio Code.app"
      "/Applications/Alacritty.app"
    ];
  };
}