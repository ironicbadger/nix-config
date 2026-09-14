{ lib, pkgs, ... }:
let
  shinyMac = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "shinymac";
    version = "1.0.5";

    src = pkgs.fetchurl {
      url = "https://github.com/Cosmin-T/ShinyMac/releases/download/v${version}/ShinyMac-${version}.dmg";
      hash = "sha256-2cKKi76pmWzZQejiRqCmHlz61FF9z0AUHrAbzAbcyWE=";
    };

    nativeBuildInputs = [ pkgs.undmg ];
    sourceRoot = ".";
    dontConfigure = true;
    dontBuild = true;
    # Preserve the upstream executable and its ad-hoc signature.
    dontFixup = true;

    installPhase = ''
      runHook preInstall
      mkdir -p "$out/Applications"
      cp -R ShinyMac.app "$out/Applications/"
      # Apply upstream's Gatekeeper workaround before the store becomes read-only.
      /usr/bin/xattr -cr "$out/Applications/ShinyMac.app"
      runHook postInstall
    '';

    meta = {
      description = "Lock your Mac's keyboard and trackpad for safe cleaning";
      homepage = "https://github.com/Cosmin-T/ShinyMac";
      license = lib.licenses.mit;
      platforms = [ "aarch64-darwin" ];
    };
  };
in
{
  environment.systemPackages = [ shinyMac ];
}
