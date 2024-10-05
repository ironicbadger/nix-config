{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, nixpkgs-unstable, ... }@inputs:
    let
      pkgsLinux = import nixpkgs { system = "x86_64-linux"; };
      pkgsLinuxUnstable = import nixpkgs-unstable { system = "x86_64-linux"; };
    in
    {
      colmena = {
        meta = {
          # this sets the nixpkgs for all nodes by default
          nixpkgs = pkgsLinux;

          # this sets the nixpkgs for each node individually
          # in case you need to use a different nixpkgs
          # for a given node
          #nodeNixpkgs = {
            # nixie = pkgsLinux;
            # sv2 = pkgsLinuxUnstable;
          #};
          specialArgs = {
            inherit inputs;
          };
        };

        cloud = import ./hosts/cloud;
      };
    };
}