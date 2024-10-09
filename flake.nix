{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

      home-manager.url = "github:nix-community/home-manager/release-24.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";

      vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;

      stateVersion = "24.05";
      libz = import ./lib { inherit inputs outputs stateVersion; };

      #genPkgs = system: import nixpkgs { inherit system; config.allowUnfree = true; };
      #genUnstablePkgs = system: import nixpkgs-unstable { inherit system; config.allowUnfree = true; };
      #genDarwinPkgs = system: import nixpkgs-darwin { inherit system; config.allowUnfree = true; };

      # creates a nixos system config
      # nixosSystem = system: hostname: username:
      #   let
      #     pkgs = genPkgs system;
      #     unstablePkgs = genUnstablePkgs system;
      #   in
      #     nixpkgs.lib.nixosSystem {
      #       inherit system;
      #       specialArgs = {
      #         inherit pkgs unstablePkgs;
      #         # lets us use these things in modules
      #         customArgs = { inherit system hostname username pkgs unstablePkgs; };
      #       };
      #       modules = [
      #         #disko.nixosModules.disko
      #         #./hosts/nixos/${hostname}/disko-config.nix

      #         ./hosts/nixos/${hostname}

      #         vscode-server.nixosModules.default
      #         home-manager.nixosModules.home-manager {
      #           networking.hostName = hostname;
      #           home-manager.useGlobalPkgs = true;
      #           home-manager.useUserPackages = true;
      #           home-manager.users.${username} = { imports = [ ./home/${username}.nix ]; };
      #         }
      #         ./hosts/common/nixos-common.nix
      #       ];
      #     };

      # creates a macos system config
      #lib.mkDarwin
      #darwinSystem = system: hostname: username:

    in {
      darwinConfigurations = {

        slartibartfast = libz.mkDarwin {
          hostname = "slartibartfast";
        };

        #slartibartfast = darwinSystem "aarch64-darwin" "slartibartfast" "alex";
        # awesomo = darwinSystem "aarch64-darwin" "awesomo" "alex";
        # wallace = darwinSystem "aarch64-darwin" "wallace" "alex";

        # # work
        # baldrick = darwinSystem "aarch64-darwin" "baldrick" "alex";
        # magrathea = darwinSystem "aarch64-darwin" "magrathea" "alex";
      };

      nixosConfigurations = {
        # servers
        morphnix = nixosSystem "x86_64-linux" "morphnix" "alex";
        nix-dev = nixosSystem "x86_64-linux" "nix-dev" "alex";
        nixApp = nixosSystem "x86_64-linux" "nixApp" "alex";

        # test system
        yeager = nixosSystem "x86_64-linux" "yeager" "alex";

        # use this for a blank ISO + disko to work
        nixos = nixosSystem "x86_64-linux" "nixos" "alex";
      };
    };

}
