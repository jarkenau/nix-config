# Dotfiles

macOS and Ubuntu configuration using [nix-darwin](https://github.com/nix-darwin/nix-darwin) and [home-manager](https://github.com/nix-community/home-manager).

## Setup

### macOS

```bash
# Install Nix
sh <(curl -L https://nixos.org/nix/install)

# Apply configuration
nix run nix-darwin -- switch --flake .#m1
```

### Ubuntu 24.04

```bash
# Install Nix (flakes are enabled by default)
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install

# Apply configuration (-b backs up the stock ~/.bashrc and ~/.profile)
nix run home-manager/release-26.05 -- switch -b backup --flake .#work
```

The login shell stays `/bin/bash` (required for GDM); bash hands off to zsh for interactive terminals.

Machine-specific settings (`ROS_DOMAIN_ID`, workspace sourcing, ...) go into `~/.zshrc.local`, which is sourced last and not managed by Nix.

## GPU and ROS on Ubuntu

Nix only provides CLI tools and dotfiles. The NVIDIA driver, CUDA, ROS 2 and the toolchain (Python, gcc, cmake) are installed with apt. Never add them to `modules/packages.nix`: Nix builds cannot load the host's GPU driver, and ROS expects the system Python and compilers.

For a venv that sees both ROS and pip packages:

```bash
python3 -m venv --system-site-packages .venv
```

## Applying Changes

To Apply configuration changes:

```bash
sudo darwin-rebuild switch --flake .#m1    # macOS
home-manager switch --flake .#work         # Ubuntu
```

## Upgrading Packages

Packages are pinned via `flake.lock`. To pull in newer versions:

```bash
nix flake update          # update all inputs
nix flake update nixpkgs  # or a single input
```

Then apply as above.

To upgrade to a new stable release, bump the channel versions in `flake.nix` (e.g. `25.11` → `26.05`), then run the above.

## Cleaning up

Old package generations accumulate in the Nix store. To free disk space:

```bash
nix-collect-garbage -d   # delete all old generations and unreferenced packages
```

Or keep the last N generations (macOS):

```bash
sudo nix-env --delete-generations +3 --profile /nix/var/nix/profiles/system
nix-collect-garbage
```

## Uninstalling

macOS: see the [official Nix uninstall instructions](https://nix.dev/manual/nix/2.24/installation/uninstall#macos).

Ubuntu:

```bash
home-manager uninstall
/nix/nix-installer uninstall
```

Then restore the backed-up dotfiles (`mv ~/.bashrc.backup ~/.bashrc`, same for `~/.profile`). apt packages are not touched.
