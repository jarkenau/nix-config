{ config, pkgs, ... }:

{
  # Shared home-manager configuration for both macOS and Linux

  home.stateVersion = "25.05";

  # Enable fzf with zsh integration
  programs.fzf.enable = true;
  programs.fzf.enableZshIntegration = true;

  # Import all user-specific modules
  imports = [
    ./packages.nix
    ./starship.nix
    ./git.nix
    ./zsh.nix
    ./tmux.nix
  ];
}
