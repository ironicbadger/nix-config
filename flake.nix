{
  description = "My first nix flake";

  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
      home-manager.url = "github:nix-community/home-manager/release-23.05";
      home-manager.inputs.nixpkgs.follows = "nixpkgs";
      # nix will normally use the nixpkgs defined in home-managers inputs, we only want one copy of nixpkgs though
      darwin.url = "github:lnl7/nix-darwin";
      darwin.inputs.nixpkgs.follows = "nixpkgs"; # ...

      ## zsh
      #zsh-completions.url = "github:zsh-users/zsh-completions";
      #zsh-completions.flake = false;
  };

  outputs = { self, nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations."slartibartfast" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ home-manager.darwinModules.home-manager ./hosts/slartibartfast/default.nix ];
    };
    darwinConfigurations."magrathea" = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ home-manager.darwinModules.home-manager ./hosts/magrathea/default.nix ];
    };
  };

}
