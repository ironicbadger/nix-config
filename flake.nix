{
  inputs = 
  {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

      vscode-server.url = "github:nix-community/nixos-vscode-server";
      
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      
      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self
    , nixpkgs, nixpkgs-unstable, nixpkgs-darwin
    , home-manager, nix-darwin, vscode-server, ... }:
    let  
      inputs = { inherit nix-darwin home-manager nixpkgs nixpkgs-unstable; };
      # creates correct package sets for specified arch
      genPkgs = system: import nixpkgs {
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
        in
          nixpkgs.lib.nixosSystem
          {
            inherit system;
            modules = [
              # adds unstable to be available in top-level evals (like in common-packages)
              { _module.args = { unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; }; }

              ./hosts/nixos/${hostName} # ip address, host specific stuff
              vscode-server.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
              }
              ./hosts/common/nixos-common.nix # things common to all nixos hosts

              # {
              #   _module.args.nixinate = {
              #     host = "10.42.0.50";
              #     sshUser = "root";
              #     buildOn = "remote"; # valid args are "local" or "remote"
              #     substituteOnTarget = true; # if buildOn is "local" then it will substitute on the target, "-s"
              #     hermetic = false;
              #   };
              # }
            ];
          };

      # creates a macos system config
      darwinSystem = system: hostName: username:
        let
          pkgs = genDarwinPkgs system;
        in
          nix-darwin.lib.darwinSystem 
          {
            inherit system inputs;
            modules = [
              # adds unstable to be available in top-level evals (like in common-packages)
              { _module.args = { unstablePkgs = inputs.nixpkgs-unstable.legacyPackages.${system}; }; }

              ./hosts/darwin/${hostName} # ip address, host specific stuff
              home-manager.darwinModules.home-manager 
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
              }
              ./hosts/common/darwin-common.nix # things common to all macos hosts
            ];
          };
    in
    {
      darwinConfigurations = {
        magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
        slartibartfast = darwinSystem "aarch64-darwin" "slartibartfast" "alex";
      };

      nixosConfigurations = {
        testnix = nixosSystem "x86_64-linux" "testnix" "alex";
      };

      # colmena = 
      # {
      #   meta = { nixpkgs = import nixpkgs { system = "x86_64-linux"; }; };
      #   testnix = 
      #   {
      #     networking.hostName = "testnix";
      #     deployment = {
      #       targetHost = "10.42.0.50";
      #       targetUser = "root";
      #       buildOnTarget = true;
      #       tags = [ "test" ];
      #     };
      #     #system.stateVersion = "23.05";
      #     boot.loader.grub.device = "nodev"; #efi nodev
      #     fileSystems."/" =
      #       { device = "/dev/disk/by-uuid/a3cfe9a3-59fd-43ab-92c1-e77dd3abfc1d";
      #         fsType = "ext4";
      #       };
      #   };
      # };
    };

}