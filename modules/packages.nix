{ pkgs, claude-code, ... }:

{
  # Shared package list for both macOS and Linux
  home.packages = with pkgs; [
    git
    zsh
    vim
    tmux
    fzf
    ripgrep
    htop
    tree
    curl
    unzip
    starship
    fastfetch
    nerd-fonts.jetbrains-mono
    claude-code
    uv
    pre-commit
    texlive.combined.scheme-medium
  ];
}
