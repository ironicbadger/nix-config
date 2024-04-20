{ pkgs, unstablePkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    ## unstable
    unstablePkgs.yt-dlp
    unstablePkgs.get_iplayer

    ## stable
    ansible
    asciinema
    bitwarden-cli
    btop
    coreutils
    devbox
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    du-dust # Modern Unix `du`
    docker-compose
    drill
    entr # Modern Unix `watch`
    esptool
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
    nmap
    qemu
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

    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}