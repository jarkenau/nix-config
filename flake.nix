{
  description = "Julian Arkenau nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }: {

    darwinConfigurations."m1" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      specialArgs = {
        pkgs-unstable = import inputs.nixpkgs-unstable {
          system = "aarch64-darwin";
          config.allowUnfree = true;
        };
      };

      modules = [
        ({ pkgs, pkgs-unstable, ... }: {
          # Define the macOS user
          users.users.julian = {
            home = "/Users/julian";
          };

          # System packages
          environment.systemPackages = with pkgs; [
            git
            zsh
            vim
            tmux
            fzf
            htop
            tree
            curl
            unzip
            starship
            fastfetch
            nerd-fonts.jetbrains-mono
            pkgs-unstable.claude-code
          ];

          # Enable flakes
          nix.settings.experimental-features = [ "nix-command" "flakes" ];

          # Import Home Manager module
          imports = [ home-manager.darwinModules.home-manager];

          # Home Manager user configuration
          home-manager.users.julian = {
            home.homeDirectory = "/Users/julian";
            home.stateVersion = "25.05";

            programs.fzf.enable = true;
            programs.fzf.enableZshIntegration = true;

            imports = [./modules/starship.nix ./modules/git.nix ./modules/zsh.nix];
         
          };

          # Darwin metadata
          system.stateVersion = 6;
          system.configurationRevision = self.rev or self.dirtyRev or null;
        })
      ];
    };
  };
}
