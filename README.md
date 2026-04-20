# Dotfiles

macOS configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Setup

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install)

# Apply configuration
nix run nix-darwin -- switch --flake .#m1
```

## Applying Changes

To Apply configuration changes:

```bash
sudo darwin-rebuild switch --flake .#m1
```

## Upgrading Packages

Packages are pinned via `flake.lock`. To pull in newer versions:

```bash
nix flake update          # update all inputs
nix flake update nixpkgs  # or a single input
sudo darwin-rebuild switch --flake .#m1
```

To upgrade to a new stable release, bump the channel versions in `flake.nix` (e.g. `25.11` → `26.05`), then run the above.

## Cleaning up

Old package generations accumulate in the Nix store. To free disk space:

```bash
nix-collect-garbage -d   # delete all old generations and unreferenced packages
```

Or keep the last N generations:

```bash
sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system
nix-collect-garbage
```

## Unsuitable to use for Linux

home-manager alone is insufficient on Linux with an Nvidia GPU. Drivers require system-level management (kernel modules, FHS paths for OpenGL/CUDA/Vulkan) that home-manager can't provide. The workaround (`nixGL`) is too fragile.
