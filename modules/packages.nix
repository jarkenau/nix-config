{ pkgs, claude-code, codex, ... }:

{
  # Shared package list for both macOS and Linux
  home.packages = with pkgs; [
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
    claude-code
    codex
    uv
  ];
}
