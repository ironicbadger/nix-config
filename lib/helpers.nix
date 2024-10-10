{ inputs, outputs, stateVersion, ... }:
{
  mkDarwin = {
    hostname,
    username ? "alex",
    system ? "aarch64-darwin",
  }:
  let
    #genUnstablePkgs = system: import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
    #unstablePkgs = genUnstablePkgs system;
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit
            system
            inputs
            username
            unstablePkgs;
      };
      modules = [
        ../common/common-packages.nix
        ../common/darwin-common.nix
        inputs.home-manager.darwinModules.home-manager {
            networking.hostName = hostname;
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${username} = { imports = [ ./../home/${username}.nix ]; };
        }
        inputs.nix-homebrew.darwinModules.nix-homebrew {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "${username}";
            mutableTaps = false;
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
              #"homebrew/cask-fonts"
            };
          };
        }
      ];
    };
}



            #   unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};

            #   # lets us use these things in modules
            #   customArgs = { inherit system hostname username pkgs; };
            # };
            # modules = [
            #   ./hosts/darwin/${hostname} # ip address, host specific stuff
            #   home-manager.darwinModules.home-manager {
            #     networking.hostName = hostname;
            #     home-manager.useGlobalPkgs = true;
            #     home-manager.useUserPackages = true;
            #     home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
            #   }
            #   ./hosts/common/darwin-common.nix
            # ];