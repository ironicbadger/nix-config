{ pkgs, unstablePkgs, ... }:

with pkgs; [
  ## unstable
  unstablePkgs.yt-dlp

  ## stable
  ansible
  asciinema
  bitwarden-cli
  coreutils
  # direnv # programs.direnv
  #docker
  drill
  du-dust
  dua
  duf
  esptool
  ffmpeg
  fd
  #fzf # programs.fzf
  git # programs.git
  gh
  go
  gnused
  #htop # programs.htop
  hub
  hugo
  ipmitool
  jetbrains-mono # font
  just
  jq
  mc
  mosh
  neofetch
  nmap
  ripgrep
  skopeo
  smartmontools
  tailscale
  terraform
  tree
  unzip
  watch
  wget
  wireguard-tools
  vim

  # requires nixpkgs.config.allowUnfree = true;
  vscode-extensions.ms-vscode-remote.remote-ssh

  # lib.optionals boolean stdenv is darwin
  #mas # mac app store cli
]