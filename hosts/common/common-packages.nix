{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.beszel
    nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.talosctl

    ## stable
    act
    ansible
    btop
    coreutils
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    drill
    dust # Modern Unix `du`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    entr # Modern Unix `watch`
    esptool
    fastfetch
    fd
    ffmpeg
    figurine
    gh
    git-crypt
    gnused
    go
    hugo
    iperf3
    ipmitool
    jetbrains-mono # font
    jq
    just
    fluxcd
    kubectl
    kubernetes-helm
    k9s
    mc
    mosh
    nmap
    qemu
    ripgrep
    skopeo
    smartmontools
    stow
    television
    terraform
    tree
    unzip
    watch
    wget
    wireguard-tools
    uv
    zoxide

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}
