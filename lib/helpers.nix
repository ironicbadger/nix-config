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

  mkDarwin = { hostname, username ? "alex", system ? "aarch64-darwin",}:
  let
    inherit (inputs.nixpkgs) lib;
    unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
    customConfPath = ./../hosts/darwin/${hostname};
    customConf = if builtins.pathExists (customConfPath) then (customConfPath + "/default.nix") else ./../common/darwin-common-dock.nix;
  in
    inputs.nix-darwin.lib.darwinSystem {
      specialArgs = {
        inherit system inputs username unstablePkgs;
      };
      modules = [
        ../common/common-packages.nix
        ../common/darwin-common.nix
        customConf
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
            autoMigrate = true;
            mutableTaps = true;
            user = "${username}";
            taps = with inputs; {
              "homebrew/homebrew-core" = homebrew-core;
              "homebrew/homebrew-cask" = homebrew-cask;
              "homebrew/homebrew-bundle" = homebrew-bundle;
            };
          };
        }
      ];
      # ] ++ lib.optionals (builtins.pathExists ./../hosts/darwin/${hostname}/default.nix) [
      #     (import ./../hosts/darwin/${hostname}/default.nix)
      #   ];
    };
}
