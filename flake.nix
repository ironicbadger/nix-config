{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin.url = "github:lnl7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = { url = "github:homebrew/homebrew-core"; flake = false; };
    homebrew-cask = { url = "github:homebrew/homebrew-cask"; flake = false; };
    homebrew-bundle = { url = "github:homebrew/homebrew-bundle"; flake = false; };

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs-darwin";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    nixos-anywhere.url = "github:nix-community/nixos-anywhere";
    nixos-anywhere.inputs.nixpkgs.follows = "nixpkgs";

    hcloud-upload-image.url = "github:apricote/hcloud-upload-image";
    hcloud-upload-image.inputs.nixpkgs.follows = "nixpkgs-darwin";

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
        nauvis = libx.mkDarwin { hostname = "nauvis"; };
        mac-studio = libx.mkDarwin { hostname = "mac-studio"; };
        mba15 = libx.mkDarwin { hostname = "mba15"; };

        # work
        baldrick = libx.mkDarwin { hostname = "baldrick"; };
        magrathea = libx.mkDarwin { hostname = "magrathea"; };
        beefcake = libx.mkDarwin { hostname = "beefcake"; };
      };

      nixosConfigurations = {
        proxmox-template = libx.mkNixos {
          hostname = "proxmox-template";
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/proxmox-template
          ];
        };

        proxmox-builder = libx.mkNixos {
          hostname = "proxmox-builder";
          system = "x86_64-linux";
          modules = [
            inputs.disko.nixosModules.disko
            ./hosts/nixos/proxmox-builder
          ];
        };

        forgejo = libx.mkNixos {
          hostname = "forgejo";
          system = "x86_64-linux";
          modules = [
            ./hosts/nixos/forgejo
          ];
        };
      };

      packages = {
        aarch64-darwin.nixos-anywhere = inputs.nixos-anywhere.packages.aarch64-darwin.default;
        x86_64-darwin.nixos-anywhere = inputs.nixos-anywhere.packages.x86_64-darwin.default;
        x86_64-linux.nixos-anywhere = inputs.nixos-anywhere.packages.x86_64-linux.default;
      };

      colmena = {
        meta = {
          nixpkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
          specialArgs = {
            inherit inputs outputs stateVersion self;
          };
        };

        defaults = { lib, config, name, ... }: {
          imports = [
            inputs.home-manager.nixosModules.home-manager
          ];
        };

        # wd
        forgejo = { ... }: {
          imports = [ ./hosts/nixos/forgejo ];
          deployment = {
            targetHost = "forgejo.ktz.ts.net";
            targetUser = "root";
            buildOnTarget = true;
            tags = [ "forgejo" ];
          };
        };
        morphnix = import ./hosts/nixos/morphnix;
        nvllama = import ./hosts/nixos/nvllama;

        # test system
        # yeager = nixosSystem "x86_64-linux" "yeager" "alex";
      };

    };

}
