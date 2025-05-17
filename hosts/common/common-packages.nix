{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # nixpkgs-unstable.legacyPackages.${pkgs.system}.beszel
    # nixpkgs-unstable.legacyPackages.${pkgs.system}.talosctl

    ## stable
    act
    # ansible
    # btop
    # coreutils
    # diffr # Modern Unix `diff`
    # difftastic # Modern Unix `diff`
    # drill
    # du-dust # Modern Unix `du`
    # dua # Modern Unix `du`
    # duf # Modern Unix `df`
    # entr # Modern Unix `watch`
    # esptool
    # fastfetch
    # fd
    # ffmpeg
    # figurine
    # fira-code
    # fira-code-nerdfont
    # fira-mono
    # gh
    # git-crypt
    # gnused
    # go
    # hugo
    # iperf3
    # ipmitool
    jetbrains-mono # font
    jq
    just
    # kubectl
    # mc
    mosh
    # nerdfonts
    nmap
    # qemu
    # ripgrep
    # skopeo
    smartmontools
    # television
    # terraform
    tree
    unzip
    watch
    # wget
    # wireguard-tools
    zoxide

    # requires nixpkgs.config.allowUnfree = true;
    # vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}
