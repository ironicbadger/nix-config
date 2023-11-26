{ pkgs, unstablePkgs, ... }:

with pkgs; [
  ## unstable
  unstablePkgs.yt-dlp
  unstablePkgs.get_iplayer

  ## stable
  ansible
  asciinema
  bitwarden-cli
  btop
  coreutils
  diffr # Modern Unix `diff`
  difftastic # Modern Unix `diff`
  dua # Modern Unix `du`
  duf # Modern Unix `df`
  du-dust # Modern Unix `du`
  # direnv # programs.direnv
  docker-compose
  drill
  du-dust
  dua
  duf
  entr # Modern Unix `watch`
  esptool
  ffmpeg
  fira-code
  fira-mono
  fd
  #fzf # programs.fzf
  git # programs.git
  gh
  go
  gnused
  htop # programs.htop
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