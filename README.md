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

### Ubuntu (x86_64)

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

Zsh is configured automatically — no need to run `chsh`. The login shell stays as `/bin/bash` (required for Wayland/GDM compatibility), and bash will hand off to zsh automatically for any interactive terminal session.

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

### Ubuntu (aarch64, ARM VM on Apple Silicon)

Same setup steps as x86_64, but use the `ubuntu-arm` configuration target instead:

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install) --daemon

# Enable flakes
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

# Apply configuration
nix run github:nix-community/home-manager/release-25.05 -- switch --flake .#ubuntu-arm
```

Zsh and font setup are identical to the x86_64 section above.

Update:
```bash
nix flake update
home-manager switch --flake .#ubuntu-arm
```
