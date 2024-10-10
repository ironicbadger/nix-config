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
        genUnstablePkgs = system: import inputs.nixpkgs-unstable { inherit system; config.allowUnfree = true; };
        unstablePkgs = genUnstablePkgs system;
    in
    inputs.nix-darwin.lib.darwinSystem {
        specialArgs = {
            inherit system inputs unstablePkgs;
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