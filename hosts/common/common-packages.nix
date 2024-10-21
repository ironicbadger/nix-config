{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    ## stable
    ansible
    btop
    coreutils
    diffr # Modern Unix `diff`
    difftastic # Modern Unix `diff`
    drill
    du-dust # Modern Unix `du`
    dua # Modern Unix `du`
    duf # Modern Unix `df`
    entr # Modern Unix `watch`
    esptool
    fastfetch
    fd
    ffmpeg
    figurine
    fira-code
    fira-code-nerdfont
    fira-mono
    gh
    gnused
    go
    hugo
    iperf3
    ipmitool
    jetbrains-mono # font
    jq
    just
    kubectl
    mc
    mosh
    nerdfonts
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
    zoxide

    # requires nixpkgs.config.allowUnfree = true;
    vscode-extensions.ms-vscode-remote.remote-ssh
  ];
}
