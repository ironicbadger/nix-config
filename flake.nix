{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      
      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self
    , nixpkgs, nixpkgs-unstable, nixpkgs-darwin
    , home-manager, nix-darwin, ... }:
    let  
      # creates correct package sets for specified arch
      genPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      genDarwinPkgs = system: import nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;
      };
      inputs = { inherit nix-darwin home-manager nixpkgs nixpkgs-unstable; };
    
      # creates a nixos system config
      nixosSystem = system: hostName: username:
        let
          pkgs = genPkgs system;
        in
          nixpkgs.lib.nixosSystem
          {
            inherit system inputs;
            modules = [
              {
                # adds unstable to be available in top-level evals (like in common-packages)
                _module.args = {
                  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; 
                };
              }

              ./hosts/${hostName} # ip address, host specific stuff

              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = {
                  imports = [
                    ./hm/alex.nix
                  ];
                };
                home-manager.extraSpecialArgs = {
                  #inherit inputs system;
                  #unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
                };
              }
              ./nixos-common.nix
            ];
          };

      # creates a macos system config
      darwinSystem = system: hostName: username:
        let
          pkgs = genDarwinPkgs system;
        in
          nix-darwin.lib.darwinSystem {
            inherit system inputs;
            modules = [
              {
                # adds unstable to be available in top-level evals (like in common-packages)
                _module.args = {
                  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; 
                };
              }

              ./hosts/${hostName} # ip address, host specific stuff

              home-manager.darwinModules.home-manager 
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = {
                  imports = [
                    ./hm/alex.nix
                    #./hosts/${hostName}
                  ];
                };
                home-manager.extraSpecialArgs = {
                  inherit inputs system;
                  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system};
                };
              }
              ./darwin-common.nix
            ];
          };
    in
    {
      darwinConfigurations = {
        magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
      };

      nixosConfigurations = {
        testnix = nixosSystem "x86_64-linux" "testnix" "alex";
      };
    };

}

  # # https://github.com/yusefnapora/nixos-system-flake
  # outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ... }:
  # let
  #   inherit (nixpkgs.lib) nixosSystem lists;
  #   inherit (nix-darwin.lib) darwinSystem;
    
  #   mkDarwinConfig = { system, modules, ... }:
  #     darwinSystem {
  #       inherit system;

  #       inputs = { inherit nix-darwin home-manager nixpkgs nixpkgs-unstable; };
  #       modules = modules
  #       ++ [
  #         home-manager.darwinModules.home-manager {
  #           home-manager.useGlobalPkgs = true;
  #           home-manager.useUserPackages = true;

  #           home-manager.users.alex = {
  #             imports = [
  #               ./.config/darwin/home.nix
  #             ];
  #           };

  #           home-manager.extraSpecialArgs = {
  #             inherit inputs system;
  #             nixosConfig = {};
  #             unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin;
  #           };
  #         }
  #       ];
  #     };
  # in
  # {
  #   darwinConfigurations = {
  #     slartibartfast = mkDarwinConfig {
  #       system = "aarch64-darwin";
  #       modules = [
  #         ./.config/darwin/darwin-configuration.nix
  #       ];
  #     };
  #     magrathea = mkDarwinConfig {
  #       system = "aarch64-darwin";
  #       modules = [
  #         ./.config/darwin/darwin-configuration.nix
  #       ];
  #     };
  #   };
  # };
#}