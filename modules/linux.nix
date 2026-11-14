{ config, pkgs, ... }:

{
  # Ubuntu-specific home-manager configuration.
  # Nix provides CLI tools only; the NVIDIA driver, CUDA, ROS, Python and
  # compilers stay on apt so nothing GPU- or ROS-related links against Nix.

  targets.genericLinux.enable = true;
  # On by default with genericLinux; it wants sudo and a pinned NVIDIA driver hash.
  targets.genericLinux.gpu.enable = false;

  # Expose Nix-installed fonts (JetBrains Mono Nerd Font) to the desktop
  fonts.fontconfig.enable = true;

  # Ubuntu's stock ~/.profile adds this, but home-manager replaces that file
  home.sessionPath = [ "$HOME/.local/bin" ];

  programs.zsh.initContent = ''
    # ROS 2
    [[ -f /opt/ros/jazzy/setup.zsh ]] && source /opt/ros/jazzy/setup.zsh

    # Machine-local settings (ROS_DOMAIN_ID, workspaces, ...), not managed by Nix
    [[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
  '';
}
