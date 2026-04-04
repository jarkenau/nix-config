{
  description = "Julian Arkenau nix-darwin and home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }: {

    darwinConfigurations."m1" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
        claude-code = inputs.claude-code.packages.aarch64-darwin.default;
      };

      modules = [
        ({ pkgs, pkgs-unstable, claude-code, ... }: {
          # Define the macOS user
          users.users.julian = {
            home = "/Users/julian";
          };

          # Enable flakes
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Import Home Manager module
          imports = [ home-manager.darwinModules.home-manager];

          # Pass pkgs-unstable and claude-code to home-manager
          home-manager.extraSpecialArgs = { inherit pkgs-unstable claude-code; };

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

    # Home Manager standalone configuration for Linux
    homeConfigurations.ubuntu = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;

      extraSpecialArgs = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        claude-code = inputs.claude-code.packages.x86_64-linux.default;
      };

      modules = [
        {
          home.username = "julian";
          home.homeDirectory = "/home/julian";
          imports = [ ./modules/common.nix ];
        }
      ];
    };
  };
}
