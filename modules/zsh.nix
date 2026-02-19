{ config, pkgs, ... }:

{
  # Enable Zsh
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    # Shell aliases
    shellAliases = {
      # Navigation aliases
      ".." = "cd ..";
      "..." = "cd ../..";

      # Listing / clearing
      ll = "ls -alh";
      c = "clear";

      # Quick access to folders
      d  = "cd ~/Documents";
      dl = "cd ~/Downloads";
      dt = "cd ~/Desktop";
    };
  };
  # Set Zsh as default shell
  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    # Set locale to English
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
