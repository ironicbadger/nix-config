{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.11-darwin";

    vscode-server.url = "github:nix-community/nixos-vscode-server";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , nixpkgs-unstable
    , nixpkgs-darwin
    , home-manager
    , nix-darwin
    , vscode-server
    , ...
    }:
    let
      inputs = { inherit nix-darwin home-manager nixpkgs nixpkgs-unstable; };
      # creates correct package sets for specified arch
      genPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      genUnstablePkgs = system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      genDarwinPkgs = system: import nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;
      };

      # creates a nixos system config
      nixosSystem = system: hostName: username:
        let
          pkgs = genPkgs system;
          unstablePkgs = genUnstablePkgs system;
        in
        nixpkgs.lib.nixosSystem
          {
            inherit system;
            modules = [
              # adds unstable to be available in top-level evals (like in common-packages)
              { _module.args = { unstablePkgs = unstablePkgs; stablePkgs = pkgs; }; }

              ./hosts/nixos/${hostName} # ip address, host specific stuff
              vscode-server.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
                home-manager.extraSpecialArgs = { inherit unstablePkgs; stablePkgs = pkgs; };
              }
              ./hosts/common/nixos-common.nix
            ];
          };

      # creates a macos system config
      darwinSystem = system: hostName: username:
        let
          unstablePkgs = genUnstablePkgs system;
          pkgs = genDarwinPkgs system;
        in
        nix-darwin.lib.darwinSystem
          {
            inherit system inputs;
            modules = [
              # adds unstable to be available in top-level evals (like in common-packages)
              { _module.args = { unstablePkgs = unstablePkgs; stablePkgs = pkgs; }; }

              ./hosts/darwin/${hostName} # ip address, host specific stuff
              home-manager.darwinModules.home-manager
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
                home-manager.extraSpecialArgs = { inherit unstablePkgs; stablePkgs = pkgs; };
              }
              ./hosts/common/darwin-common.nix
            ];
          };

      # linuxSystem = system: hostName: username:
      #   let
      #     pkgs = genPkgs system;
      #     unstablePkgs = genUnstablePkgs system;
      #   in
      #   inputs.home-manager.lib.homeManagerConfiguration {
      #     configuration = { imports = [ ./home/${username}.nix ]; };
      #     system = system;
      #     # homeDirectory = "/Users/user";
      #     # useGlobalPkgs = true;
      #     # useUserPackages = true;
      #     pkgs = unstablePkgs;
      #     username = username;
      #     extraSpecialArgs = { inherit unstablePkgs; stablePkgs = pkgs; };
      #   };
      linuxSystem = system: hostName: username:
        let
          pkgs = genPkgs system;
          unstablePkgs = genUnstablePkgs system;
        in
        {
          pkgs = unstablePkgs.legacyPackages.${system};

          modules = [
            { _module.args = { unstablePkgs = unstablePkgs; stablePkgs = pkgs; }; }

            # ./hosts/linux/${hostName} # ip address, host specific stuff
            { imports = [ ./home/${username}.nix ]; }
            {
              home = {
                username = username;
                # homeDirectory = "/home/jdoe";
                stateVersion = "23.11";
              };
            }
          ];
        };
    in
    {
      darwinConfigurations = {
        magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
        slartibartfast = darwinSystem "aarch64-darwin" "slartibartfast" "alex";
        awesomo = darwinSystem "aarch64-darwin" "awesomo" "alex";
        cat-laptop = darwinSystem "aarch64-darwin" "cat-laptop" "alex";
        osprey = darwinSystem "x86_64-darwin" "osprey" "dominik";
        thorax = darwinSystem "aarch64-darwin" "thorax" "dominik";
      };

      nixosConfigurations = {
        testnix = nixosSystem "x86_64-linux" "testnix" "alex";
      };

      # homeManagerConfigurations = {
      #   nix-hm-test = linuxSystem "x86_64-linux" "nix-hm-test" "dominik";
      # };
      homeManagerConfigurations."dominik" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs-unstable.legacyPackages.x86_64-linux;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home/dominik.nix
          {
            home = {
              username = "dominik";
              homeDirectory = "/home/dominik";
              stateVersion = "23.11";
            };
          }
        ];
        # username = "dominik";

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
    };

}
