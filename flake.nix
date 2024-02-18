{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

      #nixos-hardware.url = "github:NixOS/nixos-hardware/master";
      #nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";

      home-manager.url = "github:nix-community/home-manager/release-23.11";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";

      vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = inputs@{ self
    , nixpkgs, nixpkgs-unstable, nixpkgs-darwin
    , home-manager, nix-darwin, disko, vscode-server, nixos-hardware, ... }:
    let
      inputs = { inherit disko home-manager nixpkgs nixpkgs-unstable nix-darwin; };
      # creates correct package sets for specified arch
      genPkgs = system: import nixpkgs {
        inherit system;
        #config.allowUnfree = true;
      };
      genDarwinPkgs = system: import nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;
      };


      # creates a nixos system config
      nixosSystem = system: hostname: username:
        let
          pkgs = genPkgs system;
        in
          nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              # adds unstable to be available in top-level evals (like in common-packages)
              unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};

              # lets us use these things in modules
              customArgs = { inherit username pkgs system; };
            };
            modules = [
              disko.nixosModules.disko
              ./hosts/nixos/${hostname}/disko-config.nix
              {
                _module.args.disks = [
                  "/dev/vda"
                ];
              }

              ./hosts/nixos/${hostname}

              vscode-server.nixosModules.default
              home-manager.nixosModules.home-manager {
                networking.hostName = hostname;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
              }
              ./hosts/common/nixos-common.nix
            ];
          };

      # creates a macos system config
      darwinSystem = system: hostname: username:
        let
          pkgs = genDarwinPkgs system;
        in
          nix-darwin.lib.darwinSystem {
            inherit system inputs;
            specialArgs = {
              # adds unstable to be available in top-level evals (like in common-packages)
              unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};

              # lets us use these things in modules
              customArgs = { inherit username pkgs system; };
            };
            modules = [
              ./hosts/darwin/${hostname} # ip address, host specific stuff
              home-manager.darwinModules.home-manager {
                networking.hostName = hostname;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
              }
              ./hosts/common/darwin-common.nix
            ];
          };
    in {
      darwinConfigurations = {
        magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
        slartibartfast = darwinSystem "aarch64-darwin" "slartibartfast" "alex";
        awesomo = darwinSystem "aarch64-darwin" "awesomo" "alex";
        cat-laptop = darwinSystem "aarch64-darwin" "cat-laptop" "alex";
      };

      nixosConfigurations = {
        framework = nixosSystem "x86_64-linux" "framework" "alex";
        nix-dev = nixosSystem "x86_64-linux" "nix-dev" "alex";

        # test system
        yeager = nixosSystem "x86_64-linux" "yeager" "alex";

        # use this for a blank ISO + disko to work
        nixos = nixosSystem "x86_64-linux" "nixos" "alex";
      };
    };

}
