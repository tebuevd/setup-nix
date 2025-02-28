{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";

    taps = [ ];
    brews = [ "cowsay" ];
    casks = [
      "1password"
      "firefox"
      "ghostty"
      "google-chrome"
      "raycast"
      "reflect"
      "tailscale"
      "zed"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Velja" = 1607635845;
      "Voice Type:Real Time Dictation" = 6736525125;
    };
  };
}
