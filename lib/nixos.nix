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