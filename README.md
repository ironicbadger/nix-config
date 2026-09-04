# ironicbadger/nix-config

Personal Nix configuration for Macs, a few NixOS hosts, and Proxmox template
automation. Most day-to-day machines are managed with nix-darwin; Linux hosts
are defined as NixOS flakes.

## Hosts

Darwin configs:

- `nauvis`
- `mac-studio`
- `mba15`
- `milliways`
- `baldrick`
- `magrathea`
- `beefcake`

NixOS configs:

- `forgejo`
- `proxmox-builder`
- `proxmox-template`

Colmena also defines deploy targets for `forgejo`, `morphnix`, and `nvllama`.

## New Mac Bootstrap

A new Mac can bootstrap from the public repository without GitHub credentials
or SSH keys. Download the script over HTTPS, then pass the hostname matching a
`darwinConfigurations` entry:

```sh
curl --fail --silent --show-error --location \
  https://raw.githubusercontent.com/ironicbadger/nix-config/main/scripts/darwin/new-mac-bootstrap \
  --output /tmp/new-mac-bootstrap
chmod +x /tmp/new-mac-bootstrap
/tmp/new-mac-bootstrap HOST
```

The script installs Apple's Command Line Tools when needed, Rosetta 2 on Apple
Silicon, the official multi-user Nix distribution, and the selected nix-darwin
configuration. It uses an unauthenticated HTTPS clone at `~/tmp/nix-config` by
default; `NIX_CONFIG_REPO_DIR` and `NIX_CONFIG_REPO_URL` can override that.

The Darwin configuration disables Spotlight's Command-Space shortcut and sets
Desktop & Dock > Click wallpaper to show desktop to "Only in Stage Manager."
After the first switch, two macOS-protected settings still require one-time
manual approval:

1. Open Raycast Settings > General and record Command-Space as the Raycast
   Hotkey. Raycast v2 stores settings in an encrypted database, so this cannot
   be written safely with `defaults`.
2. Open System Settings > Privacy & Security > Full Disk Access and add/enable
   Terminal, Ghostty, and Visual Studio Code. Apple requires explicit user
   approval on an unmanaged Mac; silent grants require an MDM-delivered PPPC
   profile.

## Common Commands

Most commands are wrapped in the `justfile`.

```sh
just build              # build the current host
just switch             # switch the current host
just build HOST         # build a specific host
just trace HOST         # build with --show-trace
just update             # update flake.lock
just gc                 # collect garbage
```

Mac-specific helpers:

```sh
just mas install        # install configured Mac App Store apps
just mas get            # acquire and install missing Mac App Store apps
```

NixOS and remote helpers:

```sh
just remote ACTION HOST IP
just install IP
```

## Layout

- `flake.nix` - flake inputs and host definitions
- `hosts/common/` - shared Darwin and NixOS modules
- `hosts/darwin/` - per-Mac overrides
- `hosts/nixos/` - NixOS host configs
- `home/` - Home Manager config and dotfiles
- `modules/` - reusable NixOS modules
- `scripts/` - build, switch, install, CI, and Proxmox helpers
- `data/` - static config data used by scripts and modules
- `docs/` - longer notes for specific workflows

## Proxmox Template

The Proxmox template workflow has a dedicated note:

- [Proxmox NixOS template plan](docs/proxmox-template.md)

CI-friendly template stages are available through:

```sh
just ci template-refresh
just ci template-build-temp
just ci template-test-temp
just ci template-promote
just ci template-cleanup
```
