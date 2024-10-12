{ config, ... }: {
    nixpkgs.hostPlatform = "aarch64-darwin";

    # Show all filename extensions
    system.defaults.finder.AppleShowAllExtensions = true;
}