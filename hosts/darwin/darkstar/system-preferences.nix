{ config, pkgs, lib, ... }:

{
  # System-wide macOS preferences
  
  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToControl = false;  # Remap Caps Lock to Control
  };
  
  # Trackpad settings
  system.defaults.trackpad = {
    Clicking = true;                # Enable tap to click
    TrackpadRightClick = true;      # Enable two-finger right click
    TrackpadThreeFingerDrag = true; # Enable three-finger drag
  };
  
  # Finder settings
  system.defaults.finder = {
    AppleShowAllExtensions = true;  # Show all file extensions
    FXEnableExtensionChangeWarning = false; # Don't warn when changing file extension
    _FXShowPosixPathInTitle = true; # Show full path in Finder title
    CreateDesktop = true;           # Show desktop icons
    ShowPathbar = true;             # Show path bar
    ShowStatusBar = true;           # Show status bar
  };
  
  # Dock settings
  system.defaults.dock = {
    autohide = true;                # Auto-hide the dock
    show-recents = true;            # Show recent applications
    tilesize = 48;                  # Icon size
    static-only = false;            # Show only running applications
    mru-spaces = false;             # Don't automatically rearrange spaces
  };
  
  # Login window settings
  system.defaults.loginwindow = {
    GuestEnabled = false;           # Disable guest user
    SHOWFULLNAME = true;            # Show full name rather than username
  };
  
  # Global system settings
  system.defaults.NSGlobalDomain = {
    AppleShowAllExtensions = true;  # Show all file extensions
    NSAutomaticCapitalizationEnabled = false; # Disable auto-capitalization
    NSAutomaticDashSubstitutionEnabled = false; # Disable em dash substitution
    NSAutomaticPeriodSubstitutionEnabled = false; # Disable period substitution
    NSAutomaticQuoteSubstitutionEnabled = false; # Disable smart quotes
    NSAutomaticSpellingCorrectionEnabled = false; # Disable auto-correction
    NSNavPanelExpandedStateForSaveMode = true; # Expanded save panel by default
    NSNavPanelExpandedStateForSaveMode2 = true; # Expanded save panel by default
    "com.apple.swipescrolldirection" = true; # Natural scrolling on
    "com.apple.keyboard.fnState" = true;      # Use F1, F2, etc. as standard function keys
  };
  
  # Security settings
  security.pam.enableSudoTouchIdAuth = true;  # Enable Touch ID for sudo
}
