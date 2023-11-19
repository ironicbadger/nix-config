{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

      vscode-server.url = "github:nix-community/nixos-vscode-server";
      
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      
      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self
    , nixpkgs, nixpkgs-unstable, nixpkgs-darwin
    , home-manager, nix-darwin, disko, vscode-server, ... }:
    let  
      inputs = { inherit disko home-manager nixpkgs nixpkgs-unstable nix-darwin; };
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

              disko.nixosModules.disko
              ./hosts/nixos/${hostName}/disko-config.nix
              {
                _module.args.disks = [
                  "/dev/sda"
                ];
                boot.loader.grub = {
                  enable = true;
                  efiSupport = true;
                  devices = [ "/dev/sda1 "];
                  #efiInstallAsRemovable = true;
                };
              }
              
              ./hosts/nixos/${hostName} # ip address, host specific stuff
              vscode-server.nixosModules.default
              home-manager.nixosModules.home-manager
              {
                networking.hostName = hostName;
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
              }
              ./hosts/common/nixos-common.nix
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
              ./hosts/common/darwin-common.nix
            ];
          };
    in
    {
      darwinConfigurations = {
        magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
        slartibartfast = darwinSystem "aarch64-darwin" "slartibartfast" "alex";
        awesomo = darwinSystem "aarch64-darwin" "awesomo" "alex";
        cat-laptop = darwinSystem "aarch64-darwin" "cat-laptop" "alex";
      };

      nixosConfigurations = {
        testnix = nixosSystem "x86_64-linux" "testnix" "alex";
        yeager = nixosSystem "x86_64-linux" "yeager" "alex";
      };
    };

}
