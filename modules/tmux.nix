{ config, pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    mouse = true;
    baseIndex = 1;
    prefix = "C-a";

    extraConfig = ''
      # Renumber windows sequentially after closing any of them
      set -g renumber-windows on

      # Enable true color support
      set -ga terminal-overrides ",*256col*:Tc"

      # Pane splitting with intuitive keys
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %

      # Vim-style pane navigation
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Vim-style pane resizing
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Quick window switching with Alt+number (no prefix needed)
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Easy config reload
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Catppuccin Frappé color scheme
      set -g status-style "bg=#303446,fg=#c6d0f5"
      set -g status-left-length 40
      set -g status-right-length 100

      # Left side: session name
      set -g status-left "#[fg=#8caaee,bold] #S #[fg=#737994]│ "

      # Right side: date and time
      set -g status-right "#[fg=#737994]│ #[fg=#ca9ee6]%Y-%m-%d #[fg=#737994]│ #[fg=#eebebe]%H:%M "

      # Window status format
      set -g window-status-format "#[fg=#737994] #I:#W "
      set -g window-status-current-format "#[fg=#8caaee,bold] #I:#W "

      # Pane borders
      set -g pane-border-style "fg=#414559"
      set -g pane-active-border-style "fg=#8caaee"

      # Message styling
      set -g message-style "bg=#414559,fg=#c6d0f5"

      # Copy mode colors
      set -g mode-style "bg=#414559,fg=#c6d0f5"

      # Don't wait for escape sequence
      set -sg escape-time 0

      # Enable focus events
      set -g focus-events on
    '';
  };
}
