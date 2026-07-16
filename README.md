# ironicbadger/nix-config

Personal Nix configuration for Macs, a few NixOS hosts, and Proxmox template
automation. Most day-to-day machines are managed with nix-darwin; Linux hosts
are defined as NixOS flakes.

## Hosts

Darwin configs:

- `nauvis`
- `mac-studio`
- `mba15`
- `baldrick`
- `magrathea`
- `beefcake`

NixOS configs:

- `forgejo`
- `proxmox-builder`
- `proxmox-template`

Colmena also defines deploy targets for `forgejo`, `morphnix`, and `nvllama`.

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
