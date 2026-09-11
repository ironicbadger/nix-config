{ lib, ... }:
{
  homebrew.casks = lib.mkAfter [
    "asana"
    "linear"
    "elgato-camera-hub"
    "elgato-stream-deck"
  ];
}
