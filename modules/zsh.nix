{ config, pkgs, lib, ... }:

{
  # Enable Zsh
  programs.zsh = {
    enable = true;

    autosuggestion.enable = true;

    initContent = lib.optionalString pkgs.stdenv.isDarwin ''
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
  # Not in .bash_profile: GDM runs `bash -l -c gnome-session` with the VT as
  # stdin, so a tty check there replaced the session with zsh (login loop).
  programs.bash = {
    enable = true;
    initExtra = ''
      if [[ $- == *i* && -z $BASH_EXECUTION_STRING && $(ps -o comm= -p $PPID) != zsh ]]; then
        shopt -q login_shell && exec "${pkgs.zsh}/bin/zsh" -l
        exec "${pkgs.zsh}/bin/zsh"
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
