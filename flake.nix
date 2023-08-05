{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      
      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-unstable, home-manager, nix-darwin, ... }:
    let  
      genPkgs = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
      genDarwinPkgs = system: import nixpkgs-darwin {
        inherit system;
        config.allowUnfree = true;
      };
    
    
      nixosSystem = hostName: system:
        let
          pkgs = genPkgs system;
        in
          nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [

            ];
          };

      darwinSystem = system: hostName: username:
        let
          pkgs = genDarwinPkgs system;
        in
          darwin.lib.darwinSystem {
            inherit system;

            inputs = { inherit nix-darwin home-manager nixpkgs nixpkgs-unstable; };
            modules = [
              home-manager.darwinModules.home-manager 
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.{$username} = {
                  imports = [
                    ./.config/darwin/home.nix
                  ];
                };
                home-manager.extraSpecialArgs = {
                  inherit inputs system;
                  #nixosConfig = {};
                  unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.aarch64-darwin;
                };
              }
              #./darwin-common.nix
            ];
          };

      processConfigurations = lib.mapAttrs (n: v: v n);

    in
    {
      darwinConfigurations = processConfigurations {
        magrathea = darwinSystem "aarch64-darwin" [ ./hosts/magrathea/] "alex";
      };
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