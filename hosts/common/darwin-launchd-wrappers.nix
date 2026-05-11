{ config, lib, pkgs, ... }:
let
  # These scripts must live outside /nix/store because launchd starts them
  # before the encrypted Nix Store volume has necessarily been mounted.
  wrapperDir = "/Library/Application Support/nix-darwin/launchd-wrappers";
  wrapper = name: "${wrapperDir}/${name}";
  quote = lib.escapeShellArg;

  mountStoreWrapper = pkgs.writeText "nix-store-mounter" ''
    #!/bin/sh
    set -eu

    if [ -d /nix/store ]; then
      exit 0
    fi

    volume_name="''${NIX_DARWIN_STORE_VOLUME_NAME:-Nix Store}"
    volume_uuid="$(/usr/sbin/diskutil info -plist "$volume_name" 2>/dev/null | /usr/bin/plutil -extract VolumeUUID raw -o - - 2>/dev/null || true)"

    if [ -z "$volume_uuid" ]; then
      echo "Nix Store Mounter: APFS volume '$volume_name' not found" >&2
      exit 1
    fi

    if passphrase="$(/usr/bin/security find-generic-password -s "$volume_uuid" -w 2>/dev/null)"; then
      printf '%s' "$passphrase" | /usr/sbin/diskutil apfs unlockVolume "$volume_uuid" -mountpoint /nix -stdinpassphrase \
        || /usr/sbin/diskutil mount -mountPoint /nix "$volume_uuid"
    else
      /usr/sbin/diskutil mount -mountPoint /nix "$volume_uuid"
    fi

    /bin/wait4path /nix/store
  '';

  nixDaemonWrapper = pkgs.writeText "nix-daemon-launcher" ''
    #!/bin/sh
    set -eu

    /bin/wait4path /nix/store
    exec ${quote config.launchd.daemons.nix-daemon.command}
  '';

  activateSystemWrapper = pkgs.writeText "nix-darwin-activator" ''
    #!/bin/sh
    set -eu

    /bin/wait4path /nix/store
    exec ${quote config.launchd.daemons.activate-system.command}
  '';
in
{
  system.activationScripts.extraActivation.text = lib.mkAfter ''
    printf >&2 'installing named nix-darwin launchd wrappers...\n'

    /bin/mkdir -p ${quote wrapperDir}
    /usr/sbin/chown root:wheel ${quote wrapperDir}
    /bin/chmod 0755 ${quote wrapperDir}

    /usr/bin/install -m 0755 -o root -g wheel ${mountStoreWrapper} ${quote (wrapper "Nix Store Mounter")}
    /usr/bin/install -m 0755 -o root -g wheel ${nixDaemonWrapper} ${quote (wrapper "Nix Daemon")}
    /usr/bin/install -m 0755 -o root -g wheel ${activateSystemWrapper} ${quote (wrapper "Nix Darwin Activator")}
  '';

  launchd.daemons.darwin-store = {
    serviceConfig.Label = "org.nixos.darwin-store";
    serviceConfig.ProgramArguments = lib.mkForce [ (wrapper "Nix Store Mounter") ];
    serviceConfig.RunAtLoad = true;
  };

  launchd.daemons.nix-daemon.serviceConfig.ProgramArguments =
    lib.mkForce [ (wrapper "Nix Daemon") ];

  launchd.daemons.activate-system.serviceConfig.ProgramArguments =
    lib.mkForce [ (wrapper "Nix Darwin Activator") ];
}
