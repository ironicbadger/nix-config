{ pkgs, lib, inputs, customArgs, ... }:
let
  inherit (inputs) nixpkgs nixpkgs-unstable;
in
{
  # Nix configuration ------------------------------------------------------------------------------
  users.users.alex.home = "/Users/alex";

  nix = {
    #package = lib.mkDefault pkgs.unstable.nix;
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      warn-dirty = false;
    };
  };
  services.nix-daemon.enable = true;

  # pins to stable as unstable updates very often
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
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

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.overlays = [
    (final: prev: lib.optionalAttrs (prev.stdenv.system == "aarch64-darwin") {
      # Add access to x86 packages system is running Apple Silicon
      pkgs-x86 = import nixpkgs {
        system = "x86_64-darwin";
        config.allowUnfree = true;
      };
    })
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = false;

  # Add ability to used TouchID for sudo authentication
  security.pam.enableSudoTouchIdAuth = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    promptInit = (builtins.readFile ./../mac-dot-zshrc);
    #interactiveShellInit = "figurine -f \"3d.flf\" ${customArgs.hostname}";
  };

  homebrew = {
    enable = true;
    onActivation.upgrade = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
    taps = [
      "homebrew/cask-fonts"
    ];
    brews = [
      # home.nix
      # home.packages
      "argocd"
      "ata"
      "doctl"
      "helm"
      "flyctl"
      "lima"
      "npm"
      "node"
      #"superfile"
      "tailscale"
    ];
    casks = [
      #"alfred" # you are on alfred4 not 5
      #"autodesk-fusion360" # slow and unreliable to install
      "alacritty"
      "audacity"
      "autodesk-fusion"
      "balenaetcher"
      "bartender"
      "bambu-studio"
      #"canon-eos-utility" #old version and v3 not in repo
      "discord"
      "displaylink"
      "docker"
      "element"
      "firefox"
      "font-fira-code-nerd-font"
      "font-hack-nerd-font"
      "font-jetbrains-mono-nerd-font"
      "font-meslo-lg-nerd-font"
      "google-chrome"
      "istat-menus"
      "iterm2"
      "little-snitch"
      "lm-studio"
      "logitech-options"
      "macwhisper"
      "marta"
      "monitorcontrol"
      "mpv"
      "mqtt-explorer"
      "nextcloud"
      "notion"
      "obs"
      "obsidian"
      "ollama"
      "omnidisksweeper"
      "openscad"
      "openttd"
      "plexamp"
      "prusaslicer"
      "rectangle"
      "signal"
      "slack"
      "spotify"
      "steam"
      "thunderbird"
      "viscosity"
      "visual-studio-code"
      "vlc"
      "wireshark"
      "yubico-yubikey-manager"

      # rogue amoeba
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

      # these apps with uk apple id
      #"Final Cut Pro" = 424389933;
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
    NSGlobalDomain.KeyRepeat = 4;
    NSGlobalDomain."com.apple.mouse.tapBehavior" = 1;
    LaunchServices.LSQuarantine = false; # disables "Are you sure?" for new apps
    loginwindow.GuestEnabled = false;

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