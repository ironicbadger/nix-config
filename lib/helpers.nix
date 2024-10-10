{
  inputs,
  outputs,
  stateVersion,
  ...
}:
{
  mkDarwin =
    {
      hostname,
      username ? "alex",
      system ? "aarch64-darwin",
    }:
    let
        #pkgs = system: import nixpkgs-darwin { inherit system; config.allowUnfree = true; }; system;
    in
    inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
            inherit system inputs;
        };
        modules = [
            ../common/common-packages.nix
            ../common/darwin-common.nix
        ];
    };

  forAllSystems = inputs.nixpkgs.lib.genAttrs [
    "aarch64-linux"
    "x86_64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];
}