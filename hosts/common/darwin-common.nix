{ inputs, outputs, config, lib, hostname, system, username, pkgs, unstablePkgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  users.users.alex.home = "/Users/alex";

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
    channel.enable = false;
  };
  system.stateVersion = 5;

  # Set primary user for system-wide activation
  system.primaryUser = "alex";

  nixpkgs = {
    config.allowUnfree = true;
    hostPlatform = lib.mkDefault "${system}";
  };

  environment.systemPackages = with pkgs; [
    ## unstable
    unstablePkgs.yt-dlp
    unstablePkgs.get_iplayer
    unstablePkgs.colmena

    ## stable CLI
    pkgs.comma
    pkgs.hcloud
    pkgs.just
    pkgs.lima
    pkgs.nix
  ];

  fonts.packages = [
    pkgs.nerd-fonts.fira-code
    pkgs.nerd-fonts.fira-mono
    pkgs.nerd-fonts.hack
    pkgs.nerd-fonts.jetbrains-mono
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
    promptInit = builtins.readFile ./../../data/mac-dot-zshrc;
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
      "bitwarden-cli"
      "neovim"
      "ollama"
      #"tailscale"
      #"borders"
    ];
    taps = [
      #"FelixKratz/formulae" #sketchybar
    ];
    casks = [
      #"screenflow"
      #"cleanshot"
      "adobe-creative-cloud"
      #"nikitabobko/tap/aerospace"
      "alacritty"
      #"alcove"
      "audacity"
      #"balenaetcher"
      #"bambu-studio"
      "bentobox"
      "claude"
      "claude-code"
      #"clop"
      "discord"
      "displaylink"
      #"docker"
      "easy-move-plus-resize"
      "element"
      "elgato-camera-hub"
      "elgato-control-center"
      "elgato-stream-deck"
      "firefox"
      "flameshot"
      "font-fira-code"
      "font-fira-code-nerd-font"
      "font-fira-mono-for-powerline"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-lg-nerd-font"
      "ghostty"
      "google-chrome"
      #"iina"
      "hammerspoon"
      "istat-menus"
      "iterm2"
      "jordanbaird-ice"
      "karabiner-elements"
      "lm-studio"
      "logitech-options"
      "macwhisper"
      #"marta"
      "mqtt-explorer"
      "music-decoy" # github/FuzzyIdeas/MusicDecoy
      #"nextcloud"
      "notion"
      "obs"
      "obsidian"
      "ollama-app"
      "omnidisksweeper"
      "orbstack"
      "openscad"
      "openttd"
      "plexamp"
      #"popclip"
      #"prusaslicer"
      "raycast"
      "signal"
      #"shortcat"
      "slack"
      "spotify"
      "steam"
      #"wireshark"
      #"viscosity"
      "visual-studio-code"
      "vlc"
      # "lm-studio"

      # # rogue amoeba
      "audio-hijack"
      "farrago"
      "loopback"
      "soundsource"
    ];
    masApps = {
      "Amphetamine" = 937984704;
      "AutoMounter" = 1160435653;
      "Bitwarden" = 1352778147;
      "Creator's Best Friend" = 1524172135;
      "DaVinci Resolve" = 571213070;
      "Disk Speed Test" = 425264550;
      "Fantastical" = 975937182;
      "Ivory for Mastodon by Tapbots" = 6444602274;
      "Home Assistant Companion" = 1099568401;
      "Microsoft Remote Desktop" = 1295203466;
      "Perplexity" = 6714467650;
      "Resize Master" = 1025306797;
      "rCmd" = 1596283165;
      "Snippety" = 1530751461;
      #"Tailscale" = 1475387142;
      "Telegram" = 747648890;
      "The Unarchiver" = 425424353;
      "Todoist" = 585829637;
      "UTM" = 1538878817;
      "Wireguard" = 1451685025;

      "Final Cut Pro" = 424389933;

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

  # Add ability to used TouchID for sudo authentication
  security.pam.services.sudo_local.touchIdAuth = true;

  # macOS configuration
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
      "com.apple.HIToolbox" = {
        # Completely disable Caps Lock functionality
        AppleFnUsageType = 1; # Enable Fn key functionality
        AppleKeyboardUIMode = 3;
        # Disable Caps Lock toggle entirely
        AppleSymbolicHotKeys = {
          "60" = {
            enabled = false; # Disable Caps Lock toggle hotkey
          };
        };
        # Override modifier key behavior to prevent Caps Lock from functioning
        AppleModifierKeyRemapping = {
          "1452-630-0" = {
            # Map Caps Lock (key code 57/0x39) to nothing (disable it)
            HIDKeyboardModifierMappingSrc = 30064771129; # Caps Lock
            HIDKeyboardModifierMappingDst = 30064771299; # No Action
          };
        };
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
