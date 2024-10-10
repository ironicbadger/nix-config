{ inputs, outputs, stateVersion, ... }:
{
  # untested
  # mkNixos = { hostname, username ? "alex", system ? "x86_64-linux", }:
  #   let
  #     unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  #   in
  #     modules = [
  #       ../common/common-packages.nix
  #       ../common/nixos-common.nix
  #       ../hosts/nixos/${hostname}
  #       inputs.vscode-server.nixosModules.default
  #       inputs.home-manager.nixosModules.home-manager {
  #         networking.hostName = hostname;
  #         home-manager.useGlobalPkgs = true;
  #         home-manager.useUserPackages = true;
  #         home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
  #       }
  #     ];

  mkDarwin = { hostname, username ? "alex", system ? "aarch64-darwin", }:
  let
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit system inputs username unstablePkgs;
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
            mutableTaps = true;
            user = "${username}";
            taps = {
              "homebrew/homebrew-core" = inputs.homebrew-core;
              "homebrew/homebrew-cask" = inputs.homebrew-cask;
              "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
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