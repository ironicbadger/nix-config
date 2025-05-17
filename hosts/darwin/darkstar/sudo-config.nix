{ config, pkgs, lib, ... }:

{
  # Add passwordless sudo for user 'gz'
  environment.etc."sudoers.d/10-gz-nopasswd" = {
    text = "gz ALL=(ALL) NOPASSWD: ALL";
    mode = "0440";
  };
}
