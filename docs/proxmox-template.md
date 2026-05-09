# Proxmox NixOS Template

This repo builds the NixOS golden base image for Proxmox.

The Proxmox host stays clean: it restores finished artifacts and manages VMs,
but it does not become a Nix builder.

## Commands

```sh
just build proxmox-template
```

Break-glass path from the laptop. It creates or starts the isolated Proxmox
builder VM, builds the image, imports it, tests it, promotes it, and cleans up
temporary VMs.

```sh
just ci template-refresh
```

Programmatic path for the future Forgejo runner. It is non-interactive and runs
the same build, import, smoke-test, promote, and cleanup stages.

Useful CI stages:

```sh
just ci template-update-lock
just ci template-build-temp
just ci template-test-temp
just ci template-promote
just ci template-cleanup
```

The canonical template and clone lifecycle lives in the `infra` repo. This repo
keeps the same constants and scripts only so NixOS configs evaluate against the
same Proxmox contract.

## Consumption Contract

The Proxmox template is a base operating-system substrate, not the source of
truth for application or host behavior.

The template owns:

- NixOS bootability on Proxmox.
- QEMU guest agent.
- SSH service availability.
- Docker availability for Compose-backed app hosts.
- Cloud-init support for clone-time metadata.
- A baked-in break-glass SSH key for `alex` and `root`.

Clone-time Proxmox/cloud-init metadata owns only:

- VM identity: name and VMID.
- Initial CPU, memory, and optional disk growth.
- Initial network config, defaulting to DHCP through `ipconfig0 = "ip=dhcp"`.
- Optional SSH key injection for the cloud-init default user.

NixOS host configuration owns everything durable after first boot:

- Users beyond break-glass access.
- Packages and services.
- Firewall policy.
- Secrets integration.
- Backup jobs.
- Monitoring and alerting.

Cloud-init is deliberately kept narrow. It should make a clone reachable and
identifiable; it should not become a second configuration-management layer.

## VMIDs

Declared in `data/proxmox-builder.nix`.

```text
9000  nixos-tmpl                        current gold
9001  nixos-tmpl-last                   last known-good gold
9002  nixos-template-build-temp         disposable build/test image
9010  proxmox-builder                   temporary isolated builder
9099  nixos-template-smoke-test         disposable smoke-test VM
```

Template destination storage is also declared there. Current target:

```text
ceph-nvme3
```

## Flow

Both laptop and CI flows do this:

1. Ensure `proxmox-builder` exists and is running.
2. Copy this checkout to the builder.
3. Build `.#nixosConfigurations.proxmox-template.config.system.build.image`.
4. Copy the VMA artifact back to `./result`.
5. Upload the artifact to Proxmox.
6. Restore it as disposable build template `9002`.
7. Clone `9002` to smoke-test VM `9099`.
8. Check guest agent, architecture, `sshd`, Docker, default route, DNS, and IPv4.
9. Mark the build image as tested.
10. Clone current `9000` to last `9001`.
11. Replace `9000` with the tested build image.
12. Destroy `9010`, `9002`, and `9099`.

If the current or last VMID already exists with the wrong name, promotion
stops instead of destroying it.

## Builder Bootstrap

The builder starts from a pinned Debian cloud image only to get a reliable SSH
target. The recipe then runs `nixos-anywhere` and replaces Debian with the
declared NixOS builder in:

```text
hosts/nixos/proxmox-builder
```

The template itself is defined in:

```text
hosts/nixos/proxmox-template/default.nix
```

The generated artifact is the Proxmox VMA image from the upstream NixOS module:

```text
virtualisation/proxmox-image.nix
```

The upstream module currently emits a harmless rename warning for
`proxmox.qemuConf.diskSize`. Ignore it unless image restore breaks.

## Template Defaults

The base image currently includes:

- DHCP networking.
- SSH enabled.
- Password SSH login disabled.
- Laptop `ed25519` key authorized for `alex` and `root`.
- Serial console.
- QEMU guest agent.
- Docker.
- Disk grow support, assuming Proxmox/cloud-init disk resize behaves correctly.

Cloud-init is expected for clone-time customization later, but the base image
does not depend on cloud-init for break-glass SSH access.

## Metadata

The promotion flow writes metadata into the Proxmox template description:

```text
target=<golden|last|build-temp>
built=<UTC timestamp>
rev=<git commit>
dirty=<true|false>
lock=<flake.lock hash prefix>
source=<manual|ci>
tests=<not-run|passed>
tested=<UTC timestamp>
promoted=<UTC timestamp>
superseded=<UTC timestamp>
```

`dirty=true` means local uncommitted repo changes were included in the image.

## Debugging

Keep temporary VMs after a failed run:

```sh
INFRA_KEEP_TEMPLATE_VMS=1 just ci template-refresh
```

Optional SSH smoke test:

```sh
PROXMOX_TEMPLATE_TEST_SSH_KEY=/path/to/private/key just ci template-refresh
```

## Network Safety

Network changes are high-risk remote changes. Before applying them to a VM,
make sure Proxmox console works, QEMU guest agent works when practical, and
there is a known-good rollback path. Avoid changing SSH, firewall, default
route, bridge, and IP addressing all in the same untested step.
