{
  description = "Julian Arkenau nix-darwin and home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  let
    # Builds a standalone home-manager configuration for a given Linux architecture.
    mkLinuxHome = system: home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs = {
        claude-code = inputs.claude-code.packages.${system}.default;
      };
      modules = [{
        home.username = "julian";
        home.homeDirectory = "/home/julian";
        imports = [ ./modules/common.nix ];
      }];
    };
  in {

    darwinConfigurations."m1" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        claude-code = inputs.claude-code.packages.aarch64-darwin.default;
      };

      modules = [
        ({ pkgs, claude-code, ... }: {
          # Define the macOS user
          users.users.julian = {
            home = "/Users/julian";
          };

          # Enable flakes
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Import Home Manager module
          imports = [ home-manager.darwinModules.home-manager];

          home-manager.extraSpecialArgs = { inherit claude-code; };

          # Home Manager user configuration
          home-manager.users.julian = {
            home.homeDirectory = "/Users/julian";
            imports = [ ./modules/common.nix ];
          };

          # Darwin metadata
          system.stateVersion = 6;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        })
      ];
    };

    homeConfigurations.ubuntu     = mkLinuxHome "x86_64-linux";
    homeConfigurations.ubuntu-arm = mkLinuxHome "aarch64-linux";
  };
}
