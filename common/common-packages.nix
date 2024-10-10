{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## unstable
    # unstablePkgs.yt-dlp
    # unstablePkgs.get_iplayer
    # unstablePkgs.colmena

    ## stable
    ansible
    asciinema
    bitwarden-cli
    btop
    coreutils
    #devbox
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    du-dust # Modern Unix `du`
    docker-compose
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
    git # programs.git
    gh
    go
    gnused
    htop # programs.htop
    hub
    hugo
    iperf3
    ipmitool
    jetbrains-mono # font
    just
    jq
    kubectl
    mc
    mosh
    neofetch
    nixos-rebuild
    nmap
    qemu
    ripgrep
    skopeo
    smartmontools
    terraform
    tmux
    tree
    unzip
    watch
    wget
    wireguard-tools
    vim
    zoxide

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}