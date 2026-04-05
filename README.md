# Dotfiles

macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Setup

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install)

# Apply configuration
nix run nix-darwin -- switch --flake .#m1
```

## Update

```bash
sudo darwin-rebuild switch --flake .#m1
```

## Unsuitable to use for Linux

home-manager alone is insufficient on Linux with an Nvidia GPU. Drivers require system-level management (kernel modules, FHS paths for OpenGL/CUDA/Vulkan) that home-manager can't provide. The workaround (`nixGL`) is too fragile.
