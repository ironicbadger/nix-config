{ inputs, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    ansible
    btop
    coreutils
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    du-dust # Modern Unix `du`
    drill
    entr # Modern Unix `watch`
    esptool
    fastfetch
    ffmpeg
    fira-code
    fira-mono
    fd
    figurine
    #fzf # programs.fzf
    #git # programs.git
    gh
    go
    gnused
    #htop # programs.htop
    hugo
    iperf3
    ipmitool
    jetbrains-mono # font
    just
    jq
    kubectl
    mc
    mosh
    nerdfonts
    fira-code-nerdfont
    nmap
    qemu
    ripgrep
    skopeo
    smartmontools
    terraform
    #tmux
    tree
    unzip
    watch
    wget
    wireguard-tools
    zoxide

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}