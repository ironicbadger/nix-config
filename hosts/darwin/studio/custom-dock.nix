{ config, lib, pkgs, ... }:

{
  system.defaults.dock = {
    autohide = true;
    mru-spaces = false;
    minimize-to-application = true;
    show-recents = false;
    static-only = false;
    tilesize = 48;
  };

  # Dock items for studio machine based on current configuration
  local.dock.enable = true;
  local.dock.entries = [
    # System applications
    { path = "/System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/"; }
    { path = "/Volumes/Storage/Apps/Telegram.app/"; }
    { path = "/Applications/Pro Tools.app/"; }
    { path = "/Applications/iZotope RX 10 Audio Editor.app/"; }
    { path = "/Volumes/Storage/AudioApps/Samply.app/"; }
    { path = "/System/Applications/System Settings.app/"; }
    { path = "/System/Applications/Notes.app/"; }
    { path = "/Applications/iTerm.app/"; }
    { path = "/Applications/Fireface Settings.app/"; }
    { path = "/Applications/Totalmix.app/"; }
    { path = "/Applications/Tempomate.app/"; }
    { path = "/Applications/Guitar Pro 8.app/"; }
    { path = "/Applications/Downie 4.app/"; }
    { path = "/System/Applications/Reminders.app/"; }
    { path = "/System/Applications/Mail.app/"; }
    { path = "/Applications/Pages.app/"; }
    { path = "/Applications/ForkLift.app/"; }
    { path = "/Applications/Trello.app/"; }
    { path = "/Applications/Windsurf.app/"; }
    { path = "/Applications/Perplexity.app/"; }
    { path = "/Volumes/Storage/AudioApps/XLD.app/"; }
    { path = "/Applications/Ultimate Vocal Remover.app/"; }
    { path = "/Applications/Line6/POD HD Pro Edit.app/"; }
    { path = "/Applications/Void.app/"; }
  ];
}
