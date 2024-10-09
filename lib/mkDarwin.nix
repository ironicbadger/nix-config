{ inputs, outputs, system ? "aarch64-darwin", username ? "alex", ... }:
let
    pkgs = system: import nixpkgs-darwin { inherit system; config.allowUnfree = true; }; system;
in
    nix-darwin.lib.darwinSystem {
    inherit system inputs;
    specialArgs = {
        # adds unstable to be available in top-level evals (like in common-packages)
        unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};

        # lets us use these things in modules
        customArgs = { inherit system hostname username pkgs; };
    };
    modules = [
        ../common/common-packages.nix
        ../common/darwin-common.nix
        #./hosts/darwin/${hostname} # ip address, host specific stuff
        # home-manager.darwinModules.home-manager {
        # networking.hostName = hostname;
        # home-manager.useGlobalPkgs = true;
        # home-manager.useUserPackages = true;
        # home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
        # }
        # ./hosts/common/darwin-common.nix
    ];
    };