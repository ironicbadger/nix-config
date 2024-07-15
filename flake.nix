{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
  };

  outputs = { nixpkgs, ... }@inputs: {

    nixosConfigurations.nixdev = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [{boot.isContainer=true;}] ;
    };
  };
}
