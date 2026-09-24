{ lib, ... }:
{
  homebrew.casks = lib.mkAfter [
    "displaylink"
    "elgato-camera-hub"
    "elgato-stream-deck"
  ];
}
