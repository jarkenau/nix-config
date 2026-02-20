# Dotfiles

Cross-platform configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Structure

All user configuration is shared via modules:
- `modules/packages.nix` - Shared package list
- `modules/common.nix` - Shared home-manager config
- `modules/git.nix` - Git configuration
- `modules/zsh.nix` - Zsh with aliases
- `modules/tmux.nix` - Tmux configuration
- `modules/starship.nix` - Starship prompt

## Usage

### macOS

First-time setup:
```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install)

# Install nix-darwin
nix run nix-darwin -- switch --flake .#m1
```

Update:
```bash
sudo darwin-rebuild switch --flake .#m1
```

### Ubuntu

First-time setup:
```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Apply configuration
nix run github:nix-community/home-manager/release-25.05 -- switch --flake .#ubuntu
```

After applying the configuration for the first time, you need to manually set zsh as your login shell (home-manager cannot do this on Ubuntu):

```bash
# Allow nix zsh to be used as a login shell
echo ~/.nix-profile/bin/zsh | sudo tee -a /etc/shells

# Change your login shell to zsh
chsh -s ~/.nix-profile/bin/zsh
```

Then log out and back in for the shell change to take effect.

To make Nix-installed fonts (e.g. JetBrains Mono Nerd Font) available for selection in your terminal, link them into the user fonts directory and refresh the font cache:

```bash
mkdir -p ~/.local/share/fonts
ln -s ~/.nix-profile/share/fonts ~/.local/share/fonts/nix
fc-cache -fv
```

Update:
```bash
nix flake update
home-manager switch --flake .#ubuntu
```
