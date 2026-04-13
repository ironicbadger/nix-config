{ lib, ... }:
{
  # The app firewall is what generates many of the "accept incoming connections"
  # prompts. This trades that friction for less host-side network protection.
  networking.applicationFirewall.enable = false;

  system.defaults = {
    NSGlobalDomain.NSAutomaticCapitalizationEnabled = false;
    NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticInlinePredictionEnabled = false;
    NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticQuoteSubstitutionEnabled = false;
    NSGlobalDomain.NSAutomaticSpellingCorrectionEnabled = false;
    NSGlobalDomain.NSAutomaticWindowAnimationsEnabled = false;
    NSGlobalDomain.NSScrollAnimationEnabled = false;

    CustomSystemPreferences = {
      "com.apple.CrashReporter" = {
        DialogType = "none";
      };
    };

    CustomUserPreferences = {
      "com.apple.CrashReporter" = {
        DialogType = "none";
      };
      "com.apple.SubmitDiagInfo" = {
        AutoSubmit = false;
      };
    };
  };

  # Quarantine is already disabled in common defaults; this removes the
  # remaining Gatekeeper assessment step for newly launched apps.
  system.activationScripts.postActivation.text = lib.mkAfter ''
    echo "disabling Gatekeeper assessments..." >&2
    /usr/sbin/spctl --master-disable || true
  '';
}
