{ config, pkgs, ... }:

{
  # Enable Zsh
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    initContent = ''
      # Docker Desktop
      export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
    '';

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
  # Keep /bin/bash as the login shell (required for Wayland/GDM compatibility),
  # but exec into zsh immediately for interactive terminal sessions.
  programs.bash = {
    enable = true;
    profileExtra = ''
      if [ -t 0 ] && [ -x "${pkgs.zsh}/bin/zsh" ]; then
        exec "${pkgs.zsh}/bin/zsh" -l
      fi
    '';
  };

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    # Set locale to English
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
  };
}
