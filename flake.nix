{
  description = "Julian Arkenau nix-darwin and home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.11-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.11";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
    codex.url = "github:sadjow/codex-cli-nix";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  {

    darwinConfigurations."m1" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        claude-code = inputs.claude-code.packages.aarch64-darwin.default;
        codex = inputs.codex.packages.aarch64-darwin.default;
      };

      modules = [
        ({ pkgs, claude-code, codex, ... }: {
          # Define the macOS user
          users.users.julian = {
            home = "/Users/julian";
          };

          # Enable flakes
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Import Home Manager module
          imports = [ home-manager.darwinModules.home-manager];

          home-manager.extraSpecialArgs = { inherit claude-code codex; };

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

  };
}
