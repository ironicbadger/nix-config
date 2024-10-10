{ inputs, outputs, config, lib,
  hostname, system, username, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  # Nix configuration ------------------------------------------------------------------------------
  users.users.alex.home = "/Users/alex";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
  services.nix-daemon.enable = true;
  system.stateVersion = 5;

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };

  environment.systemPackages = with pkgs; [
    ## unstable
    unstablePkgs.yt-dlp
    unstablePkgs.get_iplayer
    unstablePkgs.colmena

    ## stable GUI
    pkgs.alacritty
    pkgs.audacity
    pkgs.discord
    pkgs.google-chrome
    pkgs.iina
    pkgs.mkalias
    pkgs.obsidian
    pkgs.openscad
    pkgs.prusa-slicer
    pkgs.spotify
    pkgs.vscode

    ## stable CLI
    pkgs.just
  ];

  fonts.packages = [
    (pkgs.nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "Hack"
        "JetBrainsMono"
      ];
    })
  ];

  # spotlight fix for nix apps
  system.activationScripts.applications.text = let
    env = pkgs.buildEnv {
      name = "system-applications";
      paths = config.environment.systemPackages;
      pathsToLink = "/Applications";
    };
  in
    pkgs.lib.mkForce ''
    # Set up applications.
    echo "setting up /Applications..." >&2
    rm -rf /Applications/Nix\ Apps
    mkdir -p /Applications/Nix\ Apps
    find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
    while read src; do
      app_name=$(basename "$src")
      echo "copying $src" >&2
      ${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
    done
        '';

  # pins to stable as unstable updates very often
  nix.registry = {
    n.to = {
      type = "path";
      path = inputs.nixpkgs;
    };
    u.to = {
      type = "path";
      path = inputs.nixpkgs-unstable;
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    promptInit = (builtins.readFile ./../data/mac-dot-zshrc);
  };

  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    onActivation.cleanup = "zap";
    onActivation.upgrade = true;

    #brews = [
      # home.nix
      # home.packages
      # "argocd"
      # "ata"
      # "doctl"
      # "helm"
      # "flyctl"
      # "lima"
      # "npm"
      # "node"
      # #"superfile"
      # "tailscale"
    #];
    casks = [
      "balenaetcher"
      "bambu-studio"
      "displaylink"
      "docker" # specified here for docker-desktop for mac
      "element"
      "firefox"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-lg-nerd-font"
      "istat-menus"
      # "iterm2"
      # "lm-studio"
      "logitech-options"
      "macwhisper"
      "marta"
      "mqtt-explorer"
      "nextcloud"
      "notion"
      "obs"
      "ollama"
      "omnidisksweeper"
      "openttd"
      "plexamp"
      "signal"
      "slack"
      "steam"
      # "thunderbird"
      "viscosity"
      "vlc"

      # # rogue amoeba
      "audio-hijack"
      "farrago"
      "loopback"
      "soundsource"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "Bitwarden" = 1352778147;
      "Creator's Best Friend" = 1524172135;
      "Disk Speed Test" = 425264550;
      "iA Writer" = 775737590;
      #"Ivory for Mastodon by Tapbots" = 2145332318;
      "Microsoft Remote Desktop" = 1295203466;
      "Reeder" = 1529448980;
      "Resize Master" = 1025306797;
      # "Steam Link" = 123;
      "Tailscale" = 1475387142;
      "Telegram" = 747648890;
      "The Unarchiver" = 425424353;
      "Todoist" = 585829637;
      "UTM" = 1538878817;
      "Wireguard" = 1451685025;
      "Yoink" = 457622435;

      # these apps with uk apple id
      "Final Cut Pro" = 424389933;
      #"Logic Pro" = 634148309;
      #"MainStage" = 634159523;
      #"Garageband" = 682658836;
      #"ShutterCount" = 720123827;
      #"Teleprompter" = 1533078079;

      "Keynote" = 409183694;
      "Numbers" = 409203825;
      "Pages" = 409201541;
    };
  };

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  # macOS configuration
  system.activationScripts.postUserActivation.text = ''
    # Following line should allow us to avoid a logout/login cycle
    /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
  '';
  system.defaults = {
    NSGlobalDomain.AppleShowAllExtensions = true;
    NSGlobalDomain.AppleShowScrollBars = "Always";
    NSGlobalDomain.NSUseAnimatedFocusRing = false;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode = true;
    NSGlobalDomain.NSNavPanelExpandedStateForSaveMode2 = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint = true;
    NSGlobalDomain.PMPrintingExpandedStateForPrint2 = true;
    NSGlobalDomain.NSDocumentSaveNewDocumentsToCloud = false;
    NSGlobalDomain.ApplePressAndHoldEnabled = false;
    NSGlobalDomain.InitialKeyRepeat = 25;
    NSGlobalDomain.KeyRepeat = 2;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "Nlsv";
    dock.persistent-apps = [
      "${pkgs.google-chrome}/Applications/Google Chrome.app"
      "/Applications/Telegram.app"
      "${pkgs.discord}/Applications/Discord.app"
      "${pkgs.vscode}/Applications/Visual Studio Code.app"
      "${pkgs.alacritty}/Applications/Alacritty.app"
    ];
  };
  system.defaults.CustomUserPreferences = {
      "com.apple.finder" = {
        ShowExternalHardDrivesOnDesktop = true;
        ShowHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowRemovableMediaOnDesktop = true;
        _FXSortFoldersFirst = true;
        # When performing a search, search the current folder by default
        FXDefaultSearchScope = "SCcf";
        DisableAllAnimations = true;
        NewWindowTarget = "PfDe";
        NewWindowTargetPath = "file://$\{HOME\}/Desktop/";
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        ShowStatusBar = true;
        ShowPathbar = true;
        WarnOnEmptyTrash = false;
      };
      "com.apple.desktopservices" = {
        # Avoid creating .DS_Store files on network or USB volumes
        DSDontWriteNetworkStores = true;
        DSDontWriteUSBStores = true;
      };
      "com.apple.dock" = {
        autohide = false;
        launchanim = false;
        static-only = false;
        show-recents = false;
        show-process-indicators = true;
        orientation = "left";
        tilesize = 36;
        minimize-to-application = true;
        mineffect = "scale";
      };
      "com.apple.ActivityMonitor" = {
        OpenMainWindow = true;
        IconType = 5;
        SortColumn = "CPUUsage";
        SortDirection = 0;
      };
      "com.apple.Safari" = {
        # Privacy: don’t send search queries to Apple
        UniversalSearchEnabled = false;
        SuppressSearchSuggestions = true;
      };
      "com.apple.AdLib" = {
        allowApplePersonalizedAdvertising = false;
      };
      "com.apple.SoftwareUpdate" = {
        AutomaticCheckEnabled = true;
        # Check for software updates daily, not just once per week
        ScheduleFrequency = 1;
        # Download newly available updates in background
        AutomaticDownload = 1;
        # Install System data files & security updates
        CriticalUpdateInstall = 1;
      };
      "com.apple.TimeMachine".DoNotOfferNewDisksForBackup = true;
      # Prevent Photos from opening automatically when devices are plugged in
      "com.apple.ImageCapture".disableHotPlug = true;
      # Turn on app auto-update
      "com.apple.commerce".AutoUpdate = true;
      "com.googlecode.iterm2".PromptOnQuit = false;
      "com.google.Chrome" = {
        AppleEnableSwipeNavigateWithScrolls = true;
        DisablePrintPreview = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
  };

}