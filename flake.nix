{
  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
      nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.05-darwin";

      nix-darwin.url = "github:lnl7/nix-darwin";
      nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

      nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
      homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
      homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
      homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

      home-manager.url = "github:nix-community/home-manager/release-24.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";

      # disko.url = "github:nix-community/disko";
      # disko.inputs.nixpkgs.follows = "nixpkgs";

      # vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { ... }@inputs:
    with inputs;
    let
      inherit (self) outputs;

      stateVersion = "24.05";
      libx = import ./lib { inherit inputs outputs stateVersion; };

    in {

      darwinConfigurations = {
        # personal
        slartibartfast = libx.mkDarwin { hostname = "slartibartfast"; };
        mac-studio = libx.mkDarwin { hostname = "mac-studio"; };
        mooncake = libx.mkDarwin { hostname = "mooncake"; };

        # work
        baldrick = libx.mkDarwin { hostname = "baldrick"; };
        magrathea = libx.mkDarwin { hostname = "magrathea"; };
      };

      nixosConfigurations = {
        # # servers
        # morphnix = nixosSystem "x86_64-linux" "morphnix" "alex";
        # nix-dev = nixosSystem "x86_64-linux" "nix-dev" "alex";
        # nixApp = nixosSystem "x86_64-linux" "nixApp" "alex";

        # # test system
        # yeager = nixosSystem "x86_64-linux" "yeager" "alex";

        # # use this for a blank ISO + disko to work
        # nixos = nixosSystem "x86_64-linux" "nixos" "alex";
      };

      colmena = {
        meta = {
          nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
          specialArgs = {
            inherit inputs;
          };
        };

        ktz-cloud = import ./hosts/nixos/ktz-cloud;
      };

    };

}
