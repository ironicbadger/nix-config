{ inputs, outputs, config, lib, hostname, system, username, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  users.users.${username}.home = "/Users/${username}";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    channel.enable = false;
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
    # unstablePkgs.get_iplayer
    # unstablePkgs.colmena

    ## stable CLI
    pkgs.comma
    pkgs.hcloud
    pkgs.just
    pkgs.lima
    pkgs.nix
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

  programs.nix-index.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # promptInit = builtins.readFile ./../../data/mac-dot-zshrc;
  };

  homebrew = {
    enable = true;
    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };
    global.autoUpdate = true;

    brews = [
      "btop"
      "bat"
      "fd"
      "ripgrep"
      "watch"
    ];
    taps = [
      #"FelixKratz/formulae" #sketchybar
    ];
    casks = [
      "discord"
      "font-fira-code"
      "font-fira-code-nerd-font"
      "font-fira-mono-for-powerline"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-lg-nerd-font"
      "iina"
      "iterm2"
      "jordanbaird-ice"
      "logitech-options"
      "macvim"
      "macwhisper"
      "omnidisksweeper"
      "raycast"
      "tailscale"
      "viscosity"
    ];
    masApps = {
      # "Amphetamine" = 937984704;
      "AutoMounter" = 1160435653;
      # "Bitwarden" = 1352778147;
      "Creator's Best Friend" = 1524172135;
      # "DaVinci Resolve" = 571213070;
      "Disk Speed Test" = 425264550;
      # "Fantastical" = 975937182;
      # "Ivory for Mastodon by Tapbots" = 6444602274;
      # "Home Assistant Companion" = 1099568401;
      # "Microsoft Remote Desktop" = 1295203466;
      "Perplexity" = 6714467650;
      # "Resize Master" = 102530679;
      # "rCmd" = 1596283165;
      # "Snippety" = 1530751461;
      #"Tailscale" = 1475387142;
      "Telegram" = 747648890;
      "The Unarchiver" = 425424353;
      # "Todoist" = 585829637;
      # "UTM" = 1538878817;
      # "Wireguard" = 1451685025;

      # "Final Cut Pro" = 424389933;

      # these apps only available via uk apple id
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
    # NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    NSGlobalDomain.NSWindowShouldDragOnGesture = true;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;
    finder.FXPreferredViewStyle = "Nlsv";
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
        orientation = "bottom";
        tilesize = 36;
        minimize-to-application = false;
        mineffect = "genie";
        enable-window-tool = false;
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
