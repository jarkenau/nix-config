{
  description = "Julian Arkenau nix-darwin and home-manager flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    claude-code.url = "github:sadjow/claude-code-nix";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
  {

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

          # Home Manager's .zshrc already runs compinit; a second one in /etc/zshrc
          # (with a different fpath) rebuilds ~/.zcompdump on every shell (~2s).
          programs.zsh.enableCompletion = false;
          programs.zsh.enableBashCompletion = false;

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

  };
}
