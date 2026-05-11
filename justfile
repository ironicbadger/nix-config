default: switch

hostname := `hostname | cut -d "." -f 1`

[macos]
build role=hostname flags="":
  scripts/darwin/build-system "{{role}}" {{flags}}

[macos]
trace role=hostname: (build role "--show-trace")

[macos]
switch:
  scripts/darwin/switch-system "{{hostname}}"

[linux]
build role=hostname flags="":
  scripts/nixos/build-system "{{role}}" {{flags}}

[linux]
trace role=hostname: (build role "--show-trace")

[linux]
switch:
  scripts/nixos/switch-system "{{hostname}}"

update:
  nix flake update

ci *ARGS:
  scripts/ci {{ARGS}}

mas action:
  scripts/darwin/install-mas-apps {{action}}

install IP:
  scripts/nixos/install-remote-vm "{{IP}}"

remote action host ip user="root" build_host="":
  scripts/nixos/remote-rebuild "{{action}}" "{{host}}" "{{ip}}" "{{user}}" "{{build_host}}"

gc:
  scripts/collect-garbage
