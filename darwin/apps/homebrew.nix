{ ... }:
{
  homebrew = {
    enable = true;
    onActivation.cleanup = "none";

    taps = [
      "nikitabobko/tap"
      "FelixKratz/formulae"
    ];
    brews = [
      "borders"
      "cowsay"
      "mactop"
    ];
    casks = [
      "aerospace"
      "1password"
      "bruno"
      "cryptomator"
      "cursor"
      "cyberduck"
      "firefox"
      "ghostty"
      "granola"
      "google-chrome"
      "imazing"
      "leader-key"
      "ollama"
      "omnidisksweeper"
      "orion"
      "raycast"
      "reflect"
      "screen-studio"
      "secretive"
      "shottr"
      "signal"
      "stats"
      "steam"
      "superhuman"
      "tableplus"
      "tailscale"
      "visual-studio-code"
      "vlc"
      "zed"
      "zoom"
    ];

    masApps = {
      "1Password for Safari" = 1569813296;
      "Velja" = 1607635845;
      "Voice Type:Real Time Dictation" = 6736525125;
    };
  };
}
