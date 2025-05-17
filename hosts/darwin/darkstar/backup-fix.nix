{ config, pkgs, lib, ... }:

{
  # Configure Home Manager to back up existing files
  home-manager.backupFileExtension = "backup";
}
