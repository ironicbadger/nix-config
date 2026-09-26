{ lib, pkgs, ... }:
let
  launchBox = pkgs.stdenvNoCC.mkDerivation {
    pname = "launchbox-nightly";
    version = "0.1.0-nightly-20260925034106";

    # Public signed archive; no credentials for the private source repo needed.
    # Upstream retains only three nightly builds: refresh the URL and hash together.
    src = pkgs.fetchurl {
      url = "https://friendlyventures.github.io/LaunchBox/nightly/20260925034106/LaunchBox-nightly-0.1.0-20260925034106-arm64.zip";
      hash = "sha256-zx2r/d3sbXAsbs1cbklSUK7CjYBhb1UD13p77VxnQ1g=";
    };

    # Apple's ZIP metadata must be restored as metadata, not ._ files inside
    # sealed bundles (which would invalidate the nested helper signatures).
    unpackPhase = ''
      runHook preUnpack
      /usr/bin/ditto -x -k "$src" .
      runHook postUnpack
    '';
    dontConfigure = true;
    dontBuild = true;
    # Preserve upstream signatures, framework links, and bundled runtime helpers.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      cp -R "LaunchBox Nightly.app" "$out/Applications/"
      runHook postInstall
    '';

    meta = {
      description = "Native keyboard-first macOS launcher (Nightly, requires macOS 26+)";
      homepage = "https://friendlyventures.github.io/LaunchBox/";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  };
in
{
  environment.systemPackages = [ launchBox ];
}
